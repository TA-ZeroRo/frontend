import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../domain/model/leaderboard/leaderboard_entry.dart';
import '../../../../../../domain/repository/leaderboard_repository.dart';
import '../../../../entry/state/auth_controller.dart';

// ========================================
// COMBINED RANKING STATE (통합 리더보드 상태)
// ========================================

/// 통합 리더보드 상태 (상위 랭킹 + 내 순위)
/// API 1회 호출로 두 데이터 모두 조회
class CombinedRankingAsyncNotifier
    extends AsyncNotifier<(List<LeaderboardEntry>, LeaderboardEntry?)> {
  late final LeaderboardRepository _repository;

  @override
  Future<(List<LeaderboardEntry>, LeaderboardEntry?)> build() async {
    _repository = getIt<LeaderboardRepository>();

    // trigger 변경 시 refresh 호출 (listen으로 변경하여 build 재실행 방지)
    ref.listen(leaderboardRefreshTriggerProvider, (previous, next) {
      if (previous != null && previous != next) {
        refresh();
      }
    });

    return await _fetchRankings();
  }

  Future<(List<LeaderboardEntry>, LeaderboardEntry?)> _fetchRankings() async {
    final userId = ref.read(authProvider).currentUser?.id;
    return await _repository.getRankingWithMyRank(userId);
  }

  Future<void> refresh() async {
    // 이전 데이터 보존하면서 로딩 (에러 시 기존 데이터 유지)
    final previousData = state.value;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userId = ref.read(authProvider).currentUser?.id;
      return await _repository.getRankingWithMyRank(userId);
    });
    // 에러 발생 시 이전 데이터로 복원
    if (state.hasError && previousData != null) {
      state = AsyncValue.data(previousData);
    }
  }
}

final combinedRankingProvider =
    AsyncNotifierProvider<
      CombinedRankingAsyncNotifier,
      (List<LeaderboardEntry>, LeaderboardEntry?)
    >(CombinedRankingAsyncNotifier.new);

// ========================================
// RANKING STATE (기존 인터페이스 유지)
// ========================================

/// 상위 리더보드 Provider (통합 Provider에서 데이터 추출)
final rankingProvider = Provider<AsyncValue<List<LeaderboardEntry>>>((ref) {
  final combined = ref.watch(combinedRankingProvider);
  return combined.when(
    data: (data) => AsyncValue.data(data.$1), // leaderboard
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// ========================================
// MY RANKING STATE (기존 인터페이스 유지)
// ========================================

/// 내 순위 Provider (통합 Provider에서 데이터 추출)
final myRankingProvider = Provider<AsyncValue<LeaderboardEntry?>>((ref) {
  final combined = ref.watch(combinedRankingProvider);
  return combined.when(
    data: (data) => AsyncValue.data(data.$2), // myRank
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// ========================================
// LEADERBOARD UI STATE
// ========================================

/// Notifier for leaderboard expansion state
class LeaderboardExpandedNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false; // Initially collapsed
  }

  void toggle() {
    state = !state;
  }

  void set(bool value) {
    state = value;
  }
}

final leaderboardExpandedProvider =
    NotifierProvider<LeaderboardExpandedNotifier, bool>(
      LeaderboardExpandedNotifier.new,
    );

// ========================================
// LEADERBOARD REFRESH TRIGGER
// ========================================

/// Notifier for triggering leaderboard data refresh
/// 캠페인 참가 등의 이벤트 후 리더보드 데이터를 리프레쉬하기 위한 트리거
class LeaderboardRefreshTrigger extends Notifier<bool> {
  @override
  bool build() {
    return false; // Initial value
  }

  void trigger() {
    state = !state; // Toggle to trigger rebuild of dependent providers
  }
}

final leaderboardRefreshTriggerProvider =
    NotifierProvider<LeaderboardRefreshTrigger, bool>(LeaderboardRefreshTrigger.new);

// ========================================
// BACKWARD COMPATIBILITY (하위 호환성)
// ========================================

/// 기존 activityRefreshTriggerProvider와의 호환성을 위한 alias
/// @deprecated Use leaderboardRefreshTriggerProvider instead
final activityRefreshTriggerProvider = leaderboardRefreshTriggerProvider;
