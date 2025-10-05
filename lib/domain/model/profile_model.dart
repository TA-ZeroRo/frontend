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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Profile &&
        other.userId == userId &&
        other.username == username &&
        other.userImg == userImg &&
        other.totalPoints == totalPoints &&
        other.continuousDays == continuousDays;
  }

  @override
  int get hashCode =>
      Object.hash(userId, username, userImg, totalPoints, continuousDays);

  @override
  String toString() =>
      'Profile(userId: $userId, username: $username, userImg: $userImg, totalPoints: $totalPoints, continuousDays: $continuousDays)';
}
