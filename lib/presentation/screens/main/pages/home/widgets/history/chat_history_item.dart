import 'package:flutter/material.dart';
import 'package:frontend/core/theme/chat_colors.dart';
import 'package:frontend/core/theme/chat_spacing.dart';
import 'package:frontend/core/theme/app_text_style.dart';
import 'package:frontend/domain/model/chat_summary.dart';
import 'package:intl/intl.dart';

class ChatHistoryItem extends StatelessWidget {
  final ChatSummary chatSummary;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ChatHistoryItem({
    super.key,
    required this.chatSummary,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(chatSummary.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('대화 삭제'),
            content: const Text('이 대화를 삭제하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: ChatColors.deleteRed,
                ),
                child: const Text('삭제'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: ChatSpacing.md),
        color: ChatColors.deleteRed,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ChatSpacing.md,
            vertical: ChatSpacing.sm,
          ),
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
              // Chat icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ChatColors.userMessageBg.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: ChatColors.userMessageBg,
                  size: 20,
                ),
              ),
              const SizedBox(width: ChatSpacing.sm),

              // Chat info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatSummary.title,
                      style: AppTextStyle.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      chatSummary.preview,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: Colors.black54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: ChatSpacing.xs),

              // Timestamp
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatTimestamp(chatSummary.lastMessageTime),
                    style: AppTextStyle.bodySmall.copyWith(
                      color: Colors.black45,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    iconSize: 18,
                    color: ChatColors.deleteRed,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('대화 삭제'),
                          content: const Text('이 대화를 삭제하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: TextButton.styleFrom(
                                foregroundColor: ChatColors.deleteRed,
                              ),
                              child: const Text('삭제'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        onDelete();
                      }
                    },
                    tooltip: '삭제',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return DateFormat('MM/dd').format(timestamp);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금';
    }
  }
}
