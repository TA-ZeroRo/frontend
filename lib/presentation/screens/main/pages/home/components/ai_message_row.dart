import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:frontend/core/theme/app_color.dart';
import '../state/chat_state.dart';

/// AI 메시지를 아바타와 함께 표시하는 행 위젯
class AiMessageRow extends StatelessWidget {
  final SimpleMessage message;

  const AiMessageRow({super.key, required this.message});

<<<<<<< Updated upstream
=======
  // MarkdownStyleSheet를 상수로 캐싱하여 재사용
  static final _markdownStyleSheet = MarkdownStyleSheet(
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
  );

  // 아바타 이미지를 상수로 캐싱
  static const _zeroroAvatar = CircleAvatar(
    radius: 20,
    backgroundColor: Colors.white,
    backgroundImage: AssetImage('assets/images/cloud_zeroro.png'),
  );

>>>>>>> Stashed changes
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Image.asset('assets/images/smile_zeroro.png'),
          ),
          const SizedBox(width: 10),

          // 메시지 버블
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: MarkdownBody(data: message.text, selectable: true),
            ),
          ),
        ],
      ),
    );
  }
}
