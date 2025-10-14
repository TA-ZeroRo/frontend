import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/model/chat_message/chat_message.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
abstract class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    required String title,
    required List<ChatMessage> messages,
    required DateTime lastUpdated,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}
