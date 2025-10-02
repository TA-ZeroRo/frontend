class Profile {
  final String userId;
  final String username;
  final String? userImg;
  final int totalPoints;
  final int continuousDays;

  const Profile({
    required this.userId,
    required this.username,
    this.userImg,
    this.totalPoints = 0,
    this.continuousDays = 0,
  });

  Profile copyWith({
    String? userId,
    String? username,
    String? userImg,
    int? totalPoints,
    int? continuousDays,
  }) {
    return Profile(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userImg: userImg ?? this.userImg,
      totalPoints: totalPoints ?? this.totalPoints,
      continuousDays: continuousDays ?? this.continuousDays,
    );
  }
}
