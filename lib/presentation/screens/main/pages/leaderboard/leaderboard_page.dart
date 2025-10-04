import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_color.dart';
import 'state/ranking_controller.dart';
import 'state/mock/mock_ranking_data.dart';
import 'components/ranking_view.dart';

class LeaderboardPage extends ConsumerWidget {
  const LeaderboardPage({super.key});

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
      color: AppColors.background, // 전체 배경 연한 회색
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24.0,
                ),
                child: Card(
                  elevation: 2, // 그림자 약하게
                  color: Colors.white,
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(
                      color: Color(0xFFE0E0E0), // 연한 회색 테두리
                      width: 1.2,
                    ),
                  ),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTabBar(),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFF0F0F0),
                        ),
                        _buildTabBarView(rankings),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
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
    );
  }

  Widget _buildLoadingView() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          const SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(strokeWidth: 3.0),
                  SizedBox(height: 16),
                  Text(
                    '랭킹을 불러오는 중...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
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
        'Leaderboard',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.blue[700],
        unselectedLabelColor: Colors.black,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        tabs: const [
          Tab(text: '국내'),
          Tab(text: '국외'),
        ],
      ),
    );
  }

  Widget _buildTabBarView(rankings) {
    return SizedBox(
      // 고정 높이 제거, 내부 콘텐츠에 맞게 유동적으로
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 350, maxHeight: 600),
        child: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: RankingView(rankings: rankings),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.construction, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    '국외 랭킹 구현 예정',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '곧 업데이트 예정입니다',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
