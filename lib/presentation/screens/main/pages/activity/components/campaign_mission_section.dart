import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/utils/toast_helper.dart';
import '../../../../../../domain/model/mission/mission_template.dart';
import '../../../../../../domain/model/mission/mission_with_template.dart';
import '../../../../../../domain/model/mission/verification_type.dart';
import '../state/activity_state.dart';
import '../../campaign/campaign_mission_webview_screen.dart';
import 'shimmer_widgets.dart';
import 'verification_bottom_sheets/image_verification_bottom_sheet.dart';
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

  static const _kMissionTileShadow = BoxShadow(
    color: Color(0x08000000), // alpha 0.03
    blurRadius: 4,
    offset: Offset(0, 2),
  );

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
        boxShadow: const [_kCardShadow],
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
        boxShadow: const [_kCardShadow],
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
        boxShadow: const [_kCardShadow],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Campaign header with highlight color
        Container(
          decoration: BoxDecoration(
            color: _getCampaignHeaderColor(campaign.category),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  campaign.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              _buildCompleteButton(context, completedCount, totalCount, missions),
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

        const SizedBox(height: 16),

        // Mission list
        ...missions.asMap().entries.map((entry) {
          final index = entry.key;
          final mission = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < missions.length - 1 ? 12.0 : 0,
            ),
            child: _MissionTileWithExpand(mission: mission),
          );
        }),
      ],
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

  /// WebView 화면 열기
  void _openMissionWebView(
    BuildContext context,
    List<MissionWithTemplate> missions,
  ) {
    if (missions.isEmpty) {
      ToastHelper.showError('미션 정보를 찾을 수 없습니다.');
      return;
    }

    final mission = missions.first;

    // RPA Form URL이 없으면 에러
    if (mission.campaign.rpaFormUrl == null ||
        mission.campaign.rpaFormUrl!.isEmpty) {
      ToastHelper.showError('이 캠페인은 자동 제출을 지원하지 않습니다.');
      return;
    }

    // WebView 화면으로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CampaignMissionWebViewScreen(mission: mission),
      ),
    );
  }

  /// 완료 버튼 위젯 생성
  Widget _buildCompleteButton(
    BuildContext context,
    int completedCount,
    int totalCount,
    List<MissionWithTemplate> missions,
  ) {
    final isAllCompleted = completedCount == totalCount;

    if (isAllCompleted) {
      return _CompleteButton(
        onPressed: () {
          _openMissionWebView(context, missions);
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? const Color(0xFFE0E0E0) : const Color(0xFFEEEEEE),
          width: 1,
        ),
        boxShadow: const [CampaignMissionSection._kMissionTileShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header: Category Badge & Points
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
      ),
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

  Widget _buildActionFooter(
    BuildContext context,
    MissionTemplate mission,
  ) {
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
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
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
               // Assuming 'image' might be a local path or similar in some contexts, 
               // but for network images usually it's a URL.
               // Just in case it's a different key.
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
                proofData['text'] ?? proofData['content'] ?? proofData['review'] ?? '내용 없음',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
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
    }
  }
}
