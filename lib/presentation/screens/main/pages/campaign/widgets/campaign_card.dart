import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_color.dart';
import '../state/mock/mock_campaign_data.dart';

class CampaignCard extends ConsumerWidget {
  final CampaignData campaign;
  final VoidCallback? onTap;
  final VoidCallback? onParticipate;
  final VoidCallback? onShare;

  const CampaignCard({
    super.key,
    required this.campaign,
    this.onTap,
    this.onParticipate,
    this.onShare,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 16 / 18,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 배경 이미지
              _buildBackgroundImage(),

              // 상단 그라데이션 + 제목
              _buildTopGradient(),

              // 하단 그라데이션 + 기간 및 버튼들
              _buildBottomGradient(),
            ],
          ),
        ),
      ),
    );
  }

/// 배경 이미지
  Widget _buildBackgroundImage() {
    return Image.network(
      campaign.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF2A2A2A),
          child: const Icon(
            Icons.image_not_supported,
            color: Color(0xFF666666),
            size: 48,
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: const Color(0xFF2A2A2A),
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  /// 상단 그라데이션 + 캠페인 제목
  Widget _buildTopGradient() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.7),
              Colors.black.withValues(alpha: 0.5),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 캠페인 제목
            Text(
              campaign.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// 하단 그라데이션 + 기간 및 버튼들
  Widget _buildBottomGradient() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.5),
              Colors.black.withValues(alpha: 0.8),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Row(
          children: [
            // 캠페인 기간
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    campaign.periodText,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // 지역 정보
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${campaign.region} ${campaign.city}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // 카테고리
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          campaign.category,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // 공유 버튼
            _ActionButton(icon: Icons.share, onPressed: onShare),

            const SizedBox(width: 8),

            // 참가 버튼
            _ParticipateButton(
              isParticipating: campaign.isParticipating,
              onPressed: onParticipate,
            ),
          ],
        ),
      ),
    );
  }
}

/// 액션 버튼 (공유 등)
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _ActionButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

/// 참가 버튼
class _ParticipateButton extends StatelessWidget {
  final bool isParticipating;
  final VoidCallback? onPressed;

  const _ParticipateButton({required this.isParticipating, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isParticipating
          ? const Color(0xFF424242).withValues(alpha: 0.8)
          : AppColors.primary,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            isParticipating ? '참가중' : '참가하기',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
