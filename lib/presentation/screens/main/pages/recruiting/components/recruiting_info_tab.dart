import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/utils/toast_helper.dart';
import '../../campaign/models/recruiting_post.dart';
import '../../campaign/state/recruiting_state.dart';

class RecruitingInfoTab extends ConsumerWidget {
  final RecruitingPost post;
  final VoidCallback? onJoinSuccess;

  const RecruitingInfoTab({
    super.key,
    required this.post,
    this.onJoinSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection(),
          const SizedBox(height: 24),
          _buildDetailsSection(),
          const SizedBox(height: 24),
          if (!post.isParticipating) _buildParticipateButton(context, ref),
        ],
      ),
    );
  }

  /// 기본 정보 섹션
  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                '지역',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${post.region} ${post.city}',
            style: AppTextStyle.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(height: 24),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                '활동 날짜',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('yyyy년 M월 d일').format(post.startDate),
            style: AppTextStyle.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(height: 24),
          Row(
            children: [
              Icon(Icons.people, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                '모집 인원',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${post.currentMembers}/${post.capacity}명',
            style: AppTextStyle.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: post.currentMembers >= post.capacity
                  ? AppColors.error
                  : AppColors.primary,
            ),
          ),
          const Divider(height: 24),
          Row(
            children: [
              Icon(Icons.cake, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                '연령대',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            post.minAge == 0 && post.maxAge == 0
                ? '나이 제한 없음'
                : '${post.minAge}세 ~ ${post.maxAge}세',
            style: AppTextStyle.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 상세 설명 섹션
  Widget _buildDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '모집글 설명',
            style: AppTextStyle.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            post.title,
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '참여 후 채팅방에서 자세한 일정과 준비물을 확인하세요!',
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 참여하기 버튼
  Widget _buildParticipateButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
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

            // 부모에게 알림 (상세 화면 새로고침용)
            onJoinSuccess?.call();
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
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_add, size: 20),
            const SizedBox(width: 8),
            Text(
              '리크루팅 참여하기',
              style: AppTextStyle.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
