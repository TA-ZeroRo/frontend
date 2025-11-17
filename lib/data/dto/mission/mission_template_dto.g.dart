// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_template_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MissionTemplateDto _$MissionTemplateDtoFromJson(Map<String, dynamic> json) =>
    MissionTemplateDto(
      id: (json['id'] as num).toInt(),
      campaignId: (json['campaign_id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      verificationType: json['verification_type'] as String,
      rewardPoints: (json['reward_points'] as num).toInt(),
      order: (json['order'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      campaigns: json['campaigns'] == null
          ? null
          : CampaignDto.fromJson(json['campaigns'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MissionTemplateDtoToJson(MissionTemplateDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'campaign_id': instance.campaignId,
      'title': instance.title,
      'description': instance.description,
      'verification_type': instance.verificationType,
      'reward_points': instance.rewardPoints,
      'order': instance.order,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'campaigns': instance.campaigns?.toJson(),
    };
