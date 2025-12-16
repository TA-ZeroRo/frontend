import '../model/plogging/gps_point.dart';
import '../model/plogging/photo_verification.dart';
import '../model/plogging/plogging_route.dart';
import '../model/plogging/plogging_session.dart';
import '../model/plogging/plogging_stats.dart';

/// 플로깅 관련 저장소 인터페이스
abstract class PloggingRepository {
  /// 플로깅 세션 시작 (초기 사진 URL 필수)
  Future<PloggingSession> startSession({
    required String userId,
    required String initialPhotoUrl,
  });

  /// 플로깅 세션 종료
  Future<PloggingSession> endSession({
    required int sessionId,
    required List<GpsPoint> routePoints,
  });

  /// 진행 중인 세션 조회
  Future<PloggingSession?> getActiveSession(String userId);

  /// 세션 상세 조회
  Future<PloggingSession> getSession(int sessionId);

  /// 사용자의 세션 히스토리 조회
  Future<List<PloggingSession>> getUserSessions(
    String userId, {
    int limit = 20,
    int offset = 0,
  });

  /// 사진 인증 제출
  Future<PhotoVerificationResponse> submitVerification({
    required int sessionId,
    required String userId,
    required String imageUrl,
    required double latitude,
    required double longitude,
  });

  /// 세션의 인증 내역 조회
  Future<List<PhotoVerificationResponse>> getSessionVerifications(
    int sessionId,
  );

  /// 커뮤니티 경로 조회 (지도용)
  Future<MapRoutesResponse> getMapRoutes({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
    int limit = 100,
  });

  /// 사용자 통계 조회
  Future<PloggingStats> getUserStats(String userId);
}
