import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../entry/state/auth_controller.dart';
import 'profile_avatar.dart';
import 'profile_action_buttons.dart';

class ProfileInfoSection extends ConsumerWidget {
  final VoidCallback onEditProfile;

  const ProfileInfoSection({super.key, required this.onEditProfile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).currentUser;

    // 사용자 정보가 없으면 로딩 표시
    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final numberFormat = NumberFormat('#,###');
    final Color primaryColor = AppColors.primary;
    final Color nameTextColor = AppColors.textPrimary;
    final Color secondaryTextColor = AppColors.textSecondary;
    final Color cardFillColor = AppColors.background;
    const Color avatarBackdrop = Color(0xFFD8DDD7);
    const double avatarSize = 96;

    return Column(
      children: [
        // 상단: 좌측 정보 + 우측 프로필 이미지
        DecoratedBox(
          decoration: BoxDecoration(
            color: cardFillColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 32,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 좌측 정보 컬럼
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 사용자 이름
                      Text(
                        user.username,
                        style: AppTextStyle.headlineSmall.copyWith(
                          color: nameTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // 주소지
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: primaryColor.withValues(alpha: 0.85),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            user.region,
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // 총 포인트
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.24),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.stars_rounded,
                              size: 20,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${numberFormat.format(user.totalPoints)} 포인트',
                              style: AppTextStyle.titleMedium.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 28),
                // 우측 프로필 이미지
                ProfileAvatar(
                  imageUrl: user.userImg,
                  size: avatarSize,
                  backgroundColor: avatarBackdrop,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        // 하단: 액션 버튼들
        ProfileActionButtons(onEditProfile: onEditProfile),
      ],
    );
  }
}
