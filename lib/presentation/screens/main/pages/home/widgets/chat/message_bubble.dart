import 'package:flutter/material.dart';
import 'package:frontend/core/theme/chat_colors.dart';
import 'package:frontend/core/theme/chat_spacing.dart';
import 'package:frontend/core/theme/app_text_style.dart';
import 'package:frontend/domain/model/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth * 0.7;

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        margin: EdgeInsets.only(
          left: message.isUser ? ChatSpacing.xl : ChatSpacing.md,
          right: message.isUser ? ChatSpacing.md : ChatSpacing.xl,
          bottom: ChatSpacing.xs,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ChatSpacing.sm,
            vertical: ChatSpacing.xs + 2,
          ),
          decoration: BoxDecoration(
            color: message.isUser
                ? ChatColors.userMessageBg
                : ChatColors.aiMessageBg,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: Radius.circular(message.isUser ? 20 : 4),
              bottomRight: Radius.circular(message.isUser ? 4 : 20),
            ),
            boxShadow: message.isUser
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Text(
            message.text,
            style: AppTextStyle.bodyMedium.copyWith(
              color: message.isUser
                  ? ChatColors.userMessageText
                  : ChatColors.aiMessageText,
            ),
          ),
        ),
      ),
    );
  }
}
