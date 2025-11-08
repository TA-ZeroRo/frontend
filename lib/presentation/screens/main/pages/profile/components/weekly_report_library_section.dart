import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../state/weekly_report_controller.dart';
import '../state/mock/weekly_report_mock_data.dart';

class WeeklyReportLibrarySection extends ConsumerStatefulWidget {
  const WeeklyReportLibrarySection({super.key});

  @override
  ConsumerState<WeeklyReportLibrarySection> createState() =>
      _WeeklyReportLibrarySectionState();
}

class _WeeklyReportLibrarySectionState
    extends ConsumerState<WeeklyReportLibrarySection> {
  String? _expandedReportId;
  final Map<String, GlobalKey> _reportKeys = {};

  @override
  void initState() {
    super.initState();
    // 가장 최근 보고서 자동 펼침
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reports = ref.read(weeklyReportsProvider);
      if (reports.isNotEmpty && _expandedReportId == null && mounted) {
        setState(() {
          _expandedReportId = reports.first.id;
        });
      }
    });
  }

  void _scrollToReport(String reportId) {
    Future.delayed(const Duration(milliseconds: 250), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final key = _reportKeys[reportId];
        if (key == null) return;

        final context = key.currentContext;
        if (context == null) return;

        try {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 300), // 확장 애니메이션과 동일
            curve: Curves.easeOutCubic, // 확장 애니메이션과 동일
            alignment: 0.5, // 화면 중앙
          );
        } catch (e) {
          // 스크롤 실패 시 무시
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final reports = ref.watch(weeklyReportsProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.library_books_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '월간보고서',
                style: AppTextStyle.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Reports list
          if (reports.isEmpty)
            SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '아직 월간보고서가 없어요',
                      style: AppTextStyle.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '매월 1일 자정에 월간보고서가 생성됩니다',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: reports.map((report) {
                final isExpanded = _expandedReportId == report.id;

                // GlobalKey 생성 (없으면 생성)
                if (!_reportKeys.containsKey(report.id)) {
                  _reportKeys[report.id] = GlobalKey();
                }

                return _WeeklyReportCard(
                  key: _reportKeys[report.id],
                  report: report,
                  isExpanded: isExpanded,
                  onTap: () {
                    final wasExpanded = isExpanded;
                    setState(() {
                      _expandedReportId = isExpanded ? null : report.id;
                    });
                    // 모든 보고서에 대해 확장 시 중앙 정렬 스크롤 적용
                    if (!wasExpanded) {
                      // 모든 보고서(첫번째, 두번째, 세번째 등)에 동일하게 적용
                      _scrollToReport(report.id);
                    }
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

}

class _WeeklyReportCard extends StatelessWidget {
  final ProfileWeeklyReport report;
  final bool isExpanded;
  final VoidCallback onTap;

  const _WeeklyReportCard({
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
                            report.periodString,
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
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: _WeeklyReportContent(report: report),
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
}

class _WeeklyReportContent extends StatelessWidget {
  final ProfileWeeklyReport report;

  const _WeeklyReportContent({required this.report});

  // 환경 관련 TMI 목록
  static const List<String> _environmentTmiList = [
    '미세플라스틱은 1주일에 신용카드 한 장 분량씩 인체에 축적됩니다',
    '대기 오염으로 인한 조기 사망자는 연간 700만 명에 달합니다',
    '플라스틱 제품의 화학물질은 호르몬 이상, 불임 등을 유발할 수 있습니다',
    '버려진 담배꽁초는 1개당 물 500L를 1시간만에 오염시킵니다',
    '숲 1헥타르는 연간 6톤의 CO2를 흡수하고 산소를 생성합니다',
    '하루 평균 2만 번 숨쉬는데, 대기 오염은 폐 기능을 20% 감소시킬 수 있습니다',
    '재활용되지 않은 플라스틱은 해양 생물을 통해 다시 우리 식탁으로 돌아옵니다',
    '살충제와 제초제는 장기적인 노출 시 신경계 질환을 유발할 수 있습니다',
    '불필요한 전력 소비는 미세먼지 배출의 주원인 중 하나입니다',
    '일회용 컵 1개는 500년이 지나도 분해되지 않습니다',
    '친환경 라이프스타일은 심혈관 질환 발병률을 30% 감소시킵니다',
    '대기 중 오존은 천식과 폐 기능 저하의 주요 원인입니다',
  ];

  String _getRandomTmi() {
    return _environmentTmiList[report.id.hashCode % _environmentTmiList.length];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          '${report.username}의 월간 활동',
          style: AppTextStyle.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          report.periodString,
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
                  if (report.campaignList.isEmpty)
                    Text(
                      '신청한 캠페인이 없습니다',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    )
                  else
                    _buildCampaignListByCategory(report.campaignList),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 카테고리별 클리어한 미션 목록
        if (report.missionCategoryCounts != null &&
            report.missionCategoryCounts!.isNotEmpty) ...[
          _buildMissionCategorySection(report.missionCategoryCounts!),
          const SizedBox(height: 16),
        ],
        // 월간 획득 포인트 (저번달 대비 색상 및 차이 표기)
        _buildMonthlyPointsRow(
          points: report.monthlyPointsEarned,
          previousMonthPoints: report.previousMonthPoints,
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
                  _getRandomTmi(),
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
                    '${points}+',
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
                  '$categoryName',
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
  Widget _buildCampaignListByCategory(List<String> campaignList) {
    // 캠페인을 카테고리별로 그룹화
    final Map<String, List<String>> groupedCampaigns = {};

    for (final campaign in campaignList) {
      final category = _getCampaignCategory(campaign);
      if (!groupedCampaigns.containsKey(category)) {
        groupedCampaigns[category] = [];
      }
      groupedCampaigns[category]!.add(campaign);
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
