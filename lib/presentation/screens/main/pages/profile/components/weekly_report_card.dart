import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../domain/model/report/monthly_report.dart';

class WeeklyReportCard extends StatelessWidget {
  final MonthlyReport report;
  final bool isExpanded;
  final VoidCallback onTap;

  const WeeklyReportCard({
    super.key,
    required this.report,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.textTertiary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header (항상 표시)
          Material(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isExpanded ? Radius.zero : const Radius.circular(16),
              bottomRight: isExpanded ? Radius.zero : const Radius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isExpanded
                    ? Radius.zero
                    : const Radius.circular(16),
                bottomRight: isExpanded
                    ? Radius.zero
                    : const Radius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 16,
                            color: AppColors.onPrimary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatPeriodString(report.period),
                            style: AppTextStyle.bodySmall.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textSecondary,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Expanded content with collapse animation
          // 확장/축소 애니메이션
          if (isExpanded)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.textTertiary.withValues(alpha: 0.1),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: WeeklyReportContent(report: report),
                    ),
                  ),
                ],
              ),
            )
          else
            // 접힐 때도 애니메이션 적용을 위해 AnimatedSize 유지
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }

  /// 보고서 기간 문자열 포맷팅 (YY.MM.DD ~ YY.MM.DD)
  String _formatPeriodString(ReportPeriod period) {
    final start = DateTime.parse(period.startDate);
    final end = DateTime.parse(period.endDate);

    final startStr = '${start.year.toString().substring(2)}.'
        '${start.month.toString().padLeft(2, '0')}.'
        '${start.day.toString().padLeft(2, '0')}';
    final endStr = '${end.year.toString().substring(2)}.'
        '${end.month.toString().padLeft(2, '0')}.'
        '${end.day.toString().padLeft(2, '0')}';
    return '$startStr ~ $endStr';
  }
}

class WeeklyReportContent extends StatelessWidget {
  final MonthlyReport report;

  const WeeklyReportContent({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${report.user.username}님의',
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '월간 환경 활동',
              style: AppTextStyle.headlineMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Stats Grid
        _buildStatsGrid(),
        const SizedBox(height: 20),

        // Campaigns Section
        _buildCampaignsSection(),
        const SizedBox(height: 20),

        // Missions Section
        if (report.missions.completedByCategory.isNotEmpty)
          _buildMissionsSection(),

        // Environmental TMI
        const SizedBox(height: 20),
        _buildTmiSection(),
      ],
    );
  }

  /// 통계 그리드 (2x2)
  Widget _buildStatsGrid() {
    final totalMissions = report.missions.completedByCategory.fold<int>(
      0,
      (sum, category) => sum + category.count,
    );

    // 포인트 증감 색상 계산
    Color? subtitleColor;
    if (report.points.previousMonth != null) {
      final difference = report.points.currentMonth - report.points.previousMonth!;
      if (difference > 0) {
        subtitleColor = AppColors.pointIncrease; // 증가 - 빨간색
      } else if (difference < 0) {
        subtitleColor = AppColors.pointDecrease; // 감소 - 파란색
      }
    }

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.stars_rounded,
            label: '획득 포인트',
            value: '${report.points.currentMonth}',
            subtitle: _getPointsSubtitle(),
            subtitleColor: subtitleColor,
            color: AppColors.primary,
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.15),
                AppColors.primary.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.emoji_events_rounded,
            label: '완료 미션',
            value: '$totalMissions개',
            color: AppColors.success,
            gradient: LinearGradient(
              colors: [
                AppColors.success.withValues(alpha: 0.15),
                AppColors.success.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ],
    );
  }

  /// 개별 통계 카드
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    String? subtitle,
    Color? subtitleColor,
    required Color color,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTextStyle.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyle.headlineSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 16,
            child: subtitle != null
                ? Text(
                    subtitle,
                    style: AppTextStyle.bodySmall.copyWith(
                      color: subtitleColor ?? AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  /// 포인트 서브타이틀
  String? _getPointsSubtitle() {
    if (report.points.previousMonth == null) return null;

    final difference = report.points.currentMonth - report.points.previousMonth!;
    if (difference == 0) return '전월 동일';

    final sign = difference > 0 ? '+' : '';
    return '전월 대비 $sign$difference';
  }

  /// 캠페인 섹션
  Widget _buildCampaignsSection() {
    if (report.campaigns.list.isEmpty) {
      return _buildEmptySection(
        icon: Icons.campaign_rounded,
        title: '신청한 캠페인',
        message: '아직 참여한 캠페인이 없어요',
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textTertiary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.campaign_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '신청한 캠페인',
                    style: AppTextStyle.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${report.campaigns.list.length}개 참여',
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.textTertiary.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 16),
          _buildCampaignList(),
        ],
      ),
    );
  }

  /// 캠페인 리스트
  Widget _buildCampaignList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: report.campaigns.list.asMap().entries.map((entry) {
        final index = entry.key;
        final campaign = entry.value;
        return _buildCampaignListItem(index + 1, campaign.title);
      }).toList(),
    );
  }

  /// 개별 캠페인 목록 아이템
  Widget _buildCampaignListItem(int number, String campaignTitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                campaignTitle,
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 미션 섹션
  Widget _buildMissionsSection() {
    final categoryCounts = _convertMissionCategoriesToMap(
      report.missions.completedByCategory,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withValues(alpha: 0.08),
            AppColors.success.withValues(alpha: 0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '완료한 미션',
                style: AppTextStyle.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...categoryCounts.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildMissionProgressBar(
                _getCategoryDisplayName(entry.key),
                entry.value,
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 미션 진행 바
  Widget _buildMissionProgressBar(String categoryName, int count) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            categoryName,
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: AppColors.success,
              ),
              const SizedBox(width: 4),
              Text(
                '$count개',
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 빈 섹션
  Widget _buildEmptySection({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textTertiary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.textTertiary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.textTertiary,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyle.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: AppTextStyle.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// TMI 섹션
  Widget _buildTmiSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '환경 TMI',
            style: AppTextStyle.titleSmall.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            report.tmi.content,
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  /// 보고서 기간 문자열 포맷팅 (YY.MM.DD ~ YY.MM.DD)
  String _formatPeriodString(ReportPeriod period) {
    final start = DateTime.parse(period.startDate);
    final end = DateTime.parse(period.endDate);

    final startStr = '${start.year.toString().substring(2)}.'
        '${start.month.toString().padLeft(2, '0')}.'
        '${start.day.toString().padLeft(2, '0')}';
    final endStr = '${end.year.toString().substring(2)}.'
        '${end.month.toString().padLeft(2, '0')}.'
        '${end.day.toString().padLeft(2, '0')}';
    return '$startStr ~ $endStr';
  }

  /// 미션 카테고리 리스트를 Map으로 변환
  Map<String, int> _convertMissionCategoriesToMap(List<MissionCategory> categories) {
    return Map.fromEntries(
      categories.map((c) => MapEntry(c.category, c.count)),
    );
  }

  /// 백엔드 카테고리를 한글로 표시
  String _getCategoryDisplayName(String backendCategory) {
    const categoryNames = {
      'RECYCLING': '재활용/분리수거',
      'TRANSPORTATION': '대중교통/자전거',
      'ENERGY': '에너지 절약',
      'ZERO_WASTE': '제로웨이스트',
      'CONSERVATION': '자연보호/환경정화',
      'EDUCATION': '교육/세미나',
      'OTHER': '기타',
    };
    return categoryNames[backendCategory] ?? backendCategory;
  }
}
