// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VerificationResult _$VerificationResultFromJson(Map<String, dynamic> json) =>
    _VerificationResult(
      isValid: json['isValid'] as bool,
      confidence: (json['confidence'] as num).toDouble(),
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$VerificationResultToJson(_VerificationResult instance) =>
    <String, dynamic>{
      'isValid': instance.isValid,
      'confidence': instance.confidence,
      'reason': instance.reason,
    };
