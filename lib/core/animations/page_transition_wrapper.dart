import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

/// 페이지 전환 애니메이션을 담당하는 래퍼 위젯
///
/// Clean Architecture의 Core Layer에 위치하여
/// 애플리케이션 전체에서 재사용 가능한 애니메이션 컴포넌트
class PageTransitionWrapper extends StatelessWidget {
  final Widget child;
  final PageTransitionDirection? direction;

  const PageTransitionWrapper({super.key, required this.child, this.direction});

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: PageTransitionConstants.duration,
      transitionBuilder: (child, animation, secondaryAnimation) {
        // 방향이 지정된 경우 커스텀 슬라이드 애니메이션 사용
        if (direction != null) {
          return _buildDirectionalTransition(
            child,
            animation,
            secondaryAnimation,
          );
        }

        // 기본 SharedAxisTransition 사용
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: PageTransitionConstants.transitionType,
          child: child,
        );
      },
      child: Container(key: ValueKey(_generatePageKey(child)), child: child),
    );
  }

  /// 방향성 있는 슬라이드 애니메이션 빌드
  Widget _buildDirectionalTransition(
    Widget child,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final slideOffset = direction == PageTransitionDirection.leftToRight
        ? const Offset(-1.0, 0.0) // 왼쪽에서 오른쪽으로
        : const Offset(1.0, 0.0); // 오른쪽에서 왼쪽으로

    return SlideTransition(
      position: Tween<Offset>(begin: slideOffset, end: Offset.zero).animate(
        CurvedAnimation(
          parent: animation,
          curve: PageTransitionConstants.curve,
        ),
      ),
      child: child, // 페이드 효과 제거하여 잔상 효과 최소화
    );
  }

  /// 페이지별 고유 키 생성
  ///
  /// 각 페이지의 타입을 기반으로 고유한 키를 생성하여
  /// PageTransitionSwitcher가 페이지 변경을 감지할 수 있도록 함
  String _generatePageKey(Widget child) {
    return child.runtimeType.toString();
  }
}

/// 페이지 전환 방향 열거형
enum PageTransitionDirection {
  /// 왼쪽에서 오른쪽으로 슬라이드 (이전 페이지로 이동)
  leftToRight,

  /// 오른쪽에서 왼쪽으로 슬라이드 (다음 페이지로 이동)
  rightToLeft,
}

/// 페이지 전환 애니메이션 관련 상수
///
/// 애니메이션 설정을 중앙화하여 일관성 유지 및
/// 필요시 쉽게 수정 가능하도록 함
class PageTransitionConstants {
  /// 페이지 전환 애니메이션 지속시간
  static const Duration duration = Duration(milliseconds: 400);

  /// 페이지 전환 애니메이션 타입
  static const SharedAxisTransitionType transitionType =
      SharedAxisTransitionType.horizontal;

  /// 커스텀 슬라이드 애니메이션 커브
  static const Curve curve = Curves.easeOutCubic;
}
