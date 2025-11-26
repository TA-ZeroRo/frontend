// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampaignDto _$CampaignDtoFromJson(Map<String, dynamic> json) => CampaignDto(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String?,
  hostOrganizer: json['host_organizer'] as String,
  campaignUrl: json['campaign_url'] as String,
  imageUrl: json['image_url'] as String?,
  startDate: json['start_date'] as String?,
  endDate: json['end_date'] as String?,
  region: json['region'] as String?,
  category: json['category'] as String?,
  status: json['status'] as String,
  submissionType: json['submission_type'] as String?,
  updatedAt: json['updated_at'] as String,
  rpaSiteConfigId: (json['rpa_site_config_id'] as num?)?.toInt(),
  rpaFormUrl: json['rpa_form_url'] as String?,
  rpaFormConfig: json['rpa_form_config'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$CampaignDtoToJson(CampaignDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'host_organizer': instance.hostOrganizer,
      'campaign_url': instance.campaignUrl,
      'image_url': instance.imageUrl,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'region': instance.region,
      'category': instance.category,
      'status': instance.status,
      'submission_type': instance.submissionType,
      'updated_at': instance.updatedAt,
      'rpa_site_config_id': instance.rpaSiteConfigId,
      'rpa_form_url': instance.rpaFormUrl,
      'rpa_form_config': instance.rpaFormConfig,
    };
