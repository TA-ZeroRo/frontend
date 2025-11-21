// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_report_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyReportDto _$MonthlyReportDtoFromJson(Map<String, dynamic> json) =>
    MonthlyReportDto(
      user: ReportUserDto.fromJson(json['user'] as Map<String, dynamic>),
      period: ReportPeriodDto.fromJson(json['period'] as Map<String, dynamic>),
      campaigns: ReportCampaignsDto.fromJson(
        json['campaigns'] as Map<String, dynamic>,
      ),
      missions: ReportMissionsDto.fromJson(
        json['missions'] as Map<String, dynamic>,
      ),
      points: ReportPointsDto.fromJson(json['points'] as Map<String, dynamic>),
      tmi: ReportTmiDto.fromJson(json['tmi'] as Map<String, dynamic>),
      reward: ReportRewardDto.fromJson(json['reward'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MonthlyReportDtoToJson(MonthlyReportDto instance) =>
    <String, dynamic>{
      'user': instance.user,
      'period': instance.period,
      'campaigns': instance.campaigns,
      'missions': instance.missions,
      'points': instance.points,
      'tmi': instance.tmi,
      'reward': instance.reward,
    };

ReportUserDto _$ReportUserDtoFromJson(Map<String, dynamic> json) =>
    ReportUserDto(
      id: json['id'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$ReportUserDtoToJson(ReportUserDto instance) =>
    <String, dynamic>{'id': instance.id, 'username': instance.username};

ReportPeriodDto _$ReportPeriodDtoFromJson(Map<String, dynamic> json) =>
    ReportPeriodDto(
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
    );

Map<String, dynamic> _$ReportPeriodDtoToJson(ReportPeriodDto instance) =>
    <String, dynamic>{
      'start_date': instance.startDate,
      'end_date': instance.endDate,
    };

ReportCampaignsDto _$ReportCampaignsDtoFromJson(Map<String, dynamic> json) =>
    ReportCampaignsDto(
      list: (json['list'] as List<dynamic>)
          .map((e) => CampaignItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$ReportCampaignsDtoToJson(ReportCampaignsDto instance) =>
    <String, dynamic>{'list': instance.list, 'count': instance.count};

CampaignItemDto _$CampaignItemDtoFromJson(Map<String, dynamic> json) =>
    CampaignItemDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$CampaignItemDtoToJson(CampaignItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
    };

ReportMissionsDto _$ReportMissionsDtoFromJson(Map<String, dynamic> json) =>
    ReportMissionsDto(
      completedByCategory: (json['completed_by_category'] as List<dynamic>)
          .map((e) => MissionCategoryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCompleted: (json['total_completed'] as num).toInt(),
    );

Map<String, dynamic> _$ReportMissionsDtoToJson(ReportMissionsDto instance) =>
    <String, dynamic>{
      'completed_by_category': instance.completedByCategory,
      'total_completed': instance.totalCompleted,
    };

MissionCategoryDto _$MissionCategoryDtoFromJson(Map<String, dynamic> json) =>
    MissionCategoryDto(
      category: json['category'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$MissionCategoryDtoToJson(MissionCategoryDto instance) =>
    <String, dynamic>{'category': instance.category, 'count': instance.count};

ReportPointsDto _$ReportPointsDtoFromJson(Map<String, dynamic> json) =>
    ReportPointsDto(
      currentMonth: (json['current_month'] as num).toInt(),
      previousMonth: (json['previous_month'] as num).toInt(),
      difference: (json['difference'] as num).toInt(),
    );

Map<String, dynamic> _$ReportPointsDtoToJson(ReportPointsDto instance) =>
    <String, dynamic>{
      'current_month': instance.currentMonth,
      'previous_month': instance.previousMonth,
      'difference': instance.difference,
    };

ReportTmiDto _$ReportTmiDtoFromJson(Map<String, dynamic> json) =>
    ReportTmiDto(content: json['content'] as String);

Map<String, dynamic> _$ReportTmiDtoToJson(ReportTmiDto instance) =>
    <String, dynamic>{'content': instance.content};

ReportRewardDto _$ReportRewardDtoFromJson(Map<String, dynamic> json) =>
    ReportRewardDto(
      isFirstView: json['is_first_view'] as bool,
      pointsEarned: (json['points_earned'] as num).toInt(),
    );

Map<String, dynamic> _$ReportRewardDtoToJson(ReportRewardDto instance) =>
    <String, dynamic>{
      'is_first_view': instance.isFirstView,
      'points_earned': instance.pointsEarned,
    };
