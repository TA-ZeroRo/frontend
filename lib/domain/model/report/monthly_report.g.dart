// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonthlyReport _$MonthlyReportFromJson(Map<String, dynamic> json) =>
    _MonthlyReport(
      user: ReportUser.fromJson(json['user'] as Map<String, dynamic>),
      period: ReportPeriod.fromJson(json['period'] as Map<String, dynamic>),
      campaigns: ReportCampaigns.fromJson(
        json['campaigns'] as Map<String, dynamic>,
      ),
      missions: ReportMissions.fromJson(
        json['missions'] as Map<String, dynamic>,
      ),
      points: ReportPoints.fromJson(json['points'] as Map<String, dynamic>),
      tmi: ReportTmi.fromJson(json['tmi'] as Map<String, dynamic>),
      reward: ReportReward.fromJson(json['reward'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MonthlyReportToJson(_MonthlyReport instance) =>
    <String, dynamic>{
      'user': instance.user,
      'period': instance.period,
      'campaigns': instance.campaigns,
      'missions': instance.missions,
      'points': instance.points,
      'tmi': instance.tmi,
      'reward': instance.reward,
    };

_ReportUser _$ReportUserFromJson(Map<String, dynamic> json) =>
    _ReportUser(id: json['id'] as String, username: json['username'] as String);

Map<String, dynamic> _$ReportUserToJson(_ReportUser instance) =>
    <String, dynamic>{'id': instance.id, 'username': instance.username};

_ReportPeriod _$ReportPeriodFromJson(Map<String, dynamic> json) =>
    _ReportPeriod(
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
    );

Map<String, dynamic> _$ReportPeriodToJson(_ReportPeriod instance) =>
    <String, dynamic>{
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };

_ReportCampaigns _$ReportCampaignsFromJson(Map<String, dynamic> json) =>
    _ReportCampaigns(
      list: (json['list'] as List<dynamic>)
          .map((e) => CampaignItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$ReportCampaignsToJson(_ReportCampaigns instance) =>
    <String, dynamic>{'list': instance.list, 'count': instance.count};

_CampaignItem _$CampaignItemFromJson(Map<String, dynamic> json) =>
    _CampaignItem(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$CampaignItemToJson(_CampaignItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
    };

_ReportMissions _$ReportMissionsFromJson(Map<String, dynamic> json) =>
    _ReportMissions(
      completedByCategory: (json['completedByCategory'] as List<dynamic>)
          .map((e) => MissionCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCompleted: (json['totalCompleted'] as num).toInt(),
    );

Map<String, dynamic> _$ReportMissionsToJson(_ReportMissions instance) =>
    <String, dynamic>{
      'completedByCategory': instance.completedByCategory,
      'totalCompleted': instance.totalCompleted,
    };

_MissionCategory _$MissionCategoryFromJson(Map<String, dynamic> json) =>
    _MissionCategory(
      category: json['category'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$MissionCategoryToJson(_MissionCategory instance) =>
    <String, dynamic>{'category': instance.category, 'count': instance.count};

_ReportPoints _$ReportPointsFromJson(Map<String, dynamic> json) =>
    _ReportPoints(
      currentMonth: (json['currentMonth'] as num).toInt(),
      previousMonth: (json['previousMonth'] as num).toInt(),
      difference: (json['difference'] as num).toInt(),
    );

Map<String, dynamic> _$ReportPointsToJson(_ReportPoints instance) =>
    <String, dynamic>{
      'currentMonth': instance.currentMonth,
      'previousMonth': instance.previousMonth,
      'difference': instance.difference,
    };

_ReportTmi _$ReportTmiFromJson(Map<String, dynamic> json) =>
    _ReportTmi(content: json['content'] as String);

Map<String, dynamic> _$ReportTmiToJson(_ReportTmi instance) =>
    <String, dynamic>{'content': instance.content};

_ReportReward _$ReportRewardFromJson(Map<String, dynamic> json) =>
    _ReportReward(
      isFirstView: json['isFirstView'] as bool,
      pointsEarned: (json['pointsEarned'] as num).toInt(),
    );

Map<String, dynamic> _$ReportRewardToJson(_ReportReward instance) =>
    <String, dynamic>{
      'isFirstView': instance.isFirstView,
      'pointsEarned': instance.pointsEarned,
    };
