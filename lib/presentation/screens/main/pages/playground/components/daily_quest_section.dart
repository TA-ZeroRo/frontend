import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/daily_quest_controller.dart';
import '../state/mock/mock_daily_quest_data.dart';

/// Daily quest section with attendance tracker and quest list
class DailyQuestSection extends ConsumerWidget {
  const DailyQuestSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questState = ref.watch(dailyQuestProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _AttendanceTracker(attendance: questState.attendance),
                const SizedBox(height: 20),
                _QuestList(quests: questState.quests),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.assignment_turned_in_rounded,
            color: Color(0xFF4A90E2),
            size: 24,
          ),
          const SizedBox(width: 8),
          const Text(
            '일일 퀘스트',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

/// Attendance tracker widget showing consecutive days and weekly calendar
class _AttendanceTracker extends StatelessWidget {
  final WeeklyAttendance attendance;

  const _AttendanceTracker({required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE5B4), Color(0xFFFFD89B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD89B).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🔥',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
              Text(
                '${attendance.consecutiveDays}일 연속 출석',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF5D4037),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: attendance.weekDays.map((day) {
              return _AttendanceDayCircle(day: day);
            }).toList(),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '활동 인증을 완료하면 출석으로 인정돼요',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF666666),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Single day circle in attendance tracker
class _AttendanceDayCircle extends StatelessWidget {
  final AttendanceDay day;

  const _AttendanceDayCircle({required this.day});

  @override
  Widget build(BuildContext context) {
    final isActive = day.isAttended || day.isToday;

    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: day.isAttended
                ? const Color(0xFF4CAF50)
                : day.isToday
                    ? Colors.white
                    : Colors.white.withOpacity(0.6),
            shape: BoxShape.circle,
            border: Border.all(
              color: day.isToday
                  ? const Color(0xFF5D4037)
                  : Colors.transparent,
              width: 2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: (day.isAttended
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFF5D4037))
                          .withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: day.isAttended
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : Text(
                    day.dayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: day.isToday
                          ? const Color(0xFF5D4037)
                          : const Color(0xFF999999),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

/// Quest list widget
class _QuestList extends ConsumerWidget {
  final List<DailyQuestItem> quests;

  const _QuestList({required this.quests});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '오늘의 미션',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                final completedCount = ref.watch(completedQuestCountProvider);
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$completedCount/${quests.length} 완료',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A90E2),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...quests.map((quest) => _QuestItem(quest: quest)),
      ],
    );
  }
}

/// Individual quest item widget
class _QuestItem extends ConsumerStatefulWidget {
  final DailyQuestItem quest;

  const _QuestItem({required this.quest});

  @override
  ConsumerState<_QuestItem> createState() => _QuestItemState();
}

class _QuestItemState extends ConsumerState<_QuestItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        ref
            .read(dailyQuestProvider.notifier)
            .toggleQuestCompletion(widget.quest.id);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.quest.isCompleted
                ? const Color(0xFF4CAF50).withOpacity(0.1)
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.quest.isCompleted
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFE0E0E0),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: widget.quest.isCompleted
                      ? const Color(0xFF4CAF50)
                      : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.quest.isCompleted
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFBDBDBD),
                    width: 2,
                  ),
                ),
                child: widget.quest.isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.quest.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: widget.quest.isCompleted
                        ? const Color(0xFF666666)
                        : Colors.black87,
                    decoration: widget.quest.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: widget.quest.isCompleted
                      ? const Color(0xFF4CAF50).withOpacity(0.2)
                      : const Color(0xFF74CD7C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+${widget.quest.points}pt',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: widget.quest.isCompleted
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF74CD7C),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
