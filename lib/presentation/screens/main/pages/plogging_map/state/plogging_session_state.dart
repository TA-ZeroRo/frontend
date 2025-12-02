import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../data/data_source/notification/plogging_notification_service.dart';
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
  final double totalDistanceMeters; // 누적 거리 (O(1) 접근)

  const PloggingSessionState({
    this.currentSession,
    this.routePoints = const [],
    this.verifications = const [],
    this.isTracking = false,
    this.nextVerificationTime,
    this.currentPosition,
    this.errorMessage,
    this.totalDistanceMeters = 0,
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

  PloggingSessionState copyWith({
    PloggingSession? currentSession,
    List<GpsPoint>? routePoints,
    List<PhotoVerificationResponse>? verifications,
    bool? isTracking,
    DateTime? nextVerificationTime,
    Position? currentPosition,
    String? errorMessage,
    double? totalDistanceMeters,
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
      totalDistanceMeters: totalDistanceMeters ?? this.totalDistanceMeters,
    );
  }
}

/// 플로깅 세션 Notifier
class PloggingSessionNotifier extends Notifier<PloggingSessionState> {
  late final PloggingRepository _repository;
  late final PloggingNotificationService _notificationService;
  StreamSubscription<Position>? _positionSubscription;
  Timer? _sessionTimer; // 통합 타이머 (알림 + 인증 체크)
  int _sessionTickCount = 0;
  bool _lastCanVerify = false; // 인증 상태 변경 감지용
  String? _lastNotificationBody; // 알림 중복 업데이트 방지

  /// 인증 간격 (20분)
  static const verificationIntervalMinutes = 20;

  @override
  PloggingSessionState build() {
    _repository = getIt<PloggingRepository>();
    _notificationService = ref.read(ploggingNotificationServiceProvider);

    // Cleanup on dispose
    ref.onDispose(() {
      _positionSubscription?.cancel();
      _sessionTimer?.cancel();
      _notificationService.stopNotification();
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
        totalDistanceMeters: 0,
        nextVerificationTime: DateTime.now().add(
          const Duration(minutes: verificationIntervalMinutes),
        ),
      );

      // GPS 트래킹 시작 (비동기, 논블로킹)
      _startTracking();

      // 통합 타이머 시작 (알림 + 인증 체크)
      _startSessionTimer();

      // 알림 시작
      await _startNotification();
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

      // 알림 종료
      await _notificationService.stopNotification();

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

  /// GPS 트래킹 시작 (논블로킹)
  Future<void> _startTracking() async {
    // 1. 캐시된 마지막 위치로 즉시 UI 업데이트 (블로킹 없음)
    try {
      final lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        state = state.copyWith(currentPosition: lastPosition);
      }
    } catch (_) {
      // 캐시된 위치가 없어도 계속 진행
    }

    // 2. 다음 마이크로태스크에서 스트림 구독 시작 (메인 스레드 블로킹 방지)
    Future.microtask(() {
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // 10미터마다 업데이트
        ),
      ).listen(_onPositionUpdate);
    });
  }

  /// GPS 위치 업데이트 콜백
  void _onPositionUpdate(Position position) {
    final point = GpsPoint(
      lat: position.latitude,
      lng: position.longitude,
      timestamp: DateTime.now(),
      accuracy: position.accuracy,
    );

    // 거리 누적 계산 (O(1))
    double additionalDistance = 0;
    if (state.routePoints.isNotEmpty) {
      final lastPoint = state.routePoints.last;
      additionalDistance = Geolocator.distanceBetween(
        lastPoint.lat,
        lastPoint.lng,
        position.latitude,
        position.longitude,
      );
    }

    state = state.copyWith(
      currentPosition: position,
      routePoints: [...state.routePoints, point],
      totalDistanceMeters: state.totalDistanceMeters + additionalDistance,
    );
  }

  /// GPS 트래킹 중지
  void _stopTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    _sessionTimer?.cancel();
    _sessionTimer = null;
    _sessionTickCount = 0;
  }

  /// 통합 세션 타이머 시작 (알림 업데이트 + 인증 상태 체크)
  void _startSessionTimer() {
    _sessionTickCount = 0;
    _lastCanVerify = state.canVerify;

    _sessionTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        _sessionTickCount++;

        // 알림 업데이트 (매초)
        _updateNotification();

        // 인증 상태 체크 (1분마다만 UI 리빌드)
        if (_sessionTickCount % 60 == 0) {
          _checkVerificationStatus();
        }
      },
    );
  }

  /// 인증 가능 상태 체크 (변경 시에만 UI 리빌드)
  void _checkVerificationStatus() {
    final canVerifyNow = state.canVerify;
    if (canVerifyNow != _lastCanVerify) {
      _lastCanVerify = canVerifyNow;
      // 인증 상태가 변경되었을 때만 상태 업데이트
      state = state.copyWith();
    }
  }

  /// 알림 시작
  Future<void> _startNotification() async {
    // 알림 권한 요청
    await _notificationService.requestPermission();

    // 알림 초기화
    await _notificationService.initialize(
      onAction: _handleNotificationAction,
    );

    // 초기 알림 표시
    await _updateNotification();
    // 이후 업데이트는 _startSessionTimer에서 처리
  }

  /// 알림 업데이트 (중복 방지)
  Future<void> _updateNotification() async {
    if (state.currentSession == null) return;

    final elapsed = DateTime.now().difference(state.currentSession!.startedAt);
    final hours = elapsed.inHours;
    final minutes = elapsed.inMinutes % 60;
    final seconds = elapsed.inSeconds % 60;

    final elapsedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    final distance = '${(state.totalDistanceMeters / 1000).toStringAsFixed(2)}km';

    // 알림 본문 생성
    final body = state.canVerify
        ? '$elapsedTime · $distance · 인증 가능!'
        : '$elapsedTime · $distance';

    // 내용이 변경되지 않았으면 스킵 (불필요한 알림 업데이트 방지)
    if (body == _lastNotificationBody) return;
    _lastNotificationBody = body;

    await _notificationService.updateNotification(
      elapsedTime: elapsedTime,
      distance: distance,
      canVerify: state.canVerify,
    );
  }

  /// 알림 액션 처리
  void _handleNotificationAction(PloggingNotificationAction action) {
    switch (action) {
      case PloggingNotificationAction.stop:
        endSession();
        break;
      case PloggingNotificationAction.verify:
        // 알림에서 인증하기 버튼 클릭 시 앱으로 이동
        // 실제 인증은 앱에서 진행
        break;
    }
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

      // 알림 업데이트 (인증 가능 상태 변경)
      await _updateNotification();

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

// ========================================
// PLOGGING ELAPSED TIME STREAM PROVIDER
// ========================================

/// 플로깅 경과 시간 스트림 Provider (PloggingSessionInfo용)
/// - 1초마다 경과 시간 업데이트
/// - 세션이 없으면 Duration.zero 반환
final ploggingElapsedTimeProvider = StreamProvider.autoDispose<Duration>((ref) {
  final sessionState = ref.watch(ploggingSessionProvider);

  if (!sessionState.isSessionActive || sessionState.currentSession == null) {
    return Stream.value(Duration.zero);
  }

  final startedAt = sessionState.currentSession!.startedAt;

  return Stream.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now().difference(startedAt),
  );
});
