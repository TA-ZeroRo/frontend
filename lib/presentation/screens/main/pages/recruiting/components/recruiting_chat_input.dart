import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_color.dart';

class RecruitingChatInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final bool isEnabled;

  const RecruitingChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: isEnabled,
                decoration: InputDecoration(
                  hintText: isEnabled ? '메시지를 입력하세요' : '전송 중...',
                  hintStyle: TextStyle(color: AppColors.textTertiary),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: isEnabled
                    ? (value) {
                        if (value.trim().isNotEmpty) {
                          onSend(value);
                        }
                      }
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: isEnabled
                  ? () {
                      final message = controller.text;
                      if (message.trim().isNotEmpty) {
                        onSend(message);
                      }
                    }
                  : null,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: isEnabled
                    ? const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      )
                    : const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
