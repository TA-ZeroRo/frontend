import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_report.freezed.dart';
part 'monthly_report.g.dart';

@freezed
abstract class MonthlyReport with _$MonthlyReport {
  const factory MonthlyReport({
    required ReportUser user,
    required ReportPeriod period,
    required ReportCampaigns campaigns,
    required ReportMissions missions,
    required ReportPoints points,
    required ReportTmi tmi,
    required ReportReward reward,
  }) = _MonthlyReport;

  factory MonthlyReport.fromJson(Map<String, dynamic> json) =>
      _$MonthlyReportFromJson(json);
}

@freezed
abstract class ReportUser with _$ReportUser {
  const factory ReportUser({
    required String id,
    required String username,
  }) = _ReportUser;

  factory ReportUser.fromJson(Map<String, dynamic> json) =>
      _$ReportUserFromJson(json);
}

@freezed
abstract class ReportPeriod with _$ReportPeriod {
  const factory ReportPeriod({
    required String startDate,
    required String endDate,
  }) = _ReportPeriod;

  factory ReportPeriod.fromJson(Map<String, dynamic> json) =>
      _$ReportPeriodFromJson(json);
}

@freezed
abstract class ReportCampaigns with _$ReportCampaigns {
  const factory ReportCampaigns({
    required List<CampaignItem> list,
    required int count,
  }) = _ReportCampaigns;

  factory ReportCampaigns.fromJson(Map<String, dynamic> json) =>
      _$ReportCampaignsFromJson(json);
}

@freezed
abstract class CampaignItem with _$CampaignItem {
  const factory CampaignItem({
    required int id,
    required String title,
    required String description,
  }) = _CampaignItem;

  factory CampaignItem.fromJson(Map<String, dynamic> json) =>
      _$CampaignItemFromJson(json);
}

@freezed
abstract class ReportMissions with _$ReportMissions {
  const factory ReportMissions({
    required List<MissionCategory> completedByCategory,
    required int totalCompleted,
  }) = _ReportMissions;

  factory ReportMissions.fromJson(Map<String, dynamic> json) =>
      _$ReportMissionsFromJson(json);
}

@freezed
abstract class MissionCategory with _$MissionCategory {
  const factory MissionCategory({
    required String category,
    required int count,
  }) = _MissionCategory;

  factory MissionCategory.fromJson(Map<String, dynamic> json) =>
      _$MissionCategoryFromJson(json);
}

@freezed
abstract class ReportPoints with _$ReportPoints {
  const factory ReportPoints({
    required int currentMonth,
    required int previousMonth,
    required int difference,
  }) = _ReportPoints;

  factory ReportPoints.fromJson(Map<String, dynamic> json) =>
      _$ReportPointsFromJson(json);
}

@freezed
abstract class ReportTmi with _$ReportTmi {
  const factory ReportTmi({
    required String content,
  }) = _ReportTmi;

  factory ReportTmi.fromJson(Map<String, dynamic> json) =>
      _$ReportTmiFromJson(json);
}

@freezed
abstract class ReportReward with _$ReportReward {
  const factory ReportReward({
    required bool isFirstView,
    required int pointsEarned,
  }) = _ReportReward;

  factory ReportReward.fromJson(Map<String, dynamic> json) =>
      _$ReportRewardFromJson(json);
}
