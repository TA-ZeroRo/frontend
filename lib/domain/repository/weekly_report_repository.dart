import '../model/weekly_report/weekly_report.dart';

abstract class WeeklyReportRepository {
  /// 주간보고서 목록 조회 (최신순)
  Future<List<WeeklyReport>> getWeeklyReports(String userId);

  /// 특정 주간보고서 조회
  Future<WeeklyReport?> getWeeklyReport(String userId, String reportId);

  /// 주간보고서 저장
  Future<void> saveWeeklyReport(WeeklyReport report);

  /// 가장 최근 주간보고서 조회
  Future<WeeklyReport?> getLatestWeeklyReport(String userId);

  /// 특정 기간의 주간보고서 조회
  Future<WeeklyReport?> getWeeklyReportByPeriod(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );
}
