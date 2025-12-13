// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_verification_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageVerificationResponseDto _$ImageVerificationResponseDtoFromJson(
  Map<String, dynamic> json,
) => ImageVerificationResponseDto(
  result: ImageVerificationResultDto.fromJson(
    json['result'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ImageVerificationResponseDtoToJson(
  ImageVerificationResponseDto instance,
) => <String, dynamic>{'result': instance.result};

ImageVerificationResultDto _$ImageVerificationResultDtoFromJson(
  Map<String, dynamic> json,
) => ImageVerificationResultDto(
  isValid: json['is_valid'] as bool,
  confidence: (json['confidence'] as num).toDouble(),
  reason: json['reason'] as String,
);

Map<String, dynamic> _$ImageVerificationResultDtoToJson(
  ImageVerificationResultDto instance,
) => <String, dynamic>{
  'is_valid': instance.isValid,
  'confidence': instance.confidence,
  'reason': instance.reason,
};
