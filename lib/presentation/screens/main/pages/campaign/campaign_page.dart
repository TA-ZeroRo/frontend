import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/toast_helper.dart';
import '../../../../../core/utils/character_notification_helper.dart';
import 'campaign_webview_screen.dart';
import 'state/campaign_state.dart';
import 'state/recruiting_state.dart';
import 'components/campaign_card.dart';
import 'components/campaign_card_shimmer.dart';
import 'components/campaign_filters.dart';
import 'components/recruiting_filters.dart';
import 'components/recruiting_card.dart';
import 'components/external_campaign_carousel.dart';
import 'models/campaign_data.dart';
import 'models/recruiting_post.dart';
import 'recruiting_create_page.dart';

class CampaignPage extends ConsumerStatefulWidget {
  const CampaignPage({super.key});

  @override
  ConsumerState<CampaignPage> createState() => _CampaignPageState();
}

class _CampaignPageState extends ConsumerState<CampaignPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isRecruitingMode = false;
  bool _isRecruitingFilterExpanded = false;

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
    // 캠페인 모드에서만 페이지 끝에 도달하면 다음 페이지 로드
    if (!_isRecruitingMode &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent) {
      ref.read(campaignListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 캠페인 필터 상태 감지
    ref.listen(campaignFilterProvider, (previous, next) {
      ref.read(campaignListProvider.notifier).refresh();
    });

    // 리크루팅 필터 상태 감지
    ref.listen(recruitingFilterProvider, (previous, next) {
      ref.refresh(recruitingListProvider);
    });

    final campaignListAsync = ref.watch(campaignListProvider);
    final campaignFilter = ref.watch(campaignFilterProvider);
    final recruitingListAsync = ref.watch(recruitingListProvider);
    final recruitingFilter = ref.watch(recruitingFilterProvider);

    // ZERORO/External 캠페인 분리
    final zeroroCampaignsAsync = ref.watch(zeroroCampaignListProvider);
    final externalCampaignsAsync = ref.watch(externalCampaignListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          if (_isRecruitingMode) {
            return ref.refresh(recruitingListProvider.future);
          } else {
            await ref.read(campaignListProvider.notifier).refresh();
          }
        },
        color: AppColors.primary,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildAppBar(),
            if (_isRecruitingMode) ...[
              _buildRecruitingTopSection(recruitingFilter),
              if (_isRecruitingFilterExpanded)
                _buildRecruitingFilters(recruitingFilter),
              _buildRecruitingList(recruitingListAsync),
            ] else ...[
              // External 캠페인 캐러셀
              _buildExternalCampaignCarousel(context, externalCampaignsAsync),
              // ZERORO 캠페인 섹션 헤더
              _buildZeroroSectionHeader(),
              // 필터
              _buildFilters(context, campaignFilter),
              // ZERORO 캠페인 리스트
              _buildZeroroCampaignList(context, zeroroCampaignsAsync, campaignListAsync),
            ],
          ],
        ),
      ),
    );
  }

  /// AppBar with toggle
  Widget _buildAppBar() {
    return SliverToBoxAdapter(
      child: AppBar(
        title: GestureDetector(
          onTap: () {
            setState(() {
              _isRecruitingMode = !_isRecruitingMode;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isRecruitingMode ? '리크루팅' : '캠페인 둘러보기',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                size: 24,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              context.push('/settings');
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }

  /// External 캠페인 캐러셀
  Widget _buildExternalCampaignCarousel(
    BuildContext context,
    AsyncValue<List<CampaignData>> externalCampaignsAsync,
  ) {
    return SliverToBoxAdapter(
      child: externalCampaignsAsync.when(
        data: (campaigns) {
          if (campaigns.isEmpty) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            child: ExternalCampaignCarousel(
              campaigns: campaigns,
              onCampaignTap: (campaign) {
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
            ),
          );
        },
        loading: () => Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          child: const ExternalCampaignCarouselShimmer(),
        ),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  /// ZERORO 캠페인 섹션 헤더
  Widget _buildZeroroSectionHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.eco_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'ZERORO',
                    style: AppTextStyle.labelMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '참여 가능한 캠페인',
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  /// ZERORO 캠페인 목록
  Widget _buildZeroroCampaignList(
    BuildContext context,
    AsyncValue<List<CampaignData>> zeroroCampaignsAsync,
    AsyncValue campaignListAsync,
  ) {
    // 전체 캠페인 로딩 상태 확인
    if (campaignListAsync.isLoading) {
      return _buildLoadingState();
    }

    return zeroroCampaignsAsync.when(
      data: (campaigns) {
        if (campaigns.isEmpty) {
          return _buildZeroroEmptyState();
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
                        // ZERORO 캠페인은 상세 페이지로 이동
                        context.pushNamed(
                          'campaign-detail',
                          pathParameters: {'id': campaign.id},
                          extra: campaign,
                        );
                      },
                      onParticipate: () async {
                        // 토글 전 상태를 저장
                        final wasParticipating = campaign.isParticipating;

                        try {
                          await ref
                              .read(campaignListProvider.notifier)
                              .toggleParticipation(campaign.id);

                          if (wasParticipating) {
                            // 참가 중이었으면 → 취소됨
                            CharacterNotificationHelper.show(
                              context,
                              message: '캠페인 참가가 취소되었어요',
                              characterImage: 'assets/images/earth_zeroro.png',
                              alignment: const Alignment(0.85, -0.4),
                            );
                          } else {
                            // 참가 안 했으면 → 참가됨
                            CharacterNotificationHelper.show(
                              context,
                              message: '캠페인 참가에 성공했어요!',
                              characterImage:
                                  'assets/images/cloud_zeroro_sunglasses.png',
                              alignment: const Alignment(0.85, -0.4),
                            );
                          }
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
                            builder: (context) =>
                                RecruitingCreatePage(campaign: campaign),
                          ),
                        );
                      },
                      onShare: () async {
                        try {
                          await Share.share(
                            '지구를 위해 저와 ${campaign.title}을(를) 함께 해요!\n\nZERORO 앱에서 함께 참여하세요!',
                            subject: '지구를 위해 저와 ${campaign.title}을(를) 함께 해요!',
                          );
                        } catch (e) {
                          if (mounted) {
                            CharacterNotificationHelper.show(
                              context,
                              message: '공유에 실패했어요ㅠㅠ',
                              characterImage:
                                  'assets/images/cloud_zeroro_sad.png',
                              alignment: const Alignment(0.85, -0.4),
                            );
                          }
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

  /// ZERORO 캠페인 없을 때 빈 상태
  Widget _buildZeroroEmptyState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.eco_rounded,
                size: 48,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '참여 가능한 캠페인이 곧 추가됩니다!',
              style: AppTextStyle.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '외부 캠페인을 먼저 둘러보세요',
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
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

  // ============ 리크루팅 관련 위젯들 ============

  /// 리크루팅 상단 섹션 (탭 + 필터 토글)
  Widget _buildRecruitingTopSection(RecruitingFilter filter) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.background,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Row(
          children: [
            // 탭 버튼들
            _buildRecruitingTabButton(
              label: '전체',
              status: ParticipationStatus.all,
              isSelected: filter.participationStatus == ParticipationStatus.all,
            ),
            const SizedBox(width: 8),
            _buildRecruitingTabButton(
              label: '내 채팅방',
              status: ParticipationStatus.participating,
              isSelected:
                  filter.participationStatus ==
                  ParticipationStatus.participating,
            ),
            const Spacer(),
            // 필터 토글 버튼
            _buildRecruitingFilterToggleButton(),
          ],
        ),
      ),
    );
  }

  /// 리크루팅 탭 버튼
  Widget _buildRecruitingTabButton({
    required String label,
    required ParticipationStatus status,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        ref.read(recruitingFilterProvider.notifier).setParticipationStatus(status);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.textPrimary : const Color(0xFFCCCCCC),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.12 : 0.08),
              blurRadius: isSelected ? 4 : 3,
              offset: Offset(0, isSelected ? 2 : 1),
            ),
          ],
        ),
        child: Text(
          label,
          style: AppTextStyle.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// 리크루팅 필터 토글 버튼
  Widget _buildRecruitingFilterToggleButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isRecruitingFilterExpanded = !_isRecruitingFilterExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _isRecruitingFilterExpanded
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isRecruitingFilterExpanded
                ? AppColors.primary
                : const Color(0xFFCCCCCC),
            width: _isRecruitingFilterExpanded ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isRecruitingFilterExpanded
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: _isRecruitingFilterExpanded ? 4 : 3,
              offset: Offset(0, _isRecruitingFilterExpanded ? 2 : 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '상세필터',
              style: AppTextStyle.bodySmall.copyWith(
                color: _isRecruitingFilterExpanded
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontWeight: _isRecruitingFilterExpanded
                    ? FontWeight.w600
                    : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              _isRecruitingFilterExpanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: _isRecruitingFilterExpanded
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  /// 리크루팅 필터 섹션
  Widget _buildRecruitingFilters(RecruitingFilter filter) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.background,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: RecruitingFilters(
          selectedRegion: filter.region,
          selectedCity: filter.city,
          minCapacity: filter.minCapacity,
          startDate: filter.startDate,
          endDate: filter.endDate,
          minAge: filter.minAge,
          maxAge: filter.maxAge,
          onRegionChanged: (region) {
            ref.read(recruitingFilterProvider.notifier).setRegion(region);
          },
          onCityChanged: (city) {
            ref.read(recruitingFilterProvider.notifier).setCity(city);
          },
          onCapacityChanged: (capacity) {
            ref.read(recruitingFilterProvider.notifier).setCapacity(capacity);
          },
          onStartDateChanged: (date) {
            final endDate = filter.endDate;
            if (date != null && endDate != null) {
              ref
                  .read(recruitingFilterProvider.notifier)
                  .setDateRange(date, endDate);
            } else if (date != null) {
              ref
                  .read(recruitingFilterProvider.notifier)
                  .setDateRange(date, date);
            }
          },
          onEndDateChanged: (date) {
            final startDate = filter.startDate;
            if (startDate != null && date != null) {
              ref
                  .read(recruitingFilterProvider.notifier)
                  .setDateRange(startDate, date);
            } else if (date != null) {
              ref
                  .read(recruitingFilterProvider.notifier)
                  .setDateRange(date, date);
            }
          },
          onAgeChanged: (min, max) {
            ref.read(recruitingFilterProvider.notifier).setAgeRange(min, max);
          },
          onResetFilters: () {
            ref.read(recruitingFilterProvider.notifier).reset();
          },
        ),
      ),
    );
  }

  /// 리크루팅 목록
  Widget _buildRecruitingList(AsyncValue recruitingListAsync) {
    return recruitingListAsync.when(
      data: (posts) {
        if (posts.isEmpty) {
          return _buildRecruitingEmptyState('해당 조건의 모집글이 없어요');
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final post = posts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RecruitingCard(
                  post: post,
                  onTap: () {
                    context.pushNamed(
                      'recruiting-detail',
                      pathParameters: {'id': post.id},
                      queryParameters:
                          post.isParticipating ? {'tab': 'chat'} : {},
                      extra: post,
                    );
                  },
                  onActionButtonTap: () {
                    if (post.isParticipating) {
                      context.pushNamed(
                        'recruiting-detail',
                        pathParameters: {'id': post.id},
                        queryParameters: {'tab': 'chat'},
                        extra: post,
                      );
                    } else {
                      _showParticipateDialog(context, post);
                    }
                  },
                ),
              );
            }, childCount: posts.length),
          ),
        );
      },
      loading: () => const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => _buildRecruitingErrorState(),
    );
  }

  /// 리크루팅 빈 상태 UI
  Widget _buildRecruitingEmptyState(String message) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 80, color: AppColors.textTertiary),
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

  /// 리크루팅 에러 상태 UI
  Widget _buildRecruitingErrorState() {
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
                ref.refresh(recruitingListProvider);
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

  /// 참여 확인 다이얼로그
  void _showParticipateDialog(BuildContext context, RecruitingPost post) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('리크루팅 참여'),
        content: Text('${post.title}\n\n이 모집글에 참여하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );

              try {
                await joinRecruiting(int.parse(post.id));

                if (context.mounted) {
                  Navigator.pop(context);
                }

                ref.invalidate(recruitingListProvider);
                ToastHelper.showSuccess('리크루팅에 참여했습니다!');

                if (context.mounted) {
                  context.pushNamed(
                    'recruiting-detail',
                    pathParameters: {'id': post.id},
                    queryParameters: {'tab': 'chat'},
                    extra: post.copyWith(isParticipating: true),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                }
                ToastHelper.showError(_getRecruitingErrorMessage(e));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('참여하기'),
          ),
        ],
      ),
    );
  }

  /// 리크루팅 에러 메시지 변환
  String _getRecruitingErrorMessage(dynamic error) {
    final errorStr = error.toString();
    if (errorStr.contains('이미 참여') || errorStr.contains('already')) {
      return '이미 참여 중인 리크루팅입니다';
    } else if (errorStr.contains('정원') || errorStr.contains('full')) {
      return '정원이 가득 찼습니다';
    } else if (errorStr.contains('마감') || errorStr.contains('closed')) {
      return '모집이 마감되었습니다';
    } else if (errorStr.contains('로그인') || errorStr.contains('login')) {
      return '로그인이 필요합니다';
    }
    return '참여에 실패했습니다';
  }
}
