// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_log_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MissionLogDto _$MissionLogDtoFromJson(Map<String, dynamic> json) =>
    MissionLogDto(
      id: (json['id'] as num).toInt(),
      userId: json['user_id'] as String,
      missionTemplateId: (json['mission_template_id'] as num).toInt(),
      status: json['status'] as String,
      startedAt: json['started_at'] as String,
      completedAt: json['completed_at'] as String?,
      proofData: json['proof_data'] as Map<String, dynamic>?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      missionTemplates: json['mission_templates'] == null
          ? null
          : MissionTemplateDto.fromJson(
              json['mission_templates'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$MissionLogDtoToJson(MissionLogDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'mission_template_id': instance.missionTemplateId,
      'status': instance.status,
      'started_at': instance.startedAt,
      'completed_at': instance.completedAt,
      'proof_data': instance.proofData,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'mission_templates': instance.missionTemplates?.toJson(),
    };
