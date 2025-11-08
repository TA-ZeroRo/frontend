import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';

class CampaignPage extends ConsumerWidget {
  const CampaignPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            floating: true,
            snap: true,
            pinned: false,
            title: Text(
              '캠페인 둘러보기',
              style: AppTextStyle.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            // bottom: const FilterSection(),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 0.9,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {}),
            ),
          ),
        ],
      ),
    );
  }
}
