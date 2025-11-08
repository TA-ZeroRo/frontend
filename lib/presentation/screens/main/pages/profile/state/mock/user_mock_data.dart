/// 프로필 페이지 전용 사용자 Mock 데이터 클래스
class ProfileUser {
  final String id;
  final String username;
  final String? userImg;
  final int totalPoints;
  final int continuousDays;
  final String region;
  final List<String> characters;
  final DateTime? lastActiveAt;
  final DateTime createdAt;

  const ProfileUser({
    required this.id,
    required this.username,
    this.userImg,
    required this.totalPoints,
    required this.continuousDays,
    required this.region,
    required this.characters,
    this.lastActiveAt,
    required this.createdAt,
  });

  ProfileUser copyWith({
    String? id,
    String? username,
    String? userImg,
    int? totalPoints,
    int? continuousDays,
    String? region,
    List<String>? characters,
    DateTime? lastActiveAt,
    DateTime? createdAt,
  }) {
    return ProfileUser(
      id: id ?? this.id,
      username: username ?? this.username,
      userImg: userImg ?? this.userImg,
      totalPoints: totalPoints ?? this.totalPoints,
      continuousDays: continuousDays ?? this.continuousDays,
      region: region ?? this.region,
      characters: characters ?? this.characters,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Mock 데이터 생성
  static ProfileUser getMockUser() {
    return ProfileUser(
      id: 'user_001',
      username: '환경지킴이',
      userImg: null,
      totalPoints: 1250,
      continuousDays: 15,
      region: '서울특별시 강남구',
      characters: [],
      lastActiveAt: DateTime.now(),
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    );
  }
}
