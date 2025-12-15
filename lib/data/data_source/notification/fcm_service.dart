import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

/// FCM 백그라운드 메시지 핸들러 (Top-level 함수여야 함)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // 백그라운드에서는 시스템이 자동으로 알림을 표시함
  print('Background message received: ${message.messageId}');
}

/// FCM 서비스 - 토큰 관리 및 메시지 처리
@injectable
class FcmService {
  final Dio _dio;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  String? _currentToken;
  bool _isInitialized = false;

  FcmService(this._dio);

  /// 현재 FCM 토큰
  String? get currentToken => _currentToken;

  /// FCM 서비스 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    // 권한 요청
    await requestPermission();

    // 토큰 가져오기
    _currentToken = await _messaging.getToken();
    print('FCM Token: $_currentToken');

    // 토큰 갱신 리스너
    _messaging.onTokenRefresh.listen((newToken) {
      print('FCM Token refreshed: $newToken');
      _currentToken = newToken;
      // TODO: 토큰 갱신 시 서버에 업데이트
    });

    _isInitialized = true;
  }

  /// 알림 권한 요청
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final granted = settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    print('FCM Permission: ${settings.authorizationStatus}');
    return granted;
  }

  /// FCM 토큰을 서버에 등록
  Future<bool> registerToken(String userId) async {
    if (_currentToken == null) {
      await initialize();
    }

    if (_currentToken == null) {
      print('FCM token is null, cannot register');
      return false;
    }

    try {
      final platform = Platform.isAndroid ? 'android' : 'ios';

      await _dio.post(
        '/fcm/token',
        data: {
          'user_id': userId,
          'fcm_token': _currentToken,
          'platform': platform,
        },
      );

      print('FCM token registered successfully');
      return true;
    } catch (e) {
      print('Failed to register FCM token: $e');
      return false;
    }
  }

  /// FCM 토큰을 서버에서 삭제 (로그아웃 시)
  Future<bool> deleteToken(String userId) async {
    if (_currentToken == null) return true;

    try {
      await _dio.delete(
        '/fcm/token',
        data: {
          'user_id': userId,
          'fcm_token': _currentToken,
        },
      );

      print('FCM token deleted successfully');
      return true;
    } catch (e) {
      print('Failed to delete FCM token: $e');
      return false;
    }
  }

  /// 포그라운드 메시지 리스너 설정
  void setupForegroundMessageHandler(void Function(RemoteMessage) onMessage) {
    FirebaseMessaging.onMessage.listen(onMessage);
  }

  /// 앱이 백그라운드에서 알림 클릭으로 열렸을 때 처리
  void setupMessageOpenedAppHandler(void Function(RemoteMessage) onMessageOpenedApp) {
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
  }

  /// 앱이 종료된 상태에서 알림 클릭으로 열렸을 때 초기 메시지 가져오기
  Future<RemoteMessage?> getInitialMessage() async {
    return await _messaging.getInitialMessage();
  }
}

/// FcmService Provider
final fcmServiceProvider = Provider<FcmService>((ref) {
  throw UnimplementedError('FcmService must be provided with Dio instance');
});
