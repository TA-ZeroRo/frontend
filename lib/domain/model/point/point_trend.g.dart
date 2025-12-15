// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_trend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PointTrendDataPoint _$PointTrendDataPointFromJson(Map<String, dynamic> json) =>
    _PointTrendDataPoint(
      date: DateTime.parse(json['date'] as String),
      totalPoints: (json['totalPoints'] as num).toInt(),
    );

Map<String, dynamic> _$PointTrendDataPointToJson(
  _PointTrendDataPoint instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'totalPoints': instance.totalPoints,
};

_PointTrend _$PointTrendFromJson(Map<String, dynamic> json) => _PointTrend(
  userId: json['userId'] as String,
  days: (json['days'] as num).toInt(),
  data: (json['data'] as List<dynamic>)
      .map((e) => PointTrendDataPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PointTrendToJson(_PointTrend instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'days': instance.days,
      'data': instance.data,
    };
