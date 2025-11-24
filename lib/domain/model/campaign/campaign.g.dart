// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Campaign _$CampaignFromJson(Map<String, dynamic> json) => _Campaign(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String?,
  hostOrganizer: json['hostOrganizer'] as String,
  campaignUrl: json['campaignUrl'] as String,
  imageUrl: json['imageUrl'] as String?,
  startDate: json['startDate'] as String,
  endDate: json['endDate'] as String?,
  region: json['region'] as String,
  category: json['category'] as String,
  status: json['status'] as String,
  submissionType: json['submissionType'] as String?,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  rpaSiteConfigId: (json['rpaSiteConfigId'] as num?)?.toInt(),
  rpaFormUrl: json['rpaFormUrl'] as String?,
  rpaFormConfig: json['rpaFormConfig'] as Map<String, dynamic>?,
  rpaFieldMapping: json['rpaFieldMapping'] as Map<String, dynamic>?,
  rpaFormSelectorStrategies:
      json['rpaFormSelectorStrategies'] as Map<String, dynamic>?,
  webviewConfig: json['webviewConfig'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$CampaignToJson(_Campaign instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'hostOrganizer': instance.hostOrganizer,
  'campaignUrl': instance.campaignUrl,
  'imageUrl': instance.imageUrl,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'region': instance.region,
  'category': instance.category,
  'status': instance.status,
  'submissionType': instance.submissionType,
  'updatedAt': instance.updatedAt.toIso8601String(),
  'rpaSiteConfigId': instance.rpaSiteConfigId,
  'rpaFormUrl': instance.rpaFormUrl,
  'rpaFormConfig': instance.rpaFormConfig,
  'rpaFieldMapping': instance.rpaFieldMapping,
  'rpaFormSelectorStrategies': instance.rpaFormSelectorStrategies,
  'webviewConfig': instance.webviewConfig,
};
