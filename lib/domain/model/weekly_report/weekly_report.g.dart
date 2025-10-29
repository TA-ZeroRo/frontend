// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeeklyReport _$WeeklyReportFromJson(Map<String, dynamic> json) =>
    _WeeklyReport(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      campaignList: (json['campaignList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      dailyMissionCompletedCount: (json['dailyMissionCompletedCount'] as num)
          .toInt(),
      totalDailyMissions: (json['totalDailyMissions'] as num).toInt(),
      monthlyPointsEarned: (json['monthlyPointsEarned'] as num).toInt(),
      previousMonthPoints: (json['previousMonthPoints'] as num?)?.toInt(),
      comparisonMessage: json['comparisonMessage'] as String?,
      recommendationMessage: json['recommendationMessage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$WeeklyReportToJson(_WeeklyReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'username': instance.username,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'campaignList': instance.campaignList,
      'dailyMissionCompletedCount': instance.dailyMissionCompletedCount,
      'totalDailyMissions': instance.totalDailyMissions,
      'monthlyPointsEarned': instance.monthlyPointsEarned,
      'previousMonthPoints': instance.previousMonthPoints,
      'comparisonMessage': instance.comparisonMessage,
      'recommendationMessage': instance.recommendationMessage,
      'createdAt': instance.createdAt.toIso8601String(),
    };
