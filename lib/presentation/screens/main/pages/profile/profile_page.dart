import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import 'components/profile_info_section.dart';
import 'components/point_chart_section.dart';
import 'components/weekly_report_library_section.dart';
import 'settings_dialog.dart' show showSettingsDialog;
import 'state/user_controller.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  Future<void> _onRefresh() async {
    await ref.read(userProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Main content
              Container(
                color: AppColors.background,
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: AppColors.primary,
                  backgroundColor: AppColors.cardBackground,
                  displacement: 40.0,
                  strokeWidth: 3.0,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      _buildSliverAppBar(context),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: _buildProfileInfoCard(),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: _buildChartCard(),
                        ),
                      ),
                      // 바텀시트가 아래쪽 1/3를 차지하므로 여유 공간 확보
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: constraints.maxHeight * 0.33 + 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom sheet - 항상 표시
              // Positioned.fill을 사용하여 전체 영역을 차지하도록 함
              Positioned.fill(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.33, // 화면 아래 1/3 (초기 위치)
                  minChildSize: 0.33, // 최소 크기도 1/3 (더 이상 내려가지 않음)
                  maxChildSize: 0.95, // 최대 크기는 거의 전체
                  snap: true,
                  snapSizes: const [0.33, 0.95],
                  builder: (context, scrollController) => Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: WeeklyReportLibrarySection(
                      scrollController: scrollController,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      floating: true,
      snap: true,
      title: Text(
        '프로필',
        style: AppTextStyle.headlineSmall.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.settings_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => showSettingsDialog(context),
          tooltip: '설정',
        ),
      ],
    );
  }

  Widget _buildProfileInfoCard() {
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
      child: const ProfileInfoSection(),
    );
  }

  Widget _buildChartCard() {
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
      child: const PointChartSection(),
    );
  }
}
