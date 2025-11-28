import 'package:flutter/material.dart';

/// 캐릭터 알림 데이터 모델
class CharacterNotification {
  final String message;
  final String characterImage;
  final Color bubbleColor;
  final Color textColor;
  final Color? bubbleBorderColor;
  final double characterSize;
  final Duration duration;
  final double borderRadius;
  final Alignment? alignment;

  const CharacterNotification({
    required this.message,
    required this.characterImage,
    this.bubbleColor = Colors.white,
    this.textColor = Colors.black87,
    this.bubbleBorderColor,
    this.characterSize = 50.0,
    this.duration = const Duration(seconds: 3),
    this.borderRadius = 16.0,
    this.alignment,
  });
}
