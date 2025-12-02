import 'package:freezed_annotation/freezed_annotation.dart';
import 'gps_point.dart';

part 'plogging_route.freezed.dart';
part 'plogging_route.g.dart';

@freezed
abstract class PloggingRoute with _$PloggingRoute {
  const factory PloggingRoute({
    required int sessionId,
    required String userId,
    required int intensityLevel,
    required List<GpsPoint> routePoints,
    required DateTime createdAt,
  }) = _PloggingRoute;

  factory PloggingRoute.fromJson(Map<String, dynamic> json) =>
      _$PloggingRouteFromJson(json);
}

@freezed
abstract class MapRoutesResponse with _$MapRoutesResponse {
  const factory MapRoutesResponse({
    required List<PloggingRoute> routes,
    required int totalCount,
  }) = _MapRoutesResponse;

  factory MapRoutesResponse.fromJson(Map<String, dynamic> json) =>
      _$MapRoutesResponseFromJson(json);
}
