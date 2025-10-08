class Profile {
  final String userId;
  final String username;
  final String? userImg;
  final int totalPoints;
  final int continuousDays;
  final DateTime? birthDate; // 생년월일 추가
  final String? region; // 지역 추가

  const Profile({
    required this.userId,
    required this.username,
    this.userImg,
    this.totalPoints = 0,
    this.continuousDays = 0,
    this.birthDate,
    this.region,
  });

  Profile copyWith({
    String? userId,
    String? username,
    String? userImg,
    int? totalPoints,
    int? continuousDays,
    DateTime? birthDate,
    String? region,
  }) {
    return Profile(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userImg: userImg ?? this.userImg,
      totalPoints: totalPoints ?? this.totalPoints,
      continuousDays: continuousDays ?? this.continuousDays,
      birthDate: birthDate ?? this.birthDate,
      region: region ?? this.region,
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
        other.continuousDays == continuousDays &&
        other.birthDate == birthDate &&
        other.region == region;
  }

  @override
  int get hashCode => Object.hash(
    userId,
    username,
    userImg,
    totalPoints,
    continuousDays,
    birthDate,
    region,
  );

  @override
  String toString() =>
      'Profile(userId: $userId, username: $username, userImg: $userImg, totalPoints: $totalPoints, continuousDays: $continuousDays, birthDate: $birthDate, region: $region)';
}
