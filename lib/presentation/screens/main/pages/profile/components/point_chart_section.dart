import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../state/mock/chart_mock_data.dart';
import '../state/chart_controller.dart';

class PointChartSection extends ConsumerStatefulWidget {
  const PointChartSection({super.key});

  @override
  ConsumerState<PointChartSection> createState() => _PointChartSectionState();
}

class _PointChartSectionState extends ConsumerState<PointChartSection> {
  // Syncfusion 차트 컨트롤러 (팬/줌용)
  late ZoomPanBehavior _zoomPanBehavior;
  late TrackballBehavior _trackballBehavior;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    // 팬/줌 동작 설정
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      enablePinching: true,
      enableDoubleTapZooming: true,
      zoomMode: ZoomMode.xy,
    );
    // 트랙볼 설정
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: const InteractiveTooltip(
        enable: true,
        // 날짜와 점수만 표시 (format만 사용)
        format: 'point.x : point.y점',
      ),
    );
    // 툴팁 설정 - builder 사용으로 커스텀 툴팁 표시
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      // 커스텀 툴팁 빌더로 날짜와 점수만 표시 (series 정보 제거)
      builder: (data, point, series, pointIndex, seriesIndex) {
        // 날짜 포맷팅
        final dateStr = DateFormat('M/d').format(point.x);
        final score = (point.y ?? 0).toInt();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            '$dateStr : ${score}점',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Riverpod에서 차트 데이터 가져오기
    final chartData = ref.watch(chartProvider);
    final Color cardFillColor = AppColors.background;
    final Color badgeFillColor = AppColors.primary.withValues(alpha: 0.1);
    final Color badgeBorderColor = AppColors.primary.withValues(alpha: 0.3);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cardFillColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '포인트 추이',
                    style: AppTextStyle.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: badgeFillColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: badgeBorderColor, width: 1),
                  ),
                  child: Text(
                    '${chartData.length}일간',
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: badgeFillColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: badgeBorderColor, width: 1),
                  ),
                  child: Text(
                    chartData.isNotEmpty ? '${chartData.last.score}점' : '0점',
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            chartData.isEmpty
                ? SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.trending_up_outlined,
                            size: 48,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '아직 성과 데이터가 없어요',
                            style: AppTextStyle.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '활동을 시작하면 차트가 표시돼요',
                            style: AppTextStyle.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    height: 190,
                    child: SfCartesianChart(
                      backgroundColor: Colors.transparent,
                      plotAreaBackgroundColor: Colors.transparent,
                      plotAreaBorderWidth: 0,
                      margin: const EdgeInsets.only(
                        top: 26,
                        bottom: 8,
                        left: 10,
                        right: 10,
                      ),
                      zoomPanBehavior: _zoomPanBehavior,
                      trackballBehavior: _trackballBehavior,
                      tooltipBehavior: _tooltipBehavior,
                      primaryXAxis: DateTimeAxis(
                        dateFormat: DateFormat('M/d'),
                        labelStyle: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        axisLine: AxisLine(
                          color: AppColors.textTertiary.withValues(alpha: 0.4),
                          width: 1,
                        ),
                        majorGridLines: MajorGridLines(
                          color: AppColors.textTertiary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        minorGridLines: MinorGridLines(
                          color: AppColors.textTertiary.withValues(alpha: 0.1),
                        ),
                        majorTickLines: const MajorTickLines(size: 0),
                        minorTickLines: const MinorTickLines(size: 0),
                        autoScrollingDelta: chartData.length > 7 ? 7 : null,
                        autoScrollingDeltaType: DateTimeIntervalType.days,
                        enableAutoIntervalOnZooming: true,
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                      ),
                      primaryYAxis: NumericAxis(
                        numberFormat: NumberFormat.compact(),
                        labelStyle: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        axisLine: AxisLine(
                          color: AppColors.textTertiary.withValues(alpha: 0.4),
                          width: 1,
                        ),
                        majorGridLines: MajorGridLines(
                          color: AppColors.textTertiary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        majorTickLines: const MajorTickLines(size: 0),
                        minorTickLines: const MinorTickLines(size: 0),
                      ),
                      series: <LineSeries<ProfileChartData, DateTime>>[
                        LineSeries<ProfileChartData, DateTime>(
                          dataSource: chartData,
                          xValueMapper: (ProfileChartData data, _) => data.date,
                          yValueMapper: (ProfileChartData data, _) =>
                              data.score.toDouble(),
                          name: '포인트',
                          color: AppColors.primary,
                          width: 3,
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            height: 11,
                            width: 11,
                            shape: DataMarkerType.circle,
                            color: AppColors.primary,
                            borderColor: AppColors.cardBackground,
                            borderWidth: 2,
                          ),
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: false,
                          ),
                          animationDuration: 800,
                          enableTooltip: true,
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
