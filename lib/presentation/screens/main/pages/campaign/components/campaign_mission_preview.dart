import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../domain/model/mission/mission_with_template.dart';
import '../../../../../../domain/model/mission/verification_type.dart';

class CampaignMissionPreview extends StatelessWidget {
  final List<MissionWithTemplate> missions;

  const CampaignMissionPreview({
    super.key,
    required this.missions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '캠페인 미션 미리보기',
              style: AppTextStyle.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...missions.map((mission) => _MissionPreviewTile(mission: mission)),
      ],
    );
  }
}

class _MissionPreviewTile extends StatelessWidget {
  final MissionWithTemplate mission;

  const _MissionPreviewTile({required this.mission});

  @override
  Widget build(BuildContext context) {
    final template = mission.missionTemplate;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _getCategoryColor(template.verificationType).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(template.verificationType),
              color: _getCategoryColor(template.verificationType),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getCategoryLabel(template.verificationType),
                      style: AppTextStyle.labelSmall.copyWith(
                        color: _getCategoryColor(template.verificationType),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${template.rewardPoints}pt',
                        style: AppTextStyle.labelSmall.copyWith(
                          color: const Color(0xFFFF9800),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  template.title,
                  style: AppTextStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  template.description,
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(VerificationType type) {
    switch (type) {
      case VerificationType.image:
        return '사진 인증';
      case VerificationType.textReview:
        return '글쓰기';
      case VerificationType.quiz:
        return '퀴즈';
      case VerificationType.location:
        return '위치 인증';
    }
  }

  IconData _getCategoryIcon(VerificationType type) {
    switch (type) {
      case VerificationType.image:
        return Icons.camera_alt_outlined;
      case VerificationType.textReview:
        return Icons.edit_outlined;
      case VerificationType.quiz:
        return Icons.quiz_outlined;
      case VerificationType.location:
        return Icons.location_on_outlined;
    }
  }

  Color _getCategoryColor(VerificationType type) {
    switch (type) {
      case VerificationType.image:
        return const Color(0xFF4CAF50);
      case VerificationType.textReview:
        return const Color(0xFF2196F3);
      case VerificationType.quiz:
        return const Color(0xFFFF9800);
      case VerificationType.location:
        return const Color(0xFF9C27B0);
    }
  }
}
