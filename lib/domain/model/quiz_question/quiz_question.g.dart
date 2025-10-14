// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) =>
    _QuizQuestion(
      question: json['question'] as String,
      answer: json['answer'] as String,
      explanation: json['explanation'] as String,
    );

Map<String, dynamic> _$QuizQuestionToJson(_QuizQuestion instance) =>
    <String, dynamic>{
      'question': instance.question,
      'answer': instance.answer,
      'explanation': instance.explanation,
    };
