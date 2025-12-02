// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GpsPoint _$GpsPointFromJson(Map<String, dynamic> json) => _GpsPoint(
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  timestamp: DateTime.parse(json['timestamp'] as String),
  accuracy: (json['accuracy'] as num?)?.toDouble(),
);

Map<String, dynamic> _$GpsPointToJson(_GpsPoint instance) => <String, dynamic>{
  'lat': instance.lat,
  'lng': instance.lng,
  'timestamp': instance.timestamp.toIso8601String(),
  'accuracy': instance.accuracy,
};
