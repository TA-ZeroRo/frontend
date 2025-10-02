class RankingItem {
  final String userId;
  final String username;
  final int totalPoints;
  final String? userImg;

  const RankingItem({
    required this.userId,
    required this.username,
    required this.totalPoints,
    this.userImg,
  });
}

// Mock 데이터
final mockRankings = [
  const RankingItem(
    userId: '1',
    username: '플레이어1',
    totalPoints: 1000,
    userImg: null,
  ),
  const RankingItem(
    userId: '2',
    username: '플레이어2',
    totalPoints: 950,
    userImg: null,
  ),
  const RankingItem(
    userId: '3',
    username: '플레이어3',
    totalPoints: 900,
    userImg: null,
  ),
  const RankingItem(
    userId: '4',
    username: '플레이어4',
    totalPoints: 850,
    userImg: null,
  ),
  const RankingItem(
    userId: '5',
    username: '플레이어5',
    totalPoints: 800,
    userImg: null,
  ),
  const RankingItem(
    userId: '6',
    username: '플레이어6',
    totalPoints: 750,
    userImg: null,
  ),
  const RankingItem(
    userId: '7',
    username: '플레이어7',
    totalPoints: 700,
    userImg: null,
  ),
  const RankingItem(
    userId: '8',
    username: '플레이어8',
    totalPoints: 650,
    userImg: null,
  ),
  const RankingItem(
    userId: '9',
    username: '플레이어9',
    totalPoints: 600,
    userImg: null,
  ),
  const RankingItem(
    userId: '10',
    username: '플레이어10',
    totalPoints: 550,
    userImg: null,
  ),
];
