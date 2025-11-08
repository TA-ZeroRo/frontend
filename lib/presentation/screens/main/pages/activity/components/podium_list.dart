import 'package:flutter/material.dart';
import '../state/mock/mock_ranking_data.dart';

class PodiumList extends StatefulWidget {
  const PodiumList({
    super.key,
    required this.top3,
    this.height = 200.0,
    this.shouldAnimate = true,
  });
  final List<RankingItem> top3;
  final double height;
  final bool shouldAnimate;

  @override
  State<PodiumList> createState() => _PodiumListState();
}

class _PodiumListState extends State<PodiumList>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _thirdPlaceAnimation;
  late Animation<double> _secondPlaceAnimation;
  late Animation<double> _firstPlaceAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
      value: widget.shouldAnimate ? 0.0 : 1.0,
    );

    _thirdPlaceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.4, curve: Curves.elasticOut),
      ),
    );

    _secondPlaceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.7, curve: Curves.elasticOut),
      ),
    );

    _firstPlaceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.7, 1.0, curve: Curves.elasticOut),
      ),
    );

    if (widget.shouldAnimate) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Animation<double> _getAnimation(int rank) {
    switch (rank) {
      case 1:
        return _firstPlaceAnimation;
      case 2:
        return _secondPlaceAnimation;
      case 3:
        return _thirdPlaceAnimation;
      default:
        return _firstPlaceAnimation;
    }
  }

  double _getTopSpacerFlex(int rank) {
    final heightRatio = widget.height / 220.0;
    switch (rank) {
      case 1:
        return 40 * heightRatio;
      case 2:
        return 50 * heightRatio;
      case 3:
        return 60 * heightRatio;
      default:
        return 40 * heightRatio;
    }
  }

  @override
  Widget build(BuildContext context) {
    final heightRatio = widget.height / 220.0;
    final profileSize = (50 * heightRatio).clamp(30.0, 50.0);

    if (widget.top3.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: Text('리더보드 데이터가 부족합니다.')),
      );
    }

    // 표시 순서: 3등(또는 2등), 1등, 2등(또는 3등)
    final List<RankingItem?> displayOrder = List.filled(3, null);
    if (widget.top3.length >= 1) displayOrder[1] = widget.top3[0]; // 1등은 중앙
    if (widget.top3.length >= 2) displayOrder[widget.top3.length == 2 ? 0 : 2] = widget.top3[1];
    if (widget.top3.length >= 3) displayOrder[0] = widget.top3[2]; // 3등은 왼쪽

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: widget.height,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (int i = 0; i < 3; i++)
                if (displayOrder[i] != null)
                  Expanded(
                    child: _buildPodiumItem(
                      user: displayOrder[i]!,
                      rank: displayOrder[i] == widget.top3[0]
                          ? 1
                          : displayOrder[i] == widget.top3[1]
                              ? 2
                              : 3,
                      animation: _getAnimation(
                        displayOrder[i] == widget.top3[0]
                            ? 1
                            : displayOrder[i] == widget.top3[1]
                                ? 2
                                : 3,
                      ),
                      profileSize: profileSize,
                      heightRatio: heightRatio,
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPodiumItem({
    required RankingItem user,
    required int rank,
    required Animation<double> animation,
    required double profileSize,
    required double heightRatio,
  }) {
    final fontSize = (14 * heightRatio).clamp(10.0, 14.0);
    final padding = (20 * heightRatio).clamp(8.0, 20.0);
    final topSpacerFlex = _getTopSpacerFlex(rank);

    return Transform.scale(
      scale: animation.value,
      child: Opacity(
        opacity: animation.value.clamp(0.0, 1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // 프로필 이미지
            ClipOval(
              child: user.userImg != null && user.userImg!.isNotEmpty
                  ? Image.network(
                      user.userImg!,
                      width: profileSize,
                      height: profileSize,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar(profileSize);
                      },
                    )
                  : _buildDefaultAvatar(profileSize),
            ),
            SizedBox(height: topSpacerFlex / 2),
            // 표시 영역
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: padding),
                color: const Color.fromARGB(112, 127, 195, 251),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.username,
                      style: TextStyle(fontSize: fontSize),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user.totalPoints.toString(),
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(double size) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[300],
      child: Icon(
        Icons.person,
        size: size * 0.6,
        color: Colors.white,
      ),
    );
  }
}
