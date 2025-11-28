import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/components/custom_app_bar.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/toast_helper.dart';
import '../campaign/state/recruiting_state.dart';
import '../campaign/components/recruiting_filters.dart';
import '../campaign/components/recruiting_card.dart';
import '../campaign/models/recruiting_post.dart';

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
            _buildParticipationTabs(context, ref, recruitingFilter),
            _buildRecruitingFilters(context, ref, recruitingFilter),
            _buildRecruitingList(context, ref, recruitingListAsync),
          ],
        ),
      ),
    );
  }

  /// AppBar
  Widget _buildAppBar() =>
      const SliverToBoxAdapter(child: CustomAppBar(title: '리크루팅'));

  /// 참여 상태 탭
  Widget _buildParticipationTabs(
    BuildContext context,
    WidgetRef ref,
    RecruitingFilter filter,
  ) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildTabButton(
                context: context,
                ref: ref,
                label: '전체',
                status: ParticipationStatus.all,
                isSelected: filter.participationStatus == ParticipationStatus.all,
              ),
            ),
            Expanded(
              child: _buildTabButton(
                context: context,
                ref: ref,
                label: '참여중',
                status: ParticipationStatus.participating,
                isSelected:
                    filter.participationStatus == ParticipationStatus.participating,
              ),
            ),
            Expanded(
              child: _buildTabButton(
                context: context,
                ref: ref,
                label: '모집중',
                status: ParticipationStatus.recruiting,
                isSelected:
                    filter.participationStatus == ParticipationStatus.recruiting,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 탭 버튼
  Widget _buildTabButton({
    required BuildContext context,
    required WidgetRef ref,
    required String label,
    required ParticipationStatus status,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        ref.read(recruitingFilterProvider.notifier).setParticipationStatus(status);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyle.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

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
    WidgetRef ref,
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
                    // 카드 클릭 시 상세 페이지로 이동
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
                      // 채팅 보기 - 상세 페이지로 이동 (채팅 탭)
                      context.pushNamed(
                        'recruiting-detail',
                        pathParameters: {'id': post.id},
                        queryParameters: {'tab': 'chat'},
                        extra: post,
                      );
                    } else {
                      // 참여하기 - 확인 다이얼로그 후 참여
                      _showParticipateDialog(context, post, ref);
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

  /// 참여 확인 다이얼로그
  void _showParticipateDialog(
    BuildContext context,
    RecruitingPost post,
    WidgetRef ref,
  ) {
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
              // 다이얼로그 닫기
              Navigator.pop(dialogContext);

              // 로딩 다이얼로그 표시
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              try {
                await joinRecruiting(int.parse(post.id));

                // 로딩 닫기
                if (context.mounted) {
                  Navigator.pop(context);
                }

                // 목록 새로고침
                ref.invalidate(recruitingListProvider);

                // 성공 토스트
                ToastHelper.showSuccess('리크루팅에 참여했습니다!');

                // 상세 페이지 채팅 탭으로 이동
                if (context.mounted) {
                  context.pushNamed(
                    'recruiting-detail',
                    pathParameters: {'id': post.id},
                    queryParameters: {'tab': 'chat'},
                    extra: post.copyWith(isParticipating: true),
                  );
                }
              } catch (e) {
                // 로딩 닫기
                if (context.mounted) {
                  Navigator.pop(context);
                }

                // 에러 메시지 처리
                ToastHelper.showError(_getErrorMessage(e));
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

  /// 에러 메시지 변환
  String _getErrorMessage(dynamic error) {
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
