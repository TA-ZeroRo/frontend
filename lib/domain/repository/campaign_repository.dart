import '../model/campaign/campaign.dart';

abstract class CampaignRepository {
  Future<List<Campaign>> getCampaigns({
    String? region,
    String? category,
    String? status,
    int offset = 0,
  });
}
