import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/info_dialog.dart';
import 'components/info_button.dart';
import 'components/fade_message_box.dart';
import 'state/quiz_verification_notifier.dart';

class VerifyQuizScreen extends ConsumerStatefulWidget {
  const VerifyQuizScreen({super.key});

  @override
  ConsumerState<VerifyQuizScreen> createState() => _VerifyQuizScreenState();
}

class _VerifyQuizScreenState extends ConsumerState<VerifyQuizScreen>
    with TickerProviderStateMixin {
  String? _resultMessage;
  Color? _resultColor;
  late AnimationController _fadeController;
  late AnimationController _cardController;
  late AnimationController _buttonController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _cardScaleAnimation;
  late Animation<Offset> _cardSlideAnimation;
  late Animation<double> _buttonScaleAnimation;
  Timer? _resultTimer;
  bool _isAnswering = false;

  // Hardcoded colors
  static const Color _errorColor = Color(0xFFFF5645);
  static const Color _positiveColor = Color(0xFF74CD7C);

  static const Duration messageVisibleDuration = Duration(milliseconds: 800);
  static const Duration fadeDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _maybeShowIntroDialog();
    // Load first question
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quizVerificationProvider.notifier).loadNextQuestion();
    });
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(vsync: this, duration: fadeDuration);
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_fadeController);

    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _cardScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );
    _cardSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutCubic),
    );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _cardController.forward();
  }

  Future<void> _maybeShowIntroDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final shouldShow = !(prefs.getBool('showAuthQuizDialog') ?? false);

    if (shouldShow && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CustomInfoDialog(
            title: '퀴즈 인증이란?',
            content:
                '제시된 지문이 친환경 행동인지 판단하고 OX로 선택해주세요.\n\n정확히 판단할수록 더 많은 포인트를 받을 수 있어요!',
            preferenceKey: 'showAuthQuizDialog',
            onClose: (_) {},
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _cardController.dispose();
    _buttonController.dispose();
    _resultTimer?.cancel();
    super.dispose();
  }

  void _handleAnswer(
    String userAnswer,
    String correctAnswer,
    String explanation,
  ) {
    if (_isAnswering) return;

    setState(() {
      _isAnswering = true;
    });

    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });

    final isCorrect = userAnswer == correctAnswer;
    setState(() {
      _resultMessage = isCorrect ? '정답!' : '땡!';
      _resultColor = isCorrect ? _positiveColor : _errorColor;
    });

    _fadeController.reset();
    _resultTimer?.cancel();
    _resultTimer = Timer(messageVisibleDuration, () {
      _fadeController.forward();
      Timer(fadeDuration, () {
        if (mounted) {
          setState(() => _resultMessage = null);
          _showExplanationDialog(isCorrect, explanation);
        }
      });
    });
  }

  void _showExplanationDialog(
    bool isCorrect,
    String explanation,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                isCorrect
                    ? _positiveColor.withValues(alpha: 0.1)
                    : _errorColor.withValues(alpha: 0.1),
                Colors.white,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                size: 60,
                color: isCorrect ? _positiveColor : _errorColor,
              ),
              const SizedBox(height: 16),
              Text(
                isCorrect ? '정답입니다!' : '오답입니다!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: isCorrect ? _positiveColor : _errorColor,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '해설',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      explanation.isNotEmpty ? explanation : '해설이 준비되지 않았습니다.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _loadNextQuestion();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isCorrect ? _positiveColor : _errorColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '다음 문제',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadNextQuestion() {
    setState(() {
      _isAnswering = false;
    });

    _cardController.reset();
    _cardController.forward();

    ref.read(quizVerificationProvider.notifier).loadNextQuestion();
  }

  Widget _shadowButton({
    required String label,
    required VoidCallback? onPressed,
    required Color backgroundColor,
  }) {
    return AnimatedBuilder(
      animation: _buttonScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonScaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withValues(alpha: 0.3),
                  offset: const Offset(0, 8),
                  blurRadius: 16,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                padding: const EdgeInsets.symmetric(vertical: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizVerificationProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        '퀴즈 인증',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
              // Content
              Expanded(child: _buildBody(quizState)),
              // Bottom Info Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      offset: const Offset(0, -2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Spacer(),
                    InfoButton(
                      title: '퀴즈 인증이란?',
                      content:
                          '제시된 지문이 친환경 행동인지 판단하고 OX로 선택해주세요.\n\n정확히 판단할수록 더 많은 포인트를 받을 수 있어요!',
                      preferenceKey: 'showAuthQuizDialog',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(QuizVerificationState quizState) {
    if (quizState.isLoading && quizState.currentQuestion == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 24),
            Text(
              '퀴즈를 준비 중입니다...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (quizState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: _errorColor),
            const SizedBox(height: 16),
            const Text(
              '퀴즈를 불러오는 중 오류가 발생했습니다.',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(quizVerificationProvider.notifier).loadNextQuestion();
              },
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    final quiz = quizState.currentQuestion;
    if (quiz == null) {
      return const Center(child: Text('퀴즈를 불러오는 중...'));
    }

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: AnimatedBuilder(
                    animation: _cardController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cardScaleAnimation.value,
                        child: SlideTransition(
                          position: _cardSlideAnimation,
                          child: Card(
                            elevation: 8,
                            shadowColor: Colors.black.withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(32),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Colors.blue.shade50,
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.quiz,
                                    size: 48,
                                    color: Colors.blue.shade400,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    quiz.question,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Row(
                children: [
                  Expanded(
                    child: _shadowButton(
                      label: 'O',
                      onPressed: _isAnswering
                          ? null
                          : () => _handleAnswer(
                                'O',
                                quiz.answer,
                                quiz.explanation,
                              ),
                      backgroundColor: Colors.blue.shade500,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _shadowButton(
                      label: 'X',
                      onPressed: _isAnswering
                          ? null
                          : () => _handleAnswer(
                                'X',
                                quiz.answer,
                                quiz.explanation,
                              ),
                      backgroundColor: _errorColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_resultMessage != null)
          Center(
            child: FadeMessageBox(
              message: _resultMessage!,
              backgroundColor:
                  _resultColor?.withValues(alpha: 0.9) ?? Colors.black.withValues(alpha: 0.9),
              textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 48,
              ),
              animation: _fadeAnimation,
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 40,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
      ],
    );
  }
}
