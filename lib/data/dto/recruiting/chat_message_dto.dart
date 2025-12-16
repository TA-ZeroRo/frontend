import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/recruiting/chat_message.dart';

part 'chat_message_dto.g.dart';

@JsonSerializable()
class ChatMessageDto {
  final int id;
  @JsonKey(name: 'chat_room_id')
  final int chatRoomId;
  @JsonKey(name: 'user_id')
  final String userId;
  final String message;
  @JsonKey(name: 'created_at')
  final String createdAt;
  final Map<String, dynamic>? profiles;

  const ChatMessageDto({
    required this.id,
    required this.chatRoomId,
    required this.userId,
    required this.message,
    required this.createdAt,
    this.profiles,
  });

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageDtoToJson(this);

  static String? _getValidImageUrl(dynamic img) {
    return (img is String && img.isNotEmpty && img.startsWith('http')) ? img : null;
  }

  ChatMessage toModel() {
    return ChatMessage(
      id: id.toString(),
      chatRoomId: chatRoomId.toString(),
      userId: userId,
      username: profiles?['username'] ?? 'Unknown',
      userImageUrl: _getValidImageUrl(profiles?['user_img']),
      message: message,
      timestamp: DateTime.parse(createdAt).toLocal(), // UTC → 한국 시간 변환
    );
  }
}
