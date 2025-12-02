// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_verification_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoVerificationRequestDto _$PhotoVerificationRequestDtoFromJson(
  Map<String, dynamic> json,
) => PhotoVerificationRequestDto(
  imageUrl: json['image_url'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
);

Map<String, dynamic> _$PhotoVerificationRequestDtoToJson(
  PhotoVerificationRequestDto instance,
) => <String, dynamic>{
  'image_url': instance.imageUrl,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};

PhotoVerificationResponseDto _$PhotoVerificationResponseDtoFromJson(
  Map<String, dynamic> json,
) => PhotoVerificationResponseDto(
  id: (json['id'] as num).toInt(),
  sessionId: (json['session_id'] as num).toInt(),
  verificationStatus: json['verification_status'] as String,
  aiConfidence: (json['ai_confidence'] as num?)?.toDouble(),
  aiResult: json['ai_result'] == null
      ? null
      : AIVerificationResultDto.fromJson(
          json['ai_result'] as Map<String, dynamic>,
        ),
  pointsEarned: (json['points_earned'] as num?)?.toInt() ?? 0,
  verifiedAt: json['verified_at'] as String,
);

Map<String, dynamic> _$PhotoVerificationResponseDtoToJson(
  PhotoVerificationResponseDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'session_id': instance.sessionId,
  'verification_status': instance.verificationStatus,
  'ai_confidence': instance.aiConfidence,
  'ai_result': instance.aiResult?.toJson(),
  'points_earned': instance.pointsEarned,
  'verified_at': instance.verifiedAt,
};

AIVerificationResultDto _$AIVerificationResultDtoFromJson(
  Map<String, dynamic> json,
) => AIVerificationResultDto(
  isValid: json['is_valid'] as bool,
  confidence: (json['confidence'] as num).toDouble(),
  detectedItems:
      (json['detected_items'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  reason: json['reason'] as String,
);

Map<String, dynamic> _$AIVerificationResultDtoToJson(
  AIVerificationResultDto instance,
) => <String, dynamic>{
  'is_valid': instance.isValid,
  'confidence': instance.confidence,
  'detected_items': instance.detectedItems,
  'reason': instance.reason,
};
