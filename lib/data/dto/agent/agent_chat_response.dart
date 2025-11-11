import 'package:json_annotation/json_annotation.dart';

part 'agent_chat_response.g.dart';

@JsonSerializable()
class AgentChatResponse {
  final String message;

  const AgentChatResponse({
    required this.message,
  });

  factory AgentChatResponse.fromJson(Map<String, dynamic> json) =>
      _$AgentChatResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AgentChatResponseToJson(this);
}
