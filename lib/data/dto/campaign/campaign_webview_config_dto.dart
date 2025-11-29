import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/campaign/campaign_webview_config.dart';

part 'campaign_webview_config_dto.g.dart';

@JsonSerializable()
class CampaignWebviewConfigDto {
  final int id;
  @JsonKey(name: 'campaign_id')
  final int campaignId;
  @JsonKey(name: 'login_url')
  final String loginUrl;
  @JsonKey(name: 'submission_url')
  final String submissionUrl;
  @JsonKey(name: 'login_detection')
  final Map<String, dynamic> loginDetection;
  @JsonKey(name: 'field_selectors')
  final Map<String, dynamic> fieldSelectors;
  @JsonKey(name: 'field_mapping')
  final Map<String, dynamic> fieldMapping;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const CampaignWebviewConfigDto({
    required this.id,
    required this.campaignId,
    required this.loginUrl,
    required this.submissionUrl,
    required this.loginDetection,
    required this.fieldSelectors,
    required this.fieldMapping,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CampaignWebviewConfigDto.fromJson(Map<String, dynamic> json) =>
      _$CampaignWebviewConfigDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CampaignWebviewConfigDtoToJson(this);

  CampaignWebviewConfig toModel() {
    return CampaignWebviewConfig(
      id: id,
      campaignId: campaignId,
      loginUrl: loginUrl,
      submissionUrl: submissionUrl,
      loginDetection: loginDetection,
      fieldSelectors: fieldSelectors,
      fieldMapping: fieldMapping,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}
