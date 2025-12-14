// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_verification_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextVerificationResponseDto _$TextVerificationResponseDtoFromJson(
  Map<String, dynamic> json,
) => TextVerificationResponseDto(
  isValid: json['is_valid'] as bool,
  confidence: (json['confidence'] as num).toDouble(),
  reason: json['reason'] as String,
);

Map<String, dynamic> _$TextVerificationResponseDtoToJson(
  TextVerificationResponseDto instance,
) => <String, dynamic>{
  'is_valid': instance.isValid,
  'confidence': instance.confidence,
  'reason': instance.reason,
};
