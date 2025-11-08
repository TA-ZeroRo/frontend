/// Model for campaign
class Campaign {
  final String id;
  final String name;
  final String iconEmoji;
  final List<CampaignMissionItem> missions;

  const Campaign({
    required this.id,
    required this.name,
    required this.iconEmoji,
    required this.missions,
  });

  int get completedMissionsCount =>
      missions.where((m) => m.isCompleted).length;
  int get totalMissionsCount => missions.length;
  double get progressPercentage =>
      totalMissionsCount > 0 ? completedMissionsCount / totalMissionsCount : 0.0;
}

/// Model for campaign mission item
class CampaignMissionItem {
  final String id;
  final String campaignId;
  final String title;
  final int points;
  final bool isCompleted;
  final String category;

  const CampaignMissionItem({
    required this.id,
    required this.campaignId,
    required this.title,
    required this.points,
    required this.isCompleted,
    required this.category,
  });

  CampaignMissionItem copyWith({
    String? id,
    String? campaignId,
    String? title,
    int? points,
    bool? isCompleted,
    String? category,
  }) {
    return CampaignMissionItem(
      id: id ?? this.id,
      campaignId: campaignId ?? this.campaignId,
      title: title ?? this.title,
      points: points ?? this.points,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
    );
  }
}

/// Model for weekly attendance record
class WeeklyAttendance {
  final int consecutiveDays;
  final List<AttendanceDay> weekDays;

  const WeeklyAttendance({
    required this.consecutiveDays,
    required this.weekDays,
  });
}

/// Model for a single day's attendance
class AttendanceDay {
  final String dayName;
  final bool isAttended;
  final bool isToday;

  const AttendanceDay({
    required this.dayName,
    required this.isAttended,
    required this.isToday,
  });
}

/// Mock data for campaigns with grouped missions
final mockCampaigns = [
  Campaign(
    id: 'campaign_1',
    name: '제로웨이스트 챌린지',
    iconEmoji: '♻️',
    missions: [
      const CampaignMissionItem(
        id: 'mission_1',
        campaignId: 'campaign_1',
        title: '일회용품 사용 안하기',
        points: 50,
        isCompleted: true,
        category: 'plastic',
      ),
      const CampaignMissionItem(
        id: 'mission_2',
        campaignId: 'campaign_1',
        title: '대중교통 이용하기',
        points: 40,
        isCompleted: true,
        category: 'transport',
      ),
      const CampaignMissionItem(
        id: 'mission_3',
        campaignId: 'campaign_1',
        title: '텀블러 사용하기',
        points: 30,
        isCompleted: false,
        category: 'reusable',
      ),
      const CampaignMissionItem(
        id: 'mission_4',
        campaignId: 'campaign_1',
        title: '에코백 사용하기',
        points: 30,
        isCompleted: false,
        category: 'reusable',
      ),
    ],
  ),
  Campaign(
    id: 'campaign_2',
    name: '에너지 절약 실천',
    iconEmoji: '💡',
    missions: [
      const CampaignMissionItem(
        id: 'mission_5',
        campaignId: 'campaign_2',
        title: '전기 절약하기',
        points: 35,
        isCompleted: false,
        category: 'energy',
      ),
      const CampaignMissionItem(
        id: 'mission_6',
        campaignId: 'campaign_2',
        title: '분리수거 실천하기',
        points: 40,
        isCompleted: true,
        category: 'recycle',
      ),
    ],
  ),
  Campaign(
    id: 'campaign_3',
    name: '친환경 식생활',
    iconEmoji: '🥗',
    missions: [
      const CampaignMissionItem(
        id: 'mission_7',
        campaignId: 'campaign_3',
        title: '채식 한 끼 먹기',
        points: 45,
        isCompleted: false,
        category: 'food',
      ),
    ],
  ),
];

/// Mock data for weekly attendance
final mockWeeklyAttendance = WeeklyAttendance(
  consecutiveDays: 3,
  weekDays: [
    const AttendanceDay(dayName: '월', isAttended: true, isToday: false),
    const AttendanceDay(dayName: '화', isAttended: true, isToday: false),
    const AttendanceDay(dayName: '수', isAttended: true, isToday: true),
    const AttendanceDay(dayName: '목', isAttended: false, isToday: false),
    const AttendanceDay(dayName: '금', isAttended: false, isToday: false),
    const AttendanceDay(dayName: '토', isAttended: false, isToday: false),
    const AttendanceDay(dayName: '일', isAttended: false, isToday: false),
  ],
);
