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

  /// 보고서 기간 문자열 포맷팅 (YY-MM-DD ~ YY-MM-DD)
  String _formatPeriodString(ReportPeriod period) {
    final start = DateTime.parse(period.startDate);
    final end = DateTime.parse(period.endDate);

    final startStr = '${start.year.toString().substring(2)}-'
        '${start.month.toString().padLeft(2, '0')}-'
        '${start.day.toString().padLeft(2, '0')}';
    final endStr = '${end.year.toString().substring(2)}-'
        '${end.month.toString().padLeft(2, '0')}-'
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          '${report.user.username}의 월간 활동',
          style: AppTextStyle.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _formatPeriodString(report.period),
          style: AppTextStyle.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        // Stats
        // 신청한 캠페인 목록 - 다른 항목과 동일한 레이아웃 구조
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.campaign_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '신청한 캠페인 목록',
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (report.campaigns.list.isEmpty)
                    Text(
                      '신청한 캠페인이 없어요',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    )
                  else
                    _buildCampaignListByCategory(report.campaigns.list),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 카테고리별 클리어한 미션 목록
        if (report.missions.completedByCategory.isNotEmpty) ...[
          _buildMissionCategorySection(_convertMissionCategoriesToMap(report.missions.completedByCategory)),
          const SizedBox(height: 16),
        ],
        // 월간 획득 포인트 (저번달 대비 색상 및 차이 표기)
        _buildMonthlyPointsRow(
          points: report.points.currentMonth,
          previousMonthPoints: report.points.previousMonth,
        ),
        // 환경 TMI 섹션
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.success,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  report.tmi.content,
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 보고서 기간 문자열 포맷팅 (YY-MM-DD ~ YY-MM-DD)
  String _formatPeriodString(ReportPeriod period) {
    final start = DateTime.parse(period.startDate);
    final end = DateTime.parse(period.endDate);

    final startStr = '${start.year.toString().substring(2)}-'
        '${start.month.toString().padLeft(2, '0')}-'
        '${start.day.toString().padLeft(2, '0')}';
    final endStr = '${end.year.toString().substring(2)}-'
        '${end.month.toString().padLeft(2, '0')}-'
        '${end.day.toString().padLeft(2, '0')}';
    return '$startStr ~ $endStr';
  }

  /// 미션 카테고리 리스트를 Map으로 변환
  Map<String, int> _convertMissionCategoriesToMap(List<MissionCategory> categories) {
    return Map.fromEntries(
      categories.map((c) => MapEntry(c.category, c.count)),
    );
  }

  /// 월간 획득 포인트 행 (저번달 대비 색상 및 차이 표기)
  Widget _buildMonthlyPointsRow({
    required int points,
    int? previousMonthPoints,
  }) {
    // 색상 결정: 실제 포인트 값 비교
    Color pointsColor;
    int? difference;
    String? differenceText;

    // 저번달 포인트가 있으면 비교하여 색상 결정
    // previousMonthPoints가 0일 수도 있음 (가장 오래된 보고서의 경우)
    if (previousMonthPoints != null) {
      // 저번달 대비 포인트 차이 계산
      difference = points - previousMonthPoints;

      // 실제 포인트 값을 직접 비교하여 색상 결정
      if (points < previousMonthPoints) {
        // 현재 포인트가 저번달보다 적음 → 감소 → 파란색
        pointsColor = AppColors.pointDecrease;
      } else {
        // 현재 포인트가 저번달보다 많거나 같음 → 증가/동일 → 빨간색
        pointsColor = AppColors.pointIncrease;
      }

      // 차이 텍스트 생성 (항상 표시)
      final sign = difference > 0 ? '+' : '';
      differenceText = '저번달 대비 $sign$difference';
    } else {
      // 저번달 포인트 정보가 없으면 기본색 사용
      pointsColor = AppColors.textPrimary;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.stars_rounded, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '월간 획득한 포인트',
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '$points+',
                    style: AppTextStyle.titleMedium.copyWith(
                      color: pointsColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (differenceText != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      differenceText,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: pointsColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 카테고리별 클리어한 미션 표시
  Widget _buildMissionCategorySection(Map<String, int> categoryCounts) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.emoji_events_rounded,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '클리어한 미션',
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              ...categoryCounts.entries.map((entry) {
                final categoryName = _getCategoryDisplayName(entry.key);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildCategoryChip(categoryName, entry.value),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  /// 카테고리 칩 위젯
  Widget _buildCategoryChip(String categoryName, int? count) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 카테고리 텍스트 너비 계산
        final categoryTextStyle = AppTextStyle.bodySmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        );
        final categoryTextPainter = TextPainter(
          text: TextSpan(text: categoryName, style: categoryTextStyle),
          textDirection: TextDirection.ltr,
        );
        categoryTextPainter.layout();
        final categoryWidth = categoryTextPainter.width;

        // 숫자 텍스트 스타일 정의
        final countTextStyle = AppTextStyle.bodyMedium.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        );

        // • 너비 계산
        final dotTextStyle = AppTextStyle.bodySmall.copyWith(
          color: AppColors.textSecondary.withValues(alpha: 0.3),
          letterSpacing: 2,
        );
        final dotTextPainter = TextPainter(
          text: TextSpan(text: '•', style: dotTextStyle),
          textDirection: TextDirection.ltr,
        );
        dotTextPainter.layout();
        final dotWidth = dotTextPainter.width;

        // 카테고리 컨테이너 padding 포함 너비 계산
        const categoryPadding = 16.0; // horizontal: 8 * 2
        final categoryTotalWidth = categoryWidth + categoryPadding;

        // 가장 큰 숫자 너비 계산 (한 자리/두 자리 등 모든 경우 고려)
        // 대략적으로 최대 숫자 너비를 미리 계산
        final maxCountText = '999개'; // 충분히 큰 숫자
        final maxCountTextPainter = TextPainter(
          text: TextSpan(text: maxCountText, style: countTextStyle),
          textDirection: TextDirection.ltr,
        );
        maxCountTextPainter.layout();
        final maxCountWidth = maxCountTextPainter.width;

        // 사용 가능한 너비 계산 (최대 숫자 너비 사용)
        final availableWidth =
            constraints.maxWidth -
            8 - // 카테고리와 • 사이 간격
            4 - // •와 숫자 사이 간격
            categoryTotalWidth -
            maxCountWidth;

        // • 개수 계산
        final dotCount = dotWidth > 0
            ? (availableWidth / dotWidth).floor().clamp(0, 1000)
            : 0;

        return SizedBox(
          width: constraints.maxWidth,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  categoryName,
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (count != null && dotCount > 0) ...[
                const SizedBox(width: 8),
                Text(
                  '•' * dotCount,
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(width: 4),
              ] else if (count != null) ...[
                const SizedBox(width: 8),
              ],
              if (count != null)
                Text(
                  '$count개',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// 캠페인 목록을 카테고리별로 그룹화하여 표시
  Widget _buildCampaignListByCategory(List<CampaignItem> campaignList) {
    // 캠페인을 카테고리별로 그룹화
    final Map<String, List<String>> groupedCampaigns = {};

    for (final campaign in campaignList) {
      final category = _getCampaignCategory(campaign.title);
      if (!groupedCampaigns.containsKey(category)) {
        groupedCampaigns[category] = [];
      }
      groupedCampaigns[category]!.add(campaign.title);
    }

    // 카테고리 순서 정렬 (백엔드 카테고리 순서)
    final categoryOrder = [
      'RECYCLING',
      'TRANSPORTATION',
      'ENERGY',
      'ZERO_WASTE',
      'CONSERVATION',
      'EDUCATION',
      'OTHER',
    ];

    final sortedCategories = groupedCampaigns.keys.toList()
      ..sort((a, b) {
        final aIndex = categoryOrder.indexOf(a);
        final bIndex = categoryOrder.indexOf(b);
        if (aIndex == -1 && bIndex == -1) return a.compareTo(b);
        if (aIndex == -1) return 1;
        if (bIndex == -1) return -1;
        return aIndex.compareTo(bIndex);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedCategories.map((category) {
        final campaigns = groupedCampaigns[category]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getCategoryDisplayName(category),
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 4),
            ...campaigns.map(
              (campaign) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 2),
                child: Text(
                  '• $campaign',
                  style: AppTextStyle.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }

  /// 캠페인명으로 카테고리 판별
  String _getCampaignCategory(String campaignName) {
    final lowerName = campaignName.toLowerCase();

    // 플로깅, 환경정화, 청소 관련
    if (lowerName.contains('플로깅') ||
        lowerName.contains('환경정화') ||
        lowerName.contains('청소') ||
        lowerName.contains('정화')) {
      return 'CONSERVATION'; // 자연보호/환경정화
    }

    // 제로웨이스트, 다회용기, 텀블러 관련
    if (lowerName.contains('제로웨이스트') ||
        lowerName.contains('다회용기') ||
        lowerName.contains('텀블러') ||
        lowerName.contains('일회용품') ||
        lowerName.contains('비닐')) {
      return 'ZERO_WASTE'; // 제로웨이스트/다회용기
    }

    // 대중교통, 자전거 관련
    if (lowerName.contains('대중교통') ||
        lowerName.contains('자전거') ||
        lowerName.contains('도보') ||
        lowerName.contains('걷기') ||
        lowerName.contains('바이크')) {
      return 'TRANSPORTATION'; // 대중교통/자전거
    }

    // 분리수거, 재활용 관련
    if (lowerName.contains('분리수거') ||
        lowerName.contains('재활용') ||
        lowerName.contains('리사이클')) {
      return 'RECYCLING'; // 재활용/분리수거
    }

    // 전기, 에너지 관련
    if (lowerName.contains('전기') ||
        lowerName.contains('에너지') ||
        lowerName.contains('절전') ||
        lowerName.contains('캠페인')) {
      return 'ENERGY'; // 에너지 절약
    }

    // 교육, 세미나 관련
    if (lowerName.contains('교육') ||
        lowerName.contains('세미나') ||
        lowerName.contains('강의') ||
        lowerName.contains('워크샵')) {
      return 'EDUCATION'; // 교육/세미나
    }

    // 비건, 식물 관련
    if (lowerName.contains('비건') ||
        lowerName.contains('채식') ||
        lowerName.contains('식물')) {
      return 'CONSERVATION'; // 자연보호/환경정화
    }

    // 기본값
    return 'OTHER';
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
