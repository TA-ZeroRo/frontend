import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/chat_colors.dart';
import 'package:frontend/core/theme/chat_spacing.dart';
import 'package:frontend/core/theme/app_text_style.dart';
import 'package:frontend/core/theme/app_color.dart';
import 'package:frontend/presentation/screens/main/pages/home/state/chat_controller.dart';
import 'package:frontend/presentation/screens/main/pages/home/widgets/history/chat_history_item.dart';

class ChatHistorySidebar extends ConsumerWidget {
  const ChatHistorySidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatHistory = ref.watch(chatHistoryProvider);
    final viewState = ref.watch(chatViewStateProvider);

    return Stack(
      children: [
        // Backdrop scrim
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              ref.read(chatViewStateProvider.notifier).setState(
                  ChatViewState.chatActive);
            },
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),

        // Sidebar
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            offset: viewState == ChatViewState.historyOpen
                ? Offset.zero
                : const Offset(-1, 0),
            child: Container(
              width: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 16,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
              child: Column(
                  children: [
                    // Header
                    SafeArea(
                      bottom: false,
                      child: Container(
                        padding: const EdgeInsets.all(ChatSpacing.md),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: ChatColors.divider,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '대화 목록',
                                style: AppTextStyle.titleLarge,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                ref
                                    .read(conversationProvider.notifier)
                                    .startNewConversation();
                                ref.read(chatViewStateProvider.notifier).setState(
                                    ChatViewState.chatActive);
                              },
                              color: AppColors.buttonColor,
                              tooltip: '새 채팅',
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Chat history list
                    Expanded(
                      child: chatHistory.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                vertical: ChatSpacing.xs,
                              ),
                              itemCount: chatHistory.length,
                              itemBuilder: (context, index) {
                                final chat = chatHistory[index];
                                return ChatHistoryItem(
                                  chatSummary: chat,
                                  onTap: () {
                                    ref
                                        .read(conversationProvider.notifier)
                                        .loadConversation(chat.id);
                                    ref
                                        .read(chatViewStateProvider.notifier)
                                        .setState(ChatViewState.chatActive);
                                  },
                                  onDelete: () {
                                    ref
                                        .read(chatHistoryProvider.notifier)
                                        .deleteChat(chat.id);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ChatSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: Colors.black.withOpacity(0.3),
            ),
            const SizedBox(height: ChatSpacing.md),
            Text(
              '아직 대화 기록이 없어요',
              style: AppTextStyle.bodyMedium.copyWith(
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
