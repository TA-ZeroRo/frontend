import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mock/weekly_report_mock_data.dart';
import '../../../../entry/state/auth_controller.dart';

/// 주간보고서 목록을 관리하는 Notifier (Mock 데이터 사용)
class WeeklyReportsNotifier extends Notifier<List<ProfileWeeklyReport>> {
  @override
  List<ProfileWeeklyReport> build() {
    final user = ref.read(authProvider).currentUser;

    // 사용자 정보가 없으면 빈 배열 반환
    if (user == null) {
      return [];
    }

    // Mock 데이터 반환 (userId와 username만 실제 값 사용)
    return ProfileWeeklyReport.getMockWeeklyReports(
      userId: user.id,
      username: user.username,
    );
  }

  /// 주간보고서 새로고침
  void refresh() {
    final user = ref.read(authProvider).currentUser;

    // 사용자 정보가 없으면 빈 배열 설정
    if (user == null) {
      state = [];
      return;
    }

    state = ProfileWeeklyReport.getMockWeeklyReports(
      userId: user.id,
      username: user.username,
    );
  }
}

/// 주간보고서 목록 Provider
final weeklyReportsProvider =
    NotifierProvider<WeeklyReportsNotifier, List<ProfileWeeklyReport>>(
      WeeklyReportsNotifier.new,
    );
