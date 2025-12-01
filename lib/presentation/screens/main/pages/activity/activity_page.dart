import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/components/custom_app_bar.dart';
import '../../../../../core/theme/app_color.dart';
import 'components/leaderboard_section.dart';
import 'components/campaign_mission_section.dart';
import 'state/leaderboard_state.dart';
import 'state/campaign_mission_state.dart';

class ActivityPage extends ConsumerWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: '활동하기'),
      body: RefreshIndicator(
        onRefresh: () async {
          // 리더보드와 미션 데이터 새로고침
          await Future.wait([
            ref.read(combinedRankingProvider.notifier).refresh(),
            ref.read(campaignMissionProvider.notifier).refresh(),
          ]);
        },
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 리더보드 섹션
              const LeaderboardSection(),
              const SizedBox(height: 24),
              // 캠페인 미션 섹션
              const CampaignMissionSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
