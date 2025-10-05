import 'package:freezed_annotation/freezed_annotation.dart';

part 'campaign_recruiting.freezed.dart';
part 'campaign_recruiting.g.dart';

@freezed
abstract class CampaignRecruiting with _$CampaignRecruiting {
  const factory CampaignRecruiting({
    required int id,
    required String userId,
    required String username,
    String? userImg,
    required String title,
    required int recruitmentCount,
    required String campaignName,
    required String requirements,
    String? url,
    required String createdAt,
  }) = _CampaignRecruiting;

  factory CampaignRecruiting.fromJson(Map<String, dynamic> json) =>
      _$CampaignRecruitingFromJson(json);
}
