import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import '../../../core/theme/app_color.dart';
import '../../routes/router_path.dart';
import 'state/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  Future<void> _handleGoogleLogin(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authProvider.notifier).loginWithGoogle();

      // Web에서는 리디렉션이 자동으로 페이지를 전환하므로 라우팅 안 함
      // Mobile에서만 로그인 성공 시 메인 화면으로 이동
      if (!kIsWeb && context.mounted) {
        context.go(RoutePath.main);
      }
    } catch (e) {
      if (!context.mounted) return;

      // 유저 정보가 없으면 회원가입 페이지로 이동
      if (e.toString().contains('USER_NOT_FOUND')) {
        context.go(RoutePath.register);
        return;
      }

      // 구글 로그인 취소는 토스트 없이 조용히 처리
      if (e.toString().contains('Google 로그인이 취소되었습니다')) {
        return;
      }

      // 기타 에러는 토스트로 표시
      String errorMessage = 'Google 로그인에 실패했습니다';

      if (e.toString().contains('Google 인증 토큰')) {
        errorMessage = '인증 정보를 가져오는데 실패했습니다';
      } else if (e.toString().contains('사용자 ID')) {
        errorMessage = '사용자 정보를 가져오는데 실패했습니다';
      } else if (e.toString().contains('Exception:')) {
        // "Exception: " 접두사 제거
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      }

      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: const Text('로그인 실패'),
        description: Text(errorMessage),
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          // 로고 이미지
          Image.asset(
            'assets/images/ZeroRo_logo.png',
            height: 80,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 16),

          // 부제목
          const Text(
            '친환경 라이프스타일을 시작해보세요',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 120),

          // 구글 로그인 버튼
          SizedBox(
            height: 56,
            width: 340,
            child: ElevatedButton(
              onPressed: authState.isLoading
                  ? null
                  : () => _handleGoogleLogin(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
                elevation: 2,
              ),
              child: authState.isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google.png',
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Google 계정으로 빠르게 시작하세요',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 20),

          // 구분선
          Row(
            children: [
              Expanded(child: Container(height: 1, color: Colors.grey[300])),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('또는', style: TextStyle(fontSize: 14)),
              ),
              Expanded(child: Container(height: 1, color: Colors.grey[300])),
            ],
          ),

          const SizedBox(height: 20),

          // 게스트 로그인 버튼
          SizedBox(
            width: 340,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                context.go(RoutePath.main);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, color: Colors.grey[700], size: 24),
                  const SizedBox(width: 12),
                  Text(
                    '게스트로 시작하기',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
