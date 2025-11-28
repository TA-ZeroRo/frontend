// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_verification_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationVerificationRequestDto _$LocationVerificationRequestDtoFromJson(
  Map<String, dynamic> json,
) => LocationVerificationRequestDto(
  campaignId: (json['campaign_id'] as num).toInt(),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
);

Map<String, dynamic> _$LocationVerificationRequestDtoToJson(
  LocationVerificationRequestDto instance,
) => <String, dynamic>{
  'campaign_id': instance.campaignId,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
