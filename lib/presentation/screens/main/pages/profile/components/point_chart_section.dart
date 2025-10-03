import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../state/chart_controller.dart';

class PointChartSection extends ConsumerStatefulWidget {
  const PointChartSection({super.key});

  @override
  ConsumerState<PointChartSection> createState() => _PointChartSectionState();
}

class _PointChartSectionState extends ConsumerState<PointChartSection>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;

  // 애니메이션 관련 변수들
  late AnimationController _chartAnimationController;
  late Animation<double> _chartScaleAnimation;

  // 차트 확장 관련 변수들
  double _currentMaxY = 100.0; // 현재 Y축 최대값
  double _targetMaxY = 100.0; // 목표 Y축 최대값
  bool suspendedAnimation = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // 애니메이션 컨트롤러 초기화
    _chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // 차트 확장 애니메이션 (0.9 ~ 1.0 배율)
    _chartScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _chartAnimationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // 애니메이션 완료 리스너
    _chartAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentMaxY = _targetMaxY;
          suspendedAnimation = false;
        });
        _chartAnimationController.reset();
      }
    });

    // 초기 최대값 설정 (동적 계산)
    _calculateDynamicScaling();

    // 차트 초기화 시 가장 오른쪽(최신 데이터)으로 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToLatest();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _chartAnimationController.dispose();
    super.dispose();
  }

  // 동적 스케일링 계산 메서드
  void _calculateDynamicScaling() {
    final chartData = ref.read(chartProvider);
    if (chartData.isEmpty) {
      _currentMaxY = 100.0;
      _targetMaxY = 100.0;
      return;
    }

    // 차트 컨트롤러의 계산 메서드 사용
    _targetMaxY = ref
        .read(chartProvider.notifier)
        .calculateDynamicMaxY(chartData);
    _currentMaxY = _targetMaxY;
  }

  void _scrollToLatest() {
    const double pointWidth = 60.0; // 각 데이터 포인트의 너비

    // 완전히 오른쪽 끝으로 스크롤하기 위해 최대 스크롤 위치 계산
    final chartData = ref.read(chartProvider);
    final double totalWidth = chartData.length * pointWidth;

    // 스크롤 가능한 최대 위치는 (전체 너비 - 뷰포트 너비)
    // 완전히 오른쪽 끝으로 가도록 약간의 여백을 더함
    final double maxScroll = math.max(
      0,
      totalWidth, // 전체 너비로 스크롤해서 완전히 오른쪽 끝으로 이동
    );

    // 부드러운 애니메이션으로 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          maxScroll,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Y축 간격을 보기 좋게 계산하는 함수 - 제공받은 로직 적용
  double _getNiceInterval(double maxValue, int targetTickCount) {
    if (maxValue <= 0) return 1;

    // 대략적인 간격 계산 (최대값을 목표 눈금 수로 나누기)
    final roughInterval = maxValue / targetTickCount;

    // 10의 거듭제곱으로 반올림할 기준값 계산
    final magnitude = math
        .pow(10, roughInterval.toString().split('.')[0].length - 1)
        .toDouble();

    // 반올림하여 보기 좋은 간격 반환
    return (roughInterval / magnitude).ceil() * magnitude;
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(48, 232, 54, 1);

    // Riverpod에서 차트 데이터 가져오기
    final chartData = ref.watch(chartProvider);

    // ChartData를 ScoreData로 변환
    final List<ScoreData> _scoreData = chartData
        .map((data) => ScoreData(data.date, data.score))
        .toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Row(
            children: [
              const Text(
                '내 성과 변화',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              if (suspendedAnimation)
                AnimatedBuilder(
                  animation: _chartAnimationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _chartScaleAnimation.value * 0.5,
                      child: Icon(
                        Icons.trending_up,
                        color: primaryColor,
                        size: 20 * _chartScaleAnimation.value,
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),

          // 차트 또는 빈 상태 메시지
          _scoreData.isEmpty
              ? Container(
                  height: 270,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      '아직 성과 데이터가 없습니다',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              // 완전히 새로운 구조 - 차트 확장하고 외부 슬라이드바
              : Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.4),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // 확장된 차트 영역 (세로 레이블이 전체 차트 높이와 날짜 레이블 포함)
                      SizedBox(
                        height: 220, // 차트 영역과 날짜 레이블을 포함한 전체 높이
                        child: Row(
                          children: [
                            // 확장된 세로 레이블 영역 (전체 높이에 걸쳐)
                            Container(
                              width: 50,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.grey.withValues(alpha: 0.4),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  // 차트 영역 레이블 (200px)
                                  Expanded(
                                    flex: 4, // 차트 영역 비율
                                    child: Column(
                                      children: List.generate(6, (index) {
                                        final interval = _getNiceInterval(
                                          _currentMaxY,
                                          5,
                                        );
                                        final value = ((5 - index) * interval)
                                            .toInt();

                                        return Expanded(
                                          child: Center(
                                            child: Text(
                                              value >= 1000
                                                  ? '${(value / 1000).toStringAsFixed(1)}K'
                                                  : value.toString(),
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  // 날짜 레이블 영역 (50px) - 비우기, 차트와 일치하는 구분선
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.grey.withValues(
                                            alpha: 0.4,
                                          ),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // 확장된 스크롤 연차트 영역 - Scrollbar로 감싸기
                            Expanded(
                              child: Scrollbar(
                                controller: _scrollController,
                                thumbVisibility: true,
                                trackVisibility: true,
                                thickness: 4,
                                radius: const Radius.circular(4),
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: _scoreData.length * 60.0,
                                    child: Column(
                                      children: [
                                        // 차트 영역 - Stack으로 수치 표시 포함
                                        SizedBox(
                                          height: 170, // 차트 높이 조정
                                          child: Stack(
                                            children: [
                                              // 커스텀 차트 그래프 (격자선과 정확히 일치)
                                              Positioned.fill(
                                                child: CustomPaint(
                                                  painter: CustomChartPainter(
                                                    data: _scoreData,
                                                    interval: _getNiceInterval(
                                                      _currentMaxY,
                                                      5,
                                                    ),
                                                    maxY: _currentMaxY,
                                                    chartHeight: 170.0,
                                                  ),
                                                ),
                                              ),
                                              // 차트 위에 수치 표시 오버레이
                                              Positioned.fill(
                                                child: Stack(
                                                  children: _scoreData.asMap().entries.map((
                                                    entry,
                                                  ) {
                                                    final index = entry.key;
                                                    final scoreData =
                                                        entry.value;
                                                    // 각 데이터 포인트의 정확한 중앙 위치 (격자선과 일치)
                                                    final x =
                                                        (index * 60.0) + 30;

                                                    final maxY =
                                                        suspendedAnimation
                                                        ? _targetMaxY
                                                        : _currentMaxY;
                                                    // Y축 계산을 정확히 맞춤 - 실제 차트 영역(170px) 기준
                                                    final yRatio =
                                                        scoreData.score / maxY;
                                                    // 커스텀 차트와 동일한 좌표 계산 사용
                                                    final chartHeight = 170.0;
                                                    // 가로 격자선과 격자선과 동일한 계산식 사용
                                                    final yPosition =
                                                        chartHeight -
                                                        (yRatio *
                                                            (chartHeight -
                                                                40)) -
                                                        20;

                                                    return Positioned(
                                                      left:
                                                          x -
                                                          15, // 박스 너비 절반으로 조정
                                                      top:
                                                          yPosition -
                                                          25, // 차트 포인트 위에 정확히 위치
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 4,
                                                              vertical: 2,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                4,
                                                              ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withValues(
                                                                    alpha: 0.2,
                                                                  ),
                                                              blurRadius: 2,
                                                              offset:
                                                                  const Offset(
                                                                    1,
                                                                    1,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Text(
                                                          '${scoreData.score}점',
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              // 가로 격자선 오버레이 (세로 레이블 기준)
                                              Positioned.fill(
                                                child: CustomPaint(
                                                  painter:
                                                      HorizontalGridPainter(
                                                        interval:
                                                            _getNiceInterval(
                                                              _currentMaxY,
                                                              5,
                                                            ),
                                                        maxY: _currentMaxY,
                                                        chartHeight: 170.0,
                                                      ),
                                                ),
                                              ),
                                              // 세로 격자선 오버레이
                                              Positioned.fill(
                                                child: CustomPaint(
                                                  painter: VerticalGridPainter(
                                                    dataCount:
                                                        _scoreData.length,
                                                    pointWidth: 60.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // 하단 날짜 레이블 영역 (차트와 함께 스크롤됨) - 상단 구분선 추가
                                        Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                color: Colors.grey.withValues(
                                                  alpha: 0.4,
                                                ),
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: _scoreData.map((data) {
                                              return SizedBox(
                                                width: 60.0,
                                                child: Center(
                                                  child: Text(
                                                    DateFormat(
                                                      'M/d',
                                                    ).format(data.date),
                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

// 커스텀 차트 그래프 그리기 페인터
class CustomChartPainter extends CustomPainter {
  final List<ScoreData> data;
  final double interval;
  final double maxY;
  final double chartHeight;

  CustomChartPainter({
    required this.data,
    required this.interval,
    required this.maxY,
    required this.chartHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final scoreData = data[i];
      final x = (i * 60.0) + 30; // 데이터 포인트 중앙

      // Y 좌표를 가로 격자선과 동일한 방식으로 계산
      final yRatio = scoreData.score / maxY;
      final y = chartHeight - (yRatio * (chartHeight - 40)) - 20;

      final point = Offset(x, y);

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }

      // 데이터 포인트 그리기 (원 모양)
      canvas.drawCircle(
        point,
        6,
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        point,
        6,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }

    // 경로 그리기
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomChartPainter oldDelegate) {
    return data != oldDelegate.data ||
        interval != oldDelegate.interval ||
        maxY != oldDelegate.maxY ||
        chartHeight != oldDelegate.chartHeight;
  }
}

// 가로 격자선을 그리는 커스텀 페인터 (세로 레이블 좌표 기준)
class HorizontalGridPainter extends CustomPainter {
  final double interval;
  final double maxY;
  final double chartHeight;

  HorizontalGridPainter({
    required this.interval,
    required this.maxY,
    required this.chartHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // 세로 레이블 값들에 해당하는 가로 격자선 그리기
    for (int i = 0; i <= 5; i++) {
      final value = i * interval.toDouble();
      final yRatio = value / maxY;
      final y = chartHeight - (yRatio * (chartHeight - 40)) - 20; // 패딩 고려

      // 차트 영역 내에서만 선 그리기
      if (y >= 20 && y <= chartHeight - 20) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(HorizontalGridPainter oldDelegate) {
    return interval != oldDelegate.interval ||
        maxY != oldDelegate.maxY ||
        chartHeight != oldDelegate.chartHeight;
  }
}

// 세로 격자선을 그리는 커스텀 페인터
class VerticalGridPainter extends CustomPainter {
  final int dataCount;
  final double pointWidth;

  VerticalGridPainter({required this.dataCount, required this.pointWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // 세로 격자선 그리기 - 각 데이터 포인트 위치에 선 그리기
    for (int i = 0; i < dataCount; i++) {
      final x = i * pointWidth + (pointWidth / 2); // 데이터 포인트 중심에 선 그리기
      if (x < size.width) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      }
    }
  }

  @override
  bool shouldRepaint(VerticalGridPainter oldDelegate) {
    return dataCount != oldDelegate.dataCount ||
        pointWidth != oldDelegate.pointWidth;
  }
}

// 차트 데이터 클래스
class ScoreData {
  final DateTime date;
  final int score;

  ScoreData(this.date, this.score);
}
