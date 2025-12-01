// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_route_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityRouteDto _$CommunityRouteDtoFromJson(Map<String, dynamic> json) =>
    CommunityRouteDto(
      sessionId: (json['session_id'] as num).toInt(),
      userId: json['user_id'] as String,
      intensityLevel: (json['intensity_level'] as num).toInt(),
      routePoints: (json['route_points'] as List<dynamic>)
          .map((e) => GpsPointDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$CommunityRouteDtoToJson(CommunityRouteDto instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'user_id': instance.userId,
      'intensity_level': instance.intensityLevel,
      'route_points': instance.routePoints.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt,
    };

MapRoutesResponseDto _$MapRoutesResponseDtoFromJson(
  Map<String, dynamic> json,
) => MapRoutesResponseDto(
  routes: (json['routes'] as List<dynamic>)
      .map((e) => CommunityRouteDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['total_count'] as num).toInt(),
);

Map<String, dynamic> _$MapRoutesResponseDtoToJson(
  MapRoutesResponseDto instance,
) => <String, dynamic>{
  'routes': instance.routes.map((e) => e.toJson()).toList(),
  'total_count': instance.totalCount,
};
