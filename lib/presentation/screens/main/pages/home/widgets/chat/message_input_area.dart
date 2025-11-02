import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/chat_colors.dart';
import 'package:frontend/core/theme/chat_spacing.dart';
import 'package:frontend/core/theme/app_text_style.dart';
import 'package:frontend/core/utils/toast_helper.dart';
import 'package:frontend/presentation/screens/main/pages/home/state/chat_controller.dart';

class MessageInputArea extends ConsumerStatefulWidget {
  const MessageInputArea({super.key});

  @override
  ConsumerState<MessageInputArea> createState() => _MessageInputAreaState();
}

class _MessageInputAreaState extends ConsumerState<MessageInputArea> {
  final TextEditingController _textController = TextEditingController();
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
                  // TODO: Implement camera functionality
                  ToastHelper.showInfo('카메라 기능은 곧 추가될 예정입니다');
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('갤러리'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement gallery functionality
                  ToastHelper.showInfo('갤러리 기능은 곧 추가될 예정입니다');
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('문서'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement document functionality
                  ToastHelper.showInfo('문서 첨부 기능은 곧 추가될 예정입니다');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ChatSpacing.md),
      decoration: BoxDecoration(
        color: ChatColors.inputAreaBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
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
                  border: Border.all(color: ChatColors.inputBorder, width: 1),
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
    );
  }
}
