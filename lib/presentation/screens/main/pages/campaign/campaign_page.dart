import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/components/custom_app_bar.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/toast_helper.dart';
import 'campaign_webview_screen.dart';
import 'state/campaign_state.dart';
import 'components/campaign_card.dart';
import 'components/campaign_card_shimmer.dart';
import 'components/campaign_filters.dart';

class CampaignPage extends ConsumerWidget {
  const CampaignPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 필터 상태 감지
    ref.listen(campaignFilterProvider, (previous, next) {
      // 필터가 변경되면 캠페인 목록 새로고침
      ref.read(campaignListProvider.notifier).refresh();
    });

    final campaignListAsync = ref.watch(campaignListProvider);
    final filter = ref.watch(campaignFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildFilters(context, ref, filter),
          _buildCampaignList(context, ref, campaignListAsync),
        ],
      ),
    );
  }

  /// AppBar
  Widget _buildAppBar() =>
      SliverToBoxAdapter(child: const CustomAppBar(title: '캠페인 둘러보기'));

  /// 필터 섹션
  Widget _buildFilters(
    BuildContext context,
    WidgetRef ref,
    CampaignFilter filter,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: CampaignFilters(
          selectedRegion: filter.region,
          selectedCity: filter.city,
          selectedCategory: filter.category,
          startDate: filter.startDate,
          endDate: filter.endDate,
          onRegionChanged: (region) {
            ref.read(campaignFilterProvider.notifier).setRegion(region);
          },
          onCityChanged: (city) {
            ref.read(campaignFilterProvider.notifier).setCity(city);
          },
          onCategoryChanged: (category) {
            ref.read(campaignFilterProvider.notifier).setCategory(category);
          },
          onStartDateChanged: (date) {
            final endDate = filter.endDate;
            if (date != null && endDate != null) {
              ref
                  .read(campaignFilterProvider.notifier)
                  .setDateRange(date, endDate);
            } else if (date != null) {
              ref
                  .read(campaignFilterProvider.notifier)
                  .setDateRange(date, date);
            } else {
              ref.read(campaignFilterProvider.notifier).clearDateRange();
            }
          },
          onEndDateChanged: (date) {
            final startDate = filter.startDate;
            if (startDate != null && date != null) {
              ref
                  .read(campaignFilterProvider.notifier)
                  .setDateRange(startDate, date);
            } else if (date != null) {
              ref
                  .read(campaignFilterProvider.notifier)
                  .setDateRange(date, date);
            } else {
              ref.read(campaignFilterProvider.notifier).clearDateRange();
            }
          },
          onResetFilters: () {
            ref.read(campaignFilterProvider.notifier).reset();
          },
        ),
      ),
    );
  }

  /// 캠페인 목록
  Widget _buildCampaignList(
    BuildContext context,
    WidgetRef ref,
    AsyncValue campaignListAsync,
  ) {
    return campaignListAsync.when(
      data: (campaigns) {
        if (campaigns.isEmpty) {
          return _buildEmptyState();
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final campaign = campaigns[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == campaigns.length - 1 ? 16 : 12,
                ),
                child: CampaignCard(
                  campaign: campaign,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CampaignWebViewScreen(
                          url: campaign.url,
                          title: campaign.title,
                        ),
                      ),
                    );
                  },
                  onParticipate: () {
                    ref
                        .read(campaignListProvider.notifier)
                        .toggleParticipation(campaign.id);
                    ToastHelper.showSuccess(
                      campaign.isParticipating
                          ? '캠페인 참가가 취소되었어요'
                          : '캠페인에 참가하셨어요!',
                    );
                  },
                  onShare: () {
                    ToastHelper.showInfo('공유 기능 준비중이에요');
                  },
                ),
              );
            }, childCount: campaigns.length),
          ),
        );
      },
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(ref),
    );
  }

  /// 빈 상태 UI
  Widget _buildEmptyState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.campaign_outlined,
              size: 80,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              '해당 조건의 캠페인이 없어요',
              style: AppTextStyle.bodyLarge.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 로딩 상태 UI (Shimmer)
  Widget _buildLoadingState() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index == 4 ? 16 : 12),
            child: const CampaignCardShimmer(),
          );
        }, childCount: 5),
      ),
    );
  }

  /// 에러 상태 UI
  Widget _buildErrorState(WidgetRef ref) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              '캠페인을 불러올 수 없어요',
              style: AppTextStyle.bodyLarge.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(campaignListProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}
