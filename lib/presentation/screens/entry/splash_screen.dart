import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_color.dart';
import '../../routes/router_path.dart';
import 'state/auth_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSession();
    });
  }

  Future<void> _checkSession() async {
    // 세션 체크
    await Future.wait([
      ref.read(authProvider.notifier).checkAndRestoreSession(),
      Future.delayed(const Duration(seconds: 1)),
    ]);

    if (!mounted) return;

    final authState = ref.read(authProvider);

    // 세션 있고 유저 정보도 있으면 메인으로
    if (authState.currentUser != null) {
      // 자동 로그인 성공 토스트
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Image.asset('assets/images/google.png', width: 20, height: 20),
                const SizedBox(width: 12),
                const Text('자동 로그인 되었습니다'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(milliseconds: 1500),
          ),
        );

        // SnackBar가 스플래시 화면에서 보이도록 대기
        await Future.delayed(const Duration(seconds: 2));
      }

      if (!mounted) return;
      context.go(RoutePath.main);
    } else {
      // 세션 없거나 유저 정보 없으면 로그인으로
      context.go(RoutePath.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Stack(
          children: [
            // 하단 이미지 (윗면 곡선 처리)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: screenHeight * 0.45,
              child: ClipPath(
                clipper: TopCurvedClipper(),
                child: Image.asset(
                  'assets/images/splash.png.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
            // 로고
            Positioned(
              top: screenHeight * 0.28,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset('assets/images/ZeroRo_logo.png', width: 320),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 윗면을 부드러운 곡선으로 처리하는 CustomClipper
class TopCurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // 왼쪽 아래에서 시작
    path.moveTo(0, size.height);

    // 왼쪽 위로 직선
    path.lineTo(0, 60);

    // 윗면을 베지어 곡선으로 (중앙이 위로 볼록한 아치형)
    path.quadraticBezierTo(
      size.width / 2,
      -50, // 제어점 (중앙, 위로 올라감)
      size.width,
      60, // 끝점 (오른쪽)
    );

    // 오른쪽 아래로 직선
    path.lineTo(size.width, size.height);

    // 패스 닫기
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
