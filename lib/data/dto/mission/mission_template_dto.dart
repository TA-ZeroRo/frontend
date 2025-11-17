import 'package:json_annotation/json_annotation.dart';

import '../../../domain/model/mission/mission_template.dart';
import '../../../domain/model/mission/verification_type.dart';
import '../campaign/campaign_dto.dart';

part 'mission_template_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class MissionTemplateDto {
  final int id;
  @JsonKey(name: 'campaign_id')
  final int campaignId;
  final String title;
  final String description;
  @JsonKey(name: 'verification_type')
  final String verificationType;
  @JsonKey(name: 'reward_points')
  final int rewardPoints;
  final int order;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  /// 캠페인 정보 (중첩된 경우에만 존재)
  final CampaignDto? campaigns;

  const MissionTemplateDto({
    required this.id,
    required this.campaignId,
    required this.title,
    required this.description,
    required this.verificationType,
    required this.rewardPoints,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
    this.campaigns,
  });

  factory MissionTemplateDto.fromJson(Map<String, dynamic> json) =>
      _$MissionTemplateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MissionTemplateDtoToJson(this);

  MissionTemplate toModel() {
    return MissionTemplate(
      id: id,
      campaignId: campaignId,
      title: title,
      description: description,
      verificationType: VerificationType.fromString(verificationType),
      rewardPoints: rewardPoints,
      order: order,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}
