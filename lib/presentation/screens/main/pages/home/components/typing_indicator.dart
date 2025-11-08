import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_color.dart';

/// AI 응답 생성 중 표시되는 타이핑 인디케이터
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (index) => AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // 각 점이 순차적으로 애니메이션
                final delay = index * 0.3;
                final value = (_controller.value - delay) % 1.0;
                final opacity = (value < 0.5)
                    ? Curves.easeInOut.transform(value * 2)
                    : Curves.easeInOut.transform(2 - value * 2);

                return Container(
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 5,
                  ),
                  child: Opacity(
                    opacity: 0.3 + (opacity * 0.7), // 0.3 ~ 1.0
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
