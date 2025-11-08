import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_color.dart';

/// 프로필 페이지에서 사용하는 공통 카드 컴포넌트
///
/// 일관된 스타일의 카드를 제공하여 코드 중복을 방지합니다.
class ProfileCard extends StatelessWidget {
  final Widget child;

  const ProfileCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.textTertiary.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
