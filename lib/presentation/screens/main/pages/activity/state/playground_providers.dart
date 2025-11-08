import 'package:flutter_riverpod/flutter_riverpod.dart';

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

/// Provider for leaderboard expansion state
/// Controls whether the leaderboard section is expanded or collapsed
final leaderboardExpandedProvider =
    NotifierProvider<LeaderboardExpandedNotifier, bool>(
  LeaderboardExpandedNotifier.new,
);
