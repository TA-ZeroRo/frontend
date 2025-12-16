// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plogging_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PloggingSession _$PloggingSessionFromJson(Map<String, dynamic> json) =>
    _PloggingSession(
      id: (json['id'] as num).toInt(),
      userId: json['userId'] as String,
      status: $enumDecode(_$PloggingStatusEnumMap, json['status']),
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      totalDistanceMeters: (json['totalDistanceMeters'] as num?)?.toDouble(),
      intensityLevel: (json['intensityLevel'] as num?)?.toInt() ?? 1,
      verificationCount: (json['verificationCount'] as num?)?.toInt() ?? 0,
      pointsEarned: (json['pointsEarned'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      initialPhotoUrl: json['initialPhotoUrl'] as String?,
    );

Map<String, dynamic> _$PloggingSessionToJson(_PloggingSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'status': _$PloggingStatusEnumMap[instance.status]!,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'totalDistanceMeters': instance.totalDistanceMeters,
      'intensityLevel': instance.intensityLevel,
      'verificationCount': instance.verificationCount,
      'pointsEarned': instance.pointsEarned,
      'createdAt': instance.createdAt.toIso8601String(),
      'initialPhotoUrl': instance.initialPhotoUrl,
    };

const _$PloggingStatusEnumMap = {
  PloggingStatus.inProgress: 'IN_PROGRESS',
  PloggingStatus.completed: 'COMPLETED',
  PloggingStatus.cancelled: 'CANCELLED',
};
