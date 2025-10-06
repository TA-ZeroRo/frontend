import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_color.dart';
import 'state/ranking_controller.dart';
import 'state/mock/mock_ranking_data.dart';
import 'components/collapsible_leaderboard_section.dart';
import 'components/daily_quest_section.dart';
import 'components/activity_verification_fab.dart';
import 'components/shimmer_widgets.dart';

class PlaygroundPage extends ConsumerStatefulWidget {
  const PlaygroundPage({super.key});

  @override
  ConsumerState<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends ConsumerState<PlaygroundPage> {
  bool _isMenuExpanded = false;
  final GlobalKey<ActivityVerificationFabState> _fabKey = GlobalKey<ActivityVerificationFabState>();

  Future<void> _onRefresh() async {
    await ref.read(rankingProvider.notifier).refresh();
  }

  void _closeMenu() {
    _fabKey.currentState?.close();
  }

  @override
  Widget build(BuildContext context) {
    final asyncRankings = ref.watch(rankingProvider);

    return asyncRankings.when(
      data: (rankings) => _buildSuccessView(context, rankings),
      loading: () => _buildLoadingView(),
      error: (error, stack) => _buildErrorView(context),
    );
  }

  Widget _buildSuccessView(
      BuildContext context, List<RankingItem> rankings) {
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
              child: DailyQuestSection(),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
          ),
        ),
        // Semi-transparent overlay when menu is expanded
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !_isMenuExpanded,
            child: GestureDetector(
              onTap: _closeMenu,
              child: AnimatedOpacity(
                opacity: _isMenuExpanded ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  color: const Color(0x80000000),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: ActivityVerificationFab(
            key: _fabKey,
            onExpandedChanged: (isExpanded) {
              setState(() => _isMenuExpanded = isExpanded);
            },
            onOverlayTap: _closeMenu,
            onPhotoVerification: () {
              // TODO: Navigate to photo verification screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('사진인증 기능은 아직 구현중입니다'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            onQuizVerification: () {
              // TODO: Navigate to quiz verification screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('퀴즈 인증 기능은 아직 구현중입니다'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context) {
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
        ),
        // Semi-transparent overlay when menu is expanded
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !_isMenuExpanded,
            child: GestureDetector(
              onTap: _closeMenu,
              child: AnimatedOpacity(
                opacity: _isMenuExpanded ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  color: const Color(0x80000000),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: ActivityVerificationFab(
            key: _fabKey,
            onExpandedChanged: (isExpanded) {
              setState(() => _isMenuExpanded = isExpanded);
            },
            onOverlayTap: _closeMenu,
            onPhotoVerification: () {
              // TODO: Navigate to photo verification screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('사진인증 기능은 아직 구현중입니다'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            onQuizVerification: () {
              // TODO: Navigate to quiz verification screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('퀴즈 인증 기능은 아직 구현중입니다'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingView() {
    return Stack(
      children: [
        Container(
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
            child: DailyQuestSection(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
          ),
        ),
        // Semi-transparent overlay when menu is expanded
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !_isMenuExpanded,
            child: GestureDetector(
              onTap: _closeMenu,
              child: AnimatedOpacity(
                opacity: _isMenuExpanded ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  color: const Color(0x80000000),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: ActivityVerificationFab(
            key: _fabKey,
            onExpandedChanged: (isExpanded) {
              setState(() => _isMenuExpanded = isExpanded);
            },
            onOverlayTap: _closeMenu,
            onPhotoVerification: () {
              // TODO: Navigate to photo verification screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('사진인증 기능은 아직 구현중입니다'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            onQuizVerification: () {
              // TODO: Navigate to quiz verification screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('퀴즈 인증 기능은 아직 구현중입니다'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      ],
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
