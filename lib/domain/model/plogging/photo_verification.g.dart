// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AIVerificationResult _$AIVerificationResultFromJson(
  Map<String, dynamic> json,
) => _AIVerificationResult(
  isValid: json['isValid'] as bool,
  confidence: (json['confidence'] as num).toDouble(),
  detectedItems:
      (json['detectedItems'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  reason: json['reason'] as String,
);

Map<String, dynamic> _$AIVerificationResultToJson(
  _AIVerificationResult instance,
) => <String, dynamic>{
  'isValid': instance.isValid,
  'confidence': instance.confidence,
  'detectedItems': instance.detectedItems,
  'reason': instance.reason,
};

_PhotoVerificationResponse _$PhotoVerificationResponseFromJson(
  Map<String, dynamic> json,
) => _PhotoVerificationResponse(
  id: (json['id'] as num).toInt(),
  sessionId: (json['sessionId'] as num).toInt(),
  verificationStatus: $enumDecode(
    _$VerificationStatusEnumMap,
    json['verificationStatus'],
  ),
  aiConfidence: (json['aiConfidence'] as num?)?.toDouble(),
  aiResult: json['aiResult'] == null
      ? null
      : AIVerificationResult.fromJson(json['aiResult'] as Map<String, dynamic>),
  pointsEarned: (json['pointsEarned'] as num?)?.toInt() ?? 0,
  verifiedAt: DateTime.parse(json['verifiedAt'] as String),
);

Map<String, dynamic> _$PhotoVerificationResponseToJson(
  _PhotoVerificationResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'sessionId': instance.sessionId,
  'verificationStatus':
      _$VerificationStatusEnumMap[instance.verificationStatus]!,
  'aiConfidence': instance.aiConfidence,
  'aiResult': instance.aiResult,
  'pointsEarned': instance.pointsEarned,
  'verifiedAt': instance.verifiedAt.toIso8601String(),
};

const _$VerificationStatusEnumMap = {
  VerificationStatus.pending: 'PENDING',
  VerificationStatus.verified: 'VERIFIED',
  VerificationStatus.rejected: 'REJECTED',
};
