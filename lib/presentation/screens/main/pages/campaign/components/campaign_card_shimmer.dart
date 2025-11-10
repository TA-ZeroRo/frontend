import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// 캠페인 카드 Shimmer 위젯
///
/// 로딩 중일 때 표시되는 Shimmer 효과가 적용된 카드입니다.
class CampaignCardShimmer extends StatelessWidget {
  const CampaignCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      period: const Duration(milliseconds: 1500),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
