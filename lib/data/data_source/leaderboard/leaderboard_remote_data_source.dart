import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/leaderboard/leaderboard_entry_dto.dart';

/// 리더보드 원격 데이터 소스
@injectable
class LeaderboardRemoteDataSource {
  final Dio _dio;

  LeaderboardRemoteDataSource(this._dio);

  /// 리더보드 순위 조회
  /// GET /leaderboard/ranking
  Future<List<LeaderboardEntryDto>> getRanking() async {
    final response = await _dio.get('/leaderboard/ranking');

    final List<dynamic> data = response.data;
    return data.map((json) => LeaderboardEntryDto.fromJson(json)).toList();
  }

  /// 내 리더보드 순위 조회
  /// GET /leaderboard/ranking/{user_id}
  Future<LeaderboardEntryDto> getMyRanking(String userId) async {
    final response = await _dio.get('/leaderboard/ranking/$userId');
    return LeaderboardEntryDto.fromJson(response.data);
  }
}
