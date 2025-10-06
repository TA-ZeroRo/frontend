import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../state/profile_controller.dart';

class ProfileInfoSection extends ConsumerStatefulWidget {
  const ProfileInfoSection({super.key});

  @override
  ConsumerState<ProfileInfoSection> createState() => _ProfileInfoSectionState();
}

class _ProfileInfoSectionState extends ConsumerState<ProfileInfoSection> {
  bool _isEditing = false;
  late TextEditingController _usernameController;
  String? _tempImageUrl;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider);
    _usernameController = TextEditingController(text: profile.username);
    _tempImageUrl = profile.userImg;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_isEditing) {
      // 저장 로직
      final notifier = ref.read(profileProvider.notifier);
      notifier.updateUsername(_usernameController.text.trim());
      notifier.updateUserImage(_tempImageUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('프로필이 업데이트되었습니다.'),
          backgroundColor: const Color.fromRGBO(116, 205, 124, 1),
        ),
      );
    } else {
      // 편집 모드 시작 - 현재 값으로 초기화
      final profile = ref.read(profileProvider);
      _usernameController.text = profile.username;
      _tempImageUrl = profile.userImg;
    }
    setState(() => _isEditing = !_isEditing);
  }

  void _cancelEdit() {
    final profile = ref.read(profileProvider);
    setState(() {
      _isEditing = false;
      _usernameController.text = profile.username;
      _tempImageUrl = profile.userImg;
    });
  }

  void _toggleAvatar() {
    setState(() {
      _tempImageUrl = _tempImageUrl == null
          ? 'https://picsum.photos/200'
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final displayImageUrl = _isEditing ? _tempImageUrl : profile.userImg;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title
          Row(
            children: [
              Icon(
                Icons.person_rounded,
                color: AppColors.primaryAccent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '프로필 정보',
                style: AppTextStyle.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Profile content
          Row(
            children: [
              // 프로필 사진
              GestureDetector(
                onTap: _isEditing ? _toggleAvatar : null,
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryAccent.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey[100],
                          backgroundImage:
                              (displayImageUrl != null &&
                                  displayImageUrl.isNotEmpty)
                              ? NetworkImage(displayImageUrl)
                              : null,
                          child:
                              (displayImageUrl == null ||
                                  displayImageUrl.isEmpty)
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: AppColors.textSecondary,
                                )
                              : null,
                        ),
                      ),
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.cardShadow,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isEditing)
                      TextField(
                        controller: _usernameController,
                        style: AppTextStyle.headlineSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: '이름을 입력하세요',
                          hintStyle: AppTextStyle.headlineSmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primaryAccent,
                              width: 2,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primaryAccent,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                        ),
                      )
                    else
                      Text(
                        profile.username.isNotEmpty ? profile.username : '김오띠',
                        style: AppTextStyle.headlineSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 12),

                    // Stats cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            '총 포인트',
                            '${profile.totalPoints}',
                            Icons.stars_rounded,
                            AppColors.primaryAccent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            '연속 일수',
                            '${profile.continuousDays}일',
                            Icons.calendar_today_rounded,
                            AppColors.secondaryAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_isEditing) ...[
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed: _cancelEdit,
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppColors.error,
                      size: 24,
                    ),
                    tooltip: '취소',
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryAccent.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _toggleEdit,
                    icon: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    tooltip: '저장',
                  ),
                ),
              ] else
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed: _toggleEdit,
                    icon: Icon(
                      Icons.edit_rounded,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                    tooltip: '편집',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyle.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
