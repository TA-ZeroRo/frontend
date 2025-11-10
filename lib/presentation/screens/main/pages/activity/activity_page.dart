import 'package:flutter/material.dart';
import 'package:frontend/core/components/custom_app_bar.dart';

import '../../../../../core/theme/app_color.dart';
import 'state/mock/mock_ranking_data.dart';
import 'components/leaderboard_section.dart';
import 'components/campaign_mission_section.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _leaderboardKey = GlobalKey(debugLabel: 'leaderboard');
  final GlobalKey _campaignKey = GlobalKey(debugLabel: 'campaign');

  int _currentIndex = 0; // 0: 리더보드, 1: 캠페인

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateActiveSection);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateActiveSection());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateActiveSection);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(int index) {
    final key = index == 0 ? _leaderboardKey : _campaignKey;
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOut,
        alignment: 0.05, // 살짝 상단에 위치
      );
    }
  }

  void _updateActiveSection() {
    // 화면 중앙에 가장 가까운 섹션을 활성으로 판단
    try {
      final size = MediaQuery.of(context).size;
      final centerY = size.height / 2;

      double? distanceToCenter(GlobalKey key) {
        final ctx = key.currentContext;
        if (ctx == null) return null;
        final box = ctx.findRenderObject() as RenderBox?;
        if (box == null || !box.attached) return null;
        final top = box.localToGlobal(Offset.zero).dy;
        final height = box.size.height;
        final sectionCenter = top + height / 2;
        return (sectionCenter - centerY).abs();
      }

      final d0 = distanceToCenter(_leaderboardKey) ?? double.infinity;
      final d1 = distanceToCenter(_campaignKey) ?? double.infinity;
      final nextIndex = d0 <= d1 ? 0 : 1;

      if (nextIndex != _currentIndex) {
        setState(() => _currentIndex = nextIndex);
      }
    } catch (_) {
      // 측정 실패 시 무시
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNarrow = MediaQuery.of(context).size.width < 360;
    final iconSize = isNarrow ? 22.0 : 24.0;
    final buttonSize = isNarrow ? 44.0 : 48.0;

    return Stack(
      children: [
        Container(
          color: AppColors.background,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // AppBar
              SliverToBoxAdapter(child: const CustomAppBar(title: '활동하기')),

              // 리더보드 섹션
              SliverToBoxAdapter(
                child: KeyedSubtree(
                  key: _leaderboardKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(17, 17, 17, 8),
                    child: LeaderboardSection(rankings: mockRankings),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // 캠페인 미션 섹션
              SliverToBoxAdapter(
                child: KeyedSubtree(
                  key: _campaignKey,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                    child: CampaignMissionSection(),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),

        // 오른쪽 중앙 네비 패널
        Positioned.fill(
          child: SafeArea(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _NavPanel(
                  currentIndex: _currentIndex,
                  iconSize: iconSize,
                  buttonSize: buttonSize,
                  onTap: _scrollTo,
                  theme: theme,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavPanel extends StatelessWidget {
  final int currentIndex;
  final double iconSize;
  final double buttonSize;
  final void Function(int) onTap;
  final ThemeData theme;

  const _NavPanel({
    required this.currentIndex,
    required this.iconSize,
    required this.buttonSize,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = Colors.white.withValues(alpha: 0.95);
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NavIconButton(
              tooltip: '리더보드',
              icon: Icons.emoji_events,
              selected: currentIndex == 0,
              iconSize: iconSize,
              buttonSize: buttonSize,
              onTap: () => onTap(0),
              selectedColor: const Color(0xFFFFD700),
              theme: theme,
            ),
            const SizedBox(height: 4),
            _NavIconButton(
              tooltip: '캠페인 미션',
              icon: Icons.assignment_turned_in_rounded,
              selected: currentIndex == 1,
              iconSize: iconSize,
              buttonSize: buttonSize,
              onTap: () => onTap(1),
              selectedColor: const Color(0xFF4A90E2),
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final bool selected;
  final double iconSize;
  final double buttonSize;
  final VoidCallback onTap;
  final Color selectedColor;
  final ThemeData theme;

  const _NavIconButton({
    required this.tooltip,
    required this.icon,
    required this.selected,
    required this.iconSize,
    required this.buttonSize,
    required this.onTap,
    required this.selectedColor,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final baseIconColor = selected ? selectedColor : Colors.black54;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(buttonSize / 2),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Icon(icon, size: iconSize, color: baseIconColor),
        ),
      ),
    );
  }
}
