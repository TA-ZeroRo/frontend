// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageDto _$ChatMessageDtoFromJson(Map<String, dynamic> json) =>
    ChatMessageDto(
      id: (json['id'] as num).toInt(),
      chatRoomId: (json['chat_room_id'] as num).toInt(),
      userId: json['user_id'] as String,
      message: json['message'] as String,
      createdAt: json['created_at'] as String,
      profiles: json['profiles'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ChatMessageDtoToJson(ChatMessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chat_room_id': instance.chatRoomId,
      'user_id': instance.userId,
      'message': instance.message,
      'created_at': instance.createdAt,
      'profiles': instance.profiles,
    };
