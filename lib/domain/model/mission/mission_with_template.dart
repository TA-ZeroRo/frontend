import 'package:freezed_annotation/freezed_annotation.dart';

import '../campaign/campaign.dart';
import 'mission_log.dart';
import 'mission_template.dart';

part 'mission_with_template.freezed.dart';

/// 미션 로그 + 미션 템플릿 + 캠페인 정보가 통합된 모델
@freezed
abstract class MissionWithTemplate with _$MissionWithTemplate {
  const factory MissionWithTemplate({
    required MissionLog missionLog,
    required MissionTemplate missionTemplate,
    required Campaign campaign,
  }) = _MissionWithTemplate;
}
