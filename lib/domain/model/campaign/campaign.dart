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
    required String startDate,
    String? endDate,
    required String region,
    required String category,
    required String status,
    String? submissionType,
    required DateTime updatedAt,
  }) = _Campaign;

  factory Campaign.fromJson(Map<String, dynamic> json) =>
      _$CampaignFromJson(json);
}
