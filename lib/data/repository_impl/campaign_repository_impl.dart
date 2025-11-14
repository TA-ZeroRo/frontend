import 'package:injectable/injectable.dart';

import '../../core/logger/logger.dart';
import '../../domain/model/campaign/campaign.dart';
import '../../domain/repository/campaign_repository.dart';
import '../data_source/campaign/campaign_api.dart';

@Injectable(as: CampaignRepository)
class CampaignRepositoryImpl implements CampaignRepository {
  final CampaignApi _campaignApi;

  CampaignRepositoryImpl(this._campaignApi);

  @override
  Future<List<Campaign>> getCampaigns({
    String? region,
    String? category,
    String? status,
    int offset = 0,
  }) async {
    try {
      final result = await _campaignApi.getCampaigns(
        region: region,
        category: category,
        status: status,
        offset: offset,
      );
      return result.map((dto) => dto.toModel()).toList();
    } catch (e) {
      CustomLogger.logger.e(
        'getCampaigns - 캠페인 목록 조회 실패 (region: $region, category: $category, status: $status, offset: $offset)',
        error: e,
      );
      rethrow;
    }
  }
}
