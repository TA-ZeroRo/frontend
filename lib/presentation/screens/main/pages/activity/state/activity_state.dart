import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mock/mock_campaign_mission_data.dart';
import 'mock/mock_ranking_data.dart';

// ========================================
// RANKING STATE
// ========================================

/// Async notifier for ranking/leaderboard data
class RankingAsyncNotifier extends AsyncNotifier<List<RankingItem>> {
  @override
  Future<List<RankingItem>> build() async {
    return await _fetchRankings();
  }

  Future<List<RankingItem>> _fetchRankings() async {
    // API call simulation
    await Future.delayed(const Duration(seconds: 2));
    return mockRankings;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(seconds: 1));
      return mockRankings;
    });
  }
}

final rankingProvider =
    AsyncNotifierProvider<RankingAsyncNotifier, List<RankingItem>>(
  RankingAsyncNotifier.new,
);

// ========================================
// CAMPAIGN MISSION STATE
// ========================================

/// State class for campaign mission data
class CampaignMissionState {
  final List<Campaign> campaigns;
  final bool isLoading;
  final String? error;

  const CampaignMissionState({
    required this.campaigns,
    this.isLoading = false,
    this.error,
  });

  CampaignMissionState copyWith({
    List<Campaign>? campaigns,
    bool? isLoading,
    String? error,
  }) {
    return CampaignMissionState(
      campaigns: campaigns ?? this.campaigns,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Notifier for managing campaign mission state
class CampaignMissionNotifier extends Notifier<CampaignMissionState> {
  @override
  CampaignMissionState build() {
    return CampaignMissionState(
      campaigns: mockCampaigns,
    );
  }

  /// Toggle mission completion status
  void toggleMissionCompletion(String missionId) {
    final updatedCampaigns = state.campaigns.map((campaign) {
      final updatedMissions = campaign.missions.map((mission) {
        if (mission.id == missionId) {
          return mission.copyWith(isCompleted: !mission.isCompleted);
        }
        return mission;
      }).toList();

      return Campaign(
        id: campaign.id,
        name: campaign.name,
        iconEmoji: campaign.iconEmoji,
        missions: updatedMissions,
      );
    }).toList();

    state = state.copyWith(campaigns: updatedCampaigns);
  }

  /// Refresh mission data (simulated)
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Reset to mock data
    state = CampaignMissionState(
      campaigns: mockCampaigns,
      isLoading: false,
    );
  }
}

final campaignMissionProvider =
    NotifierProvider<CampaignMissionNotifier, CampaignMissionState>(
  CampaignMissionNotifier.new,
);

/// Derived provider for completed mission count
final completedMissionCountProvider = Provider<int>((ref) {
  final state = ref.watch(campaignMissionProvider);
  return state.campaigns
      .expand((campaign) => campaign.missions)
      .where((mission) => mission.isCompleted)
      .length;
});

/// Derived provider for total points earned
final totalPointsEarnedProvider = Provider<int>((ref) {
  final state = ref.watch(campaignMissionProvider);
  return state.campaigns
      .expand((campaign) => campaign.missions)
      .where((mission) => mission.isCompleted)
      .fold(0, (sum, mission) => sum + mission.points);
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
