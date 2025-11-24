import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'agent_state.dart';

class AgentNotifier extends Notifier<AgentState> {
  @override
  AgentState build() {
    return const AgentState();
  }

  void switchAgent(AgentType agent) {
    state = state.copyWith(currentAgent: agent);
  }

  void randomizeStyle() {
    final styles = AgentStyle.values;
    final random = Random();
    final newStyle = styles[random.nextInt(styles.length)];
    state = state.copyWith(currentStyle: newStyle);
  }
}

final agentProvider = NotifierProvider<AgentNotifier, AgentState>(
  AgentNotifier.new,
);
