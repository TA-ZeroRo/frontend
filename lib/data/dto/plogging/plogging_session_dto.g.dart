// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plogging_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PloggingSessionDto _$PloggingSessionDtoFromJson(Map<String, dynamic> json) =>
    PloggingSessionDto(
      id: (json['id'] as num).toInt(),
      userId: json['user_id'] as String,
      status: json['status'] as String,
      startedAt: json['started_at'] as String,
      endedAt: json['ended_at'] as String?,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      totalDistanceMeters: (json['total_distance_meters'] as num?)?.toDouble(),
      intensityLevel: (json['intensity_level'] as num?)?.toInt() ?? 1,
      verificationCount: (json['verification_count'] as num?)?.toInt() ?? 0,
      pointsEarned: (json['points_earned'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] as String,
      routePoints: (json['route_points'] as List<dynamic>?)
          ?.map((e) => GpsPointDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      initialPhotoUrl: json['initial_photo_url'] as String?,
    );

Map<String, dynamic> _$PloggingSessionDtoToJson(PloggingSessionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'status': instance.status,
      'started_at': instance.startedAt,
      'ended_at': instance.endedAt,
      'duration_minutes': instance.durationMinutes,
      'total_distance_meters': instance.totalDistanceMeters,
      'intensity_level': instance.intensityLevel,
      'verification_count': instance.verificationCount,
      'points_earned': instance.pointsEarned,
      'created_at': instance.createdAt,
      'route_points': instance.routePoints?.map((e) => e.toJson()).toList(),
      'initial_photo_url': instance.initialPhotoUrl,
    };

PloggingSessionCreateRequest _$PloggingSessionCreateRequestFromJson(
  Map<String, dynamic> json,
) => PloggingSessionCreateRequest(
  userId: json['user_id'] as String,
  initialPhotoUrl: json['initial_photo_url'] as String,
);

Map<String, dynamic> _$PloggingSessionCreateRequestToJson(
  PloggingSessionCreateRequest instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'initial_photo_url': instance.initialPhotoUrl,
};

PloggingSessionEndRequest _$PloggingSessionEndRequestFromJson(
  Map<String, dynamic> json,
) => PloggingSessionEndRequest(
  routePoints: (json['route_points'] as List<dynamic>)
      .map((e) => GpsPointDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PloggingSessionEndRequestToJson(
  PloggingSessionEndRequest instance,
) => <String, dynamic>{
  'route_points': instance.routePoints.map((e) => e.toJson()).toList(),
};
