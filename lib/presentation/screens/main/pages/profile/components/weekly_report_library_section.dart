import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../core/services/weekly_report_service.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../domain/model/weekly_report/weekly_report.dart';
import '../../../../../../domain/repository/weekly_report_repository.dart';
import '../../../../../../presentation/screens/main/pages/playground/state/daily_quest_controller.dart';
import '../state/weekly_report_controller.dart';
import '../state/user_controller.dart';

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
    // 월간보고서 자동 생성 체크 및 가장 최근 보고서 자동 펼침
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeReports();
    });
  }

  Future<void> _initializeReports() async {
    // 과거 보고서를 먼저 생성하여 previousMonthPoints가 제대로 설정되도록 함
    await _generatePastReports();
    await _checkAndGenerateWeeklyReport();

    // 모든 보고서의 previousMonthPoints를 최종적으로 업데이트
    await _updateAllReportsPreviousMonthPoints();

    // 첫 보고서를 자동으로 펼치기만 하고, 스크롤은 하지 않음 (창 변환 시 이동 방지)
    final reportsAsync = ref.read(weeklyReportsProvider);
    reportsAsync.whenData((reports) {
      if (reports.isNotEmpty && _expandedReportId == null && mounted) {
        setState(() {
          _expandedReportId = reports.first.id;
        });
      }
    });
  }

  Future<void> _checkAndGenerateWeeklyReport() async {
    final user = ref.read(userProvider).value;
    if (user == null) return;

    final service = WeeklyReportService();
    final dailyQuestState = ref.read(dailyQuestProvider);

    // 이번 달 데이터 수집 (실제로는 API나 다른 데이터 소스에서 가져와야 함)
    // 목데이터: 신청한 캠페인 목록
    final campaignList = ['한강 플로깅 챌린지', '30일 제로웨이스트 챌린지', '일주일 비건 챌린지'];

    final completedQuestCount = dailyQuestState.quests
        .where((quest) => quest.isCompleted)
        .length;
    final totalDailyMissions = dailyQuestState.quests.length;
    final dailyMissionCompletedCount = completedQuestCount;

    // 목데이터: 월간 포인트 설정 (실제 데이터가 있으면 실제 데이터 사용)
    // 저번달(1개월 전: 450)보다 적게 설정하여 색상 변화 확인 가능
    final calculatedPoints = dailyQuestState.quests
        .where((quest) => quest.isCompleted)
        .fold(0, (sum, quest) => sum + quest.points);
    // 실제 데이터가 0이거나 없으면 목데이터 사용 (350: 저번달 450보다 감소 → 파란색)
    final monthlyPointsEarned = calculatedPoints > 0 ? calculatedPoints : 350;

    await service.checkAndGenerateWeeklyReport(
      userId: user.id,
      username: user.username,
      campaignList: campaignList,
      dailyMissionCompletedCount: dailyMissionCompletedCount,
      totalDailyMissions: totalDailyMissions,
      monthlyPointsEarned: monthlyPointsEarned,
    );

    // 보고서 생성/업데이트 후 목록 새로고침
    await ref.read(weeklyReportsProvider.notifier).refresh();
  }

  /// 과거 월간보고서 생성 (초기 데이터용)
  Future<void> _generatePastReports() async {
    final user = ref.read(userProvider).value;
    if (user == null) return;

    final repository = getIt<WeeklyReportRepository>();
    final service = WeeklyReportService();

    // 현재 보고서 목록 확인
    final existingReports = await repository.getWeeklyReports(user.id);

    // 최근 3개월 보고서가 필요한데 현재 보고서만 있으면 과거 2개 생성
    if (existingReports.length < 3) {
      final now = DateTime.now();

      // 지난 2개월 보고서 생성 (각각 1개월, 2개월 전)
      // 순서: 2개월 전 -> 1개월 전 -> 이번 달
      // 역순으로 생성하여 이전 보고서가 이미 존재하도록 함
      for (int i = 2; i >= 1; i--) {
        final pastMonth = now.month - i;
        final pastYear = now.year;
        int adjustedMonth = pastMonth;
        int adjustedYear = pastYear;

        if (pastMonth <= 0) {
          adjustedMonth = 12 + pastMonth;
          adjustedYear = pastYear - 1;
        }

        // 과거 월의 시작일과 마지막 날
        final monthRange = _getMonthRange(adjustedYear, adjustedMonth);
        final pastMonthStart = monthRange.start;
        final pastMonthEnd = monthRange.end;

        // 이미 존재하는지 확인
        final existing = await repository.getWeeklyReportByPeriod(
          user.id,
          pastMonthStart,
          pastMonthEnd,
        );

        if (existing == null) {
          // 저번 달 보고서 조회 (비교용)
          final previousMonthRange = _getPreviousMonthRange(
            adjustedYear,
            adjustedMonth,
          );
          final previousReport = await repository.getWeeklyReportByPeriod(
            user.id,
            previousMonthRange.start,
            previousMonthRange.end,
          );

          // 과거 데이터 (예시값)
          // 포인트 값을 서로 다르게 설정하여 색상 변화 테스트
          final reportId = 'monthly_${pastMonthStart.millisecondsSinceEpoch}';
          // 1개월 전: 450 (저번달(2개월 전: 300)보다 증가), 2개월 전: 300
          final monthlyPoints = i == 1 ? 450 : 300;
          // 저번달 보고서 포인트 가져오기
          // 가장 오래된 보고서(2개월 전)는 previousMonthPoints를 0으로 설정
          final previousMonthPoints =
              previousReport?.monthlyPointsEarned ??
              (previousReport == null && i == 2 ? 0 : null);

          // 목데이터: 캠페인 목록
          final campaignList = i == 1
              ? ['한강 플로깅 챌린지', '30일 제로웨이스트 챌린지']
              : ['일주일 비건 챌린지'];

          String? comparisonMessage;
          String? recommendationMessage;

          if (previousMonthPoints != null) {
            final difference = monthlyPoints - previousMonthPoints;
            if (difference > 0) {
              comparisonMessage =
                  '저번달보다 ${difference}포인트를 더 많이 획득했어요! 계속 좋은 활동을 이어가세요.';
              recommendationMessage =
                  '이번 달의 활동이 인상적이에요. 더 많은 캠페인 참여로 환경 지킴이로 성장해보세요!';
            } else if (difference < 0) {
              comparisonMessage =
                  '저번달보다 ${-difference}포인트가 적어졌네요. 꾸준한 활동이 중요해요.';
              recommendationMessage =
                  '일일 미션을 더 완료하시면 포인트를 더 받을 수 있어요. 작은 실천부터 시작해보세요!';
            } else {
              comparisonMessage =
                  '저번달과 동일한 포인트를 획득했어요. 조금만 더 노력하면 더 많은 포인트를 얻을 수 있어요!';
              recommendationMessage = '다양한 캠페인에 참여하시면 더 많은 포인트를 받을 수 있어요.';
            }
          } else {
            comparisonMessage = '첫 월간보고서입니다. 앞으로의 활동을 기대해요!';
            recommendationMessage = '일일 미션을 꾸준히 완료하고 캠페인에 참여해보세요.';
          }

          final pastReport = WeeklyReport(
            id: reportId,
            userId: user.id,
            username: user.username,
            startDate: pastMonthStart,
            endDate: pastMonthEnd,
            campaignList: campaignList,
            dailyMissionCompletedCount: i == 1 ? 22 : 18,
            totalDailyMissions: 30,
            monthlyPointsEarned: monthlyPoints,
            previousMonthPoints: previousMonthPoints,
            comparisonMessage: comparisonMessage,
            recommendationMessage: recommendationMessage,
            environmentalImpact: service.generateEnvironmentalImpact(),
            createdAt: pastMonthStart.add(const Duration(hours: 1)),
          );

          await repository.saveWeeklyReport(pastReport);
        }
      }

      // 과거 보고서 생성 후 목록 새로고침
      await ref.read(weeklyReportsProvider.notifier).refresh();
    }
  }

  /// 이전 달의 날짜 범위 계산
  ({DateTime start, DateTime end}) _getPreviousMonthRange(int year, int month) {
    final prevMonthStart = DateTime(year, month - 1, 1);
    final prevMonthEnd = DateTime(year, month, 0, 23, 59, 59);
    return (start: prevMonthStart, end: prevMonthEnd);
  }

  /// 특정 년/월의 날짜 범위 계산
  ({DateTime start, DateTime end}) _getMonthRange(int year, int month) {
    final monthStart = DateTime(year, month, 1);
    final monthEnd = DateTime(year, month + 1, 0, 23, 59, 59);
    return (start: monthStart, end: monthEnd);
  }

  /// 모든 보고서의 previousMonthPoints를 업데이트
  Future<void> _updateAllReportsPreviousMonthPoints() async {
    final user = ref.read(userProvider).value;
    if (user == null) return;

    final repository = getIt<WeeklyReportRepository>();
    final service = WeeklyReportService();
    final allReports = await repository.getWeeklyReports(user.id);

    // 날짜순 정렬 (오래된 순)
    allReports.sort((a, b) => a.startDate.compareTo(b.startDate));

    bool hasUpdates = false;

    // 모든 보고서를 순회하며 previousMonthPoints 및 environmentalImpact 업데이트
    for (int i = 0; i < allReports.length; i++) {
      final report = allReports[i];
      int? newPreviousMonthPoints;

      if (i == 0) {
        // 첫 번째(가장 오래된) 보고서는 0부터 시작
        newPreviousMonthPoints = 0;
      } else {
        // 이전 보고서의 포인트를 가져옴
        final previousReport = allReports[i - 1];
        newPreviousMonthPoints = previousReport.monthlyPointsEarned;
      }

      // environmentalImpact가 없거나 previousMonthPoints가 다르면 업데이트
      if (report.environmentalImpact == null ||
          report.previousMonthPoints != newPreviousMonthPoints) {
        WeeklyReport updatedReport;

        if (report.environmentalImpact == null) {
          // environmentalImpact가 없으면 추가
          updatedReport = report.copyWith(
            previousMonthPoints:
                report.previousMonthPoints != newPreviousMonthPoints
                ? newPreviousMonthPoints
                : null,
            environmentalImpact: service.generateEnvironmentalImpact(),
          );
        } else {
          // environmentalImpact는 있고 previousMonthPoints만 업데이트
          updatedReport = report.copyWith(
            previousMonthPoints: newPreviousMonthPoints,
          );
        }

        await repository.saveWeeklyReport(updatedReport);
        hasUpdates = true;
      }
    }

    // 업데이트가 있었으면 목록 새로고침
    if (hasUpdates) {
      await ref.read(weeklyReportsProvider.notifier).refresh();
    }
  }

  /// 보고서 확장 시 화면 중앙에 오도록 스크롤
  /// 사용자가 직접 클릭해서 확장할 때만 적용
  /// 확장 애니메이션(300ms)이 거의 완료된 후 스크롤하여 전체 보고서가 보이도록 함
  void _scrollToReport(String reportId) {
    // 확장 애니메이션이 거의 완료된 후(250ms) 스크롤 시작
    // 이렇게 하면 최종 크기가 거의 결정된 상태에서 정확한 위치로 스크롤 가능
    Future.delayed(const Duration(milliseconds: 250), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final key = _reportKeys[reportId];
        if (key == null) return;

        final context = key.currentContext;
        if (context == null) return;

        try {
          // Scrollable.ensureVisible을 사용하여 전체 보고서가 화면에 보이도록 배치
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
    final reportsAsync = ref.watch(weeklyReportsProvider);

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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Reports list
          reportsAsync.when(
            data: (reports) {
              if (reports.isEmpty) {
                return SizedBox(
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
                );
              }

              return Column(
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
              );
            },
            loading: () => Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '보고서를 불러오는 중...',
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    '보고서를 불러올 수 없어요',
                    style: AppTextStyle.bodyLarge.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyReportCard extends StatelessWidget {
  final WeeklyReport report;
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
                              fontWeight: FontWeight.w600,
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
  final WeeklyReport report;

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
            fontWeight: FontWeight.bold,
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
                    ...report.campaignList.map(
                      (campaign) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '• $campaign',
                          style: AppTextStyle.titleMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildStatRow(
          icon: Icons.check_circle_outline_rounded,
          label: '일일 퀘스트 완료 횟수',
          value:
              '${report.dailyMissionCompletedCount} (${report.missionCompletionRate.toStringAsFixed(1)}%)',
        ),
        const SizedBox(height: 16),
        // 월간 획득 포인트 (저번달 대비 색상 및 차이 표기)
        _buildMonthlyPointsRow(
          points: report.monthlyPointsEarned,
          previousMonthPoints: report.previousMonthPoints,
        ),
        // 나의 환경 일지
        if (report.environmentalImpact != null) ...[
          const SizedBox(height: 16),
          _buildEnvironmentalImpact(report.environmentalImpact!),
        ],
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

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyle.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
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
      } else if (points > previousMonthPoints) {
        // 현재 포인트가 저번달보다 많음 → 증가 → 빨간색
        pointsColor = AppColors.pointIncrease;
      } else {
        // 동일 → 기본색
        pointsColor = AppColors.textPrimary;
      }

      // 차이 텍스트 생성 (0이 아닌 경우에만)
      if (difference != 0) {
        final sign = difference > 0 ? '+' : '';
        differenceText = '저번달 대비 $sign$difference';
      }
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
                      fontWeight: FontWeight.bold,
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

  /// 환경 일지 섹션 빌드
  Widget _buildEnvironmentalImpact(EnvironmentalImpact impact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
        Row(
          children: [
            Icon(Icons.eco_rounded, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              '나의 환경 일지',
              style: AppTextStyle.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 환경 영향 카드들
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // CO2 절감
              _buildImpactCard(
                icon: Icons.air_rounded,
                title: 'CO₂ 절감',
                value: impact.co2Reduced,
                description: '이산화탄소를 줄였어요',
              ),
              const SizedBox(height: 12),
              // 플라스틱 절약
              _buildImpactCard(
                icon: Icons.recycling_rounded,
                title: '플라스틱 절약',
                value: impact.plasticSaved,
                description: '플라스틱 사용을 줄였어요',
              ),
              const SizedBox(height: 12),
              // 나무 환산
              _buildImpactCard(
                icon: Icons.park_rounded,
                title: '나무 환산',
                value: impact.treesEquivalent,
                description: '나무를 심은 것과 같아요',
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 환경 영향 개별 카드 빌드
  Widget _buildImpactCard({
    required IconData icon,
    required String title,
    required String value,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      value,
                      style: AppTextStyle.titleLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        description,
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
