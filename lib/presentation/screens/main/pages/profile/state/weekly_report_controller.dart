import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../core/logger/logger.dart';
import '../../../../../../core/services/weekly_report_service.dart';
import '../../../../../../domain/model/weekly_report/weekly_report.dart';
import '../../../../../../domain/repository/weekly_report_repository.dart';
import 'user_controller.dart';

/// 주간보고서 목록을 관리하는 AsyncNotifier
class WeeklyReportsNotifier extends AsyncNotifier<List<WeeklyReport>> {
  late final WeeklyReportRepository _repository;
  late final WeeklyReportService _service;

  @override
  Future<List<WeeklyReport>> build() async {
    _repository = getIt<WeeklyReportRepository>();
    _service = WeeklyReportService();

    final user = ref.read(userProvider).value;
    if (user == null) {
      return [];
    }

    try {
      return await _repository.getWeeklyReports(user.id);
    } catch (e) {
      CustomLogger.logger.e('WeeklyReportsNotifier - 목록 조회 실패', error: e);
      return [];
    }
  }

  /// 주간보고서 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(userProvider).value;
      if (user == null) {
        return [];
      }
      return await _repository.getWeeklyReports(user.id);
    });
  }

  /// 월간보고서 생성
  Future<WeeklyReport> generateWeeklyReport({
    required String userId,
    required String username,
    required DateTime startDate,
    required DateTime endDate,
    List<String> campaignList = const [],
    int dailyMissionCompletedCount = 0,
    int totalDailyMissions = 30,
    int monthlyPointsEarned = 0,
    int? previousMonthPoints,
  }) async {
    final reportId = 'monthly_${startDate.millisecondsSinceEpoch}';

    final report = WeeklyReport(
      id: reportId,
      userId: userId,
      username: username,
      startDate: startDate,
      endDate: endDate,
      campaignList: campaignList,
      dailyMissionCompletedCount: dailyMissionCompletedCount,
      totalDailyMissions: totalDailyMissions,
      monthlyPointsEarned: monthlyPointsEarned,
      previousMonthPoints: previousMonthPoints,
      environmentalImpact: _service.generateEnvironmentalImpact(),
      createdAt: DateTime.now(),
    );

    await _repository.saveWeeklyReport(report);
    await refresh();

    return report;
  }
}

/// 주간보고서 목록 Provider
final weeklyReportsProvider =
    AsyncNotifierProvider<WeeklyReportsNotifier, List<WeeklyReport>>(
      WeeklyReportsNotifier.new,
    );
