import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_color.dart';
import 'package:frontend/core/theme/app_text_style.dart';
import 'quick_action_data.dart';

/// 빠른 액션 칩 위젯
/// 가로 스크롤 가능한 칩 리스트
class QuickActionChips extends StatelessWidget {
  final void Function(String prompt) onActionTap;

  const QuickActionChips({
    super.key,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: QuickActionData.actions.map((action) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _ActionChip(
              icon: action.icon,
              label: action.label,
              onTap: () => onActionTap(action.prompt),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// 개별 액션 칩
class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
