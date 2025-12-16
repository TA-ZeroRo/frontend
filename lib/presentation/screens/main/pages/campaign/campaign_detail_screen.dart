import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/toast_helper.dart';
import '../../../../../core/utils/character_notification_helper.dart';
import 'models/campaign_data.dart';
import 'state/campaign_state.dart';
import 'state/campaign_mission_state.dart';
import 'components/campaign_mission_preview.dart';

class CampaignDetailScreen extends ConsumerStatefulWidget {
  final CampaignData campaign;

  const CampaignDetailScreen({super.key, required this.campaign});

  @override
  ConsumerState<CampaignDetailScreen> createState() =>
      _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends ConsumerState<CampaignDetailScreen> {
  late CampaignData _campaign;

  @override
  void initState() {
    super.initState();
    _campaign = widget.campaign;
  }

  @override
  Widget build(BuildContext context) {
    // 캠페인 리스트에서 최신 상태 가져오기
    final campaignListAsync = ref.watch(campaignListProvider);
    campaignListAsync.whenData((campaigns) {
      final updated = campaigns.firstWhere(
        (c) => c.id == _campaign.id,
        orElse: () => _campaign,
      );
      if (updated.isParticipating != _campaign.isParticipating) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _campaign = updated;
            });
          }
        });
      }
    });

    // 해당 캠페인의 미션 가져오기
    final campaignMissionAsync = ref.watch(campaignMissionProvider);
    final missions = campaignMissionAsync.whenOrNull(
      data: (map) => map[int.parse(_campaign.id)],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInfoSection(),
                const SizedBox(height: 8),
                const Divider(thickness: 8, color: Color(0xFFF5F7FA)),
                const SizedBox(height: 24),

                // 미션 섹션
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _campaign.isParticipating && missions != null
                      ? CampaignMissionPreview(missions: missions)
                      : (_campaign.isParticipating
                            ? _buildMissionLoadingState()
                            : _buildNotParticipatingState()),
                ),

                const SizedBox(height: 100), // 하단 버튼 공간
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  /// SliverAppBar with hero image
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share, color: Colors.white, size: 20),
          ),
          onPressed: _onShare,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // 배경 이미지
            if (_campaign.imageUrl.isNotEmpty)
              Image.network(
                _campaign.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildFallbackBackground(),
              )
            else
              _buildFallbackBackground(),

            // 그라데이션 오버레이 (가독성 향상)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                    Colors.black.withValues(alpha: 0.9),
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),

            // 제목 영역
            Positioned(
              left: 20,
              right: 20,
              bottom: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 뱃지 영역
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.eco_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'ZERORO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _campaign.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 캠페인 제목
                  Text(
                    _campaign.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackBackground() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.8),
      child: const Center(
        child: Icon(Icons.eco_rounded, size: 80, color: Colors.white24),
      ),
    );
  }

  /// 캠페인 정보 섹션
  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 핵심 정보 카드 그리드
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.calendar_today_rounded,
                  label: '기간',
                  value: _campaign.periodText,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.location_on_rounded,
                  label: '지역',
                  value: '${_campaign.region} ${_campaign.city}'
                      .replaceAll('전체', '')
                      .trim(),
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // 설명
          Text(
            '캠페인 소개',
            style: AppTextStyle.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _campaign.description,
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.8,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMissionLoadingState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildNotParticipatingState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.rocket_launch_rounded,
              size: 32,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '미션에 도전해보세요!',
            style: AppTextStyle.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '캠페인에 참여하면\n다양한 미션을 확인하고 수행할 수 있어요.',
            textAlign: TextAlign.center,
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// 하단 버튼 바
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _onParticipate,
          style: ElevatedButton.styleFrom(
            backgroundColor: _campaign.isParticipating
                ? Colors.grey[200]
                : AppColors.primary,
            foregroundColor: _campaign.isParticipating
                ? AppColors.textSecondary
                : Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            _campaign.isParticipating ? '참가 취소하기' : '캠페인 참가하기',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  Future<void> _onParticipate() async {
    try {
      await ref
          .read(campaignListProvider.notifier)
          .toggleParticipation(_campaign.id);

      if (mounted) {
        if (_campaign.isParticipating) {
          CharacterNotificationHelper.show(
            context,
            message: '캠페인 참가가 취소되었어요',
            characterImage: 'assets/images/earth_zeroro.png',
            alignment: const Alignment(0.85, -0.4),
          );
        } else {
          CharacterNotificationHelper.show(
            context,
            message: '캠페인 참가에 성공했어요!',
            characterImage: 'assets/images/cloud_zeroro_sunglasses.png',
            alignment: const Alignment(0.85, -0.4),
          );
        }
        // 미션 데이터 갱신
        ref.invalidate(campaignMissionProvider);
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  Future<void> _onShare() async {
    try {
      await Share.share(
        '지구를 위해 저와 ${_campaign.title}을(를) 함께 해요!\n\nZERORO 앱에서 함께 참여하세요!',
        subject: '지구를 위해 저와 ${_campaign.title}을(를) 함께 해요!',
      );
    } catch (e) {
      if (mounted) {
        CharacterNotificationHelper.show(
          context,
          message: '공유에 실패했어요ㅠㅠ',
          characterImage: 'assets/images/cloud_zeroro_sad.png',
          alignment: const Alignment(0.85, -0.4),
        );
      }
    }
  }
}
