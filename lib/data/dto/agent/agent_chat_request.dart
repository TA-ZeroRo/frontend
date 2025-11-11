import 'package:json_annotation/json_annotation.dart';

part 'agent_chat_request.g.dart';

@JsonSerializable()
class AgentChatRequest {
  @JsonKey(name: 'user_id')
  final String userId;
  final String message;

  const AgentChatRequest({
    required this.userId,
    required this.message,
  });

  factory AgentChatRequest.fromJson(Map<String, dynamic> json) =>
      _$AgentChatRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AgentChatRequestToJson(this);
}
