// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatSummary _$ChatSummaryFromJson(Map<String, dynamic> json) => _ChatSummary(
  id: json['id'] as String,
  title: json['title'] as String,
  preview: json['preview'] as String,
  lastMessageTime: DateTime.parse(json['lastMessageTime'] as String),
);

Map<String, dynamic> _$ChatSummaryToJson(_ChatSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'preview': instance.preview,
      'lastMessageTime': instance.lastMessageTime.toIso8601String(),
    };
