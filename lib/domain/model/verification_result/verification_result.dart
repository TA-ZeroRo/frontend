import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_result.freezed.dart';
part 'verification_result.g.dart';

@freezed
abstract class VerificationResult with _$VerificationResult {
  const factory VerificationResult({
    required bool isValid,
    required double confidence,
    required String reason,
  }) = _VerificationResult;

  factory VerificationResult.fromJson(Map<String, dynamic> json) =>
      _$VerificationResultFromJson(json);
}
