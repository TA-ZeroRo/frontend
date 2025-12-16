import 'package:json_annotation/json_annotation.dart';

part 'agent_chat_request.g.dart';

@JsonSerializable()
class AgentChatRequest {
  @JsonKey(name: 'user_id')
  final String userId;
  final String message;
  @JsonKey(name: 'selected_character')
  final String? selectedCharacter;
  @JsonKey(name: 'selected_personality')
  final String? selectedPersonality;

  const AgentChatRequest({
    required this.userId,
    required this.message,
    this.selectedCharacter = 'earth_zeroro',
    this.selectedPersonality = 'friendly',
  });

  factory AgentChatRequest.fromJson(Map<String, dynamic> json) =>
      _$AgentChatRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AgentChatRequestToJson(this);
}
