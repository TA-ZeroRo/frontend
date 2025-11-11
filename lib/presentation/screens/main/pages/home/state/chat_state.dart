import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_state.freezed.dart';

/// 간단한 메시지 모델 (Presentation 레이어 전용)
@freezed
abstract class SimpleMessage with _$SimpleMessage {
  const factory SimpleMessage({
    required String text,
    required bool isAI,
    required DateTime timestamp,
  }) = _SimpleMessage;
}

/// 채팅 UI 상태
@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<SimpleMessage> messages, // 전체 채팅 메시지 히스토리
    @Default(false) bool isLoading, // 타이핑 인디케이터 표시 여부
    @Default('') String inputText, // 입력 필드 텍스트
    @Default(false) bool isFullChatOpen, // 전체 화면 채팅 오버레이 표시 여부
    String? error, // 에러 메시지
  }) = _ChatState;
}
