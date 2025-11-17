import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/mission/mission_log_dto.dart';

@injectable
class MissionApi {
  final Dio _dio;

  MissionApi(this._dio);

  /// 사용자의 모든 미션 로그 조회
  /// GET /mission-logs/users/{user_id}
  Future<List<MissionLogDto>> getUserMissionLogs(
    String userId, {
    bool includeTemplate = true,
    bool includeCampaign = true,
  }) async {
    final queryParameters = <String, dynamic>{
      'include_template': includeTemplate,
      'include_campaign': includeCampaign,
    };

    final response = await _dio.get(
      '/mission-logs/users/$userId',
      queryParameters: queryParameters,
    );

    final List<dynamic> data = response.data;
    return data.map((json) => MissionLogDto.fromJson(json)).toList();
  }
}
