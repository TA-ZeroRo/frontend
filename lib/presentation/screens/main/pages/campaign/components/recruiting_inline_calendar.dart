import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/theme/app_color.dart';

class RecruitingInlineCalendar extends StatefulWidget {
  const RecruitingInlineCalendar({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateChanged,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onDateChanged;

  @override
  State<RecruitingInlineCalendar> createState() => _RecruitingInlineCalendarState();
}

class _RecruitingInlineCalendarState extends State<RecruitingInlineCalendar> {
  late DateTime _displayedMonth;
  late DateTime _selectedDate;
  late DateTime _today;

  @override
  void initState() {
    super.initState();
    _today = _normalize(DateTime.now());
    _selectedDate = _clamp(_normalize(widget.initialDate));
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  @override
  void didUpdateWidget(covariant RecruitingInlineCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final clampedInitial = _clamp(_normalize(widget.initialDate));
    if (!_isSameDay(clampedInitial, _selectedDate)) {
      _selectedDate = clampedInitial;
    }
    if (oldWidget.initialDate != widget.initialDate) {
      _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = _generateCalendarDays();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 8),
        _buildWeekdayRow(),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: days.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final date = days[index];
            final isCurrentMonth = date.month == _displayedMonth.month;
            final isDisabled =
                date.isBefore(_normalize(widget.firstDate)) ||
                date.isAfter(_normalize(widget.lastDate));
            return _buildDayCell(date, isCurrentMonth, isDisabled);
          },
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final monthLabel = DateFormat('MMMM yyyy').format(_displayedMonth);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _canGoPreviousMonth ? _goToPreviousMonth : null,
          icon: const Icon(Icons.chevron_left),
          color: _canGoPreviousMonth
              ? AppColors.textPrimary
              : AppColors.textTertiary,
          visualDensity: VisualDensity.compact,
        ),
        Text(
          monthLabel,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        IconButton(
          onPressed: _canGoNextMonth ? _goToNextMonth : null,
          icon: const Icon(Icons.chevron_right),
          color: _canGoNextMonth
              ? AppColors.textPrimary
              : AppColors.textTertiary,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  Widget _buildWeekdayRow() {
    const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekdays
          .map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildDayCell(DateTime date, bool isCurrentMonth, bool isDisabled) {
    final isSelected = _isSameDay(date, _selectedDate);
    final isToday = _isSameDay(date, _today);

    Color textColor = AppColors.textPrimary;
    if (!isCurrentMonth || isDisabled) {
      textColor = AppColors.textTertiary;
    }
    if (isSelected) {
      textColor = Colors.white;
    } else if (isToday && !isDisabled) {
      textColor = AppColors.primary;
    }

    BoxDecoration? decoration;
    if (isSelected) {
      decoration = BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      );
    } else if (isToday && !isDisabled) {
      decoration = BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary, width: 1.2),
      );
    }

    return GestureDetector(
      onTap: isDisabled ? null : () => _handleSelect(date),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        decoration: decoration,
        alignment: Alignment.center,
        child: Text(
          '${date.day}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  void _handleSelect(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateChanged(date);
  }

  void _goToPreviousMonth() {
    if (!_canGoPreviousMonth) return;
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _goToNextMonth() {
    if (!_canGoNextMonth) return;
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  bool get _canGoPreviousMonth {
    final previousMonthEnd = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      0,
    );
    return !previousMonthEnd.isBefore(_normalize(widget.firstDate));
  }

  bool get _canGoNextMonth {
    final nextMonthStart = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      1,
    );
    return !nextMonthStart.isAfter(_normalize(widget.lastDate));
  }

  List<DateTime> _generateCalendarDays() {
    final firstOfMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      1,
    );
    final leading = firstOfMonth.weekday % 7;
    final startDate = firstOfMonth.subtract(Duration(days: leading));
    return List.generate(
      42,
      (index) =>
          DateTime(startDate.year, startDate.month, startDate.day + index),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime _clamp(DateTime date) {
    final first = _normalize(widget.firstDate);
    final last = _normalize(widget.lastDate);
    if (date.isBefore(first)) return first;
    if (date.isAfter(last)) return last;
    return date;
  }
}

