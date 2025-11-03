import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../domain/model/chart_data/chart_data.dart';
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
              fontWeight: FontWeight.bold,
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

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and icon
          Row(
            children: [
              Icon(
                Icons.trending_up_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '포인트 추이',
                style: AppTextStyle.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Chart info badges
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${chartData.length}일간',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
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
            ],
          ),
          const SizedBox(height: 20),

          // Chart container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.textTertiary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: chartData.isEmpty
                ? SizedBox(
                    height: 270,
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
                            '아직 성과 데이터가 없습니다',
                            style: AppTextStyle.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '활동을 시작하면 차트가 표시됩니다',
                            style: AppTextStyle.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    height: 220,
                    child: SfCartesianChart(
                      // 차트 스타일 설정
                      backgroundColor: Colors.transparent,
                      plotAreaBackgroundColor: Colors.transparent,

                      // 플롯 영역 패딩 설정 (데이터 라벨을 위한 공간 확보)
                      plotAreaBorderWidth: 0,
                      margin: const EdgeInsets.only(
                        top: 30,
                        bottom: 10,
                        left: 10,
                        right: 10,
                      ),

                      // 팬/줌 동작
                      zoomPanBehavior: _zoomPanBehavior,

                      // 트랙볼
                      trackballBehavior: _trackballBehavior,

                      // 툴팁
                      tooltipBehavior: _tooltipBehavior,

                      // X축 - 날짜 (DateTimeAxis)
                      primaryXAxis: DateTimeAxis(
                        // 날짜 포맷 설정
                        dateFormat: DateFormat('M/d'),
                        labelStyle: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
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
                        // 자동 스크롤 - 최신 데이터로 이동
                        autoScrollingDelta: chartData.length > 7 ? 7 : null,
                        autoScrollingDeltaType: DateTimeIntervalType.days,
                        enableAutoIntervalOnZooming: true,
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                      ),

                      // Y축 - 점수 (NumericAxis) - Syncfusion 자동 계산 사용
                      primaryYAxis: NumericAxis(
                        // maximum과 interval을 지정하지 않으면
                        // Syncfusion이 데이터 범위에 맞춰 자동으로 최대값과 간격을 계산합니다
                        // 그래프 수치가 높아질수록 세로 레이블 숫자도 자동으로 커집니다
                        // Y축 라벨 포맷 (1000 이상이면 K 표시)
                        numberFormat: NumberFormat.compact(),
                        labelStyle: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
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

                      // 차트 시리즈
                      series: <LineSeries<ChartData, DateTime>>[
                        LineSeries<ChartData, DateTime>(
                          // 데이터 소스
                          dataSource: chartData,
                          // X축 값 (날짜)
                          xValueMapper: (ChartData data, _) => data.date,
                          // Y축 값 (점수)
                          yValueMapper: (ChartData data, _) =>
                              data.score.toDouble(),
                          // 시리즈 이름 (툴팁에서 series 정보 표시 방지)
                          name: '포인트',
                          // 선 스타일
                          color: AppColors.primary,
                          width: 3,
                          // 데이터 포인트 마커
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            height: 12,
                            width: 12,
                            shape: DataMarkerType.circle,
                            color: AppColors.primary,
                            borderColor: AppColors.cardBackground,
                            borderWidth: 2,
                          ),
                          // 데이터 라벨 숨김 (그래프에서 점수 제거)
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: false,
                          ),
                          // 애니메이션
                          animationDuration: 800,
                          enableTooltip: true,
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
