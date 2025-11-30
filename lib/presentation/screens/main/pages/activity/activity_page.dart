import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/components/custom_app_bar.dart';

import '../../../../../core/theme/app_color.dart';
import 'components/leaderboard_section.dart';
import 'components/campaign_mission_section.dart';

class ActivityPage extends ConsumerWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.background,
      child: CustomScrollView(
        slivers: [
          // AppBar
          SliverToBoxAdapter(child: const CustomAppBar(title: '활동하기')),

          // 리더보드 섹션
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 17, right: 17, top: 12),
              child: LeaderboardSection(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // 캠페인 미션 섹션
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
              child: CampaignMissionSection(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
