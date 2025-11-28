class ChatRoom {
  final String id;
  final String recruitingPostId;
  final List<String> participantIds;
  final DateTime createdAt;

  const ChatRoom({
    required this.id,
    required this.recruitingPostId,
    required this.participantIds,
    required this.createdAt,
  });

  ChatRoom copyWith({
    String? id,
    String? recruitingPostId,
    List<String>? participantIds,
    DateTime? createdAt,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      recruitingPostId: recruitingPostId ?? this.recruitingPostId,
      participantIds: participantIds ?? this.participantIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
