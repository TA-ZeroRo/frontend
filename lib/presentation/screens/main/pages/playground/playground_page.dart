import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_color.dart';
import 'state/ranking_controller.dart';
import 'state/mock/mock_ranking_data.dart';
import 'components/collapsible_leaderboard_section.dart';
import 'components/activity_verification_section.dart';
import 'components/shimmer_widgets.dart';

class PlaygroundPage extends ConsumerWidget {
  const PlaygroundPage({super.key});

  Future<void> _onRefresh(WidgetRef ref) async {
    await ref.read(rankingProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRankings = ref.watch(rankingProvider);

    return asyncRankings.when(
      data: (rankings) => _buildSuccessView(context, ref, rankings),
      loading: () => _buildLoadingView(),
      error: (error, stack) => _buildErrorView(context, ref),
    );
  }

  Widget _buildSuccessView(
      BuildContext context, WidgetRef ref, List<RankingItem> rankings) {
    return Container(
      color: AppColors.background,
      child: RefreshIndicator(
        onRefresh: () => _onRefresh(ref),
        color: Theme.of(context).primaryColor,
        backgroundColor: AppColors.background,
        displacement: 40.0,
        strokeWidth: 2.5,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: CollapsibleLeaderboardSection(rankings: rankings),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
            const SliverToBoxAdapter(
              child: ActivityVerificationSection(),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.background,
      child: RefreshIndicator(
        onRefresh: () => _onRefresh(ref),
        color: Theme.of(context).primaryColor,
        backgroundColor: AppColors.background,
        displacement: 40.0,
        strokeWidth: 2.5,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    const Text(
                      '랭킹을 불러올 수 없어요',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '아래로 당겨서 새로고침해보세요',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      color: AppColors.background,
      child: CustomScrollView(
        slivers: [
          _buildAppBar(),
          const SliverToBoxAdapter(
            child: PlaygroundShimmer(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
          const SliverToBoxAdapter(
            child: ActivityVerificationSection(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return const SliverAppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      floating: true,
      snap: true,
      title: Text(
        'Playground',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
    );
  }

}
