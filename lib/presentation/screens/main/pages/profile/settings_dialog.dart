import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/animations/page_transitions.dart';
import 'state/settings_controller.dart';

// ============================================================================
// UI Components - Settings Components (Design Guide 준수)
// ============================================================================

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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        color: Colors.white,
        border: Border.all(color: Colors.black12),
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
                  fontWeight: FontWeight.w700,
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
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
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
    final bgColor = isDanger ? Colors.red.withOpacity(0.06) : Colors.grey[50];
    final titleStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: isDanger ? Colors.red : Colors.black,
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
          icon: const Icon(Icons.logout_rounded, color: Colors.red, size: 48),
          title: const Text(
            '로그아웃',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
              child: const Text(
                '취소',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('로그아웃되었습니다. (데모)'),
                    backgroundColor: Color.fromARGB(255, 116, 205, 124),
                  ),
                );
                Navigator.of(context).maybePop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
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
          icon: const Icon(Icons.warning_rounded, color: Colors.red, size: 48),
          title: const Text(
            '계정 삭제',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.red,
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
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                '이 작업은 되돌릴 수 없습니다.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '취소',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('계정이 삭제되었습니다. (데모)'),
                    backgroundColor: Color.fromRGBO(255, 86, 69, 1),
                  ),
                );
                Navigator.of(context).maybePop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey[50]!, Colors.grey[100]!],
          ),
        ),
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
                        iconColor: Colors.blue,
                        children: [
                          SettingsToggleTile(
                            title: '다크모드',
                            subtitle: '어두운 테마로 변경',
                            icon: settings.isDarkMode
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            iconColor: settings.isDarkMode
                                ? Colors.indigo
                                : Colors.orange,
                            value: settings.isDarkMode,
                            onChanged: (_) => ref
                                .read(appSettingsProvider.notifier)
                                .toggleDarkMode(),
                          ),
                          const SizedBox(height: 12),
                          SettingsToggleTile(
                            title: '알림',
                            subtitle: '푸시 알림 받기',
                            icon: Icons.notifications_active_rounded,
                            iconColor: Colors.teal,
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
                        iconColor: Colors.teal,
                        children: [
                          SettingsActionTile(
                            title: '개인정보 보호',
                            subtitle: '개인정보 처리방침',
                            icon: Icons.privacy_tip_rounded,
                            iconColor: Colors.red,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    '개인정보 처리방침 페이지를 준비 중입니다. 잠시만 기다려 주세요!',
                                  ),
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    116,
                                    205,
                                    124,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          SettingsActionTile(
                            title: '로그아웃',
                            subtitle: '로그아웃 하기',
                            icon: Icons.logout_rounded,
                            iconColor: Colors.red,
                            onTap: _showLogoutConfirmDialog,
                            isDanger: true,
                          ),
                          const SizedBox(height: 12),
                          SettingsActionTile(
                            title: '계정 탈퇴',
                            subtitle: '계정을 영구 삭제',
                            icon: Icons.delete_forever_rounded,
                            iconColor: Colors.red,
                            onTap: _showDeleteAccountConfirmDialog,
                            isDanger: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SettingsSection(
                        title: '정보',
                        icon: Icons.info_rounded,
                        iconColor: Colors.indigo,
                        children: [
                          SettingsActionTile(
                            title: '버전 정보',
                            subtitle: 'ZeroRo v1.0.0-beta',
                            icon: Icons.info_outline_rounded,
                            iconColor: Colors.grey,
                            onTap: () {
                              showAboutDialog(
                                context: context,
                                applicationName: 'ZeroRo',
                                applicationVersion: 'v1.0.0-beta',
                                applicationIcon: const Icon(
                                  Icons.eco,
                                  size: 48,
                                  color: Colors.green,
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
                            iconColor: Colors.green,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    '홈 화면 - 사진 인증 - 카테고리 - 건의하기에서 피드백 기능을 사용할 수 있어요!',
                                  ),
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    116,
                                    205,
                                    124,
                                  ),
                                ),
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
