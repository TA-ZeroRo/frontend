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

    // 슬라이드 애니메이션
    final beginOffset = widget.notification.alignment != null
        ? const Offset(0, 0.2) // 중앙 배치 시 아래에서 살짝 위로
        : const Offset(1.5, 0); // 기본: 우측에서 좌측으로

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
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
    final content = SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Material(
          color: Colors.transparent,
          child: _buildNotificationContent(),
        ),
      ),
    );

    if (widget.notification.alignment != null) {
      return Positioned.fill(
        child: Align(
          alignment: widget.notification.alignment!,
          child: content,
        ),
      );
    }

    return Positioned(
      top: 60, // 상단 여백
      right: 16, // 우측 여백
      child: content,
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
        const SizedBox(width: 10),
        // 캐릭터 아바타
        _buildCharacterAvatar(),
      ],
    );
  }

  /// 말풍선 위젯
  Widget _buildMessageBubble() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 240, // 최대 너비 제한 증가
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), // 패딩 증가
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
            color: Colors.black.withValues(alpha: 0.15), // 그림자 진하게
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        widget.notification.message,
        style: TextStyle(
          color: widget.notification.textColor,
          fontSize: 16, // 폰트 크기 증가
          fontWeight: FontWeight.w600, // 폰트 굵기 증가
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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Transform.scale(
          scale: 1.3,
          child: Image.asset(
            widget.notification.characterImage,
            fit: BoxFit.cover,
            width: widget.notification.characterSize,
            height: widget.notification.characterSize,
          ),
        ),
      ),
    );
  }
}
