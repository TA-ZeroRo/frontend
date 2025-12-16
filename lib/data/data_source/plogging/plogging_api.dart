import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/plogging/community_route_dto.dart';
import '../../dto/plogging/h3_aggregation_dto.dart';
import '../../dto/plogging/photo_verification_dto.dart';
import '../../dto/plogging/plogging_session_dto.dart';
import '../../dto/plogging/user_plogging_stats_dto.dart';

@injectable
class PloggingApi {
  final Dio _dio;

  PloggingApi(this._dio);

  /// 플로깅 세션 시작
  /// POST /plogging/sessions
  Future<PloggingSessionDto> startSession({
    required String userId,
    required String initialPhotoUrl,
  }) async {
    final response = await _dio.post(
      '/plogging/sessions',
      data: {
        'user_id': userId,
        'initial_photo_url': initialPhotoUrl,
      },
    );
    return PloggingSessionDto.fromJson(response.data);
  }

  /// 플로깅 세션 종료
  /// PUT /plogging/sessions/{session_id}/end
  Future<PloggingSessionDto> endSession({
    required int sessionId,
    required PloggingSessionEndRequest request,
  }) async {
    final response = await _dio.put(
      '/plogging/sessions/$sessionId/end',
      data: request.toJson(),
    );
    return PloggingSessionDto.fromJson(response.data);
  }

  /// 진행 중인 세션 조회
  /// GET /plogging/sessions/active?user_id={user_id}
  Future<PloggingSessionDto?> getActiveSession(String userId) async {
    try {
      final response = await _dio.get(
        '/plogging/sessions/active',
        queryParameters: {'user_id': userId},
      );
      if (response.data == null) {
        return null;
      }
      return PloggingSessionDto.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  /// 세션 상세 조회 (경로 포함)
  /// GET /plogging/sessions/{session_id}
  Future<PloggingSessionDto> getSession(int sessionId) async {
    final response = await _dio.get('/plogging/sessions/$sessionId');
    return PloggingSessionDto.fromJson(response.data);
  }

  /// 사용자의 세션 히스토리 조회
  /// GET /plogging/sessions?user_id={user_id}
  Future<List<PloggingSessionDto>> getUserSessions(
    String userId, {
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _dio.get(
      '/plogging/sessions',
      queryParameters: {
        'user_id': userId,
        'limit': limit,
        'offset': offset,
      },
    );
    final List<dynamic> data = response.data;
    return data.map((json) => PloggingSessionDto.fromJson(json)).toList();
  }

  /// 사진 인증 제출
  /// POST /plogging/sessions/{session_id}/verify?user_id={user_id}
  Future<PhotoVerificationResponseDto> submitVerification({
    required int sessionId,
    required String userId,
    required PhotoVerificationRequestDto request,
  }) async {
    final response = await _dio.post(
      '/plogging/sessions/$sessionId/verify',
      queryParameters: {'user_id': userId},
      data: request.toJson(),
    );
    return PhotoVerificationResponseDto.fromJson(response.data);
  }

  /// 세션의 인증 내역 조회
  /// GET /plogging/sessions/{session_id}/verifications
  Future<List<PhotoVerificationResponseDto>> getSessionVerifications(
    int sessionId,
  ) async {
    final response = await _dio.get(
      '/plogging/sessions/$sessionId/verifications',
    );
    final List<dynamic> data = response.data;
    return data
        .map((json) => PhotoVerificationResponseDto.fromJson(json))
        .toList();
  }

  /// 커뮤니티 경로 조회 (지도용)
  /// GET /plogging/map/routes
  Future<MapRoutesResponseDto> getMapRoutes({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
    int limit = 100,
  }) async {
    final response = await _dio.get(
      '/plogging/map/routes',
      queryParameters: {
        'min_lat': minLat,
        'max_lat': maxLat,
        'min_lng': minLng,
        'max_lng': maxLng,
        'limit': limit,
      },
    );
    return MapRoutesResponseDto.fromJson(response.data);
  }

  /// H3 집계 데이터 조회 (히트맵용)
  /// GET /plogging/map/h3
  Future<H3MapResponseDto> getH3Aggregations({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  }) async {
    final response = await _dio.get(
      '/plogging/map/h3',
      queryParameters: {
        'min_lat': minLat,
        'max_lat': maxLat,
        'min_lng': minLng,
        'max_lng': maxLng,
      },
    );
    return H3MapResponseDto.fromJson(response.data);
  }

  /// 사용자 통계 조회
  /// GET /plogging/stats/{user_id}
  Future<UserPloggingStatsDto> getUserStats(String userId) async {
    final response = await _dio.get('/plogging/stats/$userId');
    return UserPloggingStatsDto.fromJson(response.data);
  }
}
