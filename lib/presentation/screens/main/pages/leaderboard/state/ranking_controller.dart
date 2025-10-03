import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mock/mock_ranking_data.dart';

class RankingAsyncNotifier extends AsyncNotifier<List<RankingItem>> {
  @override
  Future<List<RankingItem>> build() async {
    return await _fetchRankings();
  }

  Future<List<RankingItem>> _fetchRankings() async {
    // API 호출 시뮬레이션
    await Future.delayed(const Duration(seconds: 2));
    return mockRankings;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(seconds: 1));
      return mockRankings;
    });
  }
}

final rankingProvider =
    AsyncNotifierProvider<RankingAsyncNotifier, List<RankingItem>>(
  RankingAsyncNotifier.new,
);
