import 'package:flutter/material.dart';

/// 빠른 액션 아이템 데이터
class QuickActionItem {
  final IconData icon;
  final String label;
  final String prompt;

  const QuickActionItem({
    required this.icon,
    required this.label,
    required this.prompt,
  });
}

/// 빠른 액션 Mock 데이터
class QuickActionData {
  static const List<QuickActionItem> actions = [
    QuickActionItem(
      icon: Icons.campaign_outlined,
      label: '앱 내 캠페인',
      prompt: '제로로 앱 내 캠페인 뭐있는지 알려줘',
    ),
    QuickActionItem(
      icon: Icons.newspaper_outlined,
      label: '환경 뉴스',
      prompt: '최근 환경 관련 뉴스를 알려줘',
    ),
    QuickActionItem(
      icon: Icons.lightbulb_outline,
      label: '환경 용어',
      prompt: '환경 관련 용어를 하나 골라서 쉽게 설명해줘',
    ),
  ];
}
