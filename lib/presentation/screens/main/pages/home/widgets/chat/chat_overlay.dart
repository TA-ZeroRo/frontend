import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/chat_colors.dart';
import 'package:frontend/presentation/screens/main/pages/home/state/chat_controller.dart';
import 'package:frontend/presentation/screens/main/pages/home/widgets/chat/chat_header.dart';
import 'package:frontend/presentation/screens/main/pages/home/widgets/chat/message_list.dart';
import 'package:frontend/presentation/screens/main/pages/home/widgets/chat/message_input_area.dart';
import 'package:frontend/presentation/screens/main/pages/home/widgets/history/chat_history_sidebar.dart';

class ChatOverlay extends ConsumerWidget {
  const ChatOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(chatViewStateProvider);
    final conversation = ref.watch(conversationProvider);

    // Don't show overlay if character is visible
    if (viewState == ChatViewState.characterVisible) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // Main chat area with backdrop filter
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: ChatColors.chatOverlayBg,
                child: Column(
                  children: [
                    const ChatHeader(),
                    Expanded(
                      child: conversation == null
                          ? _buildEmptyState(context, ref)
                          : const MessageList(),
                    ),
                    const MessageInputArea(),
                  ],
                ),
              ),
            ),
          ),
        ),

        // History sidebar
        if (viewState == ChatViewState.historyOpen)
          const ChatHistorySidebar(),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.eco_outlined,
            size: 64,
            color: ChatColors.userMessageBg.withValues(alpha: 0.5),
          ),
          const Text(
            '안녕하세요! 저는 제로로예요 🌱',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '환경에 대해 무엇이든 물어보세요!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
