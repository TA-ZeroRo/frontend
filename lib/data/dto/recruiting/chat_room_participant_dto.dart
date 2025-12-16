import 'package:json_annotation/json_annotation.dart';

part 'chat_room_participant_dto.g.dart';

@JsonSerializable()
class ChatRoomParticipantDto {
  final int id;
  @JsonKey(name: 'chat_room_id')
  final int chatRoomId;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'joined_at')
  final String joinedAt;
  final Map<String, dynamic>? profiles;

  const ChatRoomParticipantDto({
    required this.id,
    required this.chatRoomId,
    required this.userId,
    required this.joinedAt,
    this.profiles,
  });

  factory ChatRoomParticipantDto.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomParticipantDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomParticipantDtoToJson(this);

  String get username => profiles?['username'] ?? 'Unknown';
  String? get userImageUrl {
    final img = profiles?['user_img'];
    return (img is String && img.isNotEmpty && img.startsWith('http')) ? img : null;
  }
  DateTime get joinedAtDateTime => DateTime.parse(joinedAt);
}
