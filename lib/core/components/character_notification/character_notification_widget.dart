import 'dart:async';
import 'package:flutter/material.dart';
import 'character_notification_controller.dart';

/// 캐릭터 알림 UI 위젯
class CharacterNotificationWidget extends StatefulWidget {
  final CharacterNotification notification;
  final VoidCallback onDismiss;

  const CharacterNotificationWidget({
    super.key,
    required this.notification,
    required this.onDismiss,
  });

  @override
  State<CharacterNotificationWidget> createState() =>
      _CharacterNotificationWidgetState();
}

class _CharacterNotificationWidgetState
    extends State<CharacterNotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // 슬라이드 애니메이션 (우측에서 진입)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0), // 우측 밖에서 시작
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack, // 바운스 효과
    ));

    // 페이드 애니메이션
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // 애니메이션 시작
    _controller.forward();

    // 자동 사라지기 타이머
    _dismissTimer = Timer(widget.notification.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// 알림 사라지기 애니메이션
  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60, // 상단 여백
      right: 16, // 우측 여백
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: _buildNotificationContent(),
          ),
        ),
      ),
    );
  }

  /// 알림 콘텐츠 빌드
  Widget _buildNotificationContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 말풍선
        _buildMessageBubble(),
        const SizedBox(width: 8),
        // 캐릭터 아바타
        _buildCharacterAvatar(),
      ],
    );
  }

  /// 말풍선 위젯
  Widget _buildMessageBubble() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 200, // 최대 너비 제한
      ),
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
      decoration: BoxDecoration(
        color: widget.notification.bubbleColor,
        borderRadius: BorderRadius.circular(widget.notification.borderRadius),
        border: widget.notification.bubbleBorderColor != null
            ? Border.all(
                color: widget.notification.bubbleBorderColor!,
                width: 1.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        widget.notification.message,
        style: TextStyle(
          color: widget.notification.textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 캐릭터 아바타 위젯
  Widget _buildCharacterAvatar() {
    return Container(
      width: widget.notification.characterSize,
      height: widget.notification.characterSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: widget.notification.characterSize / 2,
        backgroundImage: AssetImage(widget.notification.characterImage),
        backgroundColor: Colors.white,
      ),
    );
  }
}
