/// 프로필 페이지 전용 주간보고서 Mock 데이터 클래스
class ProfileWeeklyReport {
  final String id;
  final String userId;
  final String username;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> campaignList;
  final int dailyMissionCompletedCount;
  final int totalDailyMissions;
  final int monthlyPointsEarned;
  final int? previousMonthPoints;
  final String? comparisonMessage;
  final String? recommendationMessage;
  final Map<String, int>? missionCategoryCounts;
  final DateTime createdAt;

  const ProfileWeeklyReport({
    required this.id,
    required this.userId,
    required this.username,
    required this.startDate,
    required this.endDate,
    required this.campaignList,
    required this.dailyMissionCompletedCount,
    required this.totalDailyMissions,
    required this.monthlyPointsEarned,
    this.previousMonthPoints,
    this.comparisonMessage,
    this.recommendationMessage,
    this.missionCategoryCounts,
    required this.createdAt,
  });

  ProfileWeeklyReport copyWith({
    String? id,
    String? userId,
    String? username,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? campaignList,
    int? dailyMissionCompletedCount,
    int? totalDailyMissions,
    int? monthlyPointsEarned,
    int? previousMonthPoints,
    String? comparisonMessage,
    String? recommendationMessage,
    Map<String, int>? missionCategoryCounts,
    DateTime? createdAt,
  }) {
    return ProfileWeeklyReport(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      campaignList: campaignList ?? this.campaignList,
      dailyMissionCompletedCount:
          dailyMissionCompletedCount ?? this.dailyMissionCompletedCount,
      totalDailyMissions: totalDailyMissions ?? this.totalDailyMissions,
      monthlyPointsEarned: monthlyPointsEarned ?? this.monthlyPointsEarned,
      previousMonthPoints: previousMonthPoints ?? this.previousMonthPoints,
      comparisonMessage: comparisonMessage ?? this.comparisonMessage,
      recommendationMessage:
          recommendationMessage ?? this.recommendationMessage,
      missionCategoryCounts:
          missionCategoryCounts ?? this.missionCategoryCounts,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// 미션 완료율 계산 (%)
  double get missionCompletionRate {
    if (totalDailyMissions == 0) return 0.0;
    return (dailyMissionCompletedCount / totalDailyMissions) * 100;
  }

  /// 저번달 대비 포인트 변화량
  int? get pointsDifference {
    if (previousMonthPoints == null) return null;
    return monthlyPointsEarned - previousMonthPoints!;
  }

  /// 보고서 기간 문자열 (YY-MM-DD ~ YY-MM-DD)
  String get periodString {
    final start = '${startDate.year.toString().substring(2)}-'
        '${startDate.month.toString().padLeft(2, '0')}-'
        '${startDate.day.toString().padLeft(2, '0')}';
    final end = '${endDate.year.toString().substring(2)}-'
        '${endDate.month.toString().padLeft(2, '0')}-'
        '${endDate.day.toString().padLeft(2, '0')}';
    return '$start ~ $end';
  }

  /// Mock 주간보고서 데이터 생성 (최근 3개월)
  static List<ProfileWeeklyReport> getMockWeeklyReports({
    required String userId,
    required String username,
  }) {
    final now = DateTime.now();
    final reports = <ProfileWeeklyReport>[];

    for (int i = 0; i < 3; i++) {
      final monthOffset = 2 - i; // 2개월 전부터 이번 달까지
      final month = now.month - monthOffset;
      final year = now.year + (month <= 0 ? -1 : 0);
      final adjustedMonth = month <= 0 ? 12 + month : month;

      final startDate = DateTime(year, adjustedMonth, 1);
      final endDate = DateTime(year, adjustedMonth + 1, 0, 23, 59, 59);

      // 월별 다른 데이터
      final monthlyData = _getMonthlyMockData(i);

      reports.add(ProfileWeeklyReport(
        id: 'monthly_${startDate.millisecondsSinceEpoch}',
        userId: userId,
        username: username,
        startDate: startDate,
        endDate: endDate,
        campaignList: monthlyData.campaigns,
        dailyMissionCompletedCount: monthlyData.completedMissions,
        totalDailyMissions: 30,
        monthlyPointsEarned: monthlyData.points,
        previousMonthPoints: i < 2 ? _getMonthlyMockData(i + 1).points : 0,
        missionCategoryCounts: monthlyData.categoryCounts,
        createdAt: startDate.add(const Duration(hours: 1)),
      ));
    }

    return reports.reversed.toList(); // 최신순으로 정렬
  }

  /// 월별 Mock 데이터 생성
  static _MonthlyMockData _getMonthlyMockData(int monthIndex) {
    switch (monthIndex) {
      case 0: // 이번 달
        return _MonthlyMockData(
          campaigns: ['한강 플로깅 챌린지', '30일 제로웨이스트 챌린지'],
          completedMissions: 22,
          points: 350,
          categoryCounts: {
            'ZERO_WASTE': 5,
            'TRANSPORTATION': 3,
            'RECYCLING': 14,
          },
        );
      case 1: // 1개월 전
        return _MonthlyMockData(
          campaigns: ['한강 플로깅 챌린지', '30일 제로웨이스트 챌린지'],
          completedMissions: 25,
          points: 450,
          categoryCounts: {
            'ZERO_WASTE': 6,
            'TRANSPORTATION': 5,
            'RECYCLING': 14,
          },
        );
      case 2: // 2개월 전
        return _MonthlyMockData(
          campaigns: ['일주일 비건 챌린지'],
          completedMissions: 18,
          points: 300,
          categoryCounts: {
            'ZERO_WASTE': 3,
            'TRANSPORTATION': 1,
            'RECYCLING': 14,
          },
        );
      default:
        return _MonthlyMockData(
          campaigns: [],
          completedMissions: 0,
          points: 0,
          categoryCounts: {},
        );
    }
  }
}

/// 월별 Mock 데이터 헬퍼 클래스
class _MonthlyMockData {
  final List<String> campaigns;
  final int completedMissions;
  final int points;
  final Map<String, int> categoryCounts;

  _MonthlyMockData({
    required this.campaigns,
    required this.completedMissions,
    required this.points,
    required this.categoryCounts,
  });
}
