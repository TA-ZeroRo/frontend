import 'package:injectable/injectable.dart';

import '../../core/logger/logger.dart';
import '../../domain/model/point/point_trend.dart';
import '../../domain/repository/point_repository.dart';
import '../data_source/point/point_api.dart';

@Injectable(as: PointRepository)
class PointRepositoryImpl implements PointRepository {
  final PointApi _pointApi;

  PointRepositoryImpl(this._pointApi);

  @override
  Future<PointTrend> getPointTrend({
    required String userId,
    int days = 7,
  }) async {
    try {
      final result = await _pointApi.getPointTrend(
        userId: userId,
        days: days,
      );
      return result.toModel();
    } catch (e) {
      CustomLogger.logger.e(
        'getPointTrend - 포인트 추이 조회 실패 (userId: $userId, days: $days)',
        error: e,
      );
      rethrow;
    }
  }
}