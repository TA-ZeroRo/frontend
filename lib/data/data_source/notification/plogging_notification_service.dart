import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 플로깅 알림 액션 타입
enum PloggingNotificationAction {
  stop,
  verify,
}

/// 알림 액션 콜백 타입
typedef NotificationActionCallback = void Function(PloggingNotificationAction action);

/// 플로깅 Foreground Notification 서비스
class PloggingNotificationService {
  // Foreground 알림 (ongoing)
  static const int _notificationId = 1001;
  static const String _channelId = 'plogging_channel';
  static const String _channelName = '플로깅';
  static const String _channelDescription = '플로깅 진행 상태를 표시합니다';

  // 인증 알림 (진동 + 소리)
  static const int _alertNotificationId = 1002;
  static const String _alertChannelId = 'plogging_alert_channel_v2';
  static const String _alertChannelName = '플로깅 인증 알림';
  static const String _alertChannelDescription = '사진 인증이 가능할 때 알려드립니다';

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  NotificationActionCallback? _actionCallback;
  bool _isInitialized = false;

  /// 알림 서비스 초기화
  Future<void> initialize({NotificationActionCallback? onAction}) async {
    if (_isInitialized) return;

    _actionCallback = onAction;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // Android 알림 채널 생성
    if (Platform.isAndroid) {
      await _createAndroidChannel();
      await _createAlertChannel();
    }

    _isInitialized = true;
  }

  /// Android 알림 채널 생성
  Future<void> _createAndroidChannel() async {
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.defaultImportance,
      playSound: false,
      enableVibration: false,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Android 인증 알림 채널 생성 (진동 + 소리)
  Future<void> _createAlertChannel() async {
    const channel = AndroidNotificationChannel(
      _alertChannelId,
      _alertChannelName,
      description: _alertChannelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// 알림 응답 처리
  void _onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || _actionCallback == null) return;

    if (payload == 'stop') {
      _actionCallback!(PloggingNotificationAction.stop);
    } else if (payload == 'verify') {
      _actionCallback!(PloggingNotificationAction.verify);
    }
  }

  /// 플로깅 알림 시작
  Future<void> startNotification({
    required String elapsedTime,
    required String distance,
    bool canVerify = false,
  }) async {
    await _showNotification(
      elapsedTime: elapsedTime,
      distance: distance,
      canVerify: canVerify,
    );
  }

  /// 알림 업데이트
  Future<void> updateNotification({
    required String elapsedTime,
    required String distance,
    bool canVerify = false,
  }) async {
    await _showNotification(
      elapsedTime: elapsedTime,
      distance: distance,
      canVerify: canVerify,
    );
  }

  /// 알림 표시 (내부)
  Future<void> _showNotification({
    required String elapsedTime,
    required String distance,
    bool canVerify = false,
  }) async {
    final actions = <AndroidNotificationAction>[
      const AndroidNotificationAction(
        'stop',
        '종료',
        showsUserInterface: true,
      ),
    ];

    if (canVerify) {
      actions.insert(
        0,
        const AndroidNotificationAction(
          'verify',
          '인증하기',
          showsUserInterface: true,
        ),
      );
    }

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      ongoing: true, // 스와이프로 삭제 불가
      autoCancel: false,
      playSound: false,
      enableVibration: false,
      showWhen: false,
      usesChronometer: false,
      actions: actions,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: false,
      presentSound: false,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final body = canVerify
        ? '$elapsedTime · $distance · 인증 가능!'
        : '$elapsedTime · $distance';

    await _notifications.show(
      _notificationId,
      '플로깅 중',
      body,
      details,
    );
  }

  /// 알림 종료
  Future<void> stopNotification() async {
    await _notifications.cancel(_notificationId);
    await _notifications.cancel(_alertNotificationId);
  }

  /// 인증 가능 알림 (진동 + 소리)
  Future<void> showVerificationAlert() async {
    final androidDetails = AndroidNotificationDetails(
      _alertChannelId,
      _alertChannelName,
      channelDescription: _alertChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      autoCancel: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      _alertNotificationId,
      '사진 인증 시간!',
      '플로깅 인증 사진을 찍어주세요',
      details,
      payload: 'verify',
    );
  }

  /// 알림 권한 요청 (Android 13+)
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final android = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted = await android?.requestNotificationsPermission();
      return granted ?? false;
    }
    return true;
  }
}

/// PloggingNotificationService Provider
final ploggingNotificationServiceProvider =
    Provider<PloggingNotificationService>((ref) {
  return PloggingNotificationService();
});
