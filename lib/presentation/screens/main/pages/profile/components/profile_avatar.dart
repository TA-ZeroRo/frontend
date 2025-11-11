import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_color.dart';

/// 프로필 이미지를 표시하는 재사용 가능한 위젯
///
/// 이미지 URL이 없을 경우 기본 아바타 아이콘을 표시합니다.
class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final Color backgroundColor;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.size = 80,
    this.backgroundColor = AppColors.cardBackground,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: AppColors.onPrimary.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.onPrimary.withValues(alpha: 0.5),
                      ),
                    ),
                  );
                },
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: backgroundColor,
      child: Icon(
        Icons.person,
        size: size * 0.6,
        color: AppColors.onPrimary.withValues(alpha: 0.5),
      ),
    );
  }
}
