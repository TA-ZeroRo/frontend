import 'package:json_annotation/json_annotation.dart';
import 'point_trend_data_point_dto.dart';
import '../../../domain/model/point/point_trend.dart';

part 'point_trend_response_dto.g.dart';

@JsonSerializable()
class PointTrendResponseDto {
  @JsonKey(name: 'user_id')
  final String userId;
  final int days;
  final List<PointTrendDataPointDto> data;

  const PointTrendResponseDto({
    required this.userId,
    required this.days,
    required this.data,
  });

  factory PointTrendResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PointTrendResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PointTrendResponseDtoToJson(this);

  PointTrend toModel() {
    return PointTrend(
      userId: userId,
      days: days,
      data: data
          .map((dto) => PointTrendDataPoint(
                date: DateTime.parse(dto.date),
                totalPoints: dto.totalPoints,
              ))
          .toList(),
    );
  }
}