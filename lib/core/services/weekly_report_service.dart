import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection.dart';
import '../../../core/logger/logger.dart';
import '../../../domain/model/weekly_report/weekly_report.dart';
import '../../../domain/repository/weekly_report_repository.dart';

class WeeklyReportService {
  final WeeklyReportRepository _repository = getIt<WeeklyReportRepository>();
  final Random _random = Random();

  /// 환경일지 데이터 생성 (랜덤 범위로 실시간 계산)
  /// 백엔드 연동 시에는 실제 데이터로 교체될 예정
  EnvironmentalImpact generateEnvironmentalImpact() {
    // CO2 절감: 10.0 ~ 50.0 kg (소수점 첫째자리)
    final co2Reduced = (10.0 + _random.nextDouble() * 40.0).toStringAsFixed(1);

    // 플라스틱 절약: 10 ~ 100개
    final plasticSaved = (10 + _random.nextInt(91)).toString();

    // 나무 환산: 0.5 ~ 5.0그루 (소수점 첫째자리)
    final treesEquivalent = (0.5 + _random.nextDouble() * 4.5).toStringAsFixed(
      1,
    );

    return EnvironmentalImpact(
      co2Reduced: '${co2Reduced}kg',
      plasticSaved: '${plasticSaved}개',
      treesEquivalent: '${treesEquivalent}그루',
    );
  }

  /// 현재 월의 시작일과 종료일 계산 (매월 1일 ~ 마지막 날)
  ({DateTime start, DateTime end}) getCurrentMonthRange() {
    final now = DateTime.now();
    // 이번 달 1일
    final startDate = DateTime(now.year, now.month, 1);
    // 이번 달 마지막 날 계산
    final endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return (start: startDate, end: endDate);
  }

  /// 이번 달 월간보고서가 이미 생성되었는지 확인
  Future<bool> isCurrentMonthReportGenerated(String userId) async {
    try {
      final monthRange = getCurrentMonthRange();
      final existingReport = await _repository.getWeeklyReportByPeriod(
        userId,
        monthRange.start,
        monthRange.end,
      );
      return existingReport != null;
    } catch (e) {
      CustomLogger.logger.e('isCurrentMonthReportGenerated - 확인 실패', error: e);
      return false;
    }
  }

  /// 매월 1일 00시에 월간보고서 생성 (이번 달)
  ///
  /// 앱 시작 시 호출되어 이번 달 보고서가 없으면 생성
  Future<void> checkAndGenerateWeeklyReport({
    required String userId,
    required String username,
    List<String> campaignList = const [],
    int dailyMissionCompletedCount = 0,
    int totalDailyMissions = 30, // 월간 기준으로 변경 (대략)
    int monthlyPointsEarned = 0,
  }) async {
    try {
      // 이번 달 보고서가 이미 생성되었는지 확인
      final alreadyGenerated = await isCurrentMonthReportGenerated(userId);
      if (alreadyGenerated) {
        CustomLogger.logger.d('checkAndGenerateWeeklyReport - 이번 달 보고서 이미 존재');
        return;
      }

      final monthRange = getCurrentMonthRange();

      // 저번 달 보고서 조회 (포인트 비교용)
      final previousMonthStart = DateTime(
        monthRange.start.year,
        monthRange.start.month - 1,
        1,
      );
      final previousMonthEnd = DateTime(
        monthRange.start.year,
        monthRange.start.month,
        0,
        23,
        59,
        59,
      );

      final previousReport = await _repository.getWeeklyReportByPeriod(
        userId,
        previousMonthStart,
        previousMonthEnd,
      );

      final previousMonthPoints = previousReport?.monthlyPointsEarned;

      // 보고서 생성
      final report = WeeklyReport(
        id: 'monthly_${monthRange.start.millisecondsSinceEpoch}',
        userId: userId,
        username: username,
        startDate: monthRange.start,
        endDate: monthRange.end,
        campaignList: campaignList,
        dailyMissionCompletedCount: dailyMissionCompletedCount,
        totalDailyMissions: totalDailyMissions,
        monthlyPointsEarned: monthlyPointsEarned,
        previousMonthPoints: previousMonthPoints,
        environmentalImpact: generateEnvironmentalImpact(),
        createdAt: DateTime.now(),
      );

      await _repository.saveWeeklyReport(report);
      CustomLogger.logger.d(
        'checkAndGenerateWeeklyReport - 보고서 생성 성공 (userId: $userId)',
      );
    } catch (e) {
      CustomLogger.logger.e(
        'checkAndGenerateWeeklyReport - 보고서 생성 실패',
        error: e,
      );
    }
  }
}

/// 주간보고서 서비스 Provider
final weeklyReportServiceProvider = Provider<WeeklyReportService>((ref) {
  return WeeklyReportService();
});
