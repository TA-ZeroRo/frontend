import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/chat_controller.dart';
import 'message_bubble.dart';
import 'typing_indicator.dart';

/// InlineChatWidget 위에 표시되는 간단한 채팅 영역
/// 최신 AI 응답 1개만 표시 (5초 후 자동으로 사라짐)
class SimpleChatArea extends ConsumerStatefulWidget {
  const SimpleChatArea({super.key});

  @override
  ConsumerState<SimpleChatArea> createState() => _SimpleChatAreaState();
}

class _SimpleChatAreaState extends ConsumerState<SimpleChatArea> {
  Timer? _hideTimer;
  bool _isVisible = false;

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);

    // 최신 AI 메시지 찾기
    final latestAIMessage = chatState.messages.isEmpty
        ? null
        : chatState.messages.reversed.firstWhere(
            (msg) => msg.isAI,
            orElse: () => chatState.messages.last,
          );

    // 메시지나 로딩 상태가 없으면 아무것도 표시하지 않음
    final hasContent = latestAIMessage != null || chatState.isLoading;

    // 새로운 메시지가 왔을 때 표시하고 타이머 시작
    if (hasContent && !chatState.isLoading && !_isVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isVisible = true;
          });
          _startHideTimer();
        }
      });
    }

    // 로딩 중일 때는 항상 표시
    if (chatState.isLoading) {
      _hideTimer?.cancel();
      if (!_isVisible) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _isVisible = true;
            });
          }
        });
      }
    }

    if (!hasContent || !_isVisible) {
      return const SizedBox.shrink();
    }

    return AnimatedSlide(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      offset: Offset.zero,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // AI 메시지 또는 타이핑 인디케이터
            chatState.isLoading
                ? const TypingIndicator()
                : MessageBubble(message: latestAIMessage!),
            // InlineChatWidget과의 간격
            const SizedBox(height: 17),
          ],
        ),
      ),
    );
  }
}
