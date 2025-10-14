import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BottomNav {
  home('홈', Icons.eco),
  playground('놀이터', Icons.sports_esports),
  community('커뮤니티', Icons.groups),
  profile('프로필', Icons.person);

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
