// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_plogging_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPloggingStatsDto _$UserPloggingStatsDtoFromJson(
  Map<String, dynamic> json,
) => UserPloggingStatsDto(
  totalSessions: (json['total_sessions'] as num?)?.toInt() ?? 0,
  totalDurationMinutes: (json['total_duration_minutes'] as num?)?.toInt() ?? 0,
  totalDistanceMeters: (json['total_distance_meters'] as num?)?.toDouble() ?? 0,
  totalVerifications: (json['total_verifications'] as num?)?.toInt() ?? 0,
  totalPointsEarned: (json['total_points_earned'] as num?)?.toInt() ?? 0,
  avgIntensityLevel: (json['avg_intensity_level'] as num?)?.toDouble() ?? 1.0,
);

Map<String, dynamic> _$UserPloggingStatsDtoToJson(
  UserPloggingStatsDto instance,
) => <String, dynamic>{
  'total_sessions': instance.totalSessions,
  'total_duration_minutes': instance.totalDurationMinutes,
  'total_distance_meters': instance.totalDistanceMeters,
  'total_verifications': instance.totalVerifications,
  'total_points_earned': instance.totalPointsEarned,
  'avg_intensity_level': instance.avgIntensityLevel,
};
