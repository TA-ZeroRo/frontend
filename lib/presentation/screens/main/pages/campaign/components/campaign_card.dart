import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_color.dart';
import '../models/campaign_data.dart';
import 'participation_popup_menu.dart';

class CampaignCard extends ConsumerWidget {
  final CampaignData campaign;
  final VoidCallback? onTap;
  final VoidCallback? onParticipate;
  final VoidCallback? onCruiting;
  final VoidCallback? onShare;

  const CampaignCard({
    super.key,
    required this.campaign,
    this.onTap,
    this.onParticipate,
    this.onCruiting,
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
  /// 배경 이미지
  Widget _buildBackgroundImage() {
    if (campaign.imageUrl.isEmpty) {
      return _buildFallbackView();
    }

    return Image.network(
      campaign.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackView();
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

  /// 이미지 없을 때 대체 화면 (설명 텍스트 표시)
  /// 이미지 없을 때 대체 화면 (설명 텍스트 표시)
  Widget _buildFallbackView() {
    return Container(
      color: Colors.lightBlue[50],
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 80),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Icon(
              Icons.article_outlined,
              color: AppColors.textSubtle,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            campaign.description.isNotEmpty
                ? campaign.description
                : '이미지가 준비중입니다.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.start,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// 상단 그라데이션 + 캠페인 제목 및 자동처리 텍스트
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 캠페인 제목 (남은 공간 차지)
            Expanded(
              child: Text(
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
            ),
            // 자동처리 텍스트 (고정 크기)
            if (campaign.isAutoProcessable) ...[
              const SizedBox(width: 8),
              _buildAutoProcessText(),
            ],
          ],
        ),
      ),
    );
  }

  /// 자동처리 텍스트
  Widget _buildAutoProcessText() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '자동처리',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 11,
          fontWeight: FontWeight.w500,
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

            // 참가 버튼 (팝업 메뉴)
            if (onParticipate != null && onCruiting != null)
              ParticipationPopupMenu(
                isParticipating: campaign.isParticipating,
                onParticipate: onParticipate!,
                onCruiting: onCruiting!,
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
