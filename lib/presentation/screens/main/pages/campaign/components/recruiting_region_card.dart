import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/constants/regions.dart';

class RecruitingRegionCard extends StatefulWidget {
  final String? selectedRegion;
  final String? selectedCity;
  final ValueChanged<String?> onRegionChanged;
  final ValueChanged<String?> onCityChanged;
  final VoidCallback onToggle; // 다른 카드가 열릴 때 닫기 위함 (필요시)

  const RecruitingRegionCard({
    super.key,
    required this.selectedRegion,
    required this.selectedCity,
    required this.onRegionChanged,
    required this.onCityChanged,
    required this.onToggle,
  });

  @override
  State<RecruitingRegionCard> createState() => _RecruitingRegionCardState();
}

class _RecruitingRegionCardState extends State<RecruitingRegionCard> {
  bool _isProvinceExpanded = false;
  bool _isCityExpanded = false;

  void _toggleProvince() {
    setState(() {
      _isProvinceExpanded = !_isProvinceExpanded;
      if (_isProvinceExpanded) {
        _isCityExpanded = false;
        widget.onToggle(); // 부모에게 알림 (다른 확장 영역 닫기용)
      }
    });
  }

  void _toggleCity() {
    setState(() {
      _isCityExpanded = !_isCityExpanded;
      if (_isCityExpanded) {
        _isProvinceExpanded = false;
        widget.onToggle(); // 부모에게 알림
      }
    });
  }

  // 외부에서 닫기 요청이 올 때를 대비해 메소드 노출이 필요할 수 있으나,
  // 현재 구조에서는 부모가 상태를 직접 제어하지 않고 내부 상태로 둠.
  // 만약 다른 카드를 열 때 이걸 닫아야 한다면 GlobalKey나 부모 제어 방식이 필요함.
  // 여기서는 간단히 내부 상태로 관리하되, 부모가 리빌드될 때 닫히진 않게 함.

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 가이드 텍스트
          const Text(
            '활동 지역',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.textTertiary.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 6),
          // 시/도 및 시/구/군 선택 버튼
          Row(
            children: [
              Expanded(child: _buildProvinceButton()),
              const SizedBox(width: 8),
              Expanded(child: _buildCityButton()),
            ],
          ),
          // 시/도 확장 영역
          _buildProvinceExpansion(),
          // 시/구/군 확장 영역
          _buildCityExpansion(),
        ],
      ),
    );
  }

  /// 시/도 선택 버튼
  Widget _buildProvinceButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleProvince,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _getProvinceButtonColor(),
            border: Border.all(
              color: _getProvinceButtonBorderColor(),
              width: widget.selectedRegion != null ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.selectedRegion ?? '시/도',
                  style: TextStyle(
                    color: _getProvinceButtonTextColor(),
                    fontSize: 14,
                    fontWeight: widget.selectedRegion != null
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Icon(
                _isProvinceExpanded ? Icons.expand_less : Icons.expand_more,
                size: 16,
                color: _getProvinceButtonIconColor(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 시/구/군 선택 버튼
  Widget _buildCityButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.selectedRegion != null ? _toggleCity : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _getCityButtonColor(),
            border: Border.all(
              color: _getCityButtonBorderColor(),
              width: widget.selectedCity != null ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.selectedCity ?? '시/구/군',
                  style: TextStyle(
                    color: _getCityButtonTextColor(),
                    fontSize: 14,
                    fontWeight: widget.selectedCity != null
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Icon(
                _isCityExpanded ? Icons.expand_less : Icons.expand_more,
                size: 16,
                color: _getCityButtonIconColor(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 시/도 확장 영역
  Widget _buildProvinceExpansion() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: _isProvinceExpanded
          ? Container(
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
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: KoreanRegions.provinces.map((region) {
                  return _buildChip(region, widget.selectedRegion == region, () {
                    widget.onRegionChanged(region);
                    widget.onCityChanged(null); // 시/도 변경 시 시/구/군 초기화
                    setState(() {
                      _isProvinceExpanded = false;
                    });
                  });
                }).toList(),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  /// 시/구/군 확장 영역
  Widget _buildCityExpansion() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: _isCityExpanded
          ? Container(
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
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (KoreanRegions.cities[widget.selectedRegion!] ?? []).map((
                  city,
                ) {
                  return _buildChip(city, widget.selectedCity == city, () {
                    widget.onCityChanged(city);
                    setState(() {
                      _isCityExpanded = false;
                    });
                  });
                }).toList(),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  // 스타일링 헬퍼 메서드들

  Color _getProvinceButtonColor() {
    return widget.selectedRegion != null
        ? AppColors.primary.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.7);
  }

  Color _getProvinceButtonBorderColor() {
    return widget.selectedRegion != null
        ? AppColors.primary
        : AppColors.textTertiary.withValues(alpha: 0.25);
  }

  Color _getProvinceButtonTextColor() {
    return widget.selectedRegion != null
        ? AppColors.primary
        : AppColors.textTertiary;
  }

  Color _getProvinceButtonIconColor() {
    return widget.selectedRegion != null
        ? AppColors.primary
        : AppColors.textSecondary;
  }

  Color _getCityButtonColor() {
    if (widget.selectedCity != null) {
      return AppColors.primary.withValues(alpha: 0.12);
    }
    if (widget.selectedRegion != null) {
      return Colors.white.withValues(alpha: 0.7);
    }
    return Colors.white.withValues(alpha: 0.5);
  }

  Color _getCityButtonBorderColor() {
    if (widget.selectedCity != null) {
      return AppColors.primary;
    }
    if (widget.selectedRegion != null) {
      return AppColors.textTertiary.withValues(alpha: 0.25);
    }
    return AppColors.textTertiary.withValues(alpha: 0.15);
  }

  Color _getCityButtonTextColor() {
    if (widget.selectedCity != null) {
      return AppColors.primary;
    }
    if (widget.selectedRegion != null) {
      return AppColors.textTertiary;
    }
    return AppColors.textTertiary.withValues(alpha: 0.5);
  }

  Color _getCityButtonIconColor() {
    if (widget.selectedCity != null) {
      return AppColors.primary;
    }
    if (widget.selectedRegion != null) {
      return AppColors.textSecondary;
    }
    return AppColors.textSecondary.withValues(alpha: 0.5);
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

