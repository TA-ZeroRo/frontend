import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 프로필 페이지의 포인트 차트 확장/축소 상태를 관리하는 Notifier
class ChartExpandedNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false; // 초기값: 축소 상태
  }

  /// 차트 확장/축소 상태 토글
  void toggle() {
    state = !state;
  }

  /// 차트 확장/축소 상태 직접 설정
  void set(bool value) {
    state = value;
  }
}

/// 프로필 페이지의 포인트 차트 표시/숨김 상태를 관리하는 Provider
final isChartExpandedProvider =
    NotifierProvider<ChartExpandedNotifier, bool>(
  ChartExpandedNotifier.new,
);
