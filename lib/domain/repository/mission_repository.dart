import '../model/mission/mission_with_template.dart';

/// 미션 관련 저장소 인터페이스
abstract class MissionRepository {
  /// 사용자의 모든 미션 로그 조회
  ///
  /// [userId] 사용자 ID
  ///
  /// Returns 미션 템플릿 및 캠페인 정보가 포함된 미션 로그 목록
  Future<List<MissionWithTemplate>> getUserMissionLogs(String userId);

  /// 캠페인에 참가
  ///
  /// [campaignId] 참가할 캠페인 ID
  /// [userId] 사용자 ID
  ///
  /// Returns 캠페인 참가 성공 여부
  Future<bool> participateInCampaign({
    required int campaignId,
    required String userId,
  });
}
