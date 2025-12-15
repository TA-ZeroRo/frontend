import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/core/config/env_var.dart';
import 'package:frontend/data/data_source/notification/fcm_service.dart';
import 'package:frontend/data/data_source/notification/plogging_notification_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'core/di/injection.dart';
import 'presentation/routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 환경 변수 불러오기
  await EnvConfig.initialize();

  // Firebase 초기화
  await Firebase.initializeApp();

  // FCM 백그라운드 핸들러 등록
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Supabase 초기화 (DI보다 먼저 초기화 필요)
  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
  );
 
  // Dependency Injection 초기화
  configureDependencies();

  // 플로깅 알림 서비스 초기화
  final ploggingNotificationService = PloggingNotificationService();
  await ploggingNotificationService.initialize();
  await ploggingNotificationService.requestPermission();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: ToastificationWrapper(
        child: MaterialApp.router(
          routerConfig: router,
          theme: ThemeData(
            // 기본 텍스트 테마에 Jua 폰트 적용
            textTheme: GoogleFonts.juaTextTheme(ThemeData.light().textTheme),
            // 주요 텍스트 테마에도 Jua 폰트 적용
            primaryTextTheme: GoogleFonts.juaTextTheme(
              ThemeData.light().primaryTextTheme,
            ),
          ),
          // FCM 초기화는 앱 시작 시 별도로 처리됨
          // FcmInitializer를 사용하려면 아래와 같이 builder를 추가:
          // builder: (context, child) => FcmInitializer(child: child ?? const SizedBox()),
        ),
      ),
    );  
  }
}
