import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_report.freezed.dart';
part 'weekly_report.g.dart';

@freezed
abstract class WeeklyReport with _$WeeklyReport {
  const WeeklyReport._();

  const factory WeeklyReport({
    required String id,
    required String userId,
    required String username,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> campaignList, // 신청한 캠페인 목록
    required int dailyMissionCompletedCount,
    required int totalDailyMissions,
    required int monthlyPointsEarned, // 월간 획득 포인트
    int? previousMonthPoints, // 저번달 포인트
    String? comparisonMessage,
    String? recommendationMessage,
    required DateTime createdAt,
  }) = _WeeklyReport;

  factory WeeklyReport.fromJson(Map<String, dynamic> json) =>
      _$WeeklyReportFromJson(json);

  /// 미션 완료율 계산 (%)
  double get missionCompletionRate {
    if (totalDailyMissions == 0) return 0.0;
    return (dailyMissionCompletedCount / totalDailyMissions) * 100;
  }

  /// 저번달 대비 포인트 변화량
  int? get pointsDifference {
    if (previousMonthPoints == null) return null;
    return monthlyPointsEarned - previousMonthPoints!;
  }

  /// 보고서 기간 문자열 (YY-MM-DD ~ YY-MM-DD) - 월간 형식
  String get periodString {
    final start =
        '${startDate.year.toString().substring(2)}-'
        '${startDate.month.toString().padLeft(2, '0')}-'
        '${startDate.day.toString().padLeft(2, '0')}';
    final end =
        '${endDate.year.toString().substring(2)}-'
        '${endDate.month.toString().padLeft(2, '0')}-'
        '${endDate.day.toString().padLeft(2, '0')}';
    return '$start ~ $end';
  }
}
