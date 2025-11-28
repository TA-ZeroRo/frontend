// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_trend_data_point_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointTrendDataPointDto _$PointTrendDataPointDtoFromJson(
  Map<String, dynamic> json,
) => PointTrendDataPointDto(
  date: json['date'] as String,
  totalPoints: (json['total_points'] as num).toInt(),
);

Map<String, dynamic> _$PointTrendDataPointDtoToJson(
  PointTrendDataPointDto instance,
) => <String, dynamic>{
  'date': instance.date,
  'total_points': instance.totalPoints,
};
