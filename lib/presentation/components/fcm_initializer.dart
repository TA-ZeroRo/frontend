import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/di/injection.dart';
import '../../data/data_source/notification/fcm_service.dart';
import '../../data/data_source/notification/chat_notification_handler.dart';

/// FCM 초기화 및 알림 처리를 담당하는 위젯
/// 앱의 최상위에 배치하여 FCM을 초기화합니다.
class FcmInitializer extends ConsumerStatefulWidget {
  final Widget child;

  const FcmInitializer({super.key, required this.child});

  @override
  ConsumerState<FcmInitializer> createState() => _FcmInitializerState();
}

class _FcmInitializerState extends ConsumerState<FcmInitializer> {
  late final FcmService _fcmService;
  late final ChatNotificationHandler _chatNotificationHandler;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeFcm();
  }

  Future<void> _initializeFcm() async {
    if (_isInitialized) return;

    try {
      // FcmService 인스턴스 생성
      final dio = getIt<Dio>();
      _fcmService = FcmService(dio);
      _chatNotificationHandler = ChatNotificationHandler();

      // FCM 서비스 초기화
      await _fcmService.initialize();

      // 채팅 알림 핸들러 초기화
      await _chatNotificationHandler.initialize(
        onTap: _onNotificationTap,
      );

      // 포그라운드 메시지 핸들러 설정
      _fcmService.setupForegroundMessageHandler(_onForegroundMessage);

      // 백그라운드에서 알림 클릭 시 핸들러
      _fcmService.setupMessageOpenedAppHandler(_chatNotificationHandler.handleMessageOpenedApp);

      // 앱이 종료 상태에서 알림 클릭으로 열렸을 때 처리
      final initialMessage = await _fcmService.getInitialMessage();
      if (initialMessage != null) {
        _chatNotificationHandler.handleMessageOpenedApp(initialMessage);
      }

      // 로그인된 사용자가 있으면 토큰 등록
      final userId = Supabase.instance.client.auth.currentSession?.user.id;
      if (userId != null) {
        await _fcmService.registerToken(userId);
      }

      // 인증 상태 변경 감지하여 토큰 등록/삭제
      Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
        final event = data.event;
        final session = data.session;

        if (event == AuthChangeEvent.signedIn && session != null) {
          // 로그인 시 토큰 등록
          await _fcmService.registerToken(session.user.id);
        } else if (event == AuthChangeEvent.signedOut) {
          // 로그아웃 시 토큰 삭제
          final previousUserId = session?.user.id;
          if (previousUserId != null) {
            await _fcmService.deleteToken(previousUserId);
          }
        }
      });

      _isInitialized = true;
      print('FCM initialized successfully');
    } catch (e) {
      print('Error initializing FCM: $e');
    }
  }

  /// 포그라운드에서 메시지 수신 시 처리
  void _onForegroundMessage(RemoteMessage message) {
    final activeChatRoomId = ref.read(activeChatRoomIdProvider);
    _chatNotificationHandler.handleForegroundMessage(
      message,
      activeChatRoomId: activeChatRoomId,
    );
  }

  /// 알림 클릭 시 해당 채팅방으로 이동
  void _onNotificationTap(int chatRoomId, int? recruitingPostId) {
    if (!mounted) return;

    // 리크루팅 게시글 ID가 있으면 해당 화면으로 이동
    if (recruitingPostId != null) {
      // go_router를 사용하여 해당 게시글의 채팅 탭으로 이동
      // 라우트 경로는 프로젝트에 맞게 수정 필요
      context.push('/recruiting/$recruitingPostId?tab=chat');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
