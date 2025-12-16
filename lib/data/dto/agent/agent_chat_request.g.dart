// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_chat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgentChatRequest _$AgentChatRequestFromJson(
  Map<String, dynamic> json,
) => AgentChatRequest(
  userId: json['user_id'] as String,
  message: json['message'] as String,
  selectedCharacter: json['selected_character'] as String? ?? 'earth_zeroro',
  selectedPersonality: json['selected_personality'] as String? ?? 'friendly',
);

Map<String, dynamic> _$AgentChatRequestToJson(AgentChatRequest instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'message': instance.message,
      'selected_character': instance.selectedCharacter,
      'selected_personality': instance.selectedPersonality,
    };
