import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/report/monthly_report.dart';

part 'monthly_report_dto.g.dart';

@JsonSerializable()
class MonthlyReportDto {
  final ReportUserDto user;
  final ReportPeriodDto period;
  final ReportCampaignsDto campaigns;
  final ReportMissionsDto missions;
  final ReportPointsDto points;
  final ReportTmiDto tmi;
  final ReportRewardDto reward;

  const MonthlyReportDto({
    required this.user,
    required this.period,
    required this.campaigns,
    required this.missions,
    required this.points,
    required this.tmi,
    required this.reward,
  });

  factory MonthlyReportDto.fromJson(Map<String, dynamic> json) =>
      _$MonthlyReportDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MonthlyReportDtoToJson(this);

  MonthlyReport toModel() {
    return MonthlyReport(
      user: user.toModel(),
      period: period.toModel(),
      campaigns: campaigns.toModel(),
      missions: missions.toModel(),
      points: points.toModel(),
      tmi: tmi.toModel(),
      reward: reward.toModel(),
    );
  }
}

@JsonSerializable()
class ReportUserDto {
  final String id;
  final String username;

  const ReportUserDto({
    required this.id,
    required this.username,
  });

  factory ReportUserDto.fromJson(Map<String, dynamic> json) =>
      _$ReportUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReportUserDtoToJson(this);

  ReportUser toModel() {
    return ReportUser(
      id: id,
      username: username,
    );
  }
}

@JsonSerializable()
class ReportPeriodDto {
  @JsonKey(name: 'start_date')
  final String startDate;
  @JsonKey(name: 'end_date')
  final String endDate;

  const ReportPeriodDto({
    required this.startDate,
    required this.endDate,
  });

  factory ReportPeriodDto.fromJson(Map<String, dynamic> json) =>
      _$ReportPeriodDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReportPeriodDtoToJson(this);

  ReportPeriod toModel() {
    return ReportPeriod(
      startDate: startDate,
      endDate: endDate,
    );
  }
}

@JsonSerializable()
class ReportCampaignsDto {
  final List<CampaignItemDto> list;
  final int count;

  const ReportCampaignsDto({
    required this.list,
    required this.count,
  });

  factory ReportCampaignsDto.fromJson(Map<String, dynamic> json) =>
      _$ReportCampaignsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReportCampaignsDtoToJson(this);

  ReportCampaigns toModel() {
    return ReportCampaigns(
      list: list.map((e) => e.toModel()).toList(),
      count: count,
    );
  }
}

@JsonSerializable()
class CampaignItemDto {
  final int id;
  final String title;
  final String description;

  const CampaignItemDto({
    required this.id,
    required this.title,
    required this.description,
  });

  factory CampaignItemDto.fromJson(Map<String, dynamic> json) =>
      _$CampaignItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CampaignItemDtoToJson(this);

  CampaignItem toModel() {
    return CampaignItem(
      id: id,
      title: title,
      description: description,
    );
  }
}

@JsonSerializable()
class ReportMissionsDto {
  @JsonKey(name: 'completed_by_category')
  final List<MissionCategoryDto> completedByCategory;
  @JsonKey(name: 'total_completed')
  final int totalCompleted;

  const ReportMissionsDto({
    required this.completedByCategory,
    required this.totalCompleted,
  });

  factory ReportMissionsDto.fromJson(Map<String, dynamic> json) =>
      _$ReportMissionsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReportMissionsDtoToJson(this);

  ReportMissions toModel() {
    return ReportMissions(
      completedByCategory: completedByCategory.map((e) => e.toModel()).toList(),
      totalCompleted: totalCompleted,
    );
  }
}

@JsonSerializable()
class MissionCategoryDto {
  final String category;
  final int count;

  const MissionCategoryDto({
    required this.category,
    required this.count,
  });

  factory MissionCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$MissionCategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MissionCategoryDtoToJson(this);

  MissionCategory toModel() {
    return MissionCategory(
      category: category,
      count: count,
    );
  }
}

@JsonSerializable()
class ReportPointsDto {
  @JsonKey(name: 'current_month')
  final int currentMonth;
  @JsonKey(name: 'previous_month')
  final int previousMonth;
  final int difference;

  const ReportPointsDto({
    required this.currentMonth,
    required this.previousMonth,
    required this.difference,
  });

  factory ReportPointsDto.fromJson(Map<String, dynamic> json) =>
      _$ReportPointsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReportPointsDtoToJson(this);

  ReportPoints toModel() {
    return ReportPoints(
      currentMonth: currentMonth,
      previousMonth: previousMonth,
      difference: difference,
    );
  }
}

@JsonSerializable()
class ReportTmiDto {
  final String content;

  const ReportTmiDto({
    required this.content,
  });

  factory ReportTmiDto.fromJson(Map<String, dynamic> json) =>
      _$ReportTmiDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReportTmiDtoToJson(this);

  ReportTmi toModel() {
    return ReportTmi(
      content: content,
    );
  }
}

@JsonSerializable()
class ReportRewardDto {
  @JsonKey(name: 'is_first_view')
  final bool isFirstView;
  @JsonKey(name: 'points_earned')
  final int pointsEarned;

  const ReportRewardDto({
    required this.isFirstView,
    required this.pointsEarned,
  });

  factory ReportRewardDto.fromJson(Map<String, dynamic> json) =>
      _$ReportRewardDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReportRewardDtoToJson(this);

  ReportReward toModel() {
    return ReportReward(
      isFirstView: isFirstView,
      pointsEarned: pointsEarned,
    );
  }
}
