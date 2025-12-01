import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/components/custom_app_bar.dart';

import '../../../../../core/theme/app_color.dart';
import 'components/leaderboard_section.dart';

class PloggingMapPage extends ConsumerWidget {
  const PloggingMapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.background,
      child: CustomScrollView(
        slivers: [
          // AppBar
          SliverToBoxAdapter(
            child: CustomAppBar(
              title: '플로깅 맵',
              additionalActions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.symmetric(horizontal: 16),
                        child: LeaderboardSection(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.emoji_events_outlined),
                ),
              ],
            ),
          ),

          // Empty State Placeholder
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/earth_zeroro.png',
                    width: 120,
                    height: 120,
                    color: Colors.grey.withValues(alpha: 0.3),
                    colorBlendMode: BlendMode.srcIn,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '새로운 활동을 준비중이에요!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
