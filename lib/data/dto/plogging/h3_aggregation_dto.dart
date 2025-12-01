import 'package:json_annotation/json_annotation.dart';

part 'h3_aggregation_dto.g.dart';

@JsonSerializable()
class H3AggregationDto {
  @JsonKey(name: 'h3_index')
  final String h3Index;
  @JsonKey(name: 'center_lat')
  final double centerLat;
  @JsonKey(name: 'center_lng')
  final double centerLng;
  @JsonKey(name: 'total_sessions')
  final int totalSessions;
  @JsonKey(name: 'total_duration_minutes')
  final int totalDurationMinutes;
  @JsonKey(name: 'avg_intensity')
  final double avgIntensity;

  const H3AggregationDto({
    required this.h3Index,
    required this.centerLat,
    required this.centerLng,
    required this.totalSessions,
    required this.totalDurationMinutes,
    required this.avgIntensity,
  });

  factory H3AggregationDto.fromJson(Map<String, dynamic> json) =>
      _$H3AggregationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$H3AggregationDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class H3MapResponseDto {
  final List<H3AggregationDto> cells;
  @JsonKey(name: 'aggregation_date')
  final String aggregationDate;

  const H3MapResponseDto({
    required this.cells,
    required this.aggregationDate,
  });

  factory H3MapResponseDto.fromJson(Map<String, dynamic> json) =>
      _$H3MapResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$H3MapResponseDtoToJson(this);
}
