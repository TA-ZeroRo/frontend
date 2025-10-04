import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/chat_spacing.dart';
import 'package:frontend/core/theme/app_text_style.dart';
import 'package:frontend/presentation/screens/main/pages/home/state/chat_controller.dart';

class ChatHeader extends ConsumerWidget {
  const ChatHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversation = ref.watch(conversationProvider);
    final viewState = ref.watch(chatViewStateProvider);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ChatSpacing.md,
        vertical: ChatSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // History toggle button
            IconButton(
              icon: Icon(
                viewState == ChatViewState.historyOpen
                    ? Icons.close
                    : Icons.menu,
              ),
              onPressed: () {
                if (viewState == ChatViewState.historyOpen) {
                  ref.read(chatViewStateProvider.notifier).setState(
                      ChatViewState.chatActive);
                } else {
                  ref.read(chatViewStateProvider.notifier).setState(
                      ChatViewState.historyOpen);
                }
              },
              tooltip: '대화 목록',
            ),
            const SizedBox(width: ChatSpacing.xs),

            // Chat title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    conversation?.title ?? '제로로',
                    style: AppTextStyle.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (conversation != null)
                    Text(
                      '${conversation.messages.length}개의 메시지',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                ],
              ),
            ),

            // Close button
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                ref.read(chatViewStateProvider.notifier).setState(
                    ChatViewState.characterVisible);
              },
              tooltip: '닫기',
            ),
          ],
        ),
      ),
    );
  }
}
