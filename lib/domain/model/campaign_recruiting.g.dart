// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_recruiting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CampaignRecruiting _$CampaignRecruitingFromJson(Map<String, dynamic> json) =>
    _CampaignRecruiting(
      id: (json['id'] as num).toInt(),
      userId: json['userId'] as String,
      username: json['username'] as String,
      userImg: json['userImg'] as String?,
      title: json['title'] as String,
      recruitmentCount: (json['recruitmentCount'] as num).toInt(),
      campaignName: json['campaignName'] as String,
      requirements: json['requirements'] as String,
      url: json['url'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$CampaignRecruitingToJson(_CampaignRecruiting instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'username': instance.username,
      'userImg': instance.userImg,
      'title': instance.title,
      'recruitmentCount': instance.recruitmentCount,
      'campaignName': instance.campaignName,
      'requirements': instance.requirements,
      'url': instance.url,
      'createdAt': instance.createdAt,
    };
