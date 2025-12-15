import 'package:freezed_annotation/freezed_annotation.dart';

part 'point_trend.freezed.dart';
part 'point_trend.g.dart';

/// 포인트 추이 데이터 포인트 (일별)
@freezed
abstract class PointTrendDataPoint with _$PointTrendDataPoint {
  const factory PointTrendDataPoint({
    required DateTime date,
    required int totalPoints,
  }) = _PointTrendDataPoint;

  factory PointTrendDataPoint.fromJson(Map<String, dynamic> json) =>
      _$PointTrendDataPointFromJson(json);
}

/// 포인트 추이 응답 모델
@freezed
abstract class PointTrend with _$PointTrend {
  const factory PointTrend({
    required String userId,
    required int days,
    required List<PointTrendDataPoint> data,
  }) = _PointTrend;

  factory PointTrend.fromJson(Map<String, dynamic> json) =>
      _$PointTrendFromJson(json);
}