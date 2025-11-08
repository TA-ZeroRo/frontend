import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_color.dart';
import 'package:frontend/core/theme/app_text_style.dart';

/// 사용자 메시지를 표시하는 말풍선 위젯 (오른쪽 정렬)
class UserMessageBubble extends StatelessWidget {
  final String text;

  const UserMessageBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: AppTextStyle.bodyMedium.copyWith(
            color: Colors.white,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
