import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// 현재 활성화된 채팅방 ID를 관리하는 Provider
final activeChatRoomIdProvider = StateProvider<int?>((ref) => null);

/// 채팅 알림 핸들러 - 포그라운드에서 채팅 알림 처리
class ChatNotificationHandler {
  static const String _channelId = 'chat_messages';
  static const String _channelName = '채팅 메시지';
  static const String _channelDescription = '채팅 메시지 알림';

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// 알림 클릭 콜백
  void Function(int chatRoomId, int? recruitingPostId)? onNotificationTap;

  /// 초기화
  Future<void> initialize({
    void Function(int chatRoomId, int? recruitingPostId)? onTap,
  }) async {
    if (_isInitialized) return;

    onNotificationTap = onTap;

    // 로컬 알림 초기화
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // Android 알림 채널 생성
    if (Platform.isAndroid) {
      await _createAndroidChannel();
    }

    _isInitialized = true;
  }

  /// Android 알림 채널 생성
  Future<void> _createAndroidChannel() async {
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// 알림 클릭 응답 처리
  void _onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || onNotificationTap == null) return;

    // payload 형식: "chatRoomId:recruitingPostId"
    final parts = payload.split(':');
    if (parts.isEmpty) return;

    final chatRoomId = int.tryParse(parts[0]);
    final recruitingPostId = parts.length > 1 ? int.tryParse(parts[1]) : null;

    if (chatRoomId != null) {
      onNotificationTap!(chatRoomId, recruitingPostId);
    }
  }

  /// 포그라운드에서 FCM 메시지 처리
  Future<void> handleForegroundMessage(
    RemoteMessage message, {
    required int? activeChatRoomId,
  }) async {
    final data = message.data;
    final type = data['type'];

    // 채팅 메시지가 아니면 무시
    if (type != 'chat_message') return;

    final chatRoomIdStr = data['chat_room_id'];
    if (chatRoomIdStr == null) return;

    final chatRoomId = int.tryParse(chatRoomIdStr);
    if (chatRoomId == null) return;

    // 현재 보고 있는 채팅방이면 알림 표시 안 함
    if (activeChatRoomId != null && activeChatRoomId == chatRoomId) {
      print('Skipping notification for active chat room: $chatRoomId');
      return;
    }

    // 로컬 알림 표시
    await _showLocalNotification(message);
  }

  /// 로컬 알림 표시
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    if (notification == null) return;

    final chatRoomId = data['chat_room_id'] ?? '';
    final recruitingPostId = data['recruiting_post_id'] ?? '';
    final payload = '$chatRoomId:$recruitingPostId';

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // 고유한 알림 ID 생성 (채팅방별로 다르게)
    final notificationId = chatRoomId.hashCode;

    await _localNotifications.show(
      notificationId,
      notification.title,
      notification.body,
      details,
      payload: payload,
    );
  }

  /// 앱이 백그라운드/종료 상태에서 알림 클릭으로 열렸을 때 처리
  void handleMessageOpenedApp(RemoteMessage message) {
    final data = message.data;
    final chatRoomIdStr = data['chat_room_id'];
    final recruitingPostIdStr = data['recruiting_post_id'];

    if (chatRoomIdStr == null) return;

    final chatRoomId = int.tryParse(chatRoomIdStr);
    final recruitingPostId = recruitingPostIdStr != null && recruitingPostIdStr.isNotEmpty
        ? int.tryParse(recruitingPostIdStr)
        : null;

    if (chatRoomId != null && onNotificationTap != null) {
      onNotificationTap!(chatRoomId, recruitingPostId);
    }
  }
}

/// ChatNotificationHandler Provider
final chatNotificationHandlerProvider = Provider<ChatNotificationHandler>((ref) {
  return ChatNotificationHandler();
});
