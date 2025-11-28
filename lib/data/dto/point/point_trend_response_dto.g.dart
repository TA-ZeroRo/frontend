// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_trend_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointTrendResponseDto _$PointTrendResponseDtoFromJson(
  Map<String, dynamic> json,
) => PointTrendResponseDto(
  userId: json['user_id'] as String,
  days: (json['days'] as num).toInt(),
  data: (json['data'] as List<dynamic>)
      .map((e) => PointTrendDataPointDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PointTrendResponseDtoToJson(
  PointTrendResponseDto instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'days': instance.days,
  'data': instance.data,
};
