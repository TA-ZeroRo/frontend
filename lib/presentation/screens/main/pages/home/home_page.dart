import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:frontend/core/theme/app_color.dart';
import 'package:logger/logger.dart';
import '../../../../../core/components/custom_app_bar.dart';
import '../../../../../core/utils/toast_helper.dart';
import '../../../settings/state/settings_controller.dart';
import 'components/character_select_modal.dart';
import 'components/gacha_dialog.dart';
import 'components/simple_chat_area.dart';
import 'components/inline_chat_widget.dart';
import 'state/chat_controller.dart';
import 'state/chat_state.dart';

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

    final animations = await _3DController.getAvailableAnimations();

    if (animations.isNotEmpty && mounted) {
      _startAnimationWithInterval(animations[0]);
    } else if (mounted) {
      _startAnimationWithInterval(null);
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
    } else {
      _3DController.playAnimation(loopCount: 1);
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

  /// 선택된 캐릭터에 따른 3D 모델 경로 반환
  String _getModelPath(String selectedCharacter) {
    switch (selectedCharacter) {
      case 'earth':
        return 'assets/zeroro/planet_zeroro_2.glb';
      case 'cloud':
        return 'assets/zeroro/co2_zeroro_2.glb';
      default:
        return 'assets/zeroro/planet_zeroro_2.glb'; // 기본값: 지구 제로로
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final settings = ref.watch(appSettingsProvider);
    final selectedCharacter = settings.selectedCharacter;
    final modelPath = _getModelPath(selectedCharacter);

    // 에러 메시지 표시
    ref.listen<ChatState>(chatProvider, (previous, next) {
      if (next.error != null) {
        ToastHelper.showError(next.error!);
        // 에러를 표시한 후 클리어
        ref.read(chatProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: !chatState.isFullChatOpen
          ? CustomAppBar(
              title: 'ZeroRo',
              additionalActions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const GachaDialog(),
                    );
                  },
                  icon: Image.asset(
                    'assets/images/casino_icon.png',
                    width: 32,
                    height: 32,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const CharacterSelectModal(),
                    );
                  },
                  icon: Image.asset(
                    'assets/images/change_character.png',
                    width: 32,
                    height: 32,
                  ),
                ),
              ],
            )
          : null,
      body: Container(
        color: AppColors.background,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 3D 캐릭터 (좌우 30px 여백)
            Padding(
              padding: const EdgeInsets.only(bottom: 80, left: 30, right: 30),
              child: Flutter3DViewer(
                key: ValueKey(selectedCharacter), // 캐릭터 변경 시 위젯 재생성
                progressBarColor: Colors.transparent,
                controller: _3DController,
                src: modelPath,
                enableTouch: false,
                activeGestureInterceptor: false,
                onProgress: _handleProgress,
                onLoad: _handleLoad,
                onError: _handleError,
              ),
            ),

            // 로딩 오버레이 (중앙)
            if (_isLoading)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLoadingProgress(),
                      const SizedBox(height: 20),
                      _buildLoadingMessage(),
                    ],
                  ),
                ),
              ),

            // 채팅 영역 (하단) - 슬라이드 + 페이드 아웃 애니메이션
            Positioned(
              bottom: 17,
              left: 17,
              right: 17,
              child: IgnorePointer(
                ignoring: chatState.isFullChatOpen,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  offset: chatState.isFullChatOpen
                      ? const Offset(0, 1.5)
                      : Offset.zero,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: chatState.isFullChatOpen ? 0.0 : 1.0,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [SimpleChatArea(), InlineChatWidget()],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 3D 모델 로딩 진행률 처리
  void _handleProgress(double progress) {
    if (mounted) {
      setState(() {
        _loadingProgress = progress;
        // 100% 도달 시 로딩 종료
        if (progress >= 1.0) {
          _isLoading = false;
        }
      });
    }
  }

  /// 3D 모델 로드 완료 처리
  void _handleLoad(String modelAddress) {
    if (mounted) {
      setState(() {
        _isLoading = false;
        _loadingProgress = 1.0;
      });
    }
  }

  /// 3D 모델 로드 오류 처리
  void _handleError(String error) {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 로딩 프로그레스 인디케이터
  Widget _buildLoadingProgress() {
    return SizedBox(
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
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          Text(
            '${(_loadingProgress * 100).toInt()}%',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  /// 로딩 메시지
  Widget _buildLoadingMessage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '제로로 캐릭터 로딩 중...',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '잠시만 기다려주세요',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
