import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/chat_spacing.dart';
import 'package:frontend/presentation/screens/main/pages/home/state/chat_controller.dart';
import 'package:frontend/presentation/screens/main/pages/home/widgets/chat/message_bubble.dart';
import 'package:frontend/presentation/screens/main/pages/home/widgets/chat/typing_indicator.dart';

class MessageList extends ConsumerStatefulWidget {
  const MessageList({super.key});

  @override
  ConsumerState<MessageList> createState() => _MessageListState();
}

class _MessageListState extends ConsumerState<MessageList> {
  final ScrollController _scrollController = ScrollController();
  int _previousMessageCount = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final conversation = ref.watch(conversationProvider);
    final isTyping = ref.watch(isAITypingProvider);

    if (conversation == null) {
      return const SizedBox.shrink();
    }

    // Only scroll when message count changes
    if (conversation.messages.length != _previousMessageCount) {
      _previousMessageCount = conversation.messages.length;
      _scrollToBottom();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        vertical: ChatSpacing.md,
      ),
      itemCount: conversation.messages.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        // Show typing indicator at the end
        if (index == conversation.messages.length && isTyping) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(
                left: ChatSpacing.md,
                right: ChatSpacing.xl,
                bottom: ChatSpacing.xs,
              ),
              child: const TypingIndicator(),
            ),
          );
        }

        final message = conversation.messages[index];
        return MessageBubble(message: message);
      },
    );
  }
}
