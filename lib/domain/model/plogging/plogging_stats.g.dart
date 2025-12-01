// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plogging_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PloggingStats _$PloggingStatsFromJson(
  Map<String, dynamic> json,
) => _PloggingStats(
  totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
  totalDurationMinutes: (json['totalDurationMinutes'] as num?)?.toInt() ?? 0,
  totalDistanceMeters: (json['totalDistanceMeters'] as num?)?.toDouble() ?? 0.0,
  totalVerifications: (json['totalVerifications'] as num?)?.toInt() ?? 0,
  totalPointsEarned: (json['totalPointsEarned'] as num?)?.toInt() ?? 0,
  avgIntensityLevel: (json['avgIntensityLevel'] as num?)?.toDouble() ?? 1.0,
);

Map<String, dynamic> _$PloggingStatsToJson(_PloggingStats instance) =>
    <String, dynamic>{
      'totalSessions': instance.totalSessions,
      'totalDurationMinutes': instance.totalDurationMinutes,
      'totalDistanceMeters': instance.totalDistanceMeters,
      'totalVerifications': instance.totalVerifications,
      'totalPointsEarned': instance.totalPointsEarned,
      'avgIntensityLevel': instance.avgIntensityLevel,
    };
