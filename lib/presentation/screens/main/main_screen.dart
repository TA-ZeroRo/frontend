import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/community/community_page.dart';
import 'pages/home/home_page.dart';
import 'pages/playground/playground_page.dart';
import 'pages/profile/profile_page.dart';
import 'state/bottom_nav_controller.dart';

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
      body: AnimatedBodyWrapper(key: ValueKey(nav.name), child: page),
      bottomNavigationBar: const _BottomNavigationBar(),
    );
  }
}

class _BottomNavigationBar extends ConsumerWidget {
  const _BottomNavigationBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.watch(bottomNavProvider);
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          currentIndex: nav.index,
          onTap: (index) =>
              ref.read(bottomNavProvider.notifier).setIndex(index),
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: List.generate(
            BottomNav.values.length,
            (index) => BottomNavigationBarItem(
              icon: BottomNav.values[index].icon,
              label: BottomNav.values[index].title,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedBodyWrapper extends StatelessWidget {
  const AnimatedBodyWrapper({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: child,
    );
  }
}
