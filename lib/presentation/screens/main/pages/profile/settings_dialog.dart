import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/routes/router_path.dart';
import 'package:frontend/presentation/screens/entry/state/auth_controller.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/animations/page_transitions.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/utils/toast_helper.dart';
import 'state/settings_controller.dart';

class SettingsAppBar extends StatelessWidget {
  final VoidCallback onClose;

  const SettingsAppBar({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.close), onPressed: onClose),
            const Spacer(),
            Text(
              '설정',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}

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
                style: const TextStyle(
                  fontSize: 16,
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
        ? AppColors.error.withOpacity(0.06)
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

// ============================================================================
// Main Settings Dialog Function & Page
// ============================================================================

void showSettingsDialog(BuildContext context) {
  Navigator.of(
    context,
  ).push(PageTransitions.slideUpRoute(const SettingsPage()));
}

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // 페이지가 로드되면 애니메이션 시작
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 로그아웃 확인 다이얼로그
  void _showLogoutConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: const Icon(
            Icons.logout_rounded,
            color: AppColors.error,
            size: 48,
          ),
          title: const Text(
            '로그아웃',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          content: const Text(
            '정말로 로그아웃 하시겠습니까?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '취소',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // 확인 다이얼로그 닫기

                try {
                  await ref.read(authProvider.notifier).logout();

                  if (context.mounted) {
                    // 설정 화면 닫기
                    Navigator.of(context).pop();

                    // 로그인 화면으로 이동 (스택 클리어)
                    context.go(RoutePath.login);

                    // 성공 메시지
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
              child: const Text('로그아웃', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  // 계정 삭제 확인 다이얼로그
  void _showDeleteAccountConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: const Icon(
            Icons.warning_rounded,
            color: AppColors.error,
            size: 48,
          ),
          title: const Text(
            '계정 삭제',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: AppColors.error,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '계정을 삭제하면 다음 내용이 영구적으로 삭제됩니다:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                '• 모든 개인 정보\n• 저장된 데이터\n• 앱 사용 기록',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              SizedBox(height: 16),
              Text(
                '이 작업은 되돌릴 수 없습니다.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '취소',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // 확인 다이얼로그 닫기

                try {
                  await ref.read(authProvider.notifier).deleteAccount();

                  if (context.mounted) {
                    // 설정 화면 닫기
                    Navigator.of(context).pop();

                    // 로그인 화면으로 이동 (스택 클리어)
                    context.go(RoutePath.login);

                    // 성공 메시지
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
              child: const Text('삭제', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);

    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              SettingsAppBar(
                onClose: () async {
                  await _animationController.reverse();
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
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
                            onTap: _showLogoutConfirmDialog,
                            isDanger: true,
                          ),
                          const SizedBox(height: 12),
                          SettingsActionTile(
                            title: '계정 탈퇴',
                            subtitle: '계정을 영구 삭제',
                            icon: Icons.delete_forever_rounded,
                            iconColor: AppColors.error,
                            onTap: _showDeleteAccountConfirmDialog,
                            isDanger: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
