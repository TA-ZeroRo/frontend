import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';

/// Expandable FAB widget that displays a menu with three action items
///
/// Usage:
/// ```dart
/// ExpandableFab(
///   onPostCreate: () => print('Post creation'),
///   onCampaignRecruit: () => print('Campaign recruiting'),
///   onChallengeCreate: () => print('Challenge creation'),
/// )
/// ```
class ExpandableFab extends StatefulWidget {
  final VoidCallback onPostCreate;
  final VoidCallback onCampaignRecruit;
  final VoidCallback onChallengeCreate;
  final ValueChanged<bool>? onExpandedChanged;
  final VoidCallback? onOverlayTap;

  const ExpandableFab({
    super.key,
    required this.onPostCreate,
    required this.onCampaignRecruit,
    required this.onChallengeCreate,
    this.onExpandedChanged,
    this.onOverlayTap,
  });

  @override
  State<ExpandableFab> createState() => ExpandableFabState();
}

class ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.125, // 45 degrees (0.125 * 360 = 45)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      widget.onExpandedChanged?.call(_isExpanded);
    });
  }

  void close() {
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
        _controller.reverse();
        widget.onExpandedChanged?.call(false);
      });
    }
  }

  void _handleMenuItemTap(VoidCallback callback) {
    _toggle();
    // Delay callback to allow animation to complete
    Future.delayed(const Duration(milliseconds: 150), callback);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Menu item 3: Challenge Creation
        _buildMenuItem(
          icon: Icons.emoji_events,
          label: '챌린지 생성',
          onTap: () => _handleMenuItemTap(widget.onChallengeCreate),
          delay: 0,
        ),
        const SizedBox(height: 12),

        // Menu item 2: Campaign Recruiting
        _buildMenuItem(
          icon: Icons.group_add,
          label: '캠페인 크루팅',
          onTap: () => _handleMenuItemTap(widget.onCampaignRecruit),
          delay: 50,
        ),
        const SizedBox(height: 12),

        // Menu item 1: Post Creation
        _buildMenuItem(
          icon: Icons.edit,
          label: '게시글 작성',
          onTap: () => _handleMenuItemTap(widget.onPostCreate),
          delay: 100,
        ),
        const SizedBox(height: 16),

        // Main FAB button
        _buildMainFab(),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required int delay,
  }) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        final delayedAnimation = Interval(
          delay / 300,
          1.0,
          curve: Curves.easeOut,
        ).transform(_expandAnimation.value);

        return Transform.translate(
          offset: Offset(0, (1 - delayedAnimation) * 20),
          child: Opacity(
            opacity: delayedAnimation,
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 160,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: AppColors.primaryAccent,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: AppTextStyle.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainFab() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryAccent.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggle,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: _rotateAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotateAnimation.value * 2 * 3.14159, // Convert to radians
                  child: child,
                );
              },
              child: const Icon(
                Icons.add,
                color: AppColors.buttonTextColor,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
