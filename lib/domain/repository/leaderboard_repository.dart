import '../model/leaderboard/leaderboard_entry.dart';

/// 리더보드 저장소 인터페이스
abstract class LeaderboardRepository {
  /// 리더보드 순위 조회
  Future<List<LeaderboardEntry>> getRanking();

  /// 내 리더보드 순위 조회
  Future<LeaderboardEntry> getMyRanking(String userId);
}
