import 'package:flutter/material.dart';

class FadeMessageBox extends StatelessWidget {
  // 표시할 메시지 텍스트
  final String message;
  // 배경 색상
  final Color backgroundColor;
  // 텍스트 스타일
  final TextStyle textStyle;
  // 페이드 인/아웃 애니메이션 (투명도)
  final Animation<double> animation;
  // 내부 여백 (패딩), 기본값 지정
  final EdgeInsetsGeometry padding;
  // 모서리 둥글기, 기본값 지정
  final BorderRadiusGeometry borderRadius;

  const FadeMessageBox({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.textStyle,
    required this.animation,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation, // 전달받은 애니메이션으로 투명도 조절
      child: Container(
        padding: padding, // 내부 여백 적용
        decoration: BoxDecoration(
          color: backgroundColor, // 배경색 적용
          borderRadius: borderRadius, // 둥근 모서리 적용
        ),
        child: Text(
          message, // 메시지 텍스트 출력
          style: textStyle, // 텍스트 스타일 적용
          textAlign: TextAlign.center, // 중앙 정렬
        ),
      ),
    );
  }
}
