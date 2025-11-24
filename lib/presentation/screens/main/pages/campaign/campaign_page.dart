import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../core/components/custom_app_bar.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/toast_helper.dart';
import 'campaign_webview_screen.dart';
import 'state/campaign_state.dart';
import 'components/campaign_card.dart';
import 'components/campaign_card_shimmer.dart';
import 'components/campaign_filters.dart';
import 'recruiting_create_page.dart';

class CampaignPage extends ConsumerStatefulWidget {
  const CampaignPage({super.key});

  @override
  ConsumerState<CampaignPage> createState() => _CampaignPageState();
}

class _CampaignPageState extends ConsumerState<CampaignPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// 스크롤 이벤트 리스너
  void _onScroll() {
    // 페이지 끝에 도달하면 다음 페이지 로드 (인스타그램 스타일)
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      ref.read(campaignListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 필터 상태 감지
    ref.listen(campaignFilterProvider, (previous, next) {
      ref.read(campaignListProvider.notifier).refresh();
    });

    final campaignListAsync = ref.watch(campaignListProvider);
    final campaignFilter = ref.watch(campaignFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(campaignListProvider.notifier).refresh();
        },
        color: AppColors.primary,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildAppBar(),
            _buildFilters(context, campaignFilter),
            _buildCampaignList(context, campaignListAsync),
          ],
        ),
      ),
    );
  }

  /// AppBar
  Widget _buildAppBar() =>
      const SliverToBoxAdapter(child: CustomAppBar(title: '캠페인 둘러보기'));

  /// 캠페인 필터 섹션
  Widget _buildFilters(BuildContext context, CampaignFilter filter) {
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
    AsyncValue campaignListAsync,
  ) {
    return campaignListAsync.when(
      data: (campaigns) {
        if (campaigns.isEmpty) {
          return _buildEmptyState('해당 조건의 캠페인이 없어요');
        }

        final hasMore = ref.read(campaignListProvider.notifier).hasMore;

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // 캠페인 카드
                if (index < campaigns.length) {
                  final campaign = campaigns[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
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
                      onParticipate: () async {
                        try {
                          await ref
                              .read(campaignListProvider.notifier)
                              .toggleParticipation(campaign.id);
                          ToastHelper.showSuccess(
                            campaign.isParticipating
                                ? '캠페인 참가가 취소되었어요'
                                : '캠페인에 참가하셨어요!',
                          );
                        } catch (e) {
                          ToastHelper.showError(
                            e.toString().replaceFirst('Exception: ', ''),
                          );
                        }
                      },
                      onCruiting: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecruitingCreatePage(
                              campaign: campaign,
                            ),
                          ),
                        );
                      },
                      onShare: () async {
                        try {
                          await Share.share(
                            '${campaign.title}\n${campaign.url}',
                            subject: campaign.title,
                          );
                        } catch (e) {
                          ToastHelper.showError('공유하기에 실패했어요');
                        }
                      },
                    ),
                  );
                }
                // 로딩 인디케이터 (더 로드할 데이터가 있을 때만)
                else if (hasMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                // 마지막 여백
                else {
                  return const SizedBox(height: 16);
                }
              },
              childCount: campaigns.length + 1, // 캠페인 + 로딩/여백
            ),
          ),
        );
      },
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(),
    );
  }

  /// 빈 상태 UI
  Widget _buildEmptyState(String message) {
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
              message,
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
  Widget _buildErrorState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              '데이터를 불러올 수 없어요',
              style: AppTextStyle.bodyLarge.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(campaignListProvider.notifier).refresh();
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
