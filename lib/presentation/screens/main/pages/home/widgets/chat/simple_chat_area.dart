import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/chat_controller.dart';
import 'message_bubble.dart';
import 'typing_indicator.dart';

/// InlineChatWidget 위에 표시되는 간단한 채팅 영역
/// 최신 AI 응답 1개만 표시
class SimpleChatArea extends ConsumerWidget {
  const SimpleChatArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider);

    // 메시지나 로딩 상태가 없으면 아무것도 표시하지 않음
    final hasContent = chatState.latestAIMessage != null || chatState.isLoading;

    if (!hasContent) {
      return const SizedBox.shrink();
    }

    return AnimatedSlide(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      offset: Offset.zero,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: 1.0,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: chatState.isLoading
              ? const TypingIndicator()
              : MessageBubble(message: chatState.latestAIMessage!),
        ),
      ),
    );
  }
}
