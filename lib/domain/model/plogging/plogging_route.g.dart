// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plogging_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PloggingRoute _$PloggingRouteFromJson(Map<String, dynamic> json) =>
    _PloggingRoute(
      sessionId: (json['sessionId'] as num).toInt(),
      userId: json['userId'] as String,
      intensityLevel: (json['intensityLevel'] as num).toInt(),
      routePoints: (json['routePoints'] as List<dynamic>)
          .map((e) => GpsPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PloggingRouteToJson(_PloggingRoute instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'userId': instance.userId,
      'intensityLevel': instance.intensityLevel,
      'routePoints': instance.routePoints,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_MapRoutesResponse _$MapRoutesResponseFromJson(Map<String, dynamic> json) =>
    _MapRoutesResponse(
      routes: (json['routes'] as List<dynamic>)
          .map((e) => PloggingRoute.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
    );

Map<String, dynamic> _$MapRoutesResponseToJson(_MapRoutesResponse instance) =>
    <String, dynamic>{
      'routes': instance.routes,
      'totalCount': instance.totalCount,
    };
