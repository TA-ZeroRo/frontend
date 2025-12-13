import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../models/campaign_data.dart';

/// 외부 캠페인 캐러셀 위젯
class ExternalCampaignCarousel extends StatelessWidget {
  final List<CampaignData> campaigns;
  final void Function(CampaignData campaign) onCampaignTap;

  const ExternalCampaignCarousel({
    super.key,
    required this.campaigns,
    required this.onCampaignTap,
  });

  @override
  Widget build(BuildContext context) {
    if (campaigns.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              Icon(
                Icons.link_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                '외부 캠페인',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // 캐러셀
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: campaigns.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final campaign = campaigns[index];
              return _ExternalCampaignCard(
                campaign: campaign,
                onTap: () => onCampaignTap(campaign),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 외부 캠페인 카드 (캐러셀 아이템)
class _ExternalCampaignCard extends StatelessWidget {
  final CampaignData campaign;
  final VoidCallback onTap;

  const _ExternalCampaignCard({
    required this.campaign,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 배경 이미지
              _buildImage(),
              // 그라데이션 오버레이
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
              // 텍스트 콘텐츠
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      campaign.title,
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.open_in_new_rounded,
                          size: 12,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '바로가기',
                          style: AppTextStyle.labelSmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (campaign.imageUrl.isEmpty) {
      return Container(
        color: AppColors.primary.withValues(alpha: 0.3),
        child: Center(
          child: Icon(
            Icons.campaign_outlined,
            size: 48,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return Image.network(
      campaign.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: AppColors.background,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        color: AppColors.primary.withValues(alpha: 0.3),
        child: Center(
          child: Icon(
            Icons.campaign_outlined,
            size: 48,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
