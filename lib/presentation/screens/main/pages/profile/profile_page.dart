import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_color.dart';
import 'components/profile_info_section.dart';
import 'components/point_chart_section.dart';
import 'settings_dialog.dart' show showSettingsDialog;

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '프로필',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => showSettingsDialog(context),
            tooltip: '설정',
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ProfileInfoSection(),
            PointChartSection(),
            // ✅ 설정 기능이 AppBar에 추가됨
          ],
        ),
      ),
    );
  }
}
