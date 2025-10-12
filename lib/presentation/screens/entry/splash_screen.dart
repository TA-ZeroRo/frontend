import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_color.dart';
import '../../routes/router_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Fade 애니메이션 설정
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // 애니메이션 시작
    _fadeController.forward();

    // 2초 후 로그인 화면으로 이동
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go(RoutePath.login);
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Stack(
          children: [
          // 하단 이미지 (위쪽 모서리 둥글게)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.34,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(70),
                topRight: Radius.circular(70),
              ),
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
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: Image.asset('assets/images/ZeroRo_logo.png', width: 320),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
