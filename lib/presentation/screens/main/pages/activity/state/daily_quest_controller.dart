import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mock/mock_daily_quest_data.dart';

/// State class for daily quest data
class DailyQuestState {
  final List<DailyQuestItem> quests;
  final WeeklyAttendance attendance;
  final bool isLoading;
  final String? error;

  const DailyQuestState({
    required this.quests,
    required this.attendance,
    this.isLoading = false,
    this.error,
  });

  DailyQuestState copyWith({
    List<DailyQuestItem>? quests,
    WeeklyAttendance? attendance,
    bool? isLoading,
    String? error,
  }) {
    return DailyQuestState(
      quests: quests ?? this.quests,
      attendance: attendance ?? this.attendance,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Notifier for managing daily quest state
class DailyQuestNotifier extends Notifier<DailyQuestState> {
  @override
  DailyQuestState build() {
    return DailyQuestState(
      quests: mockDailyQuests,
      attendance: mockWeeklyAttendance,
    );
  }

  /// Toggle quest completion status
  void toggleQuestCompletion(String questId) {
    final updatedQuests = state.quests.map((quest) {
      if (quest.id == questId) {
        return quest.copyWith(isCompleted: !quest.isCompleted);
      }
      return quest;
    }).toList();

    state = state.copyWith(quests: updatedQuests);
  }

  /// Refresh quest data (simulated)
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Reset to mock data
    state = DailyQuestState(
      quests: mockDailyQuests,
      attendance: mockWeeklyAttendance,
      isLoading: false,
    );
  }

  /// Get completed quest count
  int get completedQuestCount {
    return state.quests.where((quest) => quest.isCompleted).length;
  }

  /// Get total points earned today
  int get totalPointsEarned {
    return state.quests
        .where((quest) => quest.isCompleted)
        .fold(0, (sum, quest) => sum + quest.points);
  }
}

/// Provider for daily quest state
final dailyQuestProvider =
    NotifierProvider<DailyQuestNotifier, DailyQuestState>(
  DailyQuestNotifier.new,
);

/// Provider for completed quest count
final completedQuestCountProvider = Provider<int>((ref) {
  final state = ref.watch(dailyQuestProvider);
  return state.quests.where((quest) => quest.isCompleted).length;
});

/// Provider for total points earned
final totalPointsEarnedProvider = Provider<int>((ref) {
  final state = ref.watch(dailyQuestProvider);
  return state.quests
      .where((quest) => quest.isCompleted)
      .fold(0, (sum, quest) => sum + quest.points);
});
