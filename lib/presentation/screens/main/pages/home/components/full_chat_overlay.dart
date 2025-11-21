import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_color.dart';
import 'package:frontend/core/theme/app_text_style.dart';
import '../state/chat_controller.dart';
import '../state/chat_state.dart';
import 'ai_message_row.dart';
import 'user_message_row.dart';
import 'inline_chat_widget.dart';
import 'typing_indicator.dart';
import 'quick_action_chips.dart';

/// 전체 화면 채팅 오버레이
class FullChatOverlay extends ConsumerStatefulWidget {
  const FullChatOverlay({super.key});

  @override
  ConsumerState<FullChatOverlay> createState() => _FullChatOverlayState();
}

class _FullChatOverlayState extends ConsumerState<FullChatOverlay> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleClose() {
    ref.read(chatProvider.notifier).toggleFullChat();
  }

  // 새 메시지가 추가되면 스크롤을 최하단으로 이동
  void _scrollToBottom() {
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

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);

    // 메시지가 변경되면 스크롤
    ref.listen(chatProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length) {
        _scrollToBottom();
      }
    });

    return Material(
      color: AppColors.background.withValues(alpha: 0.45),
      child: SafeArea(
        child: Column(
          children: [
            // 상단 헤더 (닫기 버튼)
            _buildHeader(),

            // 채팅 메시지 영역
            Expanded(child: _buildChatArea(chatState)),

            // 빠른 액션 칩 (메시지가 없을 때만 표시)
            if (chatState.messages.isEmpty && !chatState.isLoading)
              Padding(
                padding: const EdgeInsets.fromLTRB(17, 0, 17, 12),
                child: QuickActionChips(
                  onActionTap: (prompt) {
                    ref.read(chatProvider.notifier).sendMessage(prompt);
                  },
                ),
              ),

            // 입력창 (좌우 17px 여백)
            Padding(
              padding: const EdgeInsets.fromLTRB(17, 0, 17, 17),
              child: InlineChatWidget(),
            ),
          ],
        ),
      ),
    );
  }

  /// 상단 헤더 (닫기 버튼)
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '제로로와 대화하기',
            style: AppTextStyle.titleMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: _handleClose,
            icon: Icon(Icons.close, color: AppColors.textPrimary, size: 24),
            tooltip: '닫기',
          ),
        ],
      ),
    );
  }

  /// 채팅 메시지 영역
  Widget _buildChatArea(ChatState chatState) {
    // 메시지가 없고 로딩 중도 아니면 빈 상태 표시
    if (chatState.messages.isEmpty && !chatState.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.black),
            const SizedBox(height: 17),
            Text(
              '제로로에게 궁금한 것을 물어보세요!',
              style: AppTextStyle.bodyMedium.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    // 메시지 리스트
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(17),
      itemCount: chatState.messages.length + (chatState.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        // 로딩 인디케이터를 마지막에 표시
        if (index == chatState.messages.length) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제로로 아바타
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Image.asset('assets/images/smile_zeroro.png'),
              ),
              const SizedBox(width: 10),
              // 타이핑 인디케이터
              const TypingIndicator(),
            ],
          );
        }

        // 메시지 표시
        final message = chatState.messages[index];
        if (message.isAI) {
          return AiMessageRow(message: message);
        } else {
          return UserMessageRow(message: message);
        }
      },
    );
  }
}
