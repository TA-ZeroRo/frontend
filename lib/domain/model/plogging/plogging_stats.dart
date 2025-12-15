import 'package:freezed_annotation/freezed_annotation.dart';

part 'plogging_stats.freezed.dart';
part 'plogging_stats.g.dart';

@freezed
abstract class PloggingStats with _$PloggingStats {
  const factory PloggingStats({
    @Default(0) int totalSessions,
    @Default(0) int totalDurationMinutes,
    @Default(0.0) double totalDistanceMeters,
    @Default(0) int totalVerifications,
    @Default(0) int totalPointsEarned,
    @Default(1.0) double avgIntensityLevel,
  }) = _PloggingStats;

  factory PloggingStats.fromJson(Map<String, dynamic> json) =>
      _$PloggingStatsFromJson(json);
}
