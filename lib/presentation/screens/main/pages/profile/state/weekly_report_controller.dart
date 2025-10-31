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

    // 저번달과 비교하여 메시지 생성
    String? comparisonMessage;
    String? recommendationMessage;

    if (previousMonthPoints != null) {
      final difference = monthlyPointsEarned - previousMonthPoints;
      if (difference > 0) {
        comparisonMessage =
            '저번달보다 ${difference}포인트를 더 많이 획득했어요! 계속 좋은 활동을 이어가세요.';
        recommendationMessage =
            '이번 달의 활동이 인상적이에요. 더 많은 캠페인 참여로 환경 지킴이로 성장해보세요!';
      } else if (difference < 0) {
        comparisonMessage = '저번달보다 ${-difference}포인트가 적어졌네요. 꾸준한 활동이 중요해요.';
        recommendationMessage =
            '일일 미션을 더 완료하시면 포인트를 더 받을 수 있어요. 작은 실천부터 시작해보세요!';
      } else {
        comparisonMessage =
            '저번달과 동일한 포인트를 획득했어요. 조금만 더 노력하면 더 많은 포인트를 얻을 수 있어요!';
        recommendationMessage = '다양한 캠페인에 참여하시면 더 많은 포인트를 받을 수 있어요.';
      }
    } else {
      comparisonMessage = '첫 월간보고서입니다. 앞으로의 활동을 기대해요!';
      recommendationMessage = '일일 미션을 꾸준히 완료하고 캠페인에 참여해보세요.';
    }

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
      comparisonMessage: comparisonMessage,
      recommendationMessage: recommendationMessage,
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
