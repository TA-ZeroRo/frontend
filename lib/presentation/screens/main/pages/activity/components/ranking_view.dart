import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../domain/model/leaderboard/leaderboard_entry.dart';
import 'rank_tile.dart';
import 'podium_list.dart';

class RankingView extends ConsumerStatefulWidget {
  final List<LeaderboardEntry> rankings;

  const RankingView({super.key, required this.rankings});

  @override
  ConsumerState<RankingView> createState() => _RankingViewState();
}

class _RankingViewState extends ConsumerState<RankingView> {
  late ScrollController _scrollController;
  double _podiumHeight = 200.0;
  final double _minPodiumHeight = 110.0;
  final double _maxPodiumHeight = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final maxOffset = 100.0; // 스크롤 100px 후 최소 높이가 됨

    double newHeight =
        _maxPodiumHeight -
        (offset / maxOffset) * (_maxPodiumHeight - _minPodiumHeight);
    newHeight = newHeight.clamp(_minPodiumHeight, _maxPodiumHeight);

    if (newHeight != _podiumHeight) {
      setState(() {
        _podiumHeight = newHeight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ranking = widget.rankings;

    if (ranking.isEmpty) {
      return const Center(child: Text('충분한 리더보드 데이터가 없습니다.'));
    }

    // 3명 미만인 경우: ListView만 사용
    if (ranking.length < 3) {
      return ListView.builder(
        padding: EdgeInsets.zero,
        controller: _scrollController,
        itemCount: ranking.length,
        itemBuilder: (context, index) {
          final user = ranking[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: RankTile(
              rank: user.rank,
              name: user.username ?? '알 수 없음',
              score: user.totalPoints,
              userImg: user.userImg,
            ),
          );
        },
      );
    }

    // 3명 이상인 경우: PodiumList + ListView 사용
    final podium = ranking.take(3).toList();
    final rest = ranking.length > 3 ? ranking.sublist(3) : <LeaderboardEntry>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: _podiumHeight,
          child: PodiumList(top3: podium, height: _podiumHeight),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: rest.isEmpty
              ? const Center(child: Text('추가 순위 데이터가 없습니다.'))
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  controller: _scrollController,
                  itemCount: rest.length,
                  itemBuilder: (context, index) {
                    final user = rest[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: RankTile(
                        rank: user.rank,
                        name: user.username ?? '알 수 없음',
                        score: user.totalPoints,
                        userImg: user.userImg,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
