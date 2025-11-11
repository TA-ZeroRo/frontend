import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../domain/repository/agent_chat_repository.dart';
import '../../../../entry/state/auth_controller.dart';
import 'chat_state.dart';

/// 채팅 컨트롤러
class ChatNotifier extends Notifier<ChatState> {
  final AgentChatRepository _agentChatRepository = getIt<AgentChatRepository>();

  @override
  ChatState build() {
    return ChatState();
  }

  /// 메시지 전송
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 현재 로그인한 사용자 ID 가져오기
    final userId = ref.read(authProvider).currentUser?.id;
    if (userId == null) {
      state = state.copyWith(error: '로그인이 필요합니다', isLoading: false);
      return;
    }

    // 사용자 메시지 추가
    final userMessage = SimpleMessage(
      text: text,
      isAI: false,
      timestamp: DateTime.now(),
    );

    // 입력 필드 초기화, 사용자 메시지 추가, 로딩 시작
    state = state.copyWith(
      inputText: '',
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      // 실제 API 호출
      final responseMessage = await _agentChatRepository.sendMessage(
        userId: userId,
        message: text,
      );

      // AI 응답 생성
      final aiResponse = SimpleMessage(
        text: responseMessage,
        isAI: true,
        timestamp: DateTime.now(),
      );

      // AI 메시지 추가 및 로딩 종료
      state = state.copyWith(
        messages: [...state.messages, aiResponse],
        isLoading: false,
      );
    } catch (e) {
      // 에러 처리
      state = state.copyWith(
        isLoading: false,
        error: '메시지 전송에 실패했습니다: ${e.toString()}',
      );
    }
  }

  /// 전체 화면 채팅 토글
  void toggleFullChat() {
    state = state.copyWith(isFullChatOpen: !state.isFullChatOpen);
  }

  /// 에러 클리어
  void clearError() {
    state = state.copyWith(error: null);
  }
}

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);
