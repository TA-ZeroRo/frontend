// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_point_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GpsPointDto _$GpsPointDtoFromJson(Map<String, dynamic> json) => GpsPointDto(
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  timestamp: json['timestamp'] as String,
  accuracy: (json['accuracy'] as num?)?.toDouble(),
);

Map<String, dynamic> _$GpsPointDtoToJson(GpsPointDto instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'timestamp': instance.timestamp,
      'accuracy': instance.accuracy,
    };
