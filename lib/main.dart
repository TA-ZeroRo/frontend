import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/config/env_var.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

import 'core/di/injection.dart';
import 'presentation/routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 환경 변수 불러오기
  await EnvConfig.initialize();

  // Supabase 초기화 (DI보다 먼저 초기화 필요)
  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
  );

  // Dependency Injection 초기화
  configureDependencies();

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
        ),
      ),
    );
  }
}
