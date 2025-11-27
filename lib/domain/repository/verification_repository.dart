import '../model/verification/location_verification_result.dart';

/// 인증 관련 저장소 인터페이스
abstract class VerificationRepository {
  /// 위치 인증 요청
  ///
  /// [campaignId] 캠페인 ID
  /// [latitude] 현재 위치 위도
  /// [longitude] 현재 위치 경도
  ///
  /// Returns 위치 인증 결과
  Future<LocationVerificationResult> verifyLocation({
    required int campaignId,
    required double latitude,
    required double longitude,
  });
}
