import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/utils/toast_helper.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../domain/repository/recruiting_repository.dart';
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

  String? get _currentUserId =>
      Supabase.instance.client.auth.currentSession?.user.id;

  bool get _isHost => _currentUserId != null && _currentUserId == post.hostId;

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
          if (_isHost) ...[
            _buildHostManagementSection(context, ref),
            const SizedBox(height: 24),
          ],
          if (!post.isParticipating) _buildParticipateButton(context, ref),
        ],
      ),
    );
  }

  /// 주최자 관리 섹션
  Widget _buildHostManagementSection(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
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
              Icon(Icons.admin_panel_settings, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                '주최자 관리',
                style: AppTextStyle.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 모집 상태 토글 버튼
          _buildToggleRecruitingButton(context, ref),
          const SizedBox(height: 12),
          // 수정/삭제 버튼 행
          Row(
            children: [
              Expanded(
                child: _buildEditButton(context, ref),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDeleteButton(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 모집 상태 토글 버튼
  Widget _buildToggleRecruitingButton(BuildContext context, WidgetRef ref) {
    final isRecruiting = post.isRecruiting;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _toggleRecruitingStatus(context, ref),
        icon: Icon(
          isRecruiting ? Icons.pause_circle_outline : Icons.play_circle_outline,
          size: 20,
        ),
        label: Text(isRecruiting ? '모집 마감하기' : '모집 재개하기'),
        style: OutlinedButton.styleFrom(
          foregroundColor: isRecruiting ? AppColors.warning : AppColors.success,
          side: BorderSide(
            color: isRecruiting ? AppColors.warning : AppColors.success,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  /// 수정 버튼
  Widget _buildEditButton(BuildContext context, WidgetRef ref) {
    return OutlinedButton.icon(
      onPressed: () => _showEditDialog(context, ref),
      icon: const Icon(Icons.edit_outlined, size: 18),
      label: const Text('수정'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        side: BorderSide(color: AppColors.textTertiary),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// 삭제 버튼
  Widget _buildDeleteButton(BuildContext context, WidgetRef ref) {
    return OutlinedButton.icon(
      onPressed: () => _showDeleteConfirmation(context, ref),
      icon: const Icon(Icons.delete_outline, size: 18),
      label: const Text('삭제'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.error,
        side: BorderSide(color: AppColors.error),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// 모집 상태 토글
  Future<void> _toggleRecruitingStatus(BuildContext context, WidgetRef ref) async {
    final newStatus = !post.isRecruiting;
    final statusText = newStatus ? '재개' : '마감';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('모집 $statusText'),
        content: Text('정말 모집을 ${statusText}하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(statusText),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // 로딩 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final repository = getIt<RecruitingRepository>();
      await repository.updateRecruitingPost(
        postId: int.parse(post.id),
        userId: _currentUserId!,
        isRecruiting: newStatus,
      );

      if (context.mounted) Navigator.pop(context); // 로딩 닫기

      ref.invalidate(recruitingListProvider);
      onJoinSuccess?.call(); // 상세 화면 새로고침

      ToastHelper.showSuccess('모집이 ${statusText}되었습니다');
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // 로딩 닫기
      ToastHelper.showError('모집 상태 변경에 실패했습니다');
    }
  }

  /// 수정 다이얼로그
  Future<void> _showEditDialog(BuildContext context, WidgetRef ref) async {
    final titleController = TextEditingController(text: post.title);
    final capacityController = TextEditingController(text: post.capacity.toString());

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('게시글 수정'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: capacityController,
                decoration: const InputDecoration(
                  labelText: '모집 인원',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('저장'),
          ),
        ],
      ),
    );

    if (result != true || !context.mounted) return;

    // 로딩 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final repository = getIt<RecruitingRepository>();
      await repository.updateRecruitingPost(
        postId: int.parse(post.id),
        userId: _currentUserId!,
        title: titleController.text.trim(),
        capacity: int.tryParse(capacityController.text) ?? post.capacity,
      );

      if (context.mounted) Navigator.pop(context); // 로딩 닫기

      ref.invalidate(recruitingListProvider);
      onJoinSuccess?.call(); // 상세 화면 새로고침

      ToastHelper.showSuccess('게시글이 수정되었습니다');
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // 로딩 닫기
      ToastHelper.showError('게시글 수정에 실패했습니다');
    }
  }

  /// 삭제 확인 다이얼로그
  Future<void> _showDeleteConfirmation(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('게시글 삭제'),
        content: const Text('정말 이 게시글을 삭제하시겠습니까?\n삭제된 게시글은 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // 로딩 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final repository = getIt<RecruitingRepository>();
      await repository.deleteRecruitingPost(
        postId: int.parse(post.id),
        userId: _currentUserId!,
      );

      if (context.mounted) {
        Navigator.pop(context); // 로딩 닫기
        Navigator.pop(context); // 상세 화면 닫기
      }

      ref.invalidate(recruitingListProvider);
      ToastHelper.showSuccess('게시글이 삭제되었습니다');
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // 로딩 닫기
      ToastHelper.showError('게시글 삭제에 실패했습니다');
    }
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
              fontWeight: FontWeight.w500,
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
              fontWeight: FontWeight.w500,
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
              fontWeight: FontWeight.w500,
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
              fontWeight: FontWeight.w500,
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
                fontWeight: FontWeight.w200,
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
