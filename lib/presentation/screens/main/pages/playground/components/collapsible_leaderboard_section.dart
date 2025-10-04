import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/mock/mock_ranking_data.dart';
import '../state/playground_providers.dart';
import 'ranking_view.dart';
import 'rank_tile.dart';

/// Collapsible leaderboard section that shows MyRankTile by default
/// and expands to show full leaderboard when tapped
class CollapsibleLeaderboardSection extends ConsumerWidget {
  final List<RankingItem> rankings;

  const CollapsibleLeaderboardSection({
    super.key,
    required this.rankings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(leaderboardExpandedProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(context, ref, isExpanded),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          _buildMyRankSection(),
          if (isExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
            _buildExpandedContent(),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, WidgetRef ref, bool isExpanded) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(leaderboardExpandedProvider.notifier).toggle();
        },
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: isExpanded ? Radius.zero : const Radius.circular(18),
          bottomRight: isExpanded ? Radius.zero : const Radius.circular(18),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: isExpanded ? Radius.zero : const Radius.circular(18),
              bottomRight: isExpanded ? Radius.zero : const Radius.circular(18),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: Color(0xFFFFD700),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                '리더보드',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                child: Icon(
                  Icons.expand_more_rounded,
                  color: Colors.grey[700],
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyRankSection() {
    if (rankings.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.leaderboard, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                '아직 랭킹 데이터가 없어요',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Find user's rank (임시로 'me' userId 사용)
    final myRankIndex = rankings.indexWhere((r) => r.userId == 'me');
    final myRank = myRankIndex >= 0 ? myRankIndex + 1 : 1;
    final myUser = rankings[myRankIndex >= 0 ? myRankIndex : 0];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: MyRankTile(
        rank: myRank,
        name: myUser.username,
        score: myUser.totalPoints,
      ),
    );
  }

  Widget _buildExpandedContent() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 350,
          maxHeight: 500,
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
              Expanded(child: _buildTabBarView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: Colors.blue[50],
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
          Tab(text: '전체'),
          Tab(text: '지역'),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
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
    );
  }
}
