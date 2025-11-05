import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Reusable shimmer box widget
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}

/// Shimmer placeholder for MyRankTile - matches the exact design
class MyRankTileShimmer extends StatelessWidget {
  const MyRankTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: const Duration(milliseconds: 1500),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Trophy icon placeholder
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: const ShimmerBox(
                  width: 24,
                  height: 24,
                  borderRadius: BorderRadius.zero,
                ),
              ),
              const SizedBox(width: 12),
              // Left section (내 순위 + rank)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      width: 50,
                      height: 12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    const SizedBox(height: 2),
                    ShimmerBox(
                      width: 40,
                      height: 20,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                ),
              ),
              // Right section (name + score)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ShimmerBox(
                    width: 60,
                    height: 14,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 2),
                  ShimmerBox(
                    width: 50,
                    height: 16,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shimmer placeholder for activity cards
class ActivityCardShimmer extends StatelessWidget {
  const ActivityCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      period: const Duration(milliseconds: 1500),
      child: Row(
        children: [
          Expanded(child: _buildSingleCardShimmer()),
          const SizedBox(width: 16),
          Expanded(child: _buildSingleCardShimmer()),
        ],
      ),
    );
  }

  Widget _buildSingleCardShimmer() {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon placeholder
            ShimmerBox(
              width: 60,
              height: 60,
              borderRadius: BorderRadius.circular(16),
            ),
            const SizedBox(height: 10),
            // Title placeholder
            ShimmerBox(
              width: 80,
              height: 16,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 8),
            // Subtitle placeholder
            ShimmerBox(
              width: 100,
              height: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 8),
            // Points badge placeholder
            ShimmerBox(
              width: 60,
              height: 24,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
      ),
    );
  }
}

/// Complete page shimmer layout (leaderboard section with header)
class PlaygroundShimmer extends StatelessWidget {
  const PlaygroundShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header (static, no shimmer)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: Color(0xFFFFD700),
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  '리더보드',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.expand_more_rounded,
                  color: Colors.grey[700],
                  size: 24,
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          // MyRankTile shimmer only
          const MyRankTileShimmer(),
        ],
      ),
    );
  }
}
