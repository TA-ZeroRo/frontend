import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/leaderboard/leaderboard_entry_dto.dart';
import '../../dto/leaderboard/leaderboard_response_dto.dart';

/// 리더보드 원격 데이터 소스
@injectable
class LeaderboardRemoteDataSource {
  final Dio _dio;

  LeaderboardRemoteDataSource(this._dio);

  /// 리더보드 순위 조회 (상위 랭킹 + 내 순위)
  /// GET /leaderboard/ranking?user_id={userId}
  Future<LeaderboardResponseDto> getRanking({String? userId}) async {
    final response = await _dio.get(
      '/leaderboard/ranking',
      queryParameters: userId != null ? {'user_id': userId} : null,
    );

    return LeaderboardResponseDto.fromJson(response.data);
  }

  /// 내 리더보드 순위 조회 (하위 호환성을 위해 유지)
  /// GET /leaderboard/ranking/{user_id}
  Future<LeaderboardEntryDto> getMyRanking(String userId) async {
    final response = await _dio.get('/leaderboard/ranking/$userId');
    return LeaderboardEntryDto.fromJson(response.data);
  }
}
