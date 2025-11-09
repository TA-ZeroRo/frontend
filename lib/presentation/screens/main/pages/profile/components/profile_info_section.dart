import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../state/user_controller.dart';
import 'profile_avatar.dart';
import 'profile_action_buttons.dart';

class ProfileInfoSection extends ConsumerWidget {
  final VoidCallback onEditProfile;

  const ProfileInfoSection({super.key, required this.onEditProfile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final numberFormat = NumberFormat('#,###');

    return Column(
      children: [
        // 상단: 좌측 정보 + 우측 프로필 이미지
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            children: [
              // 좌측 정보 컬럼
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // 사용자 이름
                    Text(
                      user.username,
                      style: AppTextStyle.headlineSmall.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // 주소지
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppColors.onPrimary.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user.region,
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColors.onPrimary.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 총 포인트
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.onPrimary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.onPrimary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.stars_rounded,
                            size: 20,
                            color: AppColors.onPrimary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${numberFormat.format(user.totalPoints)} 포인트',
                            style: AppTextStyle.titleMedium.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // 우측 프로필 이미지
              ProfileAvatar(imageUrl: user.userImg, size: 80),
            ],
          ),
        ),
        const SizedBox(height: 40),
        // 하단: 액션 버튼들
        ProfileActionButtons(onEditProfile: onEditProfile),
      ],
    );
  }
}
