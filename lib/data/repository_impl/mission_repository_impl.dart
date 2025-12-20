import 'package:injectable/injectable.dart';

import '../../core/logger/logger.dart';
import '../../domain/model/mission/mission_with_template.dart';
import '../../domain/repository/mission_repository.dart';
import '../data_source/campaign/campaign_api.dart';
import '../data_source/mission/mission_api.dart';

@Injectable(as: MissionRepository)
class MissionRepositoryImpl implements MissionRepository {
  final MissionApi _missionApi;
  final CampaignApi _campaignApi;

  MissionRepositoryImpl(this._missionApi, this._campaignApi);

  @override
  Future<List<MissionWithTemplate>> getUserMissionLogs(String userId) async {
    try {
      final result = await _missionApi.getUserMissionLogs(
        userId,
        includeTemplate: true,
        includeCampaign: true,
      );

      // 개별 항목 변환 실패 시 해당 항목만 스킵 (전체 실패 방지)
      // toMissionWithTemplateOrNull()은 mission_templates나 campaigns가 null이면 null 반환
      final missions = result
          .map((dto) => dto.toMissionWithTemplateOrNull())
          .whereType<MissionWithTemplate>()
          .toList();

      // 스킵된 항목이 있으면 경고 로그
      final skippedCount = result.length - missions.length;
      if (skippedCount > 0) {
        CustomLogger.logger.w(
          'getUserMissionLogs - $skippedCount개의 미션 로그가 불완전한 데이터로 인해 스킵됨 (userId: $userId)',
        );
      }

      return missions;
    } catch (e) {
      CustomLogger.logger.e(
        'getUserMissionLogs - 사용자 미션 로그 조회 실패 (userId: $userId)',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<bool> participateInCampaign({
    required int campaignId,
    required String userId,
  }) async {
    try {
      final result = await _campaignApi.participateInCampaign(
        campaignId: campaignId,
        userId: userId,
      );

      if (!result.success) {
        final errorMessage = result.error ?? '캠페인 참가에 실패했습니다';
        CustomLogger.logger.w(
          'participateInCampaign - 캠페인 참가 실패 응답 '
          '(campaignId: $campaignId, userId: $userId, error: $errorMessage)',
        );
        throw Exception(errorMessage);
      }

      CustomLogger.logger.i(
        'participateInCampaign - 캠페인 참가 성공 '
        '(campaignId: $campaignId, userId: $userId, '
        'missionsCreated: ${result.missionsCreated})',
      );
      return result.success;
    } catch (e) {
      CustomLogger.logger.e(
        'participateInCampaign - 캠페인 참가 실패 '
        '(campaignId: $campaignId, userId: $userId)',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<bool> cancelCampaignParticipation({
    required int campaignId,
    required String userId,
  }) async {
    try {
      final result = await _campaignApi.cancelCampaignParticipation(
        campaignId: campaignId,
        userId: userId,
      );

      final success = result['success'] as bool? ?? false;

      if (!success) {
        final errorMessage = result['error'] as String? ?? '캠페인 참가 취소에 실패했습니다';
        CustomLogger.logger.w(
          'cancelCampaignParticipation - 캠페인 참가 취소 실패 응답 '
          '(campaignId: $campaignId, userId: $userId, error: $errorMessage)',
        );
        throw Exception(errorMessage);
      }

      final deletedCount = result['deleted_count'] as int? ?? 0;
      CustomLogger.logger.i(
        'cancelCampaignParticipation - 캠페인 참가 취소 성공 '
        '(campaignId: $campaignId, userId: $userId, deletedCount: $deletedCount)',
      );
      return success;
    } catch (e) {
      CustomLogger.logger.e(
        'cancelCampaignParticipation - 캠페인 참가 취소 실패 '
        '(campaignId: $campaignId, userId: $userId)',
        error: e,
      );
      rethrow;
    }
  }
}
