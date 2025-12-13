// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_webview_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampaignWebviewConfigDto _$CampaignWebviewConfigDtoFromJson(
  Map<String, dynamic> json,
) => CampaignWebviewConfigDto(
  id: (json['id'] as num).toInt(),
  campaignId: (json['campaign_id'] as num).toInt(),
  loginUrl: json['login_url'] as String,
  submissionUrl: json['submission_url'] as String,
  loginDetection: json['login_detection'] as Map<String, dynamic>,
  fieldSelectors: json['field_selectors'] as Map<String, dynamic>,
  fieldMapping: json['field_mapping'] as Map<String, dynamic>,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$CampaignWebviewConfigDtoToJson(
  CampaignWebviewConfigDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'campaign_id': instance.campaignId,
  'login_url': instance.loginUrl,
  'submission_url': instance.submissionUrl,
  'login_detection': instance.loginDetection,
  'field_selectors': instance.fieldSelectors,
  'field_mapping': instance.fieldMapping,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
