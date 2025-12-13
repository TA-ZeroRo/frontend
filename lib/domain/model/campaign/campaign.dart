import 'package:freezed_annotation/freezed_annotation.dart';

import 'campaign_source.dart';

part 'campaign.freezed.dart';
part 'campaign.g.dart';

@freezed
abstract class Campaign with _$Campaign {
  const factory Campaign({
    required int id,
    required String title,
    String? description,
    required String hostOrganizer,
    required String campaignUrl,
    String? imageUrl,
    String? startDate,
    String? endDate,
    String? region,
    String? category,
    required String status,
    String? submissionType,
    required DateTime updatedAt,
    /// 캠페인 출처 (ZERORO: 자체 캠페인, EXTERNAL: 외부 캠페인)
    @Default(CampaignSource.external) CampaignSource campaignSource,
    // RPA WebView 관련 필드 (레거시)
    int? rpaSiteConfigId,
    String? rpaFormUrl,
    Map<String, dynamic>? rpaFormConfig,
    Map<String, dynamic>? rpaFieldMapping,
    Map<String, dynamic>? rpaFormSelectorStrategies,
    Map<String, dynamic>? webviewConfig,
  }) = _Campaign;

  factory Campaign.fromJson(Map<String, dynamic> json) =>
      _$CampaignFromJson(json);
}
