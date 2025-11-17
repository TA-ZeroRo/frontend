import 'package:freezed_annotation/freezed_annotation.dart';

import 'mission_status.dart';

part 'mission_log.freezed.dart';

/// 미션 로그 도메인 모델 (사용자의 미션 수행 기록)
@freezed
abstract class MissionLog with _$MissionLog {
  const factory MissionLog({
    required int id,
    required String userId,
    required int missionTemplateId,
    required MissionStatus status,
    required DateTime startedAt,
    DateTime? completedAt,
    Map<String, dynamic>? proofData,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MissionLog;
}
