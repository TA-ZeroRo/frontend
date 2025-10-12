// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChartData _$ChartDataFromJson(Map<String, dynamic> json) => _ChartData(
  date: DateTime.parse(json['date'] as String),
  score: (json['score'] as num).toInt(),
);

Map<String, dynamic> _$ChartDataToJson(_ChartData instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'score': instance.score,
    };
