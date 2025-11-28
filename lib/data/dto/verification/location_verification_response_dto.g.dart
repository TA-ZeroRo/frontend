// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_verification_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationVerificationResponseDto _$LocationVerificationResponseDtoFromJson(
  Map<String, dynamic> json,
) => LocationVerificationResponseDto(
  isValid: json['is_valid'] as bool,
  reason: json['reason'] as String,
  distance: (json['distance'] as num?)?.toDouble(),
  verifiedAt: json['verified_at'] as String?,
  locationAddress: json['location_address'] as String?,
);

Map<String, dynamic> _$LocationVerificationResponseDtoToJson(
  LocationVerificationResponseDto instance,
) => <String, dynamic>{
  'is_valid': instance.isValid,
  'reason': instance.reason,
  'distance': instance.distance,
  'verified_at': instance.verifiedAt,
  'location_address': instance.locationAddress,
};
