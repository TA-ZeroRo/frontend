import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_question.freezed.dart';
part 'quiz_question.g.dart';

@freezed
abstract class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required String question,
    required String answer, // 'O' or 'X'
    required String explanation,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}
