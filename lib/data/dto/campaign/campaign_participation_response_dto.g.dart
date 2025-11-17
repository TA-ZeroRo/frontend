// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_participation_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampaignParticipationResponseDto _$CampaignParticipationResponseDtoFromJson(
  Map<String, dynamic> json,
) => CampaignParticipationResponseDto(
  success: json['success'] as bool,
  campaignId: (json['campaign_id'] as num).toInt(),
  missionsCreated: (json['missions_created'] as num).toInt(),
  missionLogs: (json['mission_logs'] as List<dynamic>)
      .map((e) => MissionLogDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CampaignParticipationResponseDtoToJson(
  CampaignParticipationResponseDto instance,
) => <String, dynamic>{
  'success': instance.success,
  'campaign_id': instance.campaignId,
  'missions_created': instance.missionsCreated,
  'mission_logs': instance.missionLogs,
};
