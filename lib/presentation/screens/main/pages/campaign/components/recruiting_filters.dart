import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/theme/app_color.dart';
import '../models/campaign_data.dart'; // regions, citiesByRegion 재사용

class RecruitingFilters extends StatefulWidget {
  final String selectedRegion;
  final String selectedCity;
  final int? minCapacity;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? minAge;
  final int? maxAge;
  final ValueChanged<String> onRegionChanged;
  final ValueChanged<String> onCityChanged;
  final ValueChanged<int?> onCapacityChanged;
  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;
  final Function(int?, int?) onAgeChanged;
  final VoidCallback onResetFilters;

  const RecruitingFilters({
    super.key,
    required this.selectedRegion,
    required this.selectedCity,
    this.minCapacity,
    this.startDate,
    this.endDate,
    this.minAge,
    this.maxAge,
    required this.onRegionChanged,
    required this.onCityChanged,
    required this.onCapacityChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onAgeChanged,
    required this.onResetFilters,
  });

  @override
  State<RecruitingFilters> createState() => _RecruitingFiltersState();
}

class _RecruitingFiltersState extends State<RecruitingFilters> {
  String? _expandedFilter;

  void _toggleFilter(String filter) {
    setState(() {
      _expandedFilter = _expandedFilter == filter ? null : filter;
    });
  }

  String get _regionText {
    if (widget.selectedRegion == '전체') return '지역';
    if (widget.selectedCity == '전체') return widget.selectedRegion;
    return '${widget.selectedRegion}·${widget.selectedCity}';
  }

  String get _capacityText {
    return widget.minCapacity == null ? '인원' : '${widget.minCapacity}명 이상';
  }

  String get _dateText {
    if (widget.startDate == null || widget.endDate == null) return '날짜';
    final formatter = DateFormat('M/d');
    return '${formatter.format(widget.startDate!)}~${formatter.format(widget.endDate!)}';
  }

  String get _ageText {
    if (widget.minAge == null && widget.maxAge == null) return '나이';
    if (widget.minAge == 0 && widget.maxAge == 0) return '무관';
    return '${widget.minAge ?? 0}~${widget.maxAge ?? 100}세';
  }

  bool get _isRegionActive => widget.selectedRegion != '전체';
  bool get _isCapacityActive => widget.minCapacity != null;
  bool get _isDateActive => widget.startDate != null && widget.endDate != null;
  bool get _isAgeActive => widget.minAge != null || widget.maxAge != null;
  bool get _isAnyFilterActive =>
      _isRegionActive || _isCapacityActive || _isDateActive || _isAgeActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterButton(
                label: _regionText,
                isActive: _isRegionActive,
                isExpanded: _expandedFilter == 'region',
                onTap: () => _toggleFilter('region'),
              ),
              const SizedBox(width: 8),
              _FilterButton(
                label: _capacityText,
                isActive: _isCapacityActive,
                isExpanded: _expandedFilter == 'capacity',
                onTap: () => _toggleFilter('capacity'),
              ),
              const SizedBox(width: 8),
              _FilterButton(
                label: _dateText,
                isActive: _isDateActive,
                isExpanded: _expandedFilter == 'date',
                onTap: () => _toggleFilter('date'),
              ),
              const SizedBox(width: 8),
              _FilterButton(
                label: _ageText,
                isActive: _isAgeActive,
                isExpanded: _expandedFilter == 'age',
                onTap: () => _toggleFilter('age'),
              ),
              const SizedBox(width: 8),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isAnyFilterActive ? widget.onResetFilters : null,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _isAnyFilterActive
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : Colors.white,
                      border: Border.all(
                        color: _isAnyFilterActive
                            ? AppColors.primary
                            : const Color(0xFFCCCCCC),
                        width: _isAnyFilterActive ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _isAnyFilterActive
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : Colors.black.withValues(alpha: 0.08),
                          blurRadius: _isAnyFilterActive ? 4 : 3,
                          offset: Offset(0, _isAnyFilterActive ? 2 : 1),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.refresh,
                      size: 20,
                      color: _isAnyFilterActive
                          ? AppColors.primary
                          : AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: _expandedFilter == null
              ? const SizedBox.shrink()
              : Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: _buildExpandedContent(),
                ),
        ),
      ],
    );
  }

  Widget _buildExpandedContent() {
    switch (_expandedFilter) {
      case 'region':
        return _buildRegionContent();
      case 'capacity':
        return _buildCapacityContent();
      case 'date':
        return _buildDateContent();
      case 'age':
        return _buildAgeContent();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRegionContent() {
    final cities = widget.selectedRegion == '전체'
        ? ['전체']
        : (citiesByRegion[widget.selectedRegion] ?? ['전체']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('지역(도)', style: _headerStyle),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: regions.map((region) {
            return _buildChip(region, widget.selectedRegion == region, () {
              widget.onRegionChanged(region);
              if (region == '전체') {
                widget.onCityChanged('전체');
              } else {
                final firstCity = citiesByRegion[region]?.first ?? '전체';
                widget.onCityChanged(firstCity);
              }
            });
          }).toList(),
        ),
        const SizedBox(height: 16),
        Text('시/구', style: _headerStyle),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: cities.map((city) {
            final enabled = widget.selectedRegion != '전체';
            return _buildChip(city, widget.selectedCity == city, () {
              if (enabled) widget.onCityChanged(city);
            }, enabled: enabled);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCapacityContent() {
    final capacities = [2, 4, 6, 8, 10];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('최소 모집 인원', style: _headerStyle),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: capacities.map((cap) {
            return _buildChip(
              '$cap명 이상',
              widget.minCapacity == cap,
              () => widget.onCapacityChanged(
                widget.minCapacity == cap ? null : cap,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDateSelector('시작일', widget.startDate, widget.onStartDateChanged),
        const SizedBox(height: 12),
        _buildDateSelector('종료일', widget.endDate, widget.onEndDateChanged),
      ],
    );
  }

  Widget _buildAgeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('나이 제한', style: _headerStyle),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildChip(
              '무관',
              widget.minAge == 0 && widget.maxAge == 0,
              () => widget.onAgeChanged(0, 0),
            ),
            _buildChip(
              '20대',
              widget.minAge == 20 && widget.maxAge == 29,
              () => widget.onAgeChanged(20, 29),
            ),
            _buildChip(
              '30대',
              widget.minAge == 30 && widget.maxAge == 39,
              () => widget.onAgeChanged(30, 39),
            ),
            // 더 많은 옵션 추가 가능
          ],
        ),
      ],
    );
  }

  Widget _buildDateSelector(
    String label,
    DateTime? selectedDate,
    ValueChanged<DateTime?> onChanged,
  ) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2026, 12, 31),
        );
        if (date != null) onChanged(date);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: selectedDate == null
                ? AppColors.textTertiary.withValues(alpha: 0.3)
                : AppColors.primary.withValues(alpha: 0.5),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textSecondary)),
            Text(
              selectedDate == null
                  ? '선택'
                  : DateFormat('yyyy-MM-dd').format(selectedDate),
              style: TextStyle(
                color: selectedDate == null
                    ? AppColors.textTertiary
                    : AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(
    String label,
    bool isSelected,
    VoidCallback onTap, {
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: enabled
              ? (isSelected ? AppColors.primary : Colors.white)
              : Colors.white.withValues(alpha: 0.5),
          border: Border.all(
            color: enabled
                ? (isSelected
                      ? AppColors.primary
                      : const Color(0xFFCCCCCC))
                : AppColors.textTertiary.withValues(alpha: 0.2),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.25)
                        : Colors.black.withValues(alpha: 0.06),
                    blurRadius: isSelected ? 4 : 2,
                    offset: Offset(0, isSelected ? 2 : 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: enabled
                ? (isSelected ? Colors.white : AppColors.textPrimary)
                : AppColors.textTertiary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  final TextStyle _headerStyle = const TextStyle(
    color: AppColors.textPrimary,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isExpanded;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.isActive,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.white,
          border: Border.all(
            color: isActive
                ? AppColors.primary
                : const Color(0xFFCCCCCC),
            width: isActive ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: isActive ? 4 : 3,
              offset: Offset(0, isActive ? 2 : 1),
            ),
          ],
        ),
        child: Row(
          children: [
            if (isActive) ...[
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              size: 16,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
