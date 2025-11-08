/// 프로필 페이지 전용 차트 Mock 데이터 클래스
class ProfileChartData {
  final DateTime date;
  final int score;

  const ProfileChartData({
    required this.date,
    required this.score,
  });

  /// Mock 차트 데이터 생성 (최근 7일)
  static List<ProfileChartData> getMockChartData() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      // 간단한 패턴의 점수 생성
      final scores = [50, 75, 60, 80, 65, 90, 70];
      return ProfileChartData(
        date: DateTime(date.year, date.month, date.day),
        score: scores[index],
      );
    });
  }
}
