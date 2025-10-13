import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/chat_colors.dart';
import 'package:frontend/core/theme/chat_spacing.dart';
import 'package:frontend/core/theme/app_text_style.dart';
import 'package:frontend/presentation/screens/main/pages/home/state/chat_controller.dart';
import 'package:frontend/presentation/screens/main/pages/home/widgets/chat/message_bubble.dart';
import 'package:frontend/presentation/screens/main/pages/home/widgets/chat/typing_indicator.dart';

/// Inline chat widget displayed at the bottom of the home page
/// Shows up to 3 recent messages and provides input area with expand button
class InlineChatWidget extends ConsumerStatefulWidget {
  const InlineChatWidget({super.key});

  @override
  ConsumerState<InlineChatWidget> createState() => _InlineChatWidgetState();
}

class _InlineChatWidgetState extends ConsumerState<InlineChatWidget> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _hasText = _textController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final conversation = ref.read(conversationProvider);

    // If no conversation, start a new one
    if (conversation == null) {
      ref.read(conversationProvider.notifier).startNewConversation();
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Clear input immediately
    _textController.clear();

    // Show typing indicator
    ref.read(isAITypingProvider.notifier).setTyping(true);

    // Send message
    await ref.read(conversationProvider.notifier).sendMessage(text);

    // Hide typing indicator
    ref.read(isAITypingProvider.notifier).setTyping(false);

    // Scroll to bottom
    _scrollToBottom();
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

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(ChatSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('카메라'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('카메라 기능은 곧 추가될 예정입니다')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('갤러리'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('갤러리 기능은 곧 추가될 예정입니다')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('문서'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('문서 첨부 기능은 곧 추가될 예정입니다')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _expandChat() {
    ref.read(chatViewStateProvider.notifier).setState(ChatViewState.chatActive);
  }

  void _closeMessages() {
    // Clear the conversation and typing indicator
    ref.read(conversationProvider.notifier).clearConversation();
    ref.read(isAITypingProvider.notifier).setTyping(false);
    // Clear text input
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final conversation = ref.watch(conversationProvider);
    final isTyping = ref.watch(isAITypingProvider);

    // Get last 3 messages (excluding welcome message if it's the only one)
    List<dynamic> displayItems = [];
    if (conversation != null && conversation.messages.isNotEmpty) {
      // Skip welcome message if it's the only message
      final messages = conversation.messages.length == 1 &&
              conversation.messages.first.id == 'msg_welcome'
          ? <dynamic>[]
          : conversation.messages.skip(
              conversation.messages.length > 3
                  ? conversation.messages.length - 3
                  : 0,
            ).toList();

      displayItems = messages;
      if (isTyping) {
        displayItems = [...displayItems, 'typing'];
      }
    }

    final hasMessages = displayItems.isNotEmpty;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Messages area with blur gradient at top
            if (hasMessages)
              Flexible(
                child: Stack(
                  children: [
                    // Messages list
                    ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(
                        top: ChatSpacing.lg,
                        left: ChatSpacing.md,
                        right: ChatSpacing.md,
                        bottom: ChatSpacing.xs,
                      ),
                      shrinkWrap: true,
                      itemCount: displayItems.length,
                      itemBuilder: (context, index) {
                        final item = displayItems[index];

                        // Show typing indicator
                        if (item == 'typing') {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(
                                right: ChatSpacing.xl,
                                bottom: ChatSpacing.xs,
                              ),
                              child: const TypingIndicator(),
                            ),
                          );
                        }

                        return MessageBubble(message: item);
                      },
                    ),

                    // Top blur gradient
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.95),
                              Colors.white.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Close button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _closeMessages,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Input area
            Container(
              padding: const EdgeInsets.all(ChatSpacing.md),
              child: SafeArea(
                top: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Attachment button
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: _showAttachmentOptions,
                      color: Colors.black87,
                      tooltip: '파일 첨부',
                    ),
                    const SizedBox(width: ChatSpacing.xs),

                    // Text input field
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 40,
                          maxHeight: 120,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: ChatColors.inputBorder,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _textController,
                          maxLines: null,
                          textInputAction: TextInputAction.newline,
                          style: AppTextStyle.bodyLarge,
                          decoration: InputDecoration(
                            hintText: '메시지를 입력하세요...',
                            hintStyle: AppTextStyle.bodyMedium.copyWith(
                              color: Colors.black45,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: ChatSpacing.md,
                              vertical: ChatSpacing.xs + 2,
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                    const SizedBox(width: ChatSpacing.xs),

                    // Expand button
                    IconButton(
                      icon: const Icon(Icons.open_in_full),
                      onPressed: _expandChat,
                      color: Colors.black87,
                      tooltip: '대화 확장',
                    ),
                    const SizedBox(width: ChatSpacing.xs),

                    // Send button
                    AnimatedScale(
                      duration: const Duration(milliseconds: 150),
                      scale: _hasText ? 1.0 : 0.8,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 150),
                        opacity: _hasText ? 1.0 : 0.5,
                        child: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _hasText ? _sendMessage : null,
                          color: ChatColors.userMessageBg,
                          disabledColor: ChatColors.disabledGray,
                          tooltip: '전송',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
