import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../../../../../../domain/model/chart_data.dart';

class ChartNotifier extends Notifier<List<ChartData>> {
  @override
  List<ChartData> build() {
    // 기존 하드코딩된 데이터를 도메인 모델로 변환
    return _loadMockData();
  }

  List<ChartData> _loadMockData() {
    return [
      ChartData(date: DateTime(2024, 1, 1), score: 50),
      ChartData(date: DateTime(2024, 1, 2), score: 75),
      ChartData(date: DateTime(2024, 1, 3), score: 60),
      ChartData(date: DateTime(2024, 1, 4), score: 85),
      ChartData(date: DateTime(2024, 1, 5), score: 90),
      ChartData(date: DateTime(2024, 1, 6), score: 70),
      ChartData(date: DateTime(2024, 1, 7), score: 95),
      ChartData(date: DateTime(2024, 1, 8), score: 110),
      ChartData(date: DateTime(2024, 1, 9), score: 85),
      ChartData(date: DateTime(2024, 1, 10), score: 120),
      ChartData(date: DateTime(2024, 1, 11), score: 100),
      ChartData(date: DateTime(2024, 1, 12), score: 135),
      ChartData(date: DateTime(2024, 1, 13), score: 115),
      ChartData(date: DateTime(2024, 1, 14), score: 140),
      ChartData(date: DateTime(2024, 1, 15), score: 125),
      ChartData(date: DateTime(2024, 1, 16), score: 160),
      ChartData(date: DateTime(2024, 1, 17), score: 145),
      ChartData(date: DateTime(2024, 1, 18), score: 170),
      ChartData(date: DateTime(2024, 1, 19), score: 155),
      ChartData(date: DateTime(2024, 1, 20), score: 580),
    ];
  }

  void updateScore(int newScore) {
    final lastDate = state.isNotEmpty
        ? state.last.date.add(const Duration(days: 1))
        : DateTime.now();
    state = [...state, ChartData(date: lastDate, score: newScore)];
  }

  void clearData() {
    state = [];
  }

  double calculateDynamicMaxY(List<ChartData> data) {
    if (data.isEmpty) return 100.0;
    final maxScore = data.map((d) => d.score).reduce((a, b) => a > b ? a : b);
    final interval = _getNiceInterval(maxScore.toDouble(), 5);
    return interval * 5;
  }

  double _getNiceInterval(double maxValue, int targetTickCount) {
    if (maxValue <= 0) return 1;
    final roughInterval = maxValue / targetTickCount;
    final magnitude = math
        .pow(10, roughInterval.toString().split('.')[0].length - 1)
        .toDouble();
    return (roughInterval / magnitude).ceil() * magnitude;
  }
}

final chartProvider = NotifierProvider<ChartNotifier, List<ChartData>>(
  ChartNotifier.new,
);
