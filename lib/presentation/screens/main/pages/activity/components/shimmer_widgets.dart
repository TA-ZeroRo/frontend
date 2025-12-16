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
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
            color: Colors.black.withValues(alpha: 0.05),
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

/// Shimmer for the "My Rank" section (Blue box style)
class MyRankSectionShimmer extends StatelessWidget {
  const MyRankSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!, width: 1.5),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.blue[100]!,
        highlightColor: Colors.blue[50]!,
        period: const Duration(milliseconds: 1500),
        child: Row(
          children: [
            // Rank circle
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 14),
            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 60,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            // Score badge
            Container(
              width: 70,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer for the main leaderboard content (Podium + Rank List)
class LeaderboardContentShimmer extends StatelessWidget {
  const LeaderboardContentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      period: const Duration(milliseconds: 1500),
      child: Column(
        children: [
          // Podium area
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPodiumBar(height: 140, width: 80), // 2nd
                const SizedBox(width: 8),
                _buildPodiumBar(height: 180, width: 90), // 1st
                const SizedBox(width: 8),
                _buildPodiumBar(height: 120, width: 80), // 3rd
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Rank list items
          ...List.generate(
            2,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumBar({required double height, required double width}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
    );
  }
}

/// Shimmer placeholder for attendance tracker
class AttendanceTrackerShimmer extends StatelessWidget {
  const AttendanceTrackerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFFFE5B4),
      highlightColor: const Color(0xFFFFD89B),
      period: const Duration(milliseconds: 1500),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            // Streak text
            ShimmerBox(
              width: 150,
              height: 24,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(height: 16),
            // Week day circles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                7,
                (index) => Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Info text
            ShimmerBox(
              width: 200,
              height: 28,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer placeholder for mission item
class MissionItemShimmer extends StatelessWidget {
  const MissionItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      period: const Duration(milliseconds: 1500),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ShimmerBox(
                width: double.infinity,
                height: 16,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 12),
            ShimmerBox(
              width: 50,
              height: 24,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      ),
    );
  }
}

/// Complete campaign mission section shimmer
class CampaignMissionSectionShimmer extends StatelessWidget {
  const CampaignMissionSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 섹션 헤더 (static, 실제 UI와 동일)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Transform.translate(
                offset: const Offset(0, -2),
                child: Image.asset(
                  'assets/images/file_icon.png',
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '캠페인 미션',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // 캠페인 카드 shimmer
        _buildCampaignCardShimmer(),
      ],
    );
  }

  Widget _buildCampaignCardShimmer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color(0xFFF5F5F5),
        period: const Duration(milliseconds: 1500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 캠페인 헤더
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 카테고리 배지
                  ShimmerBox(
                    width: 50,
                    height: 22,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 8),
                  // 캠페인 타이틀
                  ShimmerBox(
                    width: 180,
                    height: 24,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
            // 미션 리스트
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildMissionTileShimmer(),
                  const Divider(
                    height: 32,
                    thickness: 1,
                    color: Color(0xFFF5F5F5),
                  ),
                  _buildMissionTileShimmer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionTileShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header: 카테고리 배지 + 포인트 배지
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBox(
                width: 70,
                height: 22,
                borderRadius: BorderRadius.circular(6),
              ),
              ShimmerBox(
                width: 55,
                height: 22,
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
        ),
        // Body: 타이틀
        ShimmerBox(
          width: 200,
          height: 16,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 8),
        // Body: 설명 (2줄)
        ShimmerBox(
          width: double.infinity,
          height: 14,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 4),
        ShimmerBox(
          width: 250,
          height: 14,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 16),
        // Footer: 액션 버튼
        ShimmerBox(
          width: double.infinity,
          height: 45,
          borderRadius: BorderRadius.circular(16),
        ),
      ],
    );
  }
}
