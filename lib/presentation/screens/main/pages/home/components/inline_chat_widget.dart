import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_color.dart';
import 'package:frontend/core/theme/app_text_style.dart';
import '../state/chat_controller.dart';

/// 홈페이지 하단에 표시되는 인라인 채팅 입력 위젯
/// 글래스모피즘 스타일의 타원형 디자인
class InlineChatWidget extends ConsumerStatefulWidget {
  const InlineChatWidget({super.key});

  @override
  ConsumerState<InlineChatWidget> createState() => _InlineChatWidgetState();
}

class _InlineChatWidgetState extends ConsumerState<InlineChatWidget> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    // 메시지 전송
    ref.read(chatProvider.notifier).sendMessage(text);

    // 입력 필드 초기화 (포커스는 유지하여 연속 대화 가능)
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final canSend =
        _textController.text.trim().isNotEmpty && !chatState.isLoading;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Row(
            children: [
              // Full Chat Enable
              _buildExpandButton(),

              // 입력 필드
              Expanded(child: _buildTextField()),

              // 전송 버튼
              _buildSendButton(canSend),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: IconButton(
        onPressed: () {
          ref.read(chatProvider.notifier).toggleFullChat();
        },
        icon: Icon(Icons.expand_less, color: AppColors.primary, size: 24),
        tooltip: '전체 화면으로 확장',
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _textController,
      focusNode: _focusNode,
      style: AppTextStyle.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: '제로로에게 메시지 보내기...',
        hintStyle: AppTextStyle.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 17,
        ),
      ),
      maxLines: 1,
      textInputAction: TextInputAction.send,
      onChanged: (_) {
        // TextField 변경 시 UI 업데이트를 위한 setState
        setState(() {});
      },
      onSubmitted: (_) => _handleSend(),
    );
  }

  Widget _buildSendButton(bool canSend) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: IconButton(
        onPressed: canSend ? _handleSend : null,
        icon: Icon(
          Icons.send,
          color: canSend
              ? AppColors.primary
              : AppColors.textSecondary.withValues(alpha: 0.3),
          size: 24,
        ),
        tooltip: '전송',
      ),
    );
  }
}
