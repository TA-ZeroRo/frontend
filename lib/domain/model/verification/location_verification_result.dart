import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_verification_result.freezed.dart';

/// 위치 인증 결과 도메인 모델
@freezed
abstract class LocationVerificationResult with _$LocationVerificationResult {
  const factory LocationVerificationResult({
    /// 검증 성공 여부
    required bool isValid,

    /// 검증 결과 메시지
    required String reason,

    /// 캠페인 장소와의 거리 (미터 단위)
    double? distance,

    /// 검증 시간
    DateTime? verifiedAt,

    /// 캠페인 장소 주소
    String? locationAddress,
  }) = _LocationVerificationResult;
}