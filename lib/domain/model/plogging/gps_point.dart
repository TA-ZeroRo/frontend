import 'package:freezed_annotation/freezed_annotation.dart';

part 'gps_point.freezed.dart';
part 'gps_point.g.dart';

@freezed
abstract class GpsPoint with _$GpsPoint {
  const factory GpsPoint({
    required double lat,
    required double lng,
    required DateTime timestamp,
    double? accuracy,
  }) = _GpsPoint;

  factory GpsPoint.fromJson(Map<String, dynamic> json) =>
      _$GpsPointFromJson(json);
}
