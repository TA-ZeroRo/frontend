import 'package:injectable/injectable.dart';

import '../../core/logger/logger.dart';
import '../../domain/model/leaderboard/leaderboard_entry.dart';
import '../../domain/repository/leaderboard_repository.dart';
import '../data_source/leaderboard/leaderboard_remote_data_source.dart';

/// 리더보드 저장소 구현체
@Injectable(as: LeaderboardRepository)
class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final LeaderboardRemoteDataSource _remoteDataSource;

  LeaderboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<LeaderboardEntry>> getRanking() async {
    try {
      final result = await _remoteDataSource.getRanking();
      return result.map((dto) => dto.toModel()).toList();
    } catch (e) {
      CustomLogger.logger.e('getRanking - 리더보드 조회 실패', error: e);
      rethrow;
    }
  }

  @override
  Future<LeaderboardEntry> getMyRanking(String userId) async {
    try {
      final result = await _remoteDataSource.getMyRanking(userId);
      return result.toModel();
    } catch (e) {
      CustomLogger.logger.e('getMyRanking - 내 순위 조회 실패', error: e);
      rethrow;
    }
  }
}
