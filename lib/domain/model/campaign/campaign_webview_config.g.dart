// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_webview_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CampaignWebviewConfig _$CampaignWebviewConfigFromJson(
  Map<String, dynamic> json,
) => _CampaignWebviewConfig(
  id: (json['id'] as num).toInt(),
  campaignId: (json['campaignId'] as num).toInt(),
  loginUrl: json['loginUrl'] as String,
  submissionUrl: json['submissionUrl'] as String,
  loginDetection: json['loginDetection'] as Map<String, dynamic>,
  fieldSelectors: json['fieldSelectors'] as Map<String, dynamic>,
  fieldMapping: json['fieldMapping'] as Map<String, dynamic>,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CampaignWebviewConfigToJson(
  _CampaignWebviewConfig instance,
) => <String, dynamic>{
  'id': instance.id,
  'campaignId': instance.campaignId,
  'loginUrl': instance.loginUrl,
  'submissionUrl': instance.submissionUrl,
  'loginDetection': instance.loginDetection,
  'fieldSelectors': instance.fieldSelectors,
  'fieldMapping': instance.fieldMapping,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
