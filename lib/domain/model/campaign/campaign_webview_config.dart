import 'package:freezed_annotation/freezed_annotation.dart';

part 'campaign_webview_config.freezed.dart';
part 'campaign_webview_config.g.dart';

@freezed
abstract class CampaignWebviewConfig with _$CampaignWebviewConfig {
  const factory CampaignWebviewConfig({
    required int id,
    required int campaignId,
    required String loginUrl,
    required String submissionUrl,
    required Map<String, dynamic> loginDetection,
    required Map<String, dynamic> fieldSelectors,
    required Map<String, dynamic> fieldMapping,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CampaignWebviewConfig;

  factory CampaignWebviewConfig.fromJson(Map<String, dynamic> json) =>
      _$CampaignWebviewConfigFromJson(json);
}
