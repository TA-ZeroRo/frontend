import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../domain/model/recruiting/chat_message.dart';
import '../state/recruiting_chat_state.dart';

class RecruitingMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final MessageStatus status;
  final VoidCallback? onRetry;

  const RecruitingMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.status = MessageStatus.sent,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            _buildAvatar(),
            const SizedBox(width: 8),
          ],
          // 내 메시지일 때 상태 인디케이터를 왼쪽에 표시
          if (isMe) _buildStatusIndicator(),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe) _buildUsername(),
                _buildMessageBubble(),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  /// 전송 상태 인디케이터
  Widget _buildStatusIndicator() {
    if (!isMe) return const SizedBox.shrink();

    switch (status) {
      case MessageStatus.sending:
        return Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 4),
          child: SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textTertiary),
            ),
          ),
        );
      case MessageStatus.sent:
        return Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 4),
          child: Icon(
            Icons.check,
            size: 14,
            color: AppColors.textTertiary,
          ),
        );
      case MessageStatus.failed:
        return GestureDetector(
          onTap: onRetry,
          child: Padding(
            padding: const EdgeInsets.only(right: 4, bottom: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 16,
                  color: Colors.red,
                ),
                const SizedBox(width: 2),
                Text(
                  '재전송',
                  style: AppTextStyle.bodySmall.copyWith(
                    color: Colors.red,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  /// 프로필 이미지
  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 18,
      backgroundImage: message.userImageUrl != null
          ? NetworkImage(message.userImageUrl!)
          : null,
      backgroundColor: AppColors.primary.withValues(alpha: 0.2),
      child: message.userImageUrl == null
          ? Text(
              message.username[0],
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }

  /// 사용자 이름
  Widget _buildUsername() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Text(
        message.username,
        style: AppTextStyle.bodySmall.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 메시지 말풍선
  Widget _buildMessageBubble() {
    return Opacity(
      opacity: status == MessageStatus.sending ? 0.7 : 1.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMe ? 12 : 4),
            topRight: Radius.circular(isMe ? 4 : 12),
            bottomLeft: const Radius.circular(12),
            bottomRight: const Radius.circular(12),
          ),
          boxShadow: isMe
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.message,
              style: AppTextStyle.bodyMedium.copyWith(
                color: isMe ? Colors.white : AppColors.textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: AppTextStyle.bodySmall.copyWith(
                color: isMe
                    ? Colors.white.withValues(alpha: 0.8)
                    : AppColors.textTertiary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
