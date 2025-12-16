import 'package:injectable/injectable.dart';

import '../../core/logger/logger.dart';
import '../../domain/model/plogging/gps_point.dart';
import '../../domain/model/plogging/photo_verification.dart';
import '../../domain/model/plogging/plogging_route.dart';
import '../../domain/model/plogging/plogging_session.dart';
import '../../domain/model/plogging/plogging_stats.dart';
import '../../domain/repository/plogging_repository.dart';
import '../data_source/plogging/plogging_api.dart';
import '../dto/plogging/gps_point_dto.dart';
import '../dto/plogging/photo_verification_dto.dart';
import '../dto/plogging/plogging_session_dto.dart';

@Injectable(as: PloggingRepository)
class PloggingRepositoryImpl implements PloggingRepository {
  final PloggingApi _ploggingApi;

  PloggingRepositoryImpl(this._ploggingApi);

  @override
  Future<PloggingSession> startSession({
    required String userId,
    required String initialPhotoUrl,
  }) async {
    try {
      final result = await _ploggingApi.startSession(
        userId: userId,
        initialPhotoUrl: initialPhotoUrl,
      );
      CustomLogger.logger.i('startSession - 플로깅 세션 시작 (userId: $userId)');
      return result.toModel();
    } catch (e) {
      CustomLogger.logger.e(
        'startSession - 플로깅 세션 시작 실패 (userId: $userId)',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<PloggingSession> endSession({
    required int sessionId,
    required List<GpsPoint> routePoints,
  }) async {
    try {
      final request = PloggingSessionEndRequest(
        routePoints: routePoints.map((p) => GpsPointDto.fromModel(p)).toList(),
      );
      final result = await _ploggingApi.endSession(
        sessionId: sessionId,
        request: request,
      );
      CustomLogger.logger.i(
        'endSession - 플로깅 세션 종료 '
        '(sessionId: $sessionId, points: ${routePoints.length})',
      );
      return result.toModel();
    } catch (e) {
      CustomLogger.logger.e(
        'endSession - 플로깅 세션 종료 실패 (sessionId: $sessionId)',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<PloggingSession?> getActiveSession(String userId) async {
    try {
      final result = await _ploggingApi.getActiveSession(userId);
      if (result == null) {
        CustomLogger.logger.d(
          'getActiveSession - 진행 중인 세션 없음 (userId: $userId)',
        );
        return null;
      }
      return result.toModel();
    } catch (e) {
      CustomLogger.logger.e(
        'getActiveSession - 진행 중인 세션 조회 실패 (userId: $userId)',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<PloggingSession> getSession(int sessionId) async {
    try {
      final result = await _ploggingApi.getSession(sessionId);
      return result.toModel();
    } catch (e) {
      CustomLogger.logger.e(
        'getSession - 세션 조회 실패 (sessionId: $sessionId)',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<List<PloggingSession>> getUserSessions(
    String userId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final result = await _ploggingApi.getUserSessions(
        userId,
        limit: limit,
        offset: offset,
      );
      return result.map((dto) => dto.toModel()).toList();
    } catch (e) {
      CustomLogger.logger.e(
        'getUserSessions - 사용자 세션 조회 실패 (userId: $userId)',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<PhotoVerificationResponse> submitVerification({
    required int sessionId,
    required String userId,
    required String imageUrl,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final request = PhotoVerificationRequestDto(
        imageUrl: imageUrl,
        latitude: latitude,
        longitude: longitude,
      );
      final result = await _ploggingApi.submitVerification(
        sessionId: sessionId,
        userId: userId,
        request: request,
      );
      CustomLogger.logger.i(
        'submitVerification - 사진 인증 제출 '
        '(sessionId: $sessionId, status: ${result.verificationStatus})',
      );
      return result.toModel();
    } catch (e) {
      CustomLogger.logger.e(
        'submitVerification - 사진 인증 실패 (sessionId: $sessionId)',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<List<PhotoVerificationResponse>> getSessionVerifications(
    int sessionId,
  ) async {
    try {
      final result = await _ploggingApi.getSessionVerifications(sessionId);
      return result.map((dto) => dto.toModel()).toList();
    } catch (e) {
      CustomLogger.logger.e(
        'getSessionVerifications - 인증 내역 조회 실패 (sessionId: $sessionId)',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<MapRoutesResponse> getMapRoutes({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
    int limit = 100,
  }) async {
    try {
      final result = await _ploggingApi.getMapRoutes(
        minLat: minLat,
        maxLat: maxLat,
        minLng: minLng,
        maxLng: maxLng,
        limit: limit,
      );
      return result.toModel();
    } catch (e) {
      CustomLogger.logger.e(
        'getMapRoutes - 커뮤니티 경로 조회 실패',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<PloggingStats> getUserStats(String userId) async {
    try {
      final result = await _ploggingApi.getUserStats(userId);
      return result.toModel();
    } catch (e) {
      CustomLogger.logger.e(
        'getUserStats - 사용자 통계 조회 실패 (userId: $userId)',
        error: e,
      );
      rethrow;
    }
  }
}
