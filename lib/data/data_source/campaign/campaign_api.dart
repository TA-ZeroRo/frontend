import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../dto/campaign/campaign_dto.dart';
import '../../dto/campaign/campaign_participation_response_dto.dart';
// ignore: unused_import
import '../../../deprecated/webview/campaign_webview_config_dto.dart';

@injectable
class CampaignApi {
  final Dio _dio;
  final SupabaseClient _supabase = Supabase.instance.client;

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

  /// Get campaign webview config by campaign ID
  /// Supabase direct query to campaign_webview_configs table
  /// @deprecated WebView RPA is no longer used. Use in-app mission verification instead.
  @Deprecated('WebView RPA is no longer used. Use in-app mission verification instead.')
  Future<CampaignWebviewConfigDto?> getWebviewConfig({
    required int campaignId,
  }) async {
    final response = await _supabase
        .from('campaign_webview_configs')
        .select()
        .eq('campaign_id', campaignId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return CampaignWebviewConfigDto.fromJson(response);
  }
}
