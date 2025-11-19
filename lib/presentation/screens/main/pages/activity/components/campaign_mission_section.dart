import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/utils/toast_helper.dart';
import '../../../../../../domain/model/mission/mission_with_template.dart';
import '../../../../../../domain/model/mission/verification_type.dart';
import '../state/activity_state.dart';
import 'shimmer_widgets.dart';
import 'verification_bottom_sheets/image_verification_bottom_sheet.dart';
import 'verification_bottom_sheets/quiz_verification_bottom_sheet.dart';
import 'verification_bottom_sheets/text_review_verification_bottom_sheet.dart';

class CampaignMissionSection extends ConsumerWidget {
  const CampaignMissionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (int i = 0; i < campaigns.length; i++) ...[
                  _buildCampaignCard(
                    context,
                    ref,
                    campaigns[i].value, // List<MissionWithTemplate>
                  ),
                  if (i < campaigns.length - 1) ...[
                    const SizedBox(height: 20),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/file_icon.png',
            width: 36,
            height: 36,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          const Text(
            '캠페인 미션',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSectionHeader(),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          Padding(
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
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSectionHeader(),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          Padding(
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
      ),
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

    // 카테고리별 이모지
    final iconEmoji = _getCategoryEmoji(campaign.category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Campaign header with highlight color
        Container(
          decoration: BoxDecoration(
            color: _getCampaignHeaderColor(iconEmoji),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: Row(
            children: [
              Text(iconEmoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  campaign.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              _buildCompleteButton(context, completedCount, totalCount),
            ],
          ),
        ),

        // Progress bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progressPercentage,
                  minHeight: 6,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getProgressColor(progressPercentage),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Mission list
        ...missions.asMap().entries.map((entry) {
          final mission = entry.value;
          return _MissionTileWithExpand(mission: mission);
        }),
      ],
    );
  }

  /// 카테고리별 이모지 반환
  String _getCategoryEmoji(String category) {
    switch (category) {
      case 'RECYCLING':
        return '♻️';
      case 'TRANSPORTATION':
        return '🚴';
      case 'ENERGY':
        return '💡';
      case 'ZERO_WASTE':
        return '🌱';
      case 'CONSERVATION':
        return '🌍';
      case 'EDUCATION':
        return '📚';
      default:
        return '🌿';
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

  /// 캠페인 이모지에 따른 헤더 배경색 반환
  Color _getCampaignHeaderColor(String emoji) {
    switch (emoji) {
      case '♻️':
        return const Color(0xFF4CAF50).withValues(alpha: 0.08); // 연한 녹색
      case '💡':
        return const Color(0xFFFFA726).withValues(alpha: 0.08); // 연한 오렌지
      case '🥗':
        return const Color(0xFF66BB6A).withValues(alpha: 0.08); // 연한 라임
      case '🌱':
        return const Color(0xFF26A69A).withValues(alpha: 0.08); // 연한 틸
      case '🚴':
      case '🚲':
        return const Color(0xFF42A5F5).withValues(alpha: 0.08); // 연한 파랑
      case '🌍':
      case '🌎':
      case '🌏':
        return const Color(0xFF29B6F6).withValues(alpha: 0.08); // 연한 하늘색
      default:
        return const Color(0xFF9E9E9E).withValues(alpha: 0.06); // 연한 회색 (기본)
    }
  }

  /// 완료 버튼 위젯 생성
  Widget _buildCompleteButton(
    BuildContext context,
    int completedCount,
    int totalCount,
  ) {
    final isAllCompleted = completedCount == totalCount;

    if (isAllCompleted) {
      return _CompleteButton(
        onPressed: () {
          ToastHelper.showSuccess('캠페인 미션이 모두 완료되었습니다.');
        },
      );
    } else {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[600],
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: const Size(0, 36),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          '$completedCount/$totalCount 완료',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      );
    }
  }
}

/// 깜빡이는 애니메이션이 적용된 완료 버튼
class _CompleteButton extends StatefulWidget {
  const _CompleteButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_CompleteButton> createState() => _CompleteButtonState();
}

class _CompleteButtonState extends State<_CompleteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: const Size(0, 36),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          '완료',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

/// 접기/펼치기가 가능한 미션 타일
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

    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => _showVerificationBottomSheet(context, widget.mission),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // 완료 아이콘
                  Icon(
                    isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 24,
                    color: isCompleted
                        ? const Color(0xFF4CAF50)
                        : Colors.grey[400],
                  ),
                  const SizedBox(width: 12),

                  // 미션 제목
                  Expanded(
                    child: Text(
                      mission.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: isCompleted ? Colors.grey[600] : Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // 포인트 배지
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${mission.rewardPoints}pt',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),

                  // 펼치기/접기 버튼
                  IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),

          // 미션 설명 (접혔을 때 숨김)
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      mission.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
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
    }
  }
}
