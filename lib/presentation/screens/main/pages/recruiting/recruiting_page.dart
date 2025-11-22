import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/components/custom_app_bar.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/toast_helper.dart';
import '../campaign/state/recruiting_state.dart';
import '../campaign/components/recruiting_filters.dart';
import '../campaign/components/recruiting_card.dart';

class RecruitingPage extends ConsumerWidget {
  const RecruitingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 필터 상태 감지
    ref.listen(recruitingFilterProvider, (previous, next) {
      ref.refresh(recruitingListProvider);
    });

    final recruitingListAsync = ref.watch(recruitingListProvider);
    final recruitingFilter = ref.watch(recruitingFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          return ref.refresh(recruitingListProvider.future);
        },
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            _buildRecruitingFilters(context, ref, recruitingFilter),
            _buildRecruitingList(context, recruitingListAsync),
          ],
        ),
      ),
    );
  }

  /// AppBar
  Widget _buildAppBar() =>
      const SliverToBoxAdapter(child: CustomAppBar(title: '리크루팅'));

  /// 리크루팅 필터 섹션
  Widget _buildRecruitingFilters(
    BuildContext context,
    WidgetRef ref,
    RecruitingFilter filter,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
  Widget _buildRecruitingList(
    BuildContext context,
    AsyncValue recruitingListAsync,
  ) {
    return recruitingListAsync.when(
      data: (posts) {
        if (posts.isEmpty) {
          return _buildEmptyState('해당 조건의 모집글이 없어요');
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
                    ToastHelper.showInfo('모집글 상세 페이지 준비중');
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
      error: (error, stack) => _buildErrorState(context),
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
              Icons.people_outline,
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

  /// 에러 상태 UI
  Widget _buildErrorState(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Consumer(
        builder: (context, ref, child) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: AppColors.textTertiary,
              ),
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
      ),
    );
  }
}
