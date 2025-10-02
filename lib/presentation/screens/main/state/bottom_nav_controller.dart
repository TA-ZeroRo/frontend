import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BottomNav {
  home('Home', Icons.home_outlined),
  community('Community', Icons.forum_outlined),
  leaderboard('Leaderboard', Icons.emoji_events_outlined),
  profile('Profile', Icons.person_outline);

  final String title;
  final IconData iconData;
  const BottomNav(this.title, this.iconData);

  Icon get icon => Icon(iconData);
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
