import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../campaign/models/recruiting_post.dart';

class RecruitingMembersTab extends StatelessWidget {
  final RecruitingPost post;

  const RecruitingMembersTab({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    // Mock 참여자 데이터
    final members = _getMockMembers();

    return Column(
      children: [
        _buildMemberCount(),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: members.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final member = members[index];
              return _buildMemberCard(member);
            },
          ),
        ),
      ],
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
            '${post.currentMembers}/${post.capacity}명 참여 중',
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
  Widget _buildMemberCard(Map<String, dynamic> member) {
    return Row(
      children: [
        // 프로필 이미지
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(member['imageUrl']),
          backgroundColor: AppColors.primary.withValues(alpha: 0.2),
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
                    member['name'],
                    style: AppTextStyle.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (member['isHost'])
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
                member['joinedAt'],
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

  /// Mock 참여자 데이터
  List<Map<String, dynamic>> _getMockMembers() {
    return [
      {
        'name': '김환경',
        'imageUrl': 'https://i.pravatar.cc/150?u=user001',
        'isHost': true,
        'joinedAt': '3일 전 참여',
      },
      {
        'name': '나',
        'imageUrl': 'https://i.pravatar.cc/150?u=currentuser',
        'isHost': false,
        'joinedAt': '2일 전 참여',
      },
      if (post.currentMembers > 2)
        {
          'name': '박지구',
          'imageUrl': 'https://i.pravatar.cc/150?u=user002',
          'isHost': false,
          'joinedAt': '2일 전 참여',
        },
      if (post.currentMembers > 3)
        {
          'name': '이클린',
          'imageUrl': 'https://i.pravatar.cc/150?u=user003',
          'isHost': false,
          'joinedAt': '1일 전 참여',
        },
      if (post.currentMembers > 4)
        {
          'name': '최사랑',
          'imageUrl': 'https://i.pravatar.cc/150?u=user004',
          'isHost': false,
          'joinedAt': '1일 전 참여',
        },
      if (post.currentMembers > 5)
        {
          'name': '정댕댕',
          'imageUrl': 'https://i.pravatar.cc/150?u=user005',
          'isHost': false,
          'joinedAt': '12시간 전 참여',
        },
    ];
  }
}
