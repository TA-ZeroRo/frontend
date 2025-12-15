import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/utils/toast_helper.dart';
import 'package:frontend/domain/model/mission/mission_with_template.dart';
import 'package:frontend/presentation/screens/entry/state/auth_controller.dart';

import '../../../../../../../core/di/injection.dart';
import '../../../../../../../core/logger/logger.dart';
import '../../../../../../../core/theme/app_color.dart';
import '../../../../../../../data/data_source/mission/mission_api.dart';
import '../../../../../../../data/data_source/verification/verification_api.dart';
import '../../state/campaign_mission_state.dart';
import '../../state/leaderboard_state.dart';

/// 퀴즈 상태
enum QuizState {
  loading, // 퀴즈 로딩 중
  quiz, // 퀴즈 표시
  correct, // 정답
  wrong, // 오답
  submitting, // 제출 중
  error, // 에러
}

class QuizVerificationBottomSheet extends ConsumerStatefulWidget {
  final MissionWithTemplate mission;

  const QuizVerificationBottomSheet({super.key, required this.mission});

  @override
  ConsumerState<QuizVerificationBottomSheet> createState() =>
      _QuizVerificationBottomSheetState();
}

class _QuizVerificationBottomSheetState
    extends ConsumerState<QuizVerificationBottomSheet> {
  final VerificationApi _verificationApi = getIt<VerificationApi>();
  final MissionApi _missionApi = getIt<MissionApi>();

  QuizState _state = QuizState.loading;
  Map<String, dynamic>? _quizData;
  String? _selectedAnswer;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    setState(() {
      _state = QuizState.loading;
      _selectedAnswer = null;
      _errorMessage = null;
    });

    try {
      final quizData = await _verificationApi.createQuiz();
      if (!mounted) return;

      setState(() {
        _quizData = quizData;
        _state = QuizState.quiz;
      });
    } catch (e) {
      CustomLogger.logger.e('퀴즈 로드 실패', error: e);
      if (!mounted) return;

      setState(() {
        _state = QuizState.error;
        _errorMessage = '퀴즈를 불러오는데 실패했습니다.';
      });
    }
  }

  void _checkAnswer(String answer) {
    if (_quizData == null) return;

    setState(() {
      _selectedAnswer = answer;
    });

    final correctAnswer = _quizData!['answer'] as String;
    if (answer == correctAnswer) {
      setState(() => _state = QuizState.correct);
      _submitProof();
    } else {
      setState(() => _state = QuizState.wrong);
    }
  }

  Future<void> _submitProof() async {
    setState(() => _state = QuizState.submitting);

    try {
      await _missionApi.submitProof(
        logId: widget.mission.missionLog.id,
        proofData: {
          'quiz_question': _quizData!['question'],
          'quiz_answer': _quizData!['answer'],
          'user_answer': _selectedAnswer,
        },
      );

      if (!mounted) return;

      // 포인트 지급 후 사용자 정보 새로고침
      await ref.read(authProvider.notifier).refreshCurrentUser();

      // 미션 및 리더보드 상태 갱신
      ref.invalidate(campaignMissionProvider);
      ref.read(leaderboardRefreshTriggerProvider.notifier).trigger();

      ToastHelper.showSuccess('퀴즈 정답! 포인트가 지급되었어요');

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      CustomLogger.logger.e('미션 제출 실패', error: e);
      if (!mounted) return;

      ToastHelper.showError('제출에 실패했습니다. 다시 시도해주세요.');
      setState(() => _state = QuizState.correct);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildContent(),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.quiz_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              '퀴즈 인증',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          widget.mission.missionTemplate.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.mission.missionTemplate.description,
          style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (_state) {
      case QuizState.loading:
        return _buildLoadingState();
      case QuizState.quiz:
        return _buildQuizState();
      case QuizState.correct:
        return _buildCorrectState();
      case QuizState.wrong:
        return _buildWrongState();
      case QuizState.submitting:
        return _buildSubmittingState();
      case QuizState.error:
        return _buildErrorState();
    }
  }

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 16),
          Text(
            '퀴즈를 불러오는 중...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizState() {
    final question = _quizData?['question'] ?? '';

    return Column(
      children: [
        // 퀴즈 질문 카드
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFFE082), width: 1),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'O / X 퀴즈',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                question,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // O/X 버튼
        Row(
          children: [
            Expanded(
              child: _buildAnswerButton(
                answer: 'O',
                color: const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAnswerButton(
                answer: 'X',
                color: const Color(0xFFE53935),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnswerButton({
    required String answer,
    required Color color,
  }) {
    return SizedBox(
      height: 80,
      child: ElevatedButton(
        onPressed: () => _checkAnswer(answer),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          answer,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCorrectState() {
    final explanation = _quizData?['explanation'] ?? '';

    return Column(
      children: [
        // 정답 카드
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF81C784), width: 1),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '정답입니다!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                explanation,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWrongState() {
    final explanation = _quizData?['explanation'] ?? '';
    final correctAnswer = _quizData?['answer'] ?? '';

    return Column(
      children: [
        // 오답 카드
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEBEE),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEF9A9A), width: 1),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '아쉬워요!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC62828),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '정답은 "$correctAnswer" 입니다',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFC62828),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                explanation,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 다시 도전하기 버튼
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _loadQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              '다시 도전하기',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmittingState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 16),
          Text(
            '제출 중...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? '오류가 발생했습니다.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 다시 시도 버튼
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _loadQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              '다시 시도',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
