import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BottomNav {
  home('홈', Icons.eco),
  activity('활동', Icons.sports_esports),
  campaign('캠페인', Icons.campaign),
  recruiting('리크루팅', Icons.people_alt),
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
