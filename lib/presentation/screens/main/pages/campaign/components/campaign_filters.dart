import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/theme/app_color.dart';
import '../state/mock/mock_campaign_data.dart';

class CampaignFilters extends StatefulWidget {
  final String selectedRegion;
  final String selectedCity;
  final String selectedCategory;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<String> onRegionChanged;
  final ValueChanged<String> onCityChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;
  final VoidCallback onResetFilters;

  const CampaignFilters({
    super.key,
    required this.selectedRegion,
    required this.selectedCity,
    required this.selectedCategory,
    this.startDate,
    this.endDate,
    required this.onRegionChanged,
    required this.onCityChanged,
    required this.onCategoryChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onResetFilters,
  });

  @override
  State<CampaignFilters> createState() => _CampaignFiltersState();
}

class _CampaignFiltersState extends State<CampaignFilters> {
  /// 현재 확장된 필터 ('region', 'category', 'date', null)
  String? _expandedFilter;

  /// 필터 토글
  void _toggleFilter(String filter) {
    setState(() {
      _expandedFilter = _expandedFilter == filter ? null : filter;
    });
  }

  /// 지역 필터 값 표시
  String get _regionText {
    if (widget.selectedRegion == '전체') return '지역';
    if (widget.selectedCity == '전체') return widget.selectedRegion;
    return '${widget.selectedRegion}·${widget.selectedCity}';
  }

  /// 카테고리 필터 값 표시
  String get _categoryText {
    return widget.selectedCategory == '전체' ? '카테고리' : widget.selectedCategory;
  }

  /// 기간 필터 값 표시
  String get _dateText {
    if (widget.startDate == null || widget.endDate == null) return '기간';
    final formatter = DateFormat('M/d');
    return '${formatter.format(widget.startDate!)}~${formatter.format(widget.endDate!)}';
  }

  /// 필터 활성 상태 확인
  bool get _isRegionActive => widget.selectedRegion != '전체';
  bool get _isCategoryActive => widget.selectedCategory != '전체';
  bool get _isDateActive => widget.startDate != null && widget.endDate != null;
  bool get _isAnyFilterActive =>
      _isRegionActive || _isCategoryActive || _isDateActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 필터 버튼 Row
        Row(
          children: [
            Expanded(
              child: _FilterButton(
                label: _regionText,
                isActive: _isRegionActive,
                isExpanded: _expandedFilter == 'region',
                onTap: () => _toggleFilter('region'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _FilterButton(
                label: _categoryText,
                isActive: _isCategoryActive,
                isExpanded: _expandedFilter == 'category',
                onTap: () => _toggleFilter('category'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _FilterButton(
                label: _dateText,
                isActive: _isDateActive,
                isExpanded: _expandedFilter == 'date',
                onTap: () => _toggleFilter('date'),
              ),
            ),
            const SizedBox(width: 8),
            // 필터 초기화 버튼
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isAnyFilterActive ? widget.onResetFilters : null,
                borderRadius: BorderRadius.circular(12),
                splashColor: AppColors.primary.withValues(alpha: 0.1),
                highlightColor: AppColors.primary.withValues(alpha: 0.05),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _isAnyFilterActive
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : Colors.white.withValues(alpha: 0.7),
                    border: Border.all(
                      color: _isAnyFilterActive
                          ? AppColors.primary
                          : AppColors.textTertiary.withValues(alpha: 0.25),
                      width: _isAnyFilterActive ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
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

        // 확장 컨테이너
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

  /// 확장 컨텐츠 빌드
  Widget _buildExpandedContent() {
    switch (_expandedFilter) {
      case 'region':
        return _buildRegionContent();
      case 'category':
        return _buildCategoryContent();
      case 'date':
        return _buildDateContent();
      default:
        return const SizedBox.shrink();
    }
  }

  /// 지역 필터 컨텐츠
  Widget _buildRegionContent() {
    final cities = widget.selectedRegion == '전체'
        ? ['전체']
        : (citiesByRegion[widget.selectedRegion] ?? ['전체']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 지역(도)
        Text(
          '지역(도)',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
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
                // 선택된 지역의 첫 번째 시로 초기화
                final firstCity = citiesByRegion[region]?.first ?? '전체';
                widget.onCityChanged(firstCity);
              }
            });
          }).toList(),
        ),

        const SizedBox(height: 16),

        // 시/구
        Text(
          '시/구',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: cities.map((city) {
            final enabled = widget.selectedRegion != '전체';
            return _buildChip(city, widget.selectedCity == city, () {
              if (enabled) {
                widget.onCityChanged(city);
              }
            }, enabled: enabled);
          }).toList(),
        ),
      ],
    );
  }

  /// 카테고리 필터 컨텐츠
  Widget _buildCategoryContent() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        return _buildChip(
          category,
          widget.selectedCategory == category,
          () => widget.onCategoryChanged(category),
        );
      }).toList(),
    );
  }

  /// 기간 필터 컨텐츠
  Widget _buildDateContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 시작일 선택
        _buildDateSelector(
          '시작일',
          widget.startDate,
          (date) => widget.onStartDateChanged(date),
        ),
        const SizedBox(height: 12),
        // 종료일 선택
        _buildDateSelector(
          '종료일',
          widget.endDate,
          (date) => widget.onEndDateChanged(date),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// 날짜 선택 위젯
  Widget _buildDateSelector(
    String label,
    DateTime? selectedDate,
    ValueChanged<DateTime?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2025, 1, 1),
              lastDate: DateTime(2026, 12, 31),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.primary,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              onChanged(date);
            }
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
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: selectedDate == null
                      ? AppColors.textTertiary
                      : AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  selectedDate == null
                      ? '선택하세요'
                      : DateFormat('yyyy-MM-dd').format(selectedDate),
                  style: TextStyle(
                    color: selectedDate == null
                        ? AppColors.textTertiary
                        : AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: selectedDate == null
                        ? FontWeight.w400
                        : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 칩 위젯
  Widget _buildChip(
    String label,
    bool isSelected,
    VoidCallback onTap, {
    bool enabled = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(18),
        splashColor: AppColors.primary.withValues(alpha: 0.2),
        highlightColor: AppColors.primary.withValues(alpha: 0.1),
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
                        : AppColors.textTertiary.withValues(alpha: 0.3))
                  : AppColors.textTertiary.withValues(alpha: 0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
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
      ),
    );
  }
}

/// 필터 버튼 위젯
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        highlightColor: AppColors.primary.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.7),
            border: Border.all(
              color: isActive
                  ? AppColors.primary
                  : AppColors.textTertiary.withValues(alpha: 0.25),
              width: isActive ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 활성 상태 dot
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
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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
      ),
    );
  }
}
