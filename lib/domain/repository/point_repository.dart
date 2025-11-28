import '../model/point/point_trend.dart';

abstract class PointRepository {
  Future<PointTrend> getPointTrend({
    required String userId,
    int days = 7,
  });
}