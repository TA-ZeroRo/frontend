import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../domain/repository/recruiting_repository.dart';
import '../../campaign/models/recruiting_post.dart';

class RecruitingMembersTab extends StatefulWidget {
  final RecruitingPost post;

  const RecruitingMembersTab({super.key, required this.post});

  @override
  State<RecruitingMembersTab> createState() => _RecruitingMembersTabState();
}

class _RecruitingMembersTabState extends State<RecruitingMembersTab> {
  final RecruitingRepository _repository = getIt<RecruitingRepository>();
  List<ChatRoomParticipant> _members = [];
  bool _isLoading = true;
  String? _error;

  String? get _currentUserId =>
      Supabase.instance.client.auth.currentSession?.user.id;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    final chatRoomId = widget.post.chatRoomId;
    final userId = _currentUserId;

    if (chatRoomId == null || userId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final members = await _repository.getChatRoomParticipants(
        roomId: int.parse(chatRoomId),
        userId: userId,
      );
      setState(() {
        _members = members;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 참여하지 않은 경우
    if (!widget.post.isParticipating || widget.post.chatRoomId == null) {
      return _buildNotParticipatingView();
    }

    // 로딩 중
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 에러 발생
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text('참여자 목록을 불러올 수 없습니다', style: AppTextStyle.bodyLarge),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loadMembers,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        _buildMemberCount(),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _members.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final member = _members[index];
              return _buildMemberCard(member, index == 0);
            },
          ),
        ),
      ],
    );
  }

  /// 참여하지 않은 경우 뷰
  Widget _buildNotParticipatingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, size: 80, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            '참여자 목록은 참여자만 볼 수 있어요',
            style: AppTextStyle.bodyLarge.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '정보 탭에서 참여하기 버튼을 눌러주세요',
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 참여 인원 헤더
  Widget _buildMemberCount() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            '${widget.post.currentMembers}/${widget.post.capacity}명 참여 중',
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 참여자 카드
  Widget _buildMemberCard(ChatRoomParticipant member, bool isHost) {
    final isMe = member.userId == _currentUserId;

    return Row(
      children: [
        // 프로필 이미지
        CircleAvatar(
          radius: 24,
          backgroundImage: member.userImageUrl != null
              ? NetworkImage(member.userImageUrl!)
              : null,
          backgroundColor: AppColors.primary.withValues(alpha: 0.2),
          child: member.userImageUrl == null
              ? Icon(Icons.person, color: AppColors.primary)
              : null,
        ),
        const SizedBox(width: 12),
        // 정보
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    isMe ? '나' : member.username,
                    style: AppTextStyle.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (isHost)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '주최자',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _formatJoinedAt(member.joinedAt),
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 참여 시간 포맷팅
  String _formatJoinedAt(DateTime joinedAt) {
    final now = DateTime.now();
    final diff = now.difference(joinedAt);

    if (diff.inDays > 0) {
      return '${diff.inDays}일 전 참여';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}시간 전 참여';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}분 전 참여';
    } else {
      return '방금 전 참여';
    }
  }
}
