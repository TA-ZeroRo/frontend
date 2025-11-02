import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_color.dart';
import 'pages/community/community_page.dart';
import 'pages/home/home_page.dart';
import 'pages/playground/playground_page.dart';
import 'pages/profile/profile_page.dart';
import 'state/bottom_nav_controller.dart';
import 'pages/home/state/chat_controller.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BottomNav nav = ref.watch(bottomNavProvider);

    final Widget page = switch (nav) {
      BottomNav.home => const HomePage(),
      BottomNav.profile => const ProfilePage(),
      BottomNav.playground => const PlaygroundPage(),
      BottomNav.community => const CommunityPage(),
    };

    return Scaffold(
      body: Stack(
        children: [
          page,
          Positioned(
            bottom: 20,
            left: 15,
            right: 15,
            child: const _BottomNavigationBar(),
          ),
        ],
      ),
    );
  }
}

class _BottomNavigationBar extends ConsumerWidget {
  const _BottomNavigationBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.watch(bottomNavProvider);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.primary,
      ),
    );
  }
}
