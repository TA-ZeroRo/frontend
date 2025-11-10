import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/components/custom_app_bar.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../routes/router_path.dart';
import 'components/profile_info_section.dart';
import 'components/point_chart_section.dart';
import 'components/weekly_report_card.dart';
import 'state/profile_chart_state.dart';
import 'state/weekly_report_controller.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
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
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            alignment: 0.5,
          );
        } catch (e) {
          // 스크롤 실패 시 무시
        }
      });
    });
  }

  @override
  void dispose() {
    // GlobalKey들을 정리하여 메모리 누수 방지
    _reportKeys.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isChartExpanded = ref.watch(isChartExpandedProvider);
    final reports = ref.watch(weeklyReportsProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(color: AppColors.primary),
          // 전경: 컨텐츠
          Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: CustomAppBar(
                        title: '프로필',
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                    // 프로필 정보 섹션
                    SliverToBoxAdapter(
                      child: Container(
                        color: AppColors.primary,
                        padding: const EdgeInsets.all(16),
                        child: ProfileInfoSection(
                          onEditProfile: () => context.push(RoutePath.settings),
                        ),
                      ),
                    ),
                    // 애니메이션으로 나타나는 차트 섹션
                    SliverToBoxAdapter(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: isChartExpanded
                            ? AnimatedOpacity(
                                opacity: 1.0,
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  color: AppColors.primary,
                                  padding: const EdgeInsets.all(24),
                                  child: const PointChartSection(),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                    // 나머지 컨텐츠 영역 - 월간 보고서 헤더
                    SliverToBoxAdapter(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        child: Container(
                          width: double.infinity,
                          color: AppColors.background,
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                          child: Row(
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
                        ),
                      ),
                    ),
                    // 빈 상태 또는 카드 리스트
                    if (reports.isEmpty)
                      SliverToBoxAdapter(
                        child: Container(
                          color: AppColors.background,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                                  '매월 1일 자정에 월간보고서가 생성돼요',
                                  style: AppTextStyle.bodyMedium.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final report = reports[index];
                          final isExpanded = _expandedReportId == report.id;

                          // GlobalKey 생성 (없으면 생성)
                          if (!_reportKeys.containsKey(report.id)) {
                            _reportKeys[report.id] = GlobalKey();
                          }

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            color: AppColors.background,
                            child: WeeklyReportCard(
                              key: _reportKeys[report.id],
                              report: report,
                              isExpanded: isExpanded,
                              onTap: () {
                                final wasExpanded = isExpanded;
                                setState(() {
                                  _expandedReportId = isExpanded
                                      ? null
                                      : report.id;
                                });
                                // 확장 시 중앙 정렬 스크롤 적용
                                if (!wasExpanded) {
                                  _scrollToReport(report.id);
                                }
                              },
                            ),
                          );
                        }, childCount: reports.length),
                      ),
                    // 남은 공간을 배경색으로 채우기
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(color: AppColors.background),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
