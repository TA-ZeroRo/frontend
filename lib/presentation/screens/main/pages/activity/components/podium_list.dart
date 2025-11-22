import 'package:flutter/material.dart';

import '../../../../../../domain/model/leaderboard/leaderboard_entry.dart';

/// 애니메이션 설정 상수
const _kSlideDuration = Duration(milliseconds: 1500);
const _kSlideCurve = Curves.easeOutQuart;

class PodiumList extends StatefulWidget {
  const PodiumList({super.key, required this.top3, this.height = 220.0});
  final List<LeaderboardEntry> top3;
  final double height;

  @override
  State<PodiumList> createState() => _PodiumListState();
}

class _PodiumListState extends State<PodiumList>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // 메인 애니메이션 컨트롤러 (동시 슬라이드)
    _animationController = AnimationController(
      duration: _kSlideDuration,
      vsync: this,
    );

    // 애니메이션 시작 (다음 프레임에서)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.top3.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: Text('리더보드 데이터가 부족합니다.')),
      );
    }

    final heightRatio = widget.height / 220.0;
    final profileSize = (50 * heightRatio).clamp(30.0, 50.0);

    // 3등, 1등, 2등 순서 (3명이면)
    final List<int> order = [2, 0, 1];

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SizedBox(
          height: widget.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              (widget.top3.length > 3) ? 3 : widget.top3.length,
              (i) {
                int idx = (widget.top3.length == 1)
                    ? 0
                    : (widget.top3.length == 2 ? i : order[i]);

                // Rank logic: idx 0 is 1st place
                int rank = idx + 1;

                return _buildPodiumItem(
                  user: widget.top3[idx],
                  rank: rank,
                  profileSize: profileSize,
                  heightRatio: heightRatio,
                  animationValue: _animationController.value,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildPodiumItem({
    required LeaderboardEntry user,
    required int rank,
    required double profileSize,
    required double heightRatio,
    required double animationValue,
  }) {
    // Rank 1 (Gold), 2 (Silver), 3 (Bronze) logic for height
    double heightFactor;
    if (rank == 1) {
      heightFactor = 0.75;
    } else if (rank == 2) {
      heightFactor = 0.55;
    } else {
      heightFactor = 0.40;
    }

    final maxBarHeight = widget.height * heightFactor;

    // Border radius를 고려한 최소 높이 설정 (overflow 방지)
    const minBarHeight = 12.0;

    // Apply curve
    final curvedValue = _kSlideCurve.transform(animationValue);
    // 최소 높이부터 최대 높이까지 애니메이션
    final currentBarHeight =
        minBarHeight + (maxBarHeight - minBarHeight) * curvedValue;

    final fontSize = (14 * heightRatio).clamp(10.0, 14.0);
    final padding = (8 * heightRatio).clamp(4.0, 8.0);

    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Bar
            Container(
              height: currentBarHeight,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(112, 127, 195, 251),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              alignment: Alignment.center,
              child: Opacity(
                opacity: curvedValue > 0.3 ? 1.0 : 0.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: Text(
                        user.username ?? '알 수 없음',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${user.totalPoints}',
                      style: TextStyle(
                        fontSize: fontSize * 0.9,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Profile Image (애니메이션 완료 후 페이드인)
            if (curvedValue > 0.85)
              Positioned(
                bottom: currentBarHeight - (profileSize / 2),
                child: Opacity(
                  opacity: ((curvedValue - 0.85) / 0.15).clamp(0.0, 1.0),
                  child: _buildProfileImage(user, profileSize),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(LeaderboardEntry user, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: user.userImg != null && user.userImg!.isNotEmpty
            ? Image.network(
                user.userImg!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholder(size),
              )
            : _buildPlaceholder(size),
      ),
    );
  }

  Widget _buildPlaceholder(double size) {
    return Container(
      color: Colors.grey[300],
      child: Icon(Icons.person, size: size * 0.6, color: Colors.white),
    );
  }
}
