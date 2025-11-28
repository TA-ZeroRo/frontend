class ChatMessage {
  final String id;
  final String chatRoomId;
  final String userId;
  final String username;
  final String? userImageUrl;
  final String message;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.userId,
    required this.username,
    this.userImageUrl,
    required this.message,
    required this.timestamp,
  });

  ChatMessage copyWith({
    String? id,
    String? chatRoomId,
    String? userId,
    String? username,
    String? userImageUrl,
    String? message,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
