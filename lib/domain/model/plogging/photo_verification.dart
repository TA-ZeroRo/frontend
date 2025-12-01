import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_verification.freezed.dart';
part 'photo_verification.g.dart';

enum VerificationStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('VERIFIED')
  verified,
  @JsonValue('REJECTED')
  rejected,
}

@freezed
abstract class AIVerificationResult with _$AIVerificationResult {
  const factory AIVerificationResult({
    required bool isValid,
    required double confidence,
    @Default([]) List<String> detectedItems,
    required String reason,
  }) = _AIVerificationResult;

  factory AIVerificationResult.fromJson(Map<String, dynamic> json) =>
      _$AIVerificationResultFromJson(json);
}

@freezed
abstract class PhotoVerificationResponse with _$PhotoVerificationResponse {
  const factory PhotoVerificationResponse({
    required int id,
    required int sessionId,
    required VerificationStatus verificationStatus,
    double? aiConfidence,
    AIVerificationResult? aiResult,
    @Default(0) int pointsEarned,
    required DateTime verifiedAt,
  }) = _PhotoVerificationResponse;

  factory PhotoVerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$PhotoVerificationResponseFromJson(json);
}
