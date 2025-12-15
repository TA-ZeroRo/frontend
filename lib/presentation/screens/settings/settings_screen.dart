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
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        // 다이얼로그가 빌드된 후 캐릭터 알림 표시
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (dialogContext.mounted) {
            CharacterNotificationHelper.show(
              dialogContext,
              message: '정말 로그아웃 하실거에요..?',
              characterImage: 'assets/images/earth_zeroro_sad.png',
              bubbleColor: Colors.white,
              duration: const Duration(minutes: 5),
              alignment: const Alignment(0, -0.42),
            );
          }
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 아이콘
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                // 제목
                Text(
                  '로그아웃',
                  style: AppTextStyle.titleLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                // 설명
                Text(
                  '정말로 로그아웃 하시겠습니까?',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // 버튼 영역
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.textSubtle.withValues(alpha: 0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            '취소',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
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
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            '로그아웃',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      CharacterNotificationHelper.hide();
    });
  }

  /// 계정 삭제 확인 다이얼로그
  void _showDeleteAccountConfirmDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: true,
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
              alignment: const Alignment(0, -0.55),
            );
          }
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 경고 아이콘
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_rounded,
                    color: AppColors.error,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                // 제목
                Text(
                  '정말 탈퇴하시겠어요?',
                  style: AppTextStyle.titleLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                // 경고 박스
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '삭제되는 정보',
                        style: AppTextStyle.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDeleteInfoRow(Icons.person_outline, '모든 개인 정보'),
                      const SizedBox(height: 4),
                      _buildDeleteInfoRow(Icons.folder_outlined, '저장된 데이터'),
                      const SizedBox(height: 4),
                      _buildDeleteInfoRow(Icons.history, '앱 사용 기록'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // 경고 메시지
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '이 작업은 되돌릴 수 없어요',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // 버튼 영역
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.textSubtle.withValues(alpha: 0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            '취소',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
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
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            '탈퇴하기',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      CharacterNotificationHelper.hide();
    });
  }

  /// 삭제 정보 행 위젯
  Widget _buildDeleteInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyle.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// 버전 정보 다이얼로그
  void _showVersionInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 앱 로고
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.eco,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // 앱 이름
                Text(
                  'ZeroRo',
                  style: AppTextStyle.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                // 버전
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'v1.0.0-beta',
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 앱 설명
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '지속가능한 라이프스타일을 위한 앱',
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoItem(Icons.people_outline, '개발', 'ZeroRo Team'),
                      const SizedBox(height: 8),
                      _buildInfoItem(Icons.calendar_today_outlined, '출시', '2025년'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 버튼 영역
                Row(
                  children: [
                    // 자세한 정보 버튼
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            showLicensePage(
                              context: context,
                              applicationName: 'ZeroRo',
                              applicationVersion: 'v1.0.0-beta',
                              applicationIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.eco,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.textSubtle.withValues(alpha: 0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            '자세히',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 확인 버튼
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            '확인',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 정보 아이템 위젯
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyle.bodySmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: AppTextStyle.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
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
                  onTap: () => _showVersionInfoDialog(context),
                ),
                const SizedBox(height: 12),
                SettingsActionTile(
                  title: '피드백 보내기',
                  subtitle: '의견을 들려주세요',
                  icon: Icons.feedback_rounded,
                  iconColor: AppColors.primary,
                  onTap: () {
                    ToastHelper.showInfo(
                      '피드백 페이지를 준비 중입니다. 잠시만 기다려 주세요!',
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
