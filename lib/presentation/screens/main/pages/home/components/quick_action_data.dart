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
      label: '캠페인 추천받기',
      prompt: '우리 지역에서 참여할 수 있는 환경 캠페인을 추천해줘',
    ),
    QuickActionItem(
      icon: Icons.newspaper_outlined,
      label: '환경 뉴스 읽기',
      prompt: '최근 환경 관련 뉴스를 알려줘',
    ),
  ];
}
