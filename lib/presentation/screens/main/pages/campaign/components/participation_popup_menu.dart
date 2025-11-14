import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_color.dart';

/// 참가하기 버튼 클릭 시 표시되는 팝업 메뉴
class ParticipationPopupMenu extends StatelessWidget {
  final bool isParticipating;
  final VoidCallback onParticipate;
  final VoidCallback onCruiting;

  const ParticipationPopupMenu({
    super.key,
    required this.isParticipating,
    required this.onParticipate,
    required this.onCruiting,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      offset: const Offset(0, -8),
      position: PopupMenuPosition.over,
      itemBuilder: (context) => [
        // 바로 참가하기
        PopupMenuItem<String>(
          value: 'participate',
          height: 48,
          child: Row(
            children: [
              Icon(
                isParticipating ? Icons.check_circle : Icons.add_circle_outline,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Text(
                isParticipating ? '참가 취소하기' : '바로 참가하기',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        // 크루팅
        PopupMenuItem<String>(
          value: 'cruiting',
          height: 48,
          child: Row(
            children: [
              Icon(
                Icons.group_add,
                size: 20,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              const Text(
                '크루팅',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'participate') {
          onParticipate();
        } else if (value == 'cruiting') {
          onCruiting();
        }
      },
      child: Material(
        color: isParticipating
            ? const Color(0xFF424242).withValues(alpha: 0.8)
            : AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isParticipating ? '참가중' : '참가하기',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_drop_up,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
