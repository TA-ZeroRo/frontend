import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/campaign/campaign_dto.dart';
import '../../dto/campaign/campaign_participation_response_dto.dart';

@injectable
class CampaignApi {
  final Dio _dio;

  CampaignApi(this._dio);

  /// Get campaign list
  /// GET /campaign/campaign
  Future<List<CampaignDto>> getCampaigns({
    String? region,
    String? category,
    String? status,
    int offset = 0,
    int limit = 20,
  }) async {
    final queryParameters = <String, dynamic>{
      'offset': offset,
      'limit': limit,
    };

    if (region != null) {
      queryParameters['region'] = region;
    }
    if (category != null) {
      queryParameters['category'] = category;
    }
    if (status != null) {
      queryParameters['status'] = status;
    }

    final response = await _dio.get(
      '/campaign/campaigns',
      queryParameters: queryParameters,
    );

    final List<dynamic> data = response.data;
    return data.map((json) => CampaignDto.fromJson(json)).toList();
  }

  /// Participate in campaign
  /// POST /campaign-agent/campaigns/{campaignId}
  Future<CampaignParticipationResponseDto> participateInCampaign({
    required int campaignId,
    required String userId,
  }) async {
    final response = await _dio.post(
      '/campaign-agent/campaigns/$campaignId',
      data: {'user_id': userId},
    );

    return CampaignParticipationResponseDto.fromJson(response.data);
  }
}
