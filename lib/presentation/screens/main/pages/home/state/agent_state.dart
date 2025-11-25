import 'package:freezed_annotation/freezed_annotation.dart';

part 'agent_state.freezed.dart';

enum AgentType {
  planetZeroro(
    'Planet ZeroRo',
    'assets/zeroro/planet_zeroro_2.glb',
    '기본 제로로 캐릭터입니다.',
  ),
  co2Zeroro(
    'CO2 ZeroRo',
    'assets/zeroro/co2_zeroro_2.glb',
    '탄소 중립을 실천하는 제로로입니다.',
  );

  final String name;
  final String modelPath;
  final String description;

  const AgentType(this.name, this.modelPath, this.description);
}

enum AgentStyle {
  friendly('친근한 스타일', '친구처럼 편안하게 대화합니다.'),
  formal('정중한 스타일', '예의 바르고 격식 있게 대화합니다.'),
  witty('재치있는 스타일', '유머러스하고 재치 있게 대화합니다.'),
  concise('간결한 스타일', '핵심만 간단명료하게 전달합니다.');

  final String label;
  final String description;

  const AgentStyle(this.label, this.description);
}

@freezed
abstract class AgentState with _$AgentState {
  const factory AgentState({
    @Default(AgentType.planetZeroro) AgentType currentAgent,
    @Default(AgentStyle.friendly) AgentStyle currentStyle,
  }) = _AgentState;
}
