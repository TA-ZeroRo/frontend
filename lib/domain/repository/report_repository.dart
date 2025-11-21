import '../model/report/monthly_report.dart';

abstract class ReportRepository {
  Future<List<MonthlyReport>> getMonthlyReports(String userId);
}
