import 'package:json_annotation/json_annotation.dart';

part 'point_trend_data_point_dto.g.dart';

@JsonSerializable()
class PointTrendDataPointDto {
  final String date;
  @JsonKey(name: 'total_points')
  final int totalPoints;

  const PointTrendDataPointDto({
    required this.date,
    required this.totalPoints,
  });

  factory PointTrendDataPointDto.fromJson(Map<String, dynamic> json) =>
      _$PointTrendDataPointDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PointTrendDataPointDtoToJson(this);
}