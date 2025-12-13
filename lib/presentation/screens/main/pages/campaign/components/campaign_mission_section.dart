import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/utils/toast_helper.dart';
import '../../../../../../core/utils/character_notification_helper.dart';
import '../../../../../../domain/model/mission/mission_template.dart';
import '../../../../../../domain/model/mission/mission_with_template.dart';
import '../../../../../../domain/model/mission/verification_type.dart';
import '../state/campaign_mission_state.dart';
import '../../plogging_map/components/shimmer_widgets.dart';
import 'verification_bottom_sheets/image_verification_bottom_sheet.dart';
import 'verification_bottom_sheets/location_verification_bottom_sheet.dart';
import 'verification_bottom_sheets/quiz_verification_bottom_sheet.dart';
import 'verification_bottom_sheets/text_review_verification_bottom_sheet.dart';

class CampaignMissionSection extends ConsumerWidget {
  const CampaignMissionSection({super.key});

  // 공통 그림자 스타일
  static const _kCardShadow = BoxShadow(
    color: Color(0x0D000000), // alpha 0.05
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 미션 완료 상태 감지
    ref.listen(campaignMissionProvider, (previous, next) {
      next.whenData((currentMap) {
        previous?.whenData((previousMap) {
          for (final entry in currentMap.entries) {
            final campaignId = entry.key;
            final currentMissions = entry.value;
            final previousMissions = previousMap[campaignId];

            if (previousMissions == null) continue;

            final isCurrentAllCompleted = currentMissions.every(
              (m) => m.missionLog.status.value == 'COMPLETED',
            );
            final isPreviousAllCompleted = previousMissions.every(
              (m) => m.missionLog.status.value == 'COMPLETED',
            );

            // 이전에 완료되지 않았다가 이번에 모두 완료된 경우
            if (!isPreviousAllCompleted && isCurrentAllCompleted) {
              CharacterNotificationHelper.show(
                context,
                message: '미션 완료 ~\n완료 버튼을 눌러봐요',
                characterImage: 'assets/images/earth_zeroro_magic.png',
                bubbleColor: Colors.white,
                alignment: const Alignment(0.85, -0.4),
                duration: const Duration(seconds: 3),
              );
            }
          }
        });
      });
    });

    final asyncCampaignMap = ref.watch(campaignMissionProvider);

    return asyncCampaignMap.when(
      data: (campaignMap) {
        // Empty state
        if (campaignMap.isEmpty) {
          return _buildEmptyState();
        }

        return _buildContent(context, ref, campaignMap);
      },
      loading: () => const CampaignMissionSectionShimmer(),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    Map<int, List<MissionWithTemplate>> campaignMap,
  ) {
    // Map을 List로 변환
    final campaigns = campaignMap.entries.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 12),
        for (int i = 0; i < campaigns.length; i++) ...[
          _buildCampaignCard(
            context,
            ref,
            campaigns[i].value, // List<MissionWithTemplate>
          ),
          if (i < campaigns.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Transform.translate(
            offset: const Offset(0, -2),
            child: Image.asset(
              'assets/images/file_icon.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            '캠페인 미션',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
            boxShadow: const [_kCardShadow],
          ),
          padding: const EdgeInsets.all(48),
          child: Column(
            children: [
              Icon(Icons.eco, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                '참여 중인 캠페인이 없어요',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '새로운 캠페인에 참여해보세요',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(Object error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
            boxShadow: const [_kCardShadow],
          ),
          padding: const EdgeInsets.all(48),
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
              const SizedBox(height: 12),
              Text(
                '데이터를 불러올 수 없습니다',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '나중에 다시 시도해주세요',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCampaignCard(
    BuildContext context,
    WidgetRef ref,
    List<MissionWithTemplate> missions,
  ) {
    if (missions.isEmpty) return const SizedBox.shrink();

    final campaign = missions.first.campaign;
    final completedCount = missions
        .where((m) => m.missionLog.status.value == 'COMPLETED')
        .length;
    final totalCount = missions.length;
    final progressPercentage = totalCount > 0
        ? completedCount / totalCount
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        boxShadow: const [_kCardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campaign header with highlight color
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getCampaignHeaderColor(
                            campaign.category ?? '기타',
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          campaign.category ?? '기타',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        campaign.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Progress bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '진행률',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(progressPercentage * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 13,
                        color: _getProgressColor(progressPercentage),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressPercentage,
                    minHeight: 8,
                    backgroundColor: Colors.grey[100],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getProgressColor(progressPercentage),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),

          // Mission list
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ...missions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final mission = entry.value;
                  return Column(
                    children: [
                      _MissionTileWithExpand(mission: mission),
                      if (index < missions.length - 1)
                        const Divider(
                          height: 32,
                          thickness: 1,
                          color: Color(0xFFF5F5F5),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _getCategoryLabel(VerificationType type) {
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

  static IconData _getCategoryIcon(VerificationType type) {
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

  static Color _getCategoryColor(VerificationType type) {
    switch (type) {
      case VerificationType.image:
        return const Color(0xFF4CAF50); // Green
      case VerificationType.textReview:
        return const Color(0xFF2196F3); // Blue
      case VerificationType.quiz:
        return const Color(0xFFFF9800); // Orange
      case VerificationType.location:
        return const Color(0xFF9C27B0); // Purple
    }
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 0.67) {
      return const Color(0xFF4CAF50); // Green
    } else if (percentage >= 0.34) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFFFF6B6B); // Red
    }
  }

  /// 캠페인 카테고리에 따른 헤더 배경색 반환
  Color _getCampaignHeaderColor(String category) {
    switch (category) {
      case 'RECYCLING':
        return const Color(0xFF4CAF50).withValues(alpha: 0.08); // 연한 녹색
      case 'ENERGY':
        return const Color(0xFFFFA726).withValues(alpha: 0.08); // 연한 오렌지
      case 'ZERO_WASTE':
        return const Color(0xFF26A69A).withValues(alpha: 0.08); // 연한 틸
      case 'TRANSPORTATION':
        return const Color(0xFF42A5F5).withValues(alpha: 0.08); // 연한 파랑
      case 'CONSERVATION':
        return const Color(0xFF29B6F6).withValues(alpha: 0.08); // 연한 하늘색
      case 'EDUCATION':
        return const Color(0xFF66BB6A).withValues(alpha: 0.08); // 연한 라임
      default:
        return const Color(0xFF9E9E9E).withValues(alpha: 0.06); // 연한 회색 (기본)
    }
  }
}

/// 접기/펼치기가 가능한 미션 타일 (새로운 디자인)
class _MissionTileWithExpand extends StatefulWidget {
  const _MissionTileWithExpand({required this.mission});

  final MissionWithTemplate mission;

  @override
  State<_MissionTileWithExpand> createState() => _MissionTileWithExpandState();
}

class _MissionTileWithExpandState extends State<_MissionTileWithExpand> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.mission.missionLog.status.value == 'COMPLETED';
    final mission = widget.mission.missionTemplate;
    final verificationType = mission.verificationType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Header: Category Badge & Points
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCategoryBadge(verificationType),
              _buildPointBadge(mission.rewardPoints),
            ],
          ),
        ),

        // 2. Body: Title & Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mission.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? Colors.grey[600] : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                mission.description,
                style: TextStyle(
                  fontSize: 14,
                  color: isCompleted ? Colors.grey[500] : Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 3. Footer: Action Button or Status
        if (!isCompleted)
          _buildActionFooter(context, mission)
        else
          _buildCompletedFooter(),

        // 4. Collapsible Result Section (Only for completed)
        if (isCompleted)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? _buildResultSection(widget.mission.missionLog.proofData)
                : const SizedBox.shrink(),
          ),
      ],
    );
  }

  Widget _buildCategoryBadge(VerificationType type) {
    final label = CampaignMissionSection._getCategoryLabel(type);
    final icon = CampaignMissionSection._getCategoryIcon(type);
    final color = CampaignMissionSection._getCategoryColor(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointBadge(int points) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.monetization_on, size: 14, color: Color(0xFFFF9800)),
          const SizedBox(width: 4),
          Text(
            '${points}pt',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFF9800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionFooter(BuildContext context, MissionTemplate mission) {
    return InkWell(
      onTap: () => _showVerificationBottomSheet(context, widget.mission),
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '미션 시작하기',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedFooter() {
    return Column(
      children: [
        const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 18,
                      color: Color(0xFF4CAF50),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '미션 완료',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      _isExpanded ? '접기' : '기록 보기',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: Colors.grey[500],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultSection(Map<String, dynamic>? proofData) {
    if (proofData == null || proofData.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Text('제출된 기록이 없습니다.'),
      );
    }

    final verificationType = widget.mission.missionTemplate.verificationType;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (verificationType == VerificationType.image) ...[
            if (proofData['imageUrl'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  proofData['imageUrl'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    );
                  },
                ),
              )
            else if (proofData['image'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  proofData['image'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    );
                  },
                ),
              )
            else
              const Text('이미지를 불러올 수 없습니다.'),
          ] else if (verificationType == VerificationType.textReview) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                proofData['text'] ??
                    proofData['content'] ??
                    proofData['review'] ??
                    '내용 없음',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
          ] else if (verificationType == VerificationType.location) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFF9C27B0),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '위치 인증 완료',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        if (proofData['address'] != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            proofData['address'],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                        if (proofData['distance'] != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            '거리: ${proofData['distance']}m',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const Text('퀴즈 완료'),
          ],
        ],
      ),
    );
  }

  void _showVerificationBottomSheet(
    BuildContext context,
    MissionWithTemplate mission,
  ) {
    final verificationType = mission.missionTemplate.verificationType;

    switch (verificationType) {
      case VerificationType.image:
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => ImageVerificationBottomSheet(mission: mission),
        );
        break;
      case VerificationType.textReview:
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) =>
              TextReviewVerificationBottomSheet(mission: mission),
        );
        break;
      case VerificationType.quiz:
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => QuizVerificationBottomSheet(mission: mission),
        );
        break;
      case VerificationType.location:
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) =>
              LocationVerificationBottomSheet(mission: mission),
        );
        break;
    }
  }
}
