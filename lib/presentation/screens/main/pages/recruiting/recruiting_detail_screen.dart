import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../domain/repository/recruiting_repository.dart';
import '../campaign/models/recruiting_post.dart';
import '../campaign/state/recruiting_state.dart';
import 'components/recruiting_info_tab.dart';
import 'components/recruiting_chat_tab.dart';
import 'components/recruiting_members_tab.dart';

class RecruitingDetailScreen extends ConsumerStatefulWidget {
  final RecruitingPost post;
  final int initialTabIndex;

  const RecruitingDetailScreen({
    super.key,
    required this.post,
    this.initialTabIndex = 0,
  });

  @override
  ConsumerState<RecruitingDetailScreen> createState() =>
      _RecruitingDetailScreenState();
}

class _RecruitingDetailScreenState
    extends ConsumerState<RecruitingDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late RecruitingPost _currentPost;

  @override
  void initState() {
    super.initState();
    _currentPost = widget.post;
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 게시글 정보 새로고침
  Future<void> _refreshPost() async {
    try {
      final repository = getIt<RecruitingRepository>();
      final userId = Supabase.instance.client.auth.currentSession?.user.id;
      final updatedPost = await repository.getRecruitingPost(
        postId: int.parse(widget.post.id),
        userId: userId,
      );
      setState(() {
        _currentPost = updatedPost;
      });
    } catch (e) {
      // 에러 발생 시 무시 (기존 데이터 유지)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                RecruitingInfoTab(
                  post: _currentPost,
                  onJoinSuccess: () {
                    _refreshPost();
                    ref.invalidate(recruitingListProvider);
                  },
                ),
                RecruitingChatTab(post: _currentPost),
                RecruitingMembersTab(
                  post: _currentPost,
                  onMemberKicked: () {
                    _refreshPost();
                    ref.invalidate(recruitingListProvider);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 헤더 (캠페인 이미지 + 타이틀)
  Widget _buildHeader(BuildContext context) {
    final hasImage = _currentPost.campaignImageUrl?.isNotEmpty ?? false;
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: hasImage ? null : AppColors.primary.withValues(alpha: 0.3),
        image: hasImage
            ? DecorationImage(
                image: NetworkImage(_currentPost.campaignImageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Stack(
        children: [
          // 어두운 그라데이션
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
          // 뒤로가기 버튼
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 하단 정보
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 캠페인 태그
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _currentPost.campaignTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // 모집글 제목
                Text(
                  _currentPost.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 탭바
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyle.bodyMedium.copyWith(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: AppTextStyle.bodyMedium,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: '정보'),
          Tab(text: '채팅'),
          Tab(text: '참여자'),
        ],
      ),
    );
  }
}
