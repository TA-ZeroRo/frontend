import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/toast_helper.dart';
import '../../../../../core/constants/regions.dart';
import 'models/campaign_data.dart';
import 'components/recruiting_inline_calendar.dart';

/// 크루팅 작성 페이지
class RecruitingCreatePage extends StatefulWidget {
  final CampaignData campaign;

  const RecruitingCreatePage({super.key, required this.campaign});

  @override
  State<RecruitingCreatePage> createState() => _RecruitingCreatePageState();
}

class _RecruitingCreatePageState extends State<RecruitingCreatePage> {
  final _titleController = TextEditingController();
  final _capacityController = TextEditingController();

  String? _selectedRegion;
  String? _selectedCity;
  String? _selectedMinAge;
  String? _selectedMaxAge;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  /// 시/도 선택 펼침 상태
  bool _isProvinceExpanded = false;

  /// 시/구/군 선택 펼침 상태
  bool _isCityExpanded = false;

  /// 최소 나이 선택 펼침 상태
  bool _isMinAgeExpanded = false;

  /// 최대 나이 선택 펼침 상태
  bool _isMaxAgeExpanded = false;

  /// 시작일 달력 펼침 상태
  bool _isStartDateExpanded = false;

  /// 종료일 달력 펼침 상태
  bool _isEndDateExpanded = false;

  /// 나이 선택지 (10살 단위)
  static const List<String> _ageRanges = [
    '10대',
    '20대',
    '30대',
    '40대',
    '50대',
    '60대',
    '70대',
    '80대',
    '90대',
    '100대',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  /// 시/도 선택 토글
  void _toggleProvince() {
    setState(() {
      _isProvinceExpanded = !_isProvinceExpanded;
      if (_isProvinceExpanded) {
        _isCityExpanded = false;
        _isMinAgeExpanded = false;
        _isMaxAgeExpanded = false;
        _isStartDateExpanded = false;
        _isEndDateExpanded = false;
      }
    });
  }

  /// 시/구/군 선택 토글
  void _toggleCity() {
    setState(() {
      _isCityExpanded = !_isCityExpanded;
      if (_isCityExpanded) {
        _isProvinceExpanded = false;
        _isMinAgeExpanded = false;
        _isMaxAgeExpanded = false;
        _isStartDateExpanded = false;
        _isEndDateExpanded = false;
      }
    });
  }

  /// 최소 나이 선택 토글
  void _toggleMinAge() {
    setState(() {
      _isMinAgeExpanded = !_isMinAgeExpanded;
      if (_isMinAgeExpanded) {
        _isMaxAgeExpanded = false;
        _isProvinceExpanded = false;
        _isCityExpanded = false;
        _isStartDateExpanded = false;
        _isEndDateExpanded = false;
      }
    });
  }

  /// 최대 나이 선택 토글
  void _toggleMaxAge() {
    setState(() {
      _isMaxAgeExpanded = !_isMaxAgeExpanded;
      if (_isMaxAgeExpanded) {
        _isMinAgeExpanded = false;
        _isProvinceExpanded = false;
        _isCityExpanded = false;
        _isStartDateExpanded = false;
        _isEndDateExpanded = false;
      }
    });
  }

  /// 시작일 달력 토글
  void _toggleStartDate() {
    setState(() {
      _isStartDateExpanded = !_isStartDateExpanded;
      if (_isStartDateExpanded) {
        _isEndDateExpanded = false;
        _isProvinceExpanded = false;
        _isCityExpanded = false;
        _isMinAgeExpanded = false;
        _isMaxAgeExpanded = false;
      }
    });
  }

  /// 종료일 달력 토글
  void _toggleEndDate() {
    setState(() {
      _isEndDateExpanded = !_isEndDateExpanded;
      if (_isEndDateExpanded) {
        _isStartDateExpanded = false;
        _isProvinceExpanded = false;
        _isCityExpanded = false;
        _isMinAgeExpanded = false;
        _isMaxAgeExpanded = false;
      }
    });
  }

  /// 작성 완료
  void _handleSubmit() {
    // 제목 검사
    if (_titleController.text.trim().isEmpty) {
      ToastHelper.showError('제목을 입력해주세요');
      return;
    }

    // 모집인원 검사
    final capacityText = _capacityController.text.trim();
    if (capacityText.isEmpty) {
      ToastHelper.showError('모집인원을 입력해주세요');
      return;
    }
    final capacity = int.tryParse(capacityText);
    if (capacity == null || capacity < 1) {
      ToastHelper.showError('모집인원은 1명 이상이어야 합니다');
      return;
    }

    // 지역 검사
    if (_selectedRegion == null || _selectedCity == null) {
      ToastHelper.showError('지역을 선택해주세요');
      return;
    }

    // 나이조건 검사 (선택 사항)
    // 최소 나이만 선택한 경우 오류
    if (_selectedMinAge != null && _selectedMaxAge == null) {
      ToastHelper.showError('최대 나이를 선택해주세요');
      return;
    }

    // 둘 다 선택한 경우 유효성 검사
    if (_selectedMinAge != null && _selectedMaxAge != null) {
      final minIndex = _ageRanges.indexOf(_selectedMinAge!);
      final maxIndex = _ageRanges.indexOf(_selectedMaxAge!);
      if (minIndex > maxIndex) {
        ToastHelper.showError('최소 나이가 최대 나이보다 클 수 없습니다');
        return;
      }
    }

    // 크루팅 날짜 검사
    if (_selectedStartDate == null || _selectedEndDate == null) {
      ToastHelper.showError('크루팅 날짜를 선택해주세요');
      return;
    }

    if (_selectedStartDate!.isAfter(_selectedEndDate!)) {
      ToastHelper.showError('시작일이 종료일보다 늦을 수 없습니다');
      return;
    }

    // TODO: API 호출하여 크루팅 게시글 작성
    ToastHelper.showSuccess('크루팅 게시글이 작성되었습니다');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
          color: AppColors.onPrimary,
        ),
        title: Text(
          '크루팅 작성',
          style: AppTextStyle.titleLarge.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            children: [
              // 제목 섹션
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '제목',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildTitleCard(),
              const SizedBox(height: 15),
              // 모집 정보 섹션
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '모집 정보',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // 모집 인원 & 나이 조건 (가로 배치)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: _buildCapacityCard()),
                  const SizedBox(width: 12),
                  Expanded(flex: 2, child: _buildAgeCard()),
                ],
              ),
              _buildAgeExpansionArea(),
              const SizedBox(height: 15),
              // 활동 지역 카드
              _buildRegionCard(),
              const SizedBox(height: 15),
              // 크루팅 날짜 카드
              _buildDateCard(),
              const SizedBox(height: 30),
              // 작성 완료 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '작성 완료',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 제목 카드
  Widget _buildTitleCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
      child: TextField(
        controller: _titleController,
        decoration: InputDecoration(
          hintText: '크루팅 제목을 입력해주세요',
          hintStyle: TextStyle(
            fontSize: 14,
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 모집 인원 카드
  Widget _buildCapacityCard() {
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
          const Text(
            '모집 인원',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          const Divider(height: 1, thickness: 0.5, color: Color(0xFFE0E0E0)),
          const SizedBox(height: 6),
          SizedBox(
            height: 32,
            child: Center(
              child: TextField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 나이 조건 카드
  Widget _buildAgeCard() {
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
          const Text(
            '나이 조건 (선택)',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          const Divider(height: 1, thickness: 0.5, color: Color(0xFFE0E0E0)),
          const SizedBox(height: 6),
          // 최소/최대 나이 선택 버튼
          Row(
            children: [
              Expanded(child: _buildMinAgeButton()),
              const SizedBox(width: 8),
              Expanded(child: _buildMaxAgeButton()),
            ],
          ),
        ],
      ),
    );
  }

  /// 최소 나이 선택 버튼
  Widget _buildMinAgeButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleMinAge,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: _selectedMinAge != null
                ? AppColors.primary.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.7),
            border: Border.all(
              color: _selectedMinAge != null
                  ? AppColors.primary
                  : AppColors.textTertiary.withValues(alpha: 0.25),
              width: _selectedMinAge != null ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _selectedMinAge ?? '최소',
                  style: TextStyle(
                    color: _selectedMinAge != null
                        ? AppColors.primary
                        : AppColors.textTertiary,
                    fontSize: 13,
                    fontWeight: _selectedMinAge != null
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Icon(
                _isMinAgeExpanded ? Icons.expand_less : Icons.expand_more,
                size: 14,
                color: _selectedMinAge != null
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 최대 나이 선택 버튼
  Widget _buildMaxAgeButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleMaxAge,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: _selectedMaxAge != null
                ? AppColors.primary.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.7),
            border: Border.all(
              color: _selectedMaxAge != null
                  ? AppColors.primary
                  : AppColors.textTertiary.withValues(alpha: 0.25),
              width: _selectedMaxAge != null ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _selectedMaxAge ?? '최대',
                  style: TextStyle(
                    color: _selectedMaxAge != null
                        ? AppColors.primary
                        : AppColors.textTertiary,
                    fontSize: 13,
                    fontWeight: _selectedMaxAge != null
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Icon(
                _isMaxAgeExpanded ? Icons.expand_less : Icons.expand_more,
                size: 14,
                color: _selectedMaxAge != null
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgeExpansionArea() {
    final isMinMode = _isMinAgeExpanded;
    final isMaxMode = _isMaxAgeExpanded;
    if (!isMinMode && !isMaxMode) {
      return const SizedBox.shrink();
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Container(
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
          children: _ageRanges.map((age) {
            final isSelected = isMinMode
                ? _selectedMinAge == age
                : _selectedMaxAge == age;
            final enabled = isMinMode
                ? true
                : (_selectedMinAge == null ||
                      _ageRanges.indexOf(age) >=
                          _ageRanges.indexOf(_selectedMinAge!));

            return ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 72),
              child: _buildChip(age, isSelected, () {
                if (!enabled) return;
                setState(() {
                  if (isMinMode) {
                    _selectedMinAge = age;
                    if (_selectedMaxAge != null) {
                      final minIndex = _ageRanges.indexOf(age);
                      final maxIndex = _ageRanges.indexOf(_selectedMaxAge!);
                      if (minIndex > maxIndex) {
                        _selectedMaxAge = null;
                      }
                    }
                    _isMinAgeExpanded = false;
                  } else {
                    _selectedMaxAge = age;
                    _isMaxAgeExpanded = false;
                  }
                });
              }, enabled: enabled),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 활동 지역 카드
  Widget _buildRegionCard() {
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
              width: _selectedRegion != null ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _selectedRegion ?? '시/도',
                  style: TextStyle(
                    color: _getProvinceButtonTextColor(),
                    fontSize: 14,
                    fontWeight: _selectedRegion != null
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
        onTap: _selectedRegion != null ? _toggleCity : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _getCityButtonColor(),
            border: Border.all(
              color: _getCityButtonBorderColor(),
              width: _selectedCity != null ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _selectedCity ?? '시/구/군',
                  style: TextStyle(
                    color: _getCityButtonTextColor(),
                    fontSize: 14,
                    fontWeight: _selectedCity != null
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
                  return _buildChip(region, _selectedRegion == region, () {
                    setState(() {
                      _selectedRegion = region;
                      _selectedCity = null;
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
                children: (KoreanRegions.cities[_selectedRegion!] ?? []).map((
                  city,
                ) {
                  return _buildChip(city, _selectedCity == city, () {
                    setState(() {
                      _selectedCity = city;
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
    return _selectedRegion != null
        ? AppColors.primary.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.7);
  }

  Color _getProvinceButtonBorderColor() {
    return _selectedRegion != null
        ? AppColors.primary
        : AppColors.textTertiary.withValues(alpha: 0.25);
  }

  Color _getProvinceButtonTextColor() {
    return _selectedRegion != null ? AppColors.primary : AppColors.textTertiary;
  }

  Color _getProvinceButtonIconColor() {
    return _selectedRegion != null
        ? AppColors.primary
        : AppColors.textSecondary;
  }

  Color _getCityButtonColor() {
    if (_selectedCity != null) {
      return AppColors.primary.withValues(alpha: 0.12);
    }
    if (_selectedRegion != null) {
      return Colors.white.withValues(alpha: 0.7);
    }
    return Colors.white.withValues(alpha: 0.5);
  }

  Color _getCityButtonBorderColor() {
    if (_selectedCity != null) {
      return AppColors.primary;
    }
    if (_selectedRegion != null) {
      return AppColors.textTertiary.withValues(alpha: 0.25);
    }
    return AppColors.textTertiary.withValues(alpha: 0.15);
  }

  Color _getCityButtonTextColor() {
    if (_selectedCity != null) {
      return AppColors.primary;
    }
    if (_selectedRegion != null) {
      return AppColors.textTertiary;
    }
    return AppColors.textTertiary.withValues(alpha: 0.5);
  }

  Color _getCityButtonIconColor() {
    if (_selectedCity != null) {
      return AppColors.primary;
    }
    if (_selectedRegion != null) {
      return AppColors.textSecondary;
    }
    return AppColors.textSecondary.withValues(alpha: 0.5);
  }

  /// 크루팅 날짜 카드
  Widget _buildDateCard() {
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
          const Text(
            '크루팅 날짜',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.textTertiary.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 6),
          // 시작일/종료일 선택 버튼
          Row(
            children: [
              Expanded(child: _buildStartDateButton()),
              const SizedBox(width: 8),
              Expanded(child: _buildEndDateButton()),
            ],
          ),
          // 시작일 달력 확장 영역
          _buildStartDateExpansion(),
          // 종료일 달력 확장 영역
          _buildEndDateExpansion(),
        ],
      ),
    );
  }

  /// 시작일 선택 버튼
  Widget _buildStartDateButton() {
    final displayText = _selectedStartDate != null
        ? DateFormat('M/d').format(_selectedStartDate!)
        : '시작일';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleStartDate,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _selectedStartDate != null
                ? AppColors.primary.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.7),
            border: Border.all(
              color: _selectedStartDate != null
                  ? AppColors.primary
                  : AppColors.textTertiary.withValues(alpha: 0.25),
              width: _selectedStartDate != null ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  displayText,
                  style: TextStyle(
                    color: _selectedStartDate != null
                        ? AppColors.primary
                        : AppColors.textTertiary,
                    fontSize: 14,
                    fontWeight: _selectedStartDate != null
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Icon(
                _isStartDateExpanded ? Icons.expand_less : Icons.expand_more,
                size: 16,
                color: _selectedStartDate != null
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 종료일 선택 버튼
  Widget _buildEndDateButton() {
    final displayText = _selectedEndDate != null
        ? DateFormat('M/d').format(_selectedEndDate!)
        : '종료일';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleEndDate,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _selectedEndDate != null
                ? AppColors.primary.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.7),
            border: Border.all(
              color: _selectedEndDate != null
                  ? AppColors.primary
                  : AppColors.textTertiary.withValues(alpha: 0.25),
              width: _selectedEndDate != null ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  displayText,
                  style: TextStyle(
                    color: _selectedEndDate != null
                        ? AppColors.primary
                        : AppColors.textTertiary,
                    fontSize: 14,
                    fontWeight: _selectedEndDate != null
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Icon(
                _isEndDateExpanded ? Icons.expand_less : Icons.expand_more,
                size: 16,
                color: _selectedEndDate != null
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 시작일 달력 확장 영역
  Widget _buildStartDateExpansion() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: _isStartDateExpanded
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
              child: RecruitingInlineCalendar(
                initialDate: _selectedStartDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onDateChanged: (date) {
                  setState(() {
                    _selectedStartDate = date;
                    if (_selectedEndDate != null &&
                        _selectedStartDate!.isAfter(_selectedEndDate!)) {
                      _selectedEndDate = null;
                    }
                    _isStartDateExpanded = false;
                  });
                },
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  /// 종료일 달력 확장 영역
  Widget _buildEndDateExpansion() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: _isEndDateExpanded
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
              child: RecruitingInlineCalendar(
                initialDate:
                    _selectedEndDate ?? (_selectedStartDate ?? DateTime.now()),
                firstDate: _selectedStartDate ?? DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onDateChanged: (date) {
                  setState(() {
                    _selectedEndDate = date;
                    _isEndDateExpanded = false;
                  });
                },
              ),
            )
          : const SizedBox.shrink(),
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
