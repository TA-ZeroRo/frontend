import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'mock/chart_mock_data.dart';

class ChartNotifier extends Notifier<List<ProfileChartData>> {
  @override
  List<ProfileChartData> build() {
    // Mock 데이터 로드
    return ProfileChartData.getMockChartData();
  }

  void updateScore(int newScore) {
    final lastDate = state.isNotEmpty
        ? state.last.date.add(const Duration(days: 1))
        : DateTime.now();
    state = [
      ...state,
      ProfileChartData(date: lastDate, score: newScore)
    ];
  }

  void clearData() {
    state = [];
  }

  double calculateDynamicMaxY(List<ProfileChartData> data) {
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

final chartProvider = NotifierProvider<ChartNotifier, List<ProfileChartData>>(
  ChartNotifier.new,
);
