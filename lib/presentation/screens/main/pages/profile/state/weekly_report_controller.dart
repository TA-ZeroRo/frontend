import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../domain/model/report/monthly_report.dart';
import '../../../../../../domain/repository/report_repository.dart';
import '../../../../entry/state/auth_controller.dart';

/// 월간 보고서 목록을 관리하는 AsyncNotifier
class WeeklyReportsNotifier extends AsyncNotifier<List<MonthlyReport>> {
  late final ReportRepository _reportRepository;

  @override
  Future<List<MonthlyReport>> build() async {
    _reportRepository = getIt<ReportRepository>();
    return _loadReports();
  }

  /// 월간 보고서 로드
  Future<List<MonthlyReport>> _loadReports() async {
    final user = ref.read(authProvider).currentUser;

    // 사용자 정보가 없으면 빈 배열 반환
    if (user == null) {
      return [];
    }

    final reports = await _reportRepository.getMonthlyReports(user.id);
    return reports;
  }

  /// 월간 보고서 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadReports());
  }
}

/// 월간 보고서 목록 Provider
final weeklyReportsProvider =
    AsyncNotifierProvider<WeeklyReportsNotifier, List<MonthlyReport>>(
      WeeklyReportsNotifier.new,
    );
