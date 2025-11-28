import 'package:freezed_annotation/freezed_annotation.dart';

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
    // RPA WebView 관련 필드
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
