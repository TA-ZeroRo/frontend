import 'package:flutter/material.dart';
import '../state/mock/mock_ranking_data.dart';

/// 애니메이션 설정 상수
const _kSlideDuration = Duration(milliseconds: 900);
const _kSlideCurve = Curves.easeOutCubic;
// SlideTransition은 자식 높이에 대한 비율로 이동하므로, 0.25는 대략 자식 높이의 25% 아래에서 시작을 의미
const double _kStartDy = 0.25;

class PodiumList extends StatefulWidget {
  const PodiumList({super.key, required this.top3, this.height = 220.0});
  final List<RankingItem> top3;
  final double height;

  @override
  State<PodiumList> createState() => _PodiumListState();
}

class _PodiumListState extends State<PodiumList> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // 메인 애니메이션 컨트롤러 (동시 슬라이드)
    _animationController = AnimationController(
      duration: _kSlideDuration,
      vsync: this,
    );

    // 아래에서 위로 동시에 슬라이드
    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, _kStartDy),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _animationController, curve: _kSlideCurve),
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
    final heightRatio = widget.height / 220.0;
    final profileSize = (50 * heightRatio).clamp(30.0, 50.0);

    if (widget.top3.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: Text('리더보드 데이터가 부족합니다.')),
      );
    }

    // top3 개수만큼만 표시 (1~3명)
    final List<Widget> podiumWidgets = [];
    final List<int> order = [2, 0, 1]; // 3등, 1등, 2등 순서
    for (int i = 0; i < widget.top3.length && i < 3; i++) {
      int idx = (widget.top3.length == 1)
          ? 0
          : (widget.top3.length == 2 ? i : order[i]);
      double topMargin = (idx == 0)
          ? 40 * heightRatio
          : (idx == 1 ? 50 * heightRatio : 60 * heightRatio);
      podiumWidgets.add(
        _buildAnimatedPodiumItem(
          user: widget.top3[idx],
          topMargin: topMargin,
          slideAnimation: _slideAnimation,
          profileSize: profileSize,
          rank: idx + 1,
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: widget.height,
      child: Row(children: podiumWidgets),
    );
  }

  Widget _buildAnimatedPodiumItem({
    required RankingItem user,
    required double topMargin,
    required Animation<Offset> slideAnimation,
    required double profileSize,
    required int rank,
  }) {
    final heightRatio = widget.height / 220.0;
    final fontSize = (14 * heightRatio).clamp(10.0, 14.0);
    final padding = (20 * heightRatio).clamp(8.0, 20.0);

    return Expanded(
      child: SlideTransition(
        position: slideAnimation,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: padding),
              margin: EdgeInsets.only(top: topMargin, bottom: 0),
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
            Positioned(
              top: topMargin / 2,
              left: 0,
              right: 0,
              child: Center(
                child: ClipOval(
                  child: user.userImg != null && user.userImg!.isNotEmpty
                      ? Image.network(
                          user.userImg!,
                          width: profileSize,
                          height: profileSize,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: profileSize,
                          height: profileSize,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: profileSize,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
