import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';

class LikeButton extends StatefulWidget {
  final int initialCount;
  final Function(bool isLiked, int likeCount)? onLikeToggle;

  const LikeButton({super.key, this.initialCount = 0, this.onLikeToggle});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with SingleTickerProviderStateMixin {
  bool isLiked = false;
  late int likeCount;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    likeCount = widget.initialCount;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleLike() {
    setState(() {
      if (isLiked) {
        likeCount--;
      } else {
        likeCount++;
        _animationController.forward().then((_) => _animationController.reverse());
      }
      isLiked = !isLiked;
    });

    // Call callback function
    if (widget.onLikeToggle != null) {
      widget.onLikeToggle!(isLiked, likeCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: toggleLike,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? AppColors.likeActive : AppColors.likeInactive,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$likeCount',
                  style: AppTextStyle.labelMedium.copyWith(
                    color: isLiked ? AppColors.likeActive : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
