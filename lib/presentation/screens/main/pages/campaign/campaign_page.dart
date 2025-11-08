import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/toast_helper.dart';
import '../../../../routes/router_path.dart';
import 'state/community_controller.dart';
import 'widgets/expandable_fab.dart';
import 'widgets/post_widget.dart';
import 'widgets/ad_carousel.dart';

class CampaignPage extends ConsumerStatefulWidget {
  const CampaignPage({super.key});

  @override
  ConsumerState<CampaignPage> createState() => _CampaignPageState();
}

class _CampaignPageState extends ConsumerState<CampaignPage> {
  bool _isMenuExpanded = false;
  final GlobalKey<ExpandableFabState> _fabKey = GlobalKey<ExpandableFabState>();

  Future<void> _onRefresh() async {
    await ref.read(postsProvider.notifier).refresh();
  }

  void _closeMenu() {
    _fabKey.currentState?.close();
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postsProvider);

    return Stack(
      children: [
        Scaffold(
          body: Container(
            color: AppColors.background,
            child: postsAsync.when(
              data: (posts) => RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.primaryAccent,
                backgroundColor: AppColors.cardBackground,
                displacement: 40.0,
                strokeWidth: 3.0,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      floating: true,
                      snap: true,
                      title: Text(
                        'Community',
                        style: AppTextStyle.headlineSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      centerTitle: true,
                    ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: AdCarousel(),
                      ),
                    ),
                    posts.isEmpty
                        ? SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.forum_outlined,
                                    size: 72,
                                    color: AppColors.textTertiary,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    '아직 게시글이 없어요',
                                    style: AppTextStyle.titleLarge.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '첫 번째 게시글을 작성해보세요!',
                                    style: AppTextStyle.bodyMedium.copyWith(
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              return PostWidget(post: posts[index]);
                            }, childCount: posts.length),
                          ),
                  ],
                ),
              ),
              loading: () => Scaffold(
                body: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.backgroundGradient,
                  ),
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        floating: true,
                        snap: true,
                        title: Text(
                          'Community',
                          style: AppTextStyle.headlineSmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        centerTitle: true,
                      ),
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: AdCarousel(),
                        ),
                      ),
                      SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                strokeWidth: 3.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryAccent,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '게시글을 불러오는 중...',
                                style: AppTextStyle.bodyLarge.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              error: (error, stack) => RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.primaryAccent,
                backgroundColor: AppColors.cardBackground,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      floating: true,
                      snap: true,
                      title: Text(
                        'Community',
                        style: AppTextStyle.headlineSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      centerTitle: true,
                    ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: AdCarousel(),
                      ),
                    ),
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 72,
                              color: AppColors.error,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '게시글을 불러올 수 없어요',
                              style: AppTextStyle.titleLarge.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '아래로 당겨서 새로고침해보세요',
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Semi-transparent overlay when menu is expanded
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !_isMenuExpanded,
            child: GestureDetector(
              onTap: _closeMenu,
              child: AnimatedOpacity(
                opacity: _isMenuExpanded ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(color: const Color(0x80000000)),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: ExpandableFab(
            key: _fabKey,
            onExpandedChanged: (isExpanded) {
              setState(() => _isMenuExpanded = isExpanded);
            },
            onOverlayTap: _closeMenu,
            onPostCreate: () {
              context.push(RoutePath.newPost);
            },
            onCampaignRecruit: () {
              context.push(RoutePath.campaignRecruiting);
            },
            onChallengeCreate: () {
              ToastHelper.showInfo('챌린지 생성 기능은 아직 구현중입니다');
            },
          ),
        ),
      ],
    );
  }
}
