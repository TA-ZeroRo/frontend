import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/theme/app_color.dart';
import '../models/recruiting_post.dart';

class RecruitingCard extends StatelessWidget {
  final RecruitingPost post;
  final VoidCallback? onTap;

  const RecruitingCard({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 캠페인 정보 (이미지 + 타이틀)
            _buildCampaignHeader(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 모집글 제목
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // 정보 칩들
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip(
                        Icons.location_on_outlined,
                        '${post.region} ${post.city}',
                      ),
                      _buildInfoChip(
                        Icons.calendar_today_outlined,
                        DateFormat('M/d').format(post.startDate),
                      ),
                      _buildInfoChip(
                        Icons.people_outline,
                        '${post.currentMembers}/${post.capacity}명',
                        color: post.currentMembers >= post.capacity
                            ? AppColors.error
                            : AppColors.primary,
                      ),
                      _buildInfoChip(
                        Icons.cake_outlined,
                        post.minAge == 0 && post.maxAge == 0
                            ? '나이무관'
                            : '${post.minAge}~${post.maxAge}세',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignHeader() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        image: DecorationImage(
          image: NetworkImage(post.campaignImageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.4),
            BlendMode.darken,
          ),
        ),
      ),
      padding: const EdgeInsets.all(12),
      alignment: Alignment.bottomLeft,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'CAMPAIGN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              post.campaignTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black54,
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? AppColors.textSecondary).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color ?? AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color ?? AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
