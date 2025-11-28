import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:frontend/core/theme/app_color.dart';
import '../state/chat_state.dart';

/// AI 메시지를 표시하는 말풍선 위젯
class MessageBubble extends StatelessWidget {
  final SimpleMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: MarkdownBody(
          data: message.text,
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            p: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
            strong: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            a: TextStyle(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
            ),
            code: TextStyle(
              backgroundColor: Colors.grey.shade200,
              color: Colors.black87,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ),
    );
  }
}
