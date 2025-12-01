import 'package:json_annotation/json_annotation.dart';

import '../../../domain/model/plogging/plogging_stats.dart';

part 'user_plogging_stats_dto.g.dart';

@JsonSerializable()
class UserPloggingStatsDto {
  @JsonKey(name: 'total_sessions')
  final int totalSessions;
  @JsonKey(name: 'total_duration_minutes')
  final int totalDurationMinutes;
  @JsonKey(name: 'total_distance_meters')
  final double totalDistanceMeters;
  @JsonKey(name: 'total_verifications')
  final int totalVerifications;
  @JsonKey(name: 'total_points_earned')
  final int totalPointsEarned;
  @JsonKey(name: 'avg_intensity_level')
  final double avgIntensityLevel;

  const UserPloggingStatsDto({
    this.totalSessions = 0,
    this.totalDurationMinutes = 0,
    this.totalDistanceMeters = 0,
    this.totalVerifications = 0,
    this.totalPointsEarned = 0,
    this.avgIntensityLevel = 1.0,
  });

  factory UserPloggingStatsDto.fromJson(Map<String, dynamic> json) =>
      _$UserPloggingStatsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserPloggingStatsDtoToJson(this);

  PloggingStats toModel() {
    return PloggingStats(
      totalSessions: totalSessions,
      totalDurationMinutes: totalDurationMinutes,
      totalDistanceMeters: totalDistanceMeters,
      totalVerifications: totalVerifications,
      totalPointsEarned: totalPointsEarned,
      avgIntensityLevel: avgIntensityLevel,
    );
  }
}
