import 'package:flutter/material.dart';
import 'package:frontend/core/components/custom_app_bar.dart';

import '../../../../../core/theme/app_color.dart';
import 'state/mock/mock_ranking_data.dart';
import 'components/leaderboard_section.dart';
import 'components/campaign_mission_section.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: CustomScrollView(
        slivers: [
          // AppBar
          SliverToBoxAdapter(child: const CustomAppBar(title: '활동하기')),

          // 리더보드 섹션
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(17, 17, 17, 8),
              child: LeaderboardSection(rankings: mockRankings),
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
