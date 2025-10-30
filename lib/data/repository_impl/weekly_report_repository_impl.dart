import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/logger/logger.dart';
import '../../domain/model/weekly_report/weekly_report.dart';
import '../../domain/repository/weekly_report_repository.dart';

@Injectable(as: WeeklyReportRepository)
class WeeklyReportRepositoryImpl implements WeeklyReportRepository {
  static const String _reportsKeyPrefix = 'weekly_reports_';
  static const String _reportsListKeyPrefix = 'weekly_reports_list_';

  @override
  Future<List<WeeklyReport>> getWeeklyReports(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listKey = '$_reportsListKeyPrefix$userId';
      final reportIdsJson = prefs.getString(listKey);

      if (reportIdsJson == null || reportIdsJson.isEmpty) {
        return [];
      }

      final reportIds = List<String>.from(jsonDecode(reportIdsJson));
      final reports = <WeeklyReport>[];

      for (final reportId in reportIds) {
        final reportKey = '$_reportsKeyPrefix$userId#$reportId';
        final reportJson = prefs.getString(reportKey);
        if (reportJson != null) {
          try {
            final reportMap = jsonDecode(reportJson) as Map<String, dynamic>;
            final report = WeeklyReport.fromJson(reportMap);
            reports.add(report);
          } catch (e) {
            CustomLogger.logger.w(
              'getWeeklyReports - 보고서 파싱 실패 (reportId: $reportId)',
              error: e,
            );
          }
        }
      }

      // 최신순 정렬
      reports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return reports;
    } catch (e) {
      CustomLogger.logger.e('getWeeklyReports - 조회 실패', error: e);
      rethrow;
    }
  }

  @override
  Future<WeeklyReport?> getWeeklyReport(String userId, String reportId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportKey = '$_reportsKeyPrefix$userId#$reportId';
      final reportJson = prefs.getString(reportKey);

      if (reportJson == null) {
        return null;
      }

      final reportMap = jsonDecode(reportJson) as Map<String, dynamic>;
      return WeeklyReport.fromJson(reportMap);
    } catch (e) {
      CustomLogger.logger.e(
        'getWeeklyReport - 조회 실패 (reportId: $reportId)',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<void> saveWeeklyReport(WeeklyReport report) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportKey = '$_reportsKeyPrefix${report.userId}#${report.id}';
      final listKey = '$_reportsListKeyPrefix${report.userId}';

      // 보고서 저장
      final reportJson = jsonEncode(report.toJson());
      await prefs.setString(reportKey, reportJson);

      // 리스트에 추가 (중복 방지)
      final reportIdsJson = prefs.getString(listKey);
      final reportIds = reportIdsJson != null
          ? List<String>.from(jsonDecode(reportIdsJson))
          : <String>[];

      if (!reportIds.contains(report.id)) {
        reportIds.add(report.id);
        await prefs.setString(listKey, jsonEncode(reportIds));
      }

      CustomLogger.logger.d(
        'saveWeeklyReport - 보고서 저장 성공 (reportId: ${report.id})',
      );
    } catch (e) {
      CustomLogger.logger.e('saveWeeklyReport - 저장 실패', error: e);
      rethrow;
    }
  }

  @override
  Future<WeeklyReport?> getLatestWeeklyReport(String userId) async {
    try {
      final reports = await getWeeklyReports(userId);
      return reports.isNotEmpty ? reports.first : null;
    } catch (e) {
      CustomLogger.logger.e('getLatestWeeklyReport - 조회 실패', error: e);
      rethrow;
    }
  }

  @override
  Future<WeeklyReport?> getWeeklyReportByPeriod(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final reports = await getWeeklyReports(userId);
      // 월간보고서의 경우 같은 월인지 확인 (날짜까지 정확히 일치하지 않아도 됨)
      return reports.firstWhere(
        (report) =>
            report.startDate.year == startDate.year &&
            report.startDate.month == startDate.month &&
            report.endDate.year == endDate.year &&
            report.endDate.month == endDate.month,
        orElse: () => throw StateError('Report not found'),
      );
    } on StateError {
      return null;
    } catch (e) {
      CustomLogger.logger.e('getWeeklyReportByPeriod - 조회 실패', error: e);
      rethrow;
    }
  }
}
