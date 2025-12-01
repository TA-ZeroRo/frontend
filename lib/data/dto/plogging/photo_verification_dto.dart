import 'package:json_annotation/json_annotation.dart';

import '../../../domain/model/plogging/photo_verification.dart';

part 'photo_verification_dto.g.dart';

@JsonSerializable()
class PhotoVerificationRequestDto {
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final double latitude;
  final double longitude;

  const PhotoVerificationRequestDto({
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });

  factory PhotoVerificationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$PhotoVerificationRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoVerificationRequestDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PhotoVerificationResponseDto {
  final int id;
  @JsonKey(name: 'session_id')
  final int sessionId;
  @JsonKey(name: 'verification_status')
  final String verificationStatus;
  @JsonKey(name: 'ai_confidence')
  final double? aiConfidence;
  @JsonKey(name: 'ai_result')
  final AIVerificationResultDto? aiResult;
  @JsonKey(name: 'points_earned')
  final int pointsEarned;
  @JsonKey(name: 'verified_at')
  final String verifiedAt;

  const PhotoVerificationResponseDto({
    required this.id,
    required this.sessionId,
    required this.verificationStatus,
    this.aiConfidence,
    this.aiResult,
    this.pointsEarned = 0,
    required this.verifiedAt,
  });

  factory PhotoVerificationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PhotoVerificationResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoVerificationResponseDtoToJson(this);

  PhotoVerificationResponse toModel() {
    return PhotoVerificationResponse(
      id: id,
      sessionId: sessionId,
      verificationStatus: _parseStatus(verificationStatus),
      aiConfidence: aiConfidence,
      aiResult: aiResult?.toModel(),
      pointsEarned: pointsEarned,
      verifiedAt: DateTime.parse(verifiedAt),
    );
  }

  VerificationStatus _parseStatus(String status) {
    switch (status) {
      case 'PENDING':
        return VerificationStatus.pending;
      case 'VERIFIED':
        return VerificationStatus.verified;
      case 'REJECTED':
        return VerificationStatus.rejected;
      default:
        return VerificationStatus.pending;
    }
  }
}

@JsonSerializable()
class AIVerificationResultDto {
  @JsonKey(name: 'is_valid')
  final bool isValid;
  final double confidence;
  @JsonKey(name: 'detected_items')
  final List<String> detectedItems;
  final String reason;

  const AIVerificationResultDto({
    required this.isValid,
    required this.confidence,
    this.detectedItems = const [],
    required this.reason,
  });

  factory AIVerificationResultDto.fromJson(Map<String, dynamic> json) =>
      _$AIVerificationResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AIVerificationResultDtoToJson(this);

  AIVerificationResult toModel() {
    return AIVerificationResult(
      isValid: isValid,
      confidence: confidence,
      detectedItems: detectedItems,
      reason: reason,
    );
  }
}
