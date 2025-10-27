import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:frontend/core/theme/app_color.dart';
import 'package:frontend/presentation/screens/main/pages/home/state/chat_controller.dart';
import 'package:frontend/presentation/screens/main/pages/home/widgets/chat/chat_overlay.dart';
import 'package:frontend/presentation/screens/main/pages/home/widgets/chat/inline_chat_widget.dart';
import 'package:logger/logger.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final Flutter3DController _3DController = Flutter3DController();
  Timer? _animationTimer;

  // 3D 모델 로딩 상태 관리
  bool _isLoading = true;
  double _loadingProgress = 0.0;

  // 리스너 참조를 저장하여 나중에 제거할 수 있도록 함
  VoidCallback? _modelLoadedListener;

  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();

    // 리스너를 변수에 저장
    _modelLoadedListener = () {
      if (_3DController.onModelLoaded.value && mounted) {
        _loadAndPlayAnimation();
      }
    };
    _3DController.onModelLoaded.addListener(_modelLoadedListener!);
  }

  Future<void> _loadAndPlayAnimation() async {
    if (!mounted) return;

    try {
      final animations = await _3DController.getAvailableAnimations();
      _logger.d('사용 가능한 애니메이션: $animations');

      if (animations != null && animations.isNotEmpty && mounted) {
        _startAnimationWithInterval(animations[0]);
      } else if (mounted) {
        _startAnimationWithInterval(null);
      }
    } catch (e) {
      _logger.e('애니메이션 재생 오류: $e');
    }
  }

  void _startAnimationWithInterval(String? animationName) {
    _animationTimer?.cancel();
    if (!mounted) return;

    _playAnimationOnce(animationName);
    _animationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        _playAnimationOnce(animationName);
      } else {
        timer.cancel();
      }
    });
  }

  void _playAnimationOnce(String? animationName) {
    if (!mounted) return;

    if (animationName != null) {
      _3DController.playAnimation(animationName: animationName, loopCount: 1);
      _logger.d('애니메이션 재생: $animationName');
    } else {
      _3DController.playAnimation(loopCount: 1);
      _logger.d('기본 애니메이션 재생');
    }
  }

  @override
  void dispose() {
    _animationTimer?.cancel();

    // 3D 컨트롤러 리스너 제거
    if (_modelLoadedListener != null) {
      _3DController.onModelLoaded.removeListener(_modelLoadedListener!);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double logoHeight = 50;
    final viewState = ref.watch(chatViewStateProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Character 3D model (dimmed when chat is active)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: viewState == ChatViewState.characterVisible ? 1.0 : 0.6,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Flutter3DViewer(
                      progressBarColor: Colors.transparent,
                      controller: _3DController,
                      src: 'assets/zeroro/co2_zeroro_2.glb',
                      enableTouch: false,
                      onProgress: (double progress) {
                        _logger.d('로딩 진행: $progress');
                        if (mounted) {
                          setState(() {
                            _loadingProgress = progress;
                          });
                        }
                      },
                      onLoad: (String modelAddress) {
                        _logger.d('모델 로드 완료: $modelAddress');
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                            _loadingProgress = 1.0;
                          });
                        }
                      },
                      onError: (String error) {
                        _logger.e('오류: $error');
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                    ),
                  ),
                  // 로딩 오버레이
                  if (_isLoading)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: CircularProgressIndicator(
                                      value: _loadingProgress,
                                      strokeWidth: 6,
                                      backgroundColor: Colors.grey[200],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.green,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${(_loadingProgress * 100).toInt()}%',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              '제로로 캐릭터 로딩 중...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '잠시만 기다려주세요',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Logo at top (only visible when character is visible)
            if (viewState == ChatViewState.characterVisible)
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                child: Image.asset(
                  'assets/images/ZeroRo_logo.png',
                  height: logoHeight,
                  fit: BoxFit.contain,
                ),
              ),

            // Chat overlay
            const ChatOverlay(),

            // Inline chat widget (only visible when character is visible)
            if (viewState == ChatViewState.characterVisible)
              const InlineChatWidget(),
          ],
        ),
      ),
    );
  }
}
