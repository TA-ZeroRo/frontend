// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_participant_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoomParticipantDto _$ChatRoomParticipantDtoFromJson(
  Map<String, dynamic> json,
) => ChatRoomParticipantDto(
  id: (json['id'] as num).toInt(),
  chatRoomId: (json['chat_room_id'] as num).toInt(),
  userId: json['user_id'] as String,
  joinedAt: json['joined_at'] as String,
  profiles: json['profiles'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ChatRoomParticipantDtoToJson(
  ChatRoomParticipantDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'chat_room_id': instance.chatRoomId,
  'user_id': instance.userId,
  'joined_at': instance.joinedAt,
  'profiles': instance.profiles,
};
