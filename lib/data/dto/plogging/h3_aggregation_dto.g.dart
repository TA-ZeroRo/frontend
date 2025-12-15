// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'h3_aggregation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

H3AggregationDto _$H3AggregationDtoFromJson(Map<String, dynamic> json) =>
    H3AggregationDto(
      h3Index: json['h3_index'] as String,
      centerLat: (json['center_lat'] as num).toDouble(),
      centerLng: (json['center_lng'] as num).toDouble(),
      totalSessions: (json['total_sessions'] as num).toInt(),
      totalDurationMinutes: (json['total_duration_minutes'] as num).toInt(),
      avgIntensity: (json['avg_intensity'] as num).toDouble(),
    );

Map<String, dynamic> _$H3AggregationDtoToJson(H3AggregationDto instance) =>
    <String, dynamic>{
      'h3_index': instance.h3Index,
      'center_lat': instance.centerLat,
      'center_lng': instance.centerLng,
      'total_sessions': instance.totalSessions,
      'total_duration_minutes': instance.totalDurationMinutes,
      'avg_intensity': instance.avgIntensity,
    };

H3MapResponseDto _$H3MapResponseDtoFromJson(Map<String, dynamic> json) =>
    H3MapResponseDto(
      cells: (json['cells'] as List<dynamic>)
          .map((e) => H3AggregationDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      aggregationDate: json['aggregation_date'] as String,
    );

Map<String, dynamic> _$H3MapResponseDtoToJson(H3MapResponseDto instance) =>
    <String, dynamic>{
      'cells': instance.cells.map((e) => e.toJson()).toList(),
      'aggregation_date': instance.aggregationDate,
    };
