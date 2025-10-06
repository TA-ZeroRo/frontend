import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/community/community_page.dart';
import 'pages/home/home_page.dart';
import 'pages/playground/playground_page.dart';
import 'pages/profile/profile_page.dart';
import 'state/bottom_nav_controller.dart';
import 'pages/home/state/chat_controller.dart';
import '../../../core/animations/page_transition_wrapper.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  BottomNav? _previousNav;

  @override
  Widget build(BuildContext context) {
    final BottomNav nav = ref.watch(bottomNavProvider);
    final chatViewState = ref.watch(chatViewStateProvider);

    final Widget page = switch (nav) {
      BottomNav.home => const HomePage(),
      BottomNav.profile => const ProfilePage(),
      BottomNav.playground => const PlaygroundPage(),
      BottomNav.community => const CommunityPage(),
    };

    // 방향 계산
    PageTransitionDirection? direction;
    if (_previousNav != null && _previousNav != nav) {
      final previousIndex = _previousNav!.index;
      final currentIndex = nav.index;

      if (currentIndex > previousIndex) {
        direction = PageTransitionDirection.rightToLeft; // 다음 페이지로 이동
      } else {
        direction = PageTransitionDirection.leftToRight; // 이전 페이지로 이동
      }
    }

    // 현재 네비게이션을 이전으로 저장
    _previousNav = nav;

    // Hide bottom navigation bar when chat is active on home page
    final shouldShowBottomNav =
        nav != BottomNav.home ||
        chatViewState == ChatViewState.characterVisible;

    return Scaffold(
      body: PageTransitionWrapper(direction: direction, child: page),
      bottomNavigationBar: shouldShowBottomNav
          ? const _BottomNavigationBar()
          : null,
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
