import 'package:freezed_annotation/freezed_annotation.dart';

import 'verification_type.dart';

part 'mission_template.freezed.dart';

/// 미션 템플릿 도메인 모델
@freezed
abstract class MissionTemplate with _$MissionTemplate {
  const factory MissionTemplate({
    required int id,
    required int campaignId,
    required String title,
    required String description,
    required VerificationType verificationType,
    required int rewardPoints,
    required int order,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MissionTemplate;
}
