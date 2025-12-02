import 'package:json_annotation/json_annotation.dart';

import '../../../domain/model/plogging/plogging_route.dart';
import 'gps_point_dto.dart';

part 'community_route_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class CommunityRouteDto {
  @JsonKey(name: 'session_id')
  final int sessionId;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'intensity_level')
  final int intensityLevel;
  @JsonKey(name: 'route_points')
  final List<GpsPointDto> routePoints;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const CommunityRouteDto({
    required this.sessionId,
    required this.userId,
    required this.intensityLevel,
    required this.routePoints,
    required this.createdAt,
  });

  factory CommunityRouteDto.fromJson(Map<String, dynamic> json) =>
      _$CommunityRouteDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityRouteDtoToJson(this);

  PloggingRoute toModel() {
    return PloggingRoute(
      sessionId: sessionId,
      userId: userId,
      intensityLevel: intensityLevel,
      routePoints: routePoints.map((p) => p.toModel()).toList(),
      createdAt: DateTime.parse(createdAt),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MapRoutesResponseDto {
  final List<CommunityRouteDto> routes;
  @JsonKey(name: 'total_count')
  final int totalCount;

  const MapRoutesResponseDto({
    required this.routes,
    required this.totalCount,
  });

  factory MapRoutesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MapRoutesResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MapRoutesResponseDtoToJson(this);

  MapRoutesResponse toModel() {
    return MapRoutesResponse(
      routes: routes.map((r) => r.toModel()).toList(),
      totalCount: totalCount,
    );
  }
}
