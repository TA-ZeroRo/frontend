import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BottomNav { home, community, leaderboard, profile }

extension BottomNavX on BottomNav {
  int get index => BottomNav.values.indexOf(this);

  String get title => switch (this) {
    BottomNav.home => 'Home',
    BottomNav.profile => 'Profile',
    BottomNav.leaderboard => 'Leaderboard',
    BottomNav.community => 'Community',
  };

  Icon get icon => switch (this) {
    BottomNav.home => const Icon(Icons.home_outlined),
    BottomNav.profile => const Icon(Icons.person_outline),
    BottomNav.leaderboard => const Icon(Icons.emoji_events_outlined),
    BottomNav.community => const Icon(Icons.forum_outlined),
  };
}

class BottomNavNotifier extends Notifier<BottomNav> {
  @override
  BottomNav build() => BottomNav.home;

  void setIndex(int index) {
    if (index < 0 || index >= BottomNav.values.length) return;
    state = BottomNav.values[index];
  }
}

final bottomNavProvider = NotifierProvider<BottomNavNotifier, BottomNav>(
  BottomNavNotifier.new,
);
