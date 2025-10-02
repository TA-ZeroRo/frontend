import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart' hide Image;
import '../../routes/router_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isAnimationLoaded = false;
  RiveAnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('Timeline 1');

    // 2초 후 login 화면으로 이동
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go(RoutePath.login);
      }
    });
  }

  void _onRiveInit(Artboard artboard) {
    setState(() {
      _isAnimationLoaded = true;
    });

    // 애니메이션이 로드된 후 1초 뒤에 애니메이션 시작
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _controller?.isActive = true;
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 애니메이션이 로드되지 않았을 때 로딩 인디케이터
                  if (!_isAnimationLoaded)
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),

                  // Rive 애니메이션
                  RiveAnimation.asset(
                    'assets/animation/zeroro4.riv',
                    controllers: [_controller!],
                    onInit: _onRiveInit,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
