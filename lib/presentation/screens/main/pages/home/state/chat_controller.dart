import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Mock/mock_chat_data.dart';

/// 간단한 메시지 모델 (Presentation 레이어 전용)
class SimpleMessage {
  final String text;
  final bool isAI;
  final DateTime timestamp;

  SimpleMessage({
    required this.text,
    required this.isAI,
    required this.timestamp,
  });
}

/// 채팅 UI 상태
class ChatState {
  final SimpleMessage? latestAIMessage; // 최신 AI 메시지 1개만 유지
  final bool isLoading; // 타이핑 인디케이터 표시 여부
  final String inputText; // 입력 필드 텍스트

  ChatState({
    this.latestAIMessage,
    this.isLoading = false,
    this.inputText = '',
  });

  ChatState copyWith({
    SimpleMessage? latestAIMessage,
    bool? isLoading,
    String? inputText,
  }) {
    return ChatState(
      latestAIMessage: latestAIMessage ?? this.latestAIMessage,
      isLoading: isLoading ?? this.isLoading,
      inputText: inputText ?? this.inputText,
    );
  }
}

/// 채팅 컨트롤러
class ChatNotifier extends Notifier<ChatState> {
  @override
  ChatState build() {
    return ChatState();
  }

  /// 입력 텍스트 업데이트
  void updateInputText(String text) {
    state = state.copyWith(inputText: text);
  }

  /// 메시지 전송
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 입력 필드 초기화
    state = state.copyWith(
      inputText: '',
      isLoading: true,
    );

    // Mock 응답 시뮬레이션 (1-2초 딜레이)
    await Future.delayed(const Duration(milliseconds: 1500));

    // Mock AI 응답 생성
    final aiResponse = SimpleMessage(
      text: MockChatData.getNextResponse(),
      isAI: true,
      timestamp: DateTime.now(),
    );

    // 상태 업데이트
    state = state.copyWith(
      latestAIMessage: aiResponse,
      isLoading: false,
    );
  }

  /// 채팅 초기화
  void resetChat() {
    MockChatData.reset();
    state = ChatState();
  }
}

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);
