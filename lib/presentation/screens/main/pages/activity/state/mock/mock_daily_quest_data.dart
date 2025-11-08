/// Model for daily quest item
class DailyQuestItem {
  final String id;
  final String title;
  final int points;
  final bool isCompleted;
  final String category;

  const DailyQuestItem({
    required this.id,
    required this.title,
    required this.points,
    required this.isCompleted,
    required this.category,
  });

  DailyQuestItem copyWith({
    String? id,
    String? title,
    int? points,
    bool? isCompleted,
    String? category,
  }) {
    return DailyQuestItem(
      id: id ?? this.id,
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

/// Mock data for daily quests
final mockDailyQuests = [
  const DailyQuestItem(
    id: 'quest_1',
    title: '일회용품 사용 안하기',
    points: 50,
    isCompleted: true,
    category: 'plastic',
  ),
  const DailyQuestItem(
    id: 'quest_2',
    title: '대중교통 이용하기',
    points: 40,
    isCompleted: true,
    category: 'transport',
  ),
  const DailyQuestItem(
    id: 'quest_3',
    title: '텀블러 사용하기',
    points: 30,
    isCompleted: false,
    category: 'reusable',
  ),
  const DailyQuestItem(
    id: 'quest_4',
    title: '에코백 사용하기',
    points: 30,
    isCompleted: false,
    category: 'reusable',
  ),
  const DailyQuestItem(
    id: 'quest_5',
    title: '전기 절약하기',
    points: 35,
    isCompleted: false,
    category: 'energy',
  ),
  const DailyQuestItem(
    id: 'quest_6',
    title: '분리수거 실천하기',
    points: 40,
    isCompleted: false,
    category: 'recycle',
  ),
  const DailyQuestItem(
    id: 'quest_7',
    title: '채식 한 끼 먹기',
    points: 45,
    isCompleted: false,
    category: 'food',
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
