import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/utils/toast_helper.dart';
import '../state/activity_state.dart';
import '../state/mock/mock_campaign_mission_data.dart';
import 'shimmer_widgets.dart';

class CampaignMissionSection extends ConsumerWidget {
  const CampaignMissionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionState = ref.watch(campaignMissionProvider);

    // Show shimmer when loading
    if (missionState.isLoading) {
      return const CampaignMissionSectionShimmer();
    }

    final campaigns = missionState.campaigns;

    // Empty state
    if (campaigns.isEmpty) {
      return _buildEmptyState();
    }

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
                  _buildCampaignCard(context, ref, campaigns[i]),
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
          const Icon(
            Icons.assignment_turned_in_rounded,
            color: Color(0xFF4A90E2),
            size: 24,
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

  Widget _buildCampaignCard(
    BuildContext context,
    WidgetRef ref,
    Campaign campaign,
  ) {
    final completedCount = campaign.completedMissionsCount;
    final totalCount = campaign.totalMissionsCount;
    final progressPercentage = campaign.progressPercentage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Campaign header with highlight color
        Container(
          decoration: BoxDecoration(
            color: _getCampaignHeaderColor(campaign.iconEmoji),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: Row(
            children: [
              Text(campaign.iconEmoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  campaign.name,
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
        ...campaign.missions.asMap().entries.map((entry) {
          final mission = entry.value;
          return _buildMissionTile(context, ref, mission);
        }),
      ],
    );
  }

  Widget _buildMissionTile(
    BuildContext context,
    WidgetRef ref,
    CampaignMissionItem mission,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref
              .read(campaignMissionProvider.notifier)
              .toggleMissionCompletion(mission.id);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                mission.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                size: 24,
                color: mission.isCompleted
                    ? const Color(0xFF4CAF50)
                    : Colors.grey[400],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  mission.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: mission.isCompleted
                        ? Colors.grey[600]
                        : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${mission.points}pt',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A90E2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
