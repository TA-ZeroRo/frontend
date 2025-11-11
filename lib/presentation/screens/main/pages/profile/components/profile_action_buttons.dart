import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../state/profile_chart_state.dart';

/// 프로필 페이지의 액션 버튼들 (프로필 수정, 포인트 히스토리)
class ProfileActionButtons extends ConsumerWidget {
  final VoidCallback onEditProfile;

  const ProfileActionButtons({super.key, required this.onEditProfile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChartExpanded = ref.watch(isChartExpandedProvider);

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onEditProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: AppColors.onPrimary.withValues(alpha: 0.8),
                width: 1.5,
              ),
              elevation: 0,
            ),
            child: Text(
              '프로필 수정',
              style: AppTextStyle.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              ref.read(isChartExpandedProvider.notifier).toggle();
            },
            icon: AnimatedRotation(
              turns: isChartExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
            ),
            label: Text(
              '포인트 히스토리',
              style: AppTextStyle.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.onPrimary,
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.35),
                width: 1.0,
              ),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
