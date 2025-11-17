import 'package:json_annotation/json_annotation.dart';

import '../mission/mission_log_dto.dart';

part 'campaign_participation_response_dto.g.dart';

@JsonSerializable()
class CampaignParticipationResponseDto {
  final bool success;
  @JsonKey(name: 'campaign_id')
  final int campaignId;
  @JsonKey(name: 'missions_created')
  final int missionsCreated;
  @JsonKey(name: 'mission_logs')
  final List<MissionLogDto> missionLogs;

  const CampaignParticipationResponseDto({
    required this.success,
    required this.campaignId,
    required this.missionsCreated,
    required this.missionLogs,
  });

  factory CampaignParticipationResponseDto.fromJson(
          Map<String, dynamic> json) =>
      _$CampaignParticipationResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CampaignParticipationResponseDtoToJson(this);
}
