import 'package:json_annotation/json_annotation.dart';

import '../../../domain/model/plogging/gps_point.dart';

part 'gps_point_dto.g.dart';

@JsonSerializable()
class GpsPointDto {
  final double lat;
  final double lng;
  final String timestamp;
  final double? accuracy;

  const GpsPointDto({
    required this.lat,
    required this.lng,
    required this.timestamp,
    this.accuracy,
  });

  factory GpsPointDto.fromJson(Map<String, dynamic> json) =>
      _$GpsPointDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GpsPointDtoToJson(this);

  GpsPoint toModel() {
    return GpsPoint(
      lat: lat,
      lng: lng,
      timestamp: DateTime.parse(timestamp),
      accuracy: accuracy,
    );
  }

  factory GpsPointDto.fromModel(GpsPoint model) {
    return GpsPointDto(
      lat: model.lat,
      lng: model.lng,
      timestamp: model.timestamp.toIso8601String(),
      accuracy: model.accuracy,
    );
  }
}
