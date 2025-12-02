import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_color.dart';
import 'pages/activity/activity_page.dart';
import 'pages/campaign/campaign_page.dart';
import 'pages/home/home_page.dart';
import 'pages/plogging_map/plogging_map_page.dart';
import 'pages/profile/profile_page.dart';
import 'state/bottom_nav_controller.dart';
import 'pages/home/state/chat_controller.dart';
import 'pages/home/components/full_chat_overlay.dart';
import 'pages/activity/state/leaderboard_state.dart';
import 'pages/campaign/state/campaign_state.dart';
import 'pages/activity/state/campaign_mission_state.dart';
import 'pages/profile/state/weekly_report_controller.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BottomNav nav = ref.watch(bottomNavProvider);
    final chatState = ref.watch(chatProvider);

    // 탭 변경 감지 및 자동 새로고침
    ref.listen<BottomNav>(bottomNavProvider, (previous, next) {
      if (previous != null && previous != next) {
        _refreshTabData(ref, next);
      }
    });

    final Widget page = switch (nav) {
      BottomNav.home => const HomePage(),
      BottomNav.activity => const ActivityPage(),
      BottomNav.ploggingMap => const PloggingMapPage(),
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

/// 탭별 데이터 새로고침
void _refreshTabData(WidgetRef ref, BottomNav tab) {
  switch (tab) {
    case BottomNav.home:
      // Home은 3D 모델/채팅이라 별도 refresh 불필요
      break;
    case BottomNav.activity:
      ref.read(combinedRankingProvider.notifier).refresh();
      ref.read(campaignMissionProvider.notifier).refresh();
      break;
    case BottomNav.ploggingMap:
      // 플로깅 맵은 별도 refresh 불필요
      break;
    case BottomNav.campaign:
      ref.read(campaignListProvider.notifier).refresh();
      break;
    case BottomNav.profile:
      ref.read(weeklyReportsProvider.notifier).refresh();
      break;
  }
}
