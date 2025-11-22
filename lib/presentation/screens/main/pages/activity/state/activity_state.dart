import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../domain/model/leaderboard/leaderboard_entry.dart';
import '../../../../../../domain/model/mission/mission_with_template.dart';
import '../../../../../../domain/repository/leaderboard_repository.dart';
import '../../../../../../domain/repository/mission_repository.dart';
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
    // Watch trigger to auto-refresh when needed
    ref.watch(activityRefreshTriggerProvider);
    return await _fetchRankings();
  }

  Future<(List<LeaderboardEntry>, LeaderboardEntry?)> _fetchRankings() async {
    final userId = ref.read(authProvider).currentUser?.id;
    return await _repository.getRankingWithMyRank(userId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userId = ref.read(authProvider).currentUser?.id;
      return await _repository.getRankingWithMyRank(userId);
    });
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
// CAMPAIGN MISSION STATE
// ========================================

/// AsyncNotifier for managing campaign mission state with real server data
/// 캠페인별로 그룹화된 미션 데이터를 Map으로 반환
class CampaignMissionAsyncNotifier
    extends AsyncNotifier<Map<int, List<MissionWithTemplate>>> {
  late final MissionRepository _repository;

  @override
  Future<Map<int, List<MissionWithTemplate>>> build() async {
    _repository = getIt<MissionRepository>();
    // Watch trigger to auto-refresh when needed
    ref.watch(activityRefreshTriggerProvider);
    return await _fetchCampaignMissions();
  }

  Future<Map<int, List<MissionWithTemplate>>> _fetchCampaignMissions() async {
    final userId = ref.read(authProvider).currentUser?.id;
    if (userId == null) {
      return {};
    }

    // 서버에서 사용자의 미션 로그 가져오기
    final missionLogs = await _repository.getUserMissionLogs(userId);

    // 캠페인별로 그룹화
    final Map<int, List<MissionWithTemplate>> campaignMap = {};
    for (final missionLog in missionLogs) {
      final campaignId = missionLog.campaign.id;
      if (!campaignMap.containsKey(campaignId)) {
        campaignMap[campaignId] = [];
      }
      campaignMap[campaignId]!.add(missionLog);
    }

    return campaignMap;
  }

  /// 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _fetchCampaignMissions();
    });
  }
}

final campaignMissionProvider =
    AsyncNotifierProvider<
      CampaignMissionAsyncNotifier,
      Map<int, List<MissionWithTemplate>>
    >(CampaignMissionAsyncNotifier.new);

/// Derived provider for completed mission count
final completedMissionCountProvider = Provider<int>((ref) {
  final asyncState = ref.watch(campaignMissionProvider);
  return asyncState.when(
    data: (campaignMap) => campaignMap.values
        .expand((missions) => missions)
        .where((m) => m.missionLog.status.value == 'COMPLETED')
        .length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Derived provider for total points earned
final totalPointsEarnedProvider = Provider<int>((ref) {
  final asyncState = ref.watch(campaignMissionProvider);
  return asyncState.when(
    data: (campaignMap) => campaignMap.values
        .expand((missions) => missions)
        .where((m) => m.missionLog.status.value == 'COMPLETED')
        .fold(0, (sum, m) => sum + m.missionTemplate.rewardPoints),
    loading: () => 0,
    error: (_, __) => 0,
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
// ACTIVITY REFRESH TRIGGER
// ========================================

/// Notifier for triggering activity page data refresh
/// 캠페인 참가 등의 이벤트 후 활동하기 페이지 데이터를 리프레쉬하기 위한 트리거
class ActivityRefreshTrigger extends Notifier<bool> {
  @override
  bool build() {
    return false; // Initial value
  }

  void trigger() {
    state = !state; // Toggle to trigger rebuild of dependent providers
  }
}

final activityRefreshTriggerProvider =
    NotifierProvider<ActivityRefreshTrigger, bool>(ActivityRefreshTrigger.new);
