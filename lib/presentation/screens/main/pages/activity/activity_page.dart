import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_color.dart';
import 'state/activity_state.dart';
import 'components/collapsible_leaderboard_section.dart';
import 'components/campaign_mission_section.dart';
import 'components/shimmer_widgets.dart';

class ActivityPage extends ConsumerStatefulWidget {
  const ActivityPage({super.key});

  @override
  ConsumerState<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends ConsumerState<ActivityPage> {
  Future<void> _onRefresh() async {
    await ref.read(rankingProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final asyncRankings = ref.watch(rankingProvider);

    return Stack(
      children: [
        Container(
          color: AppColors.background,
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            color: Theme.of(context).primaryColor,
            backgroundColor: AppColors.background,
            displacement: 40.0,
            strokeWidth: 2.5,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // AppBar
                const SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  floating: true,
                  scrolledUnderElevation: 0,
                  snap: true,
                  title: Text(
                    '활동하기',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),

                // 리더보드 섹션 (로딩/에러 상태 처리)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: asyncRankings.when(
                      data: (rankings) =>
                          LeaderboardSection(rankings: rankings),
                      loading: () => const PlaygroundShimmer(),
                      error: (error, stack) => const SizedBox.shrink(),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // 캠페인 미션 섹션
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: CampaignMissionSection(),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
