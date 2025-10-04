import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/model/quiz_question.dart';

// Mock Quiz Data
const _mockQuizQuestions = [
  QuizQuestion(
    question: '텀블러를 사용하면 일회용 컵 사용을 줄일 수 있다.',
    answer: 'O',
    explanation: '텀블러 사용은 일회용 컵 쓰레기를 줄이는 가장 효과적인 방법입니다.',
  ),
  QuizQuestion(
    question: '페트병 라벨은 제거하지 않고 버려도 재활용이 가능하다.',
    answer: 'X',
    explanation: '페트병은 라벨과 뚜껑을 분리해야 올바르게 재활용할 수 있습니다.',
  ),
  QuizQuestion(
    question: '전자영수증을 사용하면 종이 낭비를 줄일 수 있다.',
    answer: 'O',
    explanation: '전자영수증은 종이 사용을 줄이고 환경 보호에 도움이 됩니다.',
  ),
  QuizQuestion(
    question: '스티로폼 박스는 깨끗하게 세척한 후 분리배출해야 한다.',
    answer: 'O',
    explanation: '스티로폼은 이물질을 제거하고 깨끗하게 세척해야 재활용이 가능합니다.',
  ),
  QuizQuestion(
    question: '플라스틱은 모두 같은 종류이므로 구분하지 않고 버려도 된다.',
    answer: 'X',
    explanation: '플라스틱은 종류에 따라 재활용 방법이 다르므로 분리해서 배출해야 합니다.',
  ),
  QuizQuestion(
    question: '음식물이 묻은 비닐은 깨끗이 씻어서 버리면 재활용할 수 있다.',
    answer: 'X',
    explanation: '음식물이 묻은 비닐은 세척해도 재활용이 어려우므로 일반쓰레기로 버려야 합니다.',
  ),
];

class QuizVerificationState {
  final bool isLoading;
  final QuizQuestion? currentQuestion;
  final String? error;

  const QuizVerificationState({
    this.isLoading = false,
    this.currentQuestion,
    this.error,
  });

  QuizVerificationState copyWith({
    bool? isLoading,
    QuizQuestion? currentQuestion,
    String? error,
  }) {
    return QuizVerificationState(
      isLoading: isLoading ?? this.isLoading,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      error: error ?? this.error,
    );
  }
}

class QuizVerificationNotifier extends Notifier<QuizVerificationState> {
  @override
  QuizVerificationState build() {
    return const QuizVerificationState();
  }

  Future<void> loadNextQuestion() async {
    state = state.copyWith(isLoading: true, error: null);

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // Return random mock question
      final mockQuestion = (_mockQuizQuestions.toList()..shuffle()).first;
      state = state.copyWith(
        isLoading: false,
        currentQuestion: mockQuestion,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = const QuizVerificationState();
  }
}

final quizVerificationProvider =
    NotifierProvider<QuizVerificationNotifier, QuizVerificationState>(
  QuizVerificationNotifier.new,
);
