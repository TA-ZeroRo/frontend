import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../domain/model/leaderboard/leaderboard_entry.dart';
import '../../../../../../domain/model/mission/mission_with_template.dart';
import '../../../../../../domain/repository/leaderboard_repository.dart';
import '../../../../../../domain/repository/mission_repository.dart';
import '../../../../entry/state/auth_controller.dart';

class RankingAsyncNotifier extends AsyncNotifier<List<LeaderboardEntry>> {
  late final LeaderboardRepository _repository;

  @override
  Future<List<LeaderboardEntry>> build() async {
    _repository = getIt<LeaderboardRepository>();
    return await _fetchRankings();
  }

  Future<List<LeaderboardEntry>> _fetchRankings() async {
    return await _repository.getRanking();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _repository.getRanking();
    });
  }
}

final rankingProvider =
    AsyncNotifierProvider<RankingAsyncNotifier, List<LeaderboardEntry>>(
      RankingAsyncNotifier.new,
    );

// ========================================
// MY RANKING STATE
// ========================================

class MyRankingAsyncNotifier extends AsyncNotifier<LeaderboardEntry?> {
  late final LeaderboardRepository _repository;

  @override
  Future<LeaderboardEntry?> build() async {
    _repository = getIt<LeaderboardRepository>();
    return await _fetchMyRanking();
  }

  Future<LeaderboardEntry?> _fetchMyRanking() async {
    final userId = ref.read(authProvider).currentUser?.id;
    if (userId == null) {
      return null;
    }
    return await _repository.getMyRanking(userId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userId = ref.read(authProvider).currentUser?.id;
      if (userId == null) {
        return null;
      }
      return await _repository.getMyRanking(userId);
    });
  }
}

final myRankingProvider =
    AsyncNotifierProvider<MyRankingAsyncNotifier, LeaderboardEntry?>(
      MyRankingAsyncNotifier.new,
    );

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

final campaignMissionProvider = AsyncNotifierProvider<
    CampaignMissionAsyncNotifier, Map<int, List<MissionWithTemplate>>>(
  CampaignMissionAsyncNotifier.new,
);

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
