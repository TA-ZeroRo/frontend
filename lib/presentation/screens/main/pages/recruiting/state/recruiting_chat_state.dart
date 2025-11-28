import '../../../../../../domain/model/recruiting/chat_message.dart';

/// 메시지 전송 상태
enum MessageStatus {
  sending, // 전송 중
  sent, // 전송 완료
  failed, // 전송 실패
}

/// 전송 상태를 포함한 채팅 메시지 래퍼
class ChatMessageWithStatus {
  final ChatMessage message;
  final MessageStatus status;
  final String? localId; // 낙관적 업데이트용 로컬 ID

  const ChatMessageWithStatus({
    required this.message,
    required this.status,
    this.localId,
  });

  ChatMessageWithStatus copyWith({
    ChatMessage? message,
    MessageStatus? status,
    String? localId,
  }) {
    return ChatMessageWithStatus(
      message: message ?? this.message,
      status: status ?? this.status,
      localId: localId ?? this.localId,
    );
  }
}
