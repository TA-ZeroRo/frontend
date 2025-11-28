import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/utils/toast_helper.dart';
import '../../routes/router_path.dart';
import '../entry/state/auth_controller.dart';
import 'state/settings_controller.dart';
import '../../../core/utils/character_notification_helper.dart';

/// 설정 화면 섹션 컴포넌트
class SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border.all(color: AppColors.cardShadow),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyle.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

/// 토글 스위치가 있는 설정 항목
class SettingsToggleTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: Switch(value: value, onChanged: onChanged),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

/// 클릭 가능한 설정 항목
class SettingsActionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isDanger;

  const SettingsActionTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDanger
        ? AppColors.error.withValues(alpha: 0.06)
        : AppColors.background;
    final titleStyle = TextStyle(
      fontWeight: FontWeight.w500,
      color: isDanger ? AppColors.error : AppColors.textPrimary,
    );

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: titleStyle),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: const Icon(Icons.chevron_right),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
      ),
    );
  }
}

/// 설정 화면
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  /// 로그아웃 확인 다이얼로그
  void _showLogoutConfirmDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // 다이얼로그가 빌드된 후 캐릭터 알림 표시
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (dialogContext.mounted) {
            CharacterNotificationHelper.show(
              dialogContext,
              message: '정말 로그아웃 하실거에요..?',
              characterImage: 'assets/images/earth_zeroro_sad.png',
              bubbleColor: Colors.white,
              duration: const Duration(minutes: 5), // 다이얼로그가 닫힐 때까지 유지
              alignment: const Alignment(0, -0.43),
            );
          }
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: const Icon(
            Icons.logout_rounded,
            color: AppColors.error,
            size: 48,
          ),
          title: Text(
            '로그아웃',
            style: AppTextStyle.titleLarge.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Text('정말로 로그아웃 하시겠습니까?', style: AppTextStyle.bodyLarge),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                '취소',
                style: AppTextStyle.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                try {
                  await ref.read(authProvider.notifier).logout();

                  if (context.mounted) {
                    context.go(RoutePath.login);
                    ToastHelper.showSuccess('로그아웃되었습니다.');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ToastHelper.showError('로그아웃 실패: ${e.toString()}');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('로그아웃', style: AppTextStyle.bodyLarge),
            ),
          ],
        );
      },
    ).then((_) {
      // 다이얼로그가 닫히면 캐릭터 알림도 숨김
      CharacterNotificationHelper.hide();
    });
  }

  /// 계정 삭제 확인 다이얼로그
  void _showDeleteAccountConfirmDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // 다이얼로그가 빌드된 후 캐릭터 알림 표시
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (dialogContext.mounted) {
            CharacterNotificationHelper.show(
              dialogContext,
              message: '떠나지마요 ㅠㅠ',
              characterImage: 'assets/images/earth_zeroro_sad.png',
              bubbleColor: Colors.white,
              duration: const Duration(minutes: 5),
              alignment: const Alignment(0, -0.6), // 모달이 커서 더 위로 배치
            );
          }
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: const Icon(
            Icons.warning_rounded,
            color: AppColors.error,
            size: 48,
          ),
          title: Text(
            '계정 삭제',
            style: AppTextStyle.titleLarge.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.error,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '계정을 삭제하면 다음 내용이 영구적으로 삭제됩니다:',
                style: AppTextStyle.bodyLarge,
              ),
              const SizedBox(height: 12),
              Text(
                '• 모든 개인 정보\n• 저장된 데이터\n• 앱 사용 기록',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '이 작업은 되돌릴 수 없습니다.',
                style: AppTextStyle.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                '취소',
                style: AppTextStyle.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                try {
                  await ref.read(authProvider.notifier).deleteAccount();

                  if (context.mounted) {
                    context.go(RoutePath.login);
                    ToastHelper.showInfo('계정이 삭제되었습니다.');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ToastHelper.showError('계정 삭제 실패: ${e.toString()}');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('삭제', style: AppTextStyle.bodyLarge),
            ),
          ],
        );
      },
    ).then((_) {
      // 다이얼로그가 닫히면 캐릭터 알림도 숨김
      CharacterNotificationHelper.hide();
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_rounded),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '설정',
          style: AppTextStyle.headlineSmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 앱 설정 섹션
            SettingsSection(
              title: '앱 설정',
              icon: Icons.settings_rounded,
              iconColor: AppColors.primary,
              children: [
                SettingsToggleTile(
                  title: '알림',
                  subtitle: '푸시 알림 받기',
                  icon: Icons.notifications_active_rounded,
                  iconColor: AppColors.primary,
                  value: settings.notificationsEnabled,
                  onChanged: (_) => ref
                      .read(appSettingsProvider.notifier)
                      .toggleNotifications(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 계정 섹션
            SettingsSection(
              title: '계정',
              icon: Icons.person_rounded,
              iconColor: AppColors.primary,
              children: [
                SettingsActionTile(
                  title: '개인정보 보호',
                  subtitle: '개인정보 처리방침',
                  icon: Icons.privacy_tip_rounded,
                  iconColor: AppColors.error,
                  onTap: () {
                    ToastHelper.showInfo(
                      '개인정보 처리방침 페이지를 준비 중입니다. 잠시만 기다려 주세요!',
                    );
                  },
                ),
                const SizedBox(height: 12),
                SettingsActionTile(
                  title: '로그아웃',
                  subtitle: '로그아웃 하기',
                  icon: Icons.logout_rounded,
                  iconColor: AppColors.error,
                  onTap: () => _showLogoutConfirmDialog(context, ref),
                  isDanger: true,
                ),
                const SizedBox(height: 12),
                SettingsActionTile(
                  title: '계정 탈퇴',
                  subtitle: '계정을 영구 삭제',
                  icon: Icons.delete_forever_rounded,
                  iconColor: AppColors.error,
                  onTap: () => _showDeleteAccountConfirmDialog(context, ref),
                  isDanger: true,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 정보 섹션
            SettingsSection(
              title: '정보',
              icon: Icons.info_rounded,
              iconColor: AppColors.secondaryAccent,
              children: [
                SettingsActionTile(
                  title: '버전 정보',
                  subtitle: 'ZeroRo v1.0.0-beta',
                  icon: Icons.info_outline_rounded,
                  iconColor: AppColors.textSecondary,
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'ZeroRo',
                      applicationVersion: 'v1.0.0-beta',
                      applicationIcon: const Icon(
                        Icons.eco,
                        size: 48,
                        color: AppColors.primary,
                      ),
                      children: const [
                        Text(
                          '제로로는 지속가능한 라이프스타일을 위한 앱입니다.\n\n개발자: ZeroRo Team\n출시일: 2025년',
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                SettingsActionTile(
                  title: '피드백 보내기',
                  subtitle: '의견을 들려주세요',
                  icon: Icons.feedback_rounded,
                  iconColor: AppColors.primary,
                  onTap: () {
                    ToastHelper.showInfo(
                      '홈 화면 - 사진 인증 - 카테고리 - 건의하기에서 피드백 기능을 사용할 수 있어요!',
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
