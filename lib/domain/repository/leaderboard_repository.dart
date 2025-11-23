import '../model/leaderboard/leaderboard_entry.dart';

/// 리더보드 저장소 인터페이스
abstract class LeaderboardRepository {
  /// 리더보드 순위 조회 (하위 호환성을 위해 유지)
  Future<List<LeaderboardEntry>> getRanking();

  /// 내 리더보드 순위 조회 (하위 호환성을 위해 유지)
  Future<LeaderboardEntry> getMyRanking(String userId);

  /// 리더보드 순위 + 내 순위 통합 조회
  /// Returns: (leaderboard, myRank)
  Future<(List<LeaderboardEntry>, LeaderboardEntry?)> getRankingWithMyRank(
    String? userId,
  );
}
