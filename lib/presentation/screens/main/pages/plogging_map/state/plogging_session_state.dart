import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../domain/model/plogging/gps_point.dart';
import '../../../../../../domain/model/plogging/photo_verification.dart';
import '../../../../../../domain/model/plogging/plogging_session.dart';
import '../../../../../../domain/repository/plogging_repository.dart';
import '../../../../entry/state/auth_controller.dart';

// ========================================
// PLOGGING SESSION STATE
// ========================================

/// 플로깅 세션 상태
class PloggingSessionState {
  final PloggingSession? currentSession;
  final List<GpsPoint> routePoints;
  final List<PhotoVerificationResponse> verifications;
  final bool isTracking;
  final DateTime? nextVerificationTime;
  final Position? currentPosition;
  final String? errorMessage;

  const PloggingSessionState({
    this.currentSession,
    this.routePoints = const [],
    this.verifications = const [],
    this.isTracking = false,
    this.nextVerificationTime,
    this.currentPosition,
    this.errorMessage,
  });

  /// 세션 진행 중 여부
  bool get isSessionActive =>
      currentSession?.status == PloggingStatus.inProgress;

  /// 경과 시간 (분)
  int get elapsedMinutes {
    if (currentSession == null) return 0;
    return DateTime.now().difference(currentSession!.startedAt).inMinutes;
  }

  /// 인증 가능 여부 (20분마다)
  bool get canVerify {
    if (nextVerificationTime == null) return true;
    return DateTime.now().isAfter(nextVerificationTime!);
  }

  /// 총 이동 거리 (미터)
  double get totalDistanceMeters {
    if (routePoints.length < 2) return 0;
    double total = 0;
    for (int i = 1; i < routePoints.length; i++) {
      total += Geolocator.distanceBetween(
        routePoints[i - 1].lat,
        routePoints[i - 1].lng,
        routePoints[i].lat,
        routePoints[i].lng,
      );
    }
    return total;
  }

  PloggingSessionState copyWith({
    PloggingSession? currentSession,
    List<GpsPoint>? routePoints,
    List<PhotoVerificationResponse>? verifications,
    bool? isTracking,
    DateTime? nextVerificationTime,
    Position? currentPosition,
    String? errorMessage,
    bool clearSession = false,
    bool clearError = false,
  }) {
    return PloggingSessionState(
      currentSession: clearSession ? null : (currentSession ?? this.currentSession),
      routePoints: routePoints ?? this.routePoints,
      verifications: verifications ?? this.verifications,
      isTracking: isTracking ?? this.isTracking,
      nextVerificationTime: nextVerificationTime ?? this.nextVerificationTime,
      currentPosition: currentPosition ?? this.currentPosition,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// 플로깅 세션 Notifier
class PloggingSessionNotifier extends Notifier<PloggingSessionState> {
  late final PloggingRepository _repository;
  StreamSubscription<Position>? _positionSubscription;
  Timer? _verificationTimer;

  /// 인증 간격 (20분)
  static const verificationIntervalMinutes = 20;

  @override
  PloggingSessionState build() {
    _repository = getIt<PloggingRepository>();

    // Cleanup on dispose
    ref.onDispose(() {
      _positionSubscription?.cancel();
      _verificationTimer?.cancel();
    });

    // 초기 상태 - 진행 중인 세션이 있는지 확인
    _checkActiveSession();

    return const PloggingSessionState();
  }

  /// 진행 중인 세션 확인
  Future<void> _checkActiveSession() async {
    final userId = ref.read(authProvider).currentUser?.id;
    if (userId == null) return;

    try {
      final activeSession = await _repository.getActiveSession(userId);
      if (activeSession != null) {
        state = state.copyWith(
          currentSession: activeSession,
          isTracking: true,
        );
        _startTracking();
      }
    } catch (e) {
      // 무시 - 세션이 없는 경우
    }
  }

  /// 플로깅 세션 시작
  Future<void> startSession() async {
    final userId = ref.read(authProvider).currentUser?.id;
    if (userId == null) {
      state = state.copyWith(errorMessage: '로그인이 필요합니다');
      return;
    }

    try {
      state = state.copyWith(clearError: true);

      // 위치 권한 확인
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied ||
            requested == LocationPermission.deniedForever) {
          state = state.copyWith(errorMessage: '위치 권한이 필요합니다');
          return;
        }
      }

      // 세션 생성
      final session = await _repository.startSession(userId);

      state = state.copyWith(
        currentSession: session,
        routePoints: [],
        verifications: [],
        isTracking: true,
        nextVerificationTime: DateTime.now().add(
          const Duration(minutes: verificationIntervalMinutes),
        ),
      );

      // GPS 트래킹 시작
      _startTracking();

      // 인증 알림 타이머 시작
      _startVerificationTimer();
    } catch (e) {
      state = state.copyWith(errorMessage: '세션 시작 실패: $e');
    }
  }

  /// 플로깅 세션 종료
  Future<void> endSession() async {
    if (state.currentSession == null) return;

    try {
      final result = await _repository.endSession(
        sessionId: state.currentSession!.id,
        routePoints: state.routePoints,
      );

      // 트래킹 중지
      _stopTracking();

      state = state.copyWith(
        currentSession: result,
        isTracking: false,
        clearSession: true,
      );

      // 지도 데이터 리프레시 트리거
      ref.read(ploggingMapRefreshTriggerProvider.notifier).trigger();
    } catch (e) {
      state = state.copyWith(errorMessage: '세션 종료 실패: $e');
    }
  }

  /// GPS 트래킹 시작
  void _startTracking() {
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // 10미터마다 업데이트
      ),
    ).listen((position) {
      final point = GpsPoint(
        lat: position.latitude,
        lng: position.longitude,
        timestamp: DateTime.now(),
        accuracy: position.accuracy,
      );

      state = state.copyWith(
        currentPosition: position,
        routePoints: [...state.routePoints, point],
      );
    });
  }

  /// GPS 트래킹 중지
  void _stopTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    _verificationTimer?.cancel();
    _verificationTimer = null;
  }

  /// 인증 타이머 시작
  void _startVerificationTimer() {
    _verificationTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) {
        // 상태 업데이트하여 UI 리빌드 (인증 가능 여부 체크)
        state = state.copyWith();
      },
    );
  }

  /// 사진 인증 제출
  Future<PhotoVerificationResponse?> submitVerification({
    required String imageUrl,
  }) async {
    if (state.currentSession == null || state.currentPosition == null) {
      state = state.copyWith(errorMessage: '세션 또는 위치 정보가 없습니다');
      return null;
    }

    try {
      final result = await _repository.submitVerification(
        sessionId: state.currentSession!.id,
        imageUrl: imageUrl,
        latitude: state.currentPosition!.latitude,
        longitude: state.currentPosition!.longitude,
      );

      state = state.copyWith(
        verifications: [...state.verifications, result],
        nextVerificationTime: DateTime.now().add(
          const Duration(minutes: verificationIntervalMinutes),
        ),
      );

      return result;
    } catch (e) {
      state = state.copyWith(errorMessage: '인증 실패: $e');
      return null;
    }
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// 현재 위치 가져오기 (세션 없이도 동작)
  Future<Position?> getCurrentLocation() async {
    try {
      // 위치 권한 확인
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          state = state.copyWith(errorMessage: '위치 권한이 필요합니다');
          return null;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      state = state.copyWith(currentPosition: position);
      return position;
    } catch (e) {
      state = state.copyWith(errorMessage: '위치를 가져올 수 없습니다: $e');
      return null;
    }
  }
}

/// 플로깅 세션 Provider
final ploggingSessionProvider =
    NotifierProvider<PloggingSessionNotifier, PloggingSessionState>(
      PloggingSessionNotifier.new,
    );

// ========================================
// PLOGGING MAP REFRESH TRIGGER
// ========================================

/// 지도 데이터 리프레시 트리거
class PloggingMapRefreshTrigger extends Notifier<bool> {
  @override
  bool build() => false;

  void trigger() {
    state = !state;
  }
}

final ploggingMapRefreshTriggerProvider =
    NotifierProvider<PloggingMapRefreshTrigger, bool>(
      PloggingMapRefreshTrigger.new,
    );
