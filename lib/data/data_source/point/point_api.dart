import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/point/point_trend_response_dto.dart';

@injectable
class PointApi {
  final Dio _dio;

  PointApi(this._dio);

  /// 사용자의 포인트 추이 조회
  /// GET /point/trend/{userId}
  Future<PointTrendResponseDto> getPointTrend({
    required String userId,
    int days = 7,
  }) async {
    final response = await _dio.get(
      '/point/trend/$userId',
      queryParameters: {'days': days},
    );

    return PointTrendResponseDto.fromJson(response.data);
  }
}