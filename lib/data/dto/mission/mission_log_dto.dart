import 'package:json_annotation/json_annotation.dart';

import '../../../domain/model/mission/mission_log.dart';
import '../../../domain/model/mission/mission_status.dart';
import '../../../domain/model/mission/mission_with_template.dart';
import 'mission_template_dto.dart';

part 'mission_log_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class MissionLogDto {
  final int id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'mission_template_id')
  final int missionTemplateId;
  final String status;
  @JsonKey(name: 'started_at')
  final String startedAt;
  @JsonKey(name: 'completed_at')
  final String? completedAt;
  @JsonKey(name: 'proof_data')
  final Map<String, dynamic>? proofData;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  /// 미션 템플릿 정보 (중첩된 경우에만 존재)
  @JsonKey(name: 'mission_templates')
  final MissionTemplateDto? missionTemplates;

  const MissionLogDto({
    required this.id,
    required this.userId,
    required this.missionTemplateId,
    required this.status,
    required this.startedAt,
    this.completedAt,
    this.proofData,
    required this.createdAt,
    required this.updatedAt,
    this.missionTemplates,
  });

  factory MissionLogDto.fromJson(Map<String, dynamic> json) =>
      _$MissionLogDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MissionLogDtoToJson(this);

  MissionLog toModel() {
    return MissionLog(
      id: id,
      userId: userId,
      missionTemplateId: missionTemplateId,
      status: MissionStatus.fromString(status),
      startedAt: DateTime.parse(startedAt),
      completedAt: completedAt != null ? DateTime.parse(completedAt!) : null,
      proofData: proofData,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  /// MissionWithTemplate 모델로 변환
  /// mission_templates와 campaigns가 모두 있어야 함
  MissionWithTemplate toMissionWithTemplate() {
    if (missionTemplates == null) {
      throw StateError('missionTemplates is null - cannot convert to MissionWithTemplate');
    }
    if (missionTemplates!.campaigns == null) {
      throw StateError('campaigns is null - cannot convert to MissionWithTemplate');
    }

    return MissionWithTemplate(
      missionLog: toModel(),
      missionTemplate: missionTemplates!.toModel(),
      campaign: missionTemplates!.campaigns!.toModel(),
    );
  }
}
