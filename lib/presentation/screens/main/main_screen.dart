import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_color.dart';
import 'pages/campaign/campaign_page.dart';
import 'pages/home/home_page.dart';
import 'pages/activity/activity_page.dart';
import 'pages/profile/profile_page.dart';
import 'state/bottom_nav_controller.dart';
import 'pages/home/state/chat_controller.dart';
import 'pages/home/components/full_chat_overlay.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BottomNav nav = ref.watch(bottomNavProvider);
    final chatState = ref.watch(chatProvider);

    final Widget page = switch (nav) {
      BottomNav.home => const HomePage(),
      BottomNav.activity => const ActivityPage(),
      BottomNav.campaign => const CampaignPage(),
      BottomNav.profile => const ProfilePage(),
    };

    // HomePage에서 full chat이 열려있으면 바텀 네비게이션 바 숨김
    final showBottomNav = !(nav == BottomNav.home && chatState.isFullChatOpen);

    return Stack(
      children: [
        Scaffold(
          body: page,
          bottomNavigationBar: Container(
            color: AppColors.background,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              offset: showBottomNav ? Offset.zero : const Offset(0, 1),
              child: const _BottomNavigationBar(),
            ),
          ),
        ),
        // 전체 화면 채팅 오버레이 - HomePage에서만 표시
        if (nav == BottomNav.home)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !chatState.isFullChatOpen,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: chatState.isFullChatOpen ? 1.0 : 0.0,
                child: const FullChatOverlay(),
              ),
            ),
          ),
      ],
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
          showSelectedLabels: false,
          selectedItemColor: AppColors.primary,
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
