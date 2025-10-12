// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String,
  text: json['text'] as String,
  sender: json['sender'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  isUser: json['isUser'] as bool,
  fileUrl: json['fileUrl'] as String?,
  fileName: json['fileName'] as String?,
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'sender': instance.sender,
      'timestamp': instance.timestamp.toIso8601String(),
      'isUser': instance.isUser,
      'fileUrl': instance.fileUrl,
      'fileName': instance.fileName,
    };
