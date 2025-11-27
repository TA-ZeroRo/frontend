import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/campaign/campaign.dart';

part 'campaign_dto.g.dart';

@JsonSerializable()
class CampaignDto {
  final int id;
  final String title;
  final String? description;
  @JsonKey(name: 'host_organizer')
  final String hostOrganizer;
  @JsonKey(name: 'campaign_url')
  final String campaignUrl;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'start_date')
  final String? startDate;
  @JsonKey(name: 'end_date')
  final String? endDate;
  final String? region;
  final String? category;
  final String status;
  @JsonKey(name: 'submission_type')
  final String? submissionType;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'rpa_site_config_id')
  final int? rpaSiteConfigId;
  @JsonKey(name: 'rpa_form_url')
  final String? rpaFormUrl;
  @JsonKey(name: 'rpa_form_config')
  final Map<String, dynamic>? rpaFormConfig;

  const CampaignDto({
    required this.id,
    required this.title,
    this.description,
    required this.hostOrganizer,
    required this.campaignUrl,
    this.imageUrl,
    this.startDate,
    this.endDate,
    this.region,
    this.category,
    required this.status,
    this.submissionType,
    required this.updatedAt,
    this.rpaSiteConfigId,
    this.rpaFormUrl,
    this.rpaFormConfig,
  });

  factory CampaignDto.fromJson(Map<String, dynamic> json) =>
      _$CampaignDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CampaignDtoToJson(this);

  Campaign toModel() {
    return Campaign(
      id: id,
      title: title,
      description: description,
      hostOrganizer: hostOrganizer,
      campaignUrl: campaignUrl,
      imageUrl: imageUrl,
      startDate: startDate,
      endDate: endDate,
      region: region,
      category: category,
      status: status,
      submissionType: submissionType,
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}
