import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/toast_helper.dart';
import '../../../../../core/constants/regions.dart';
import 'models/campaign_data.dart';

/// 크루팅 작성 페이지
class RecruitingCreatePage extends StatefulWidget {
  final CampaignData campaign;

  const RecruitingCreatePage({super.key, required this.campaign});

  @override
  State<RecruitingCreatePage> createState() => _RecruitingCreatePageState();
}

class _RecruitingCreatePageState extends State<RecruitingCreatePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _capacityController = TextEditingController();
  final _minAgeController = TextEditingController();
  final _maxAgeController = TextEditingController();

  String? _selectedRegion;
  String? _selectedCity;

  /// 시/도 선택 펼침 상태
  bool _isProvinceExpanded = false;

  /// 시/구/군 선택 펼침 상태
  bool _isCityExpanded = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _capacityController.dispose();
    _minAgeController.dispose();
    _maxAgeController.dispose();
    super.dispose();
  }

  /// 시/도 선택 토글
  void _toggleProvince() {
    setState(() {
      _isProvinceExpanded = !_isProvinceExpanded;
      if (_isProvinceExpanded) {
        _isCityExpanded = false;
      }
    });
  }

  /// 시/구/군 선택 토글
  void _toggleCity() {
    setState(() {
      _isCityExpanded = !_isCityExpanded;
      if (_isCityExpanded) {
        _isProvinceExpanded = false;
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
    if (_capacityController.text.trim().isEmpty) {
      ToastHelper.showError('모집인원을 입력해주세요');
      return;
    }
    final capacity = int.tryParse(_capacityController.text);
    if (capacity == null || capacity <= 0) {
      ToastHelper.showError('올바른 모집인원을 입력해주세요');
      return;
    }

    // 지역 검사
    if (_selectedRegion == null || _selectedCity == null) {
      ToastHelper.showError('지역을 선택해주세요');
      return;
    }

    // 나이조건 검사 (선택 사항)
    final minAgeText = _minAgeController.text.trim();
    final maxAgeText = _maxAgeController.text.trim();

    // 최소 나이만 입력한 경우 오류
    if (minAgeText.isNotEmpty && maxAgeText.isEmpty) {
      ToastHelper.showError('최대 나이를 입력해주세요');
      return;
    }

    // 둘 다 입력한 경우 유효성 검사
    if (minAgeText.isNotEmpty && maxAgeText.isNotEmpty) {
      final minAge = int.tryParse(minAgeText);
      final maxAge = int.tryParse(maxAgeText);

      if (minAge == null || maxAge == null) {
        ToastHelper.showError('올바른 나이를 입력해주세요');
        return;
      }

      if (minAge <= 0 || maxAge <= 0) {
        ToastHelper.showError('나이는 0보다 커야 합니다');
        return;
      }

      if (minAge > maxAge) {
        ToastHelper.showError('최소 나이가 최대 나이보다 클 수 없습니다');
        return;
      }
    }

    // 최대 나이만 입력한 경우는 통과 (~최대나이살까지)
    // 둘 다 입력 안한 경우도 통과 (전 연령)

    // 내용 검사
    if (_contentController.text.trim().isEmpty) {
      ToastHelper.showError('내용을 입력해주세요');
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
              // 제목 카드
              _buildTitleCard(),
              const SizedBox(height: 15),
              // 모집 인원 카드
              _buildCapacityCard(),
              const SizedBox(height: 15),
              // 활동 지역 카드
              _buildRegionCard(),
              const SizedBox(height: 15),
              // 나이 조건 카드
              _buildAgeCard(),
              const SizedBox(height: 15),
              // 내용 카드 (큰 크기)
              _buildContentCard(),
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
    return _buildInputCard(
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
          fontSize: 20,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      guideText: '제목',
    );
  }

  /// 모집 인원 카드
  Widget _buildCapacityCard() {
    return _buildInputCard(
      child: TextField(
        controller: _capacityController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          hintText: '모집 인원을 입력해주세요',
          hintStyle: TextStyle(
            fontSize: 14,
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: const TextStyle(
          fontSize: 20,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      guideText: '모집 인원 수',
    );
  }

  /// 나이 조건 카드
  Widget _buildAgeCard() {
    return _buildInputCard(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _minAgeController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: '최소 (선택)',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '~',
              style: TextStyle(
                fontSize: 20,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _maxAgeController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: '최대 (선택)',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      guideText: '나이 조건 (선택)',
    );
  }

  /// 활동 지역 카드
  Widget _buildRegionCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 가이드 텍스트
          const Text(
            '활동 지역',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.textTertiary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 8),
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

  /// 내용 카드 (큰 크기)
  Widget _buildContentCard() {
    return _buildInputCard(
      height: 200,
      child: TextField(
        controller: _contentController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          hintText: '동기 / 함께하는 방식 / 분위기 / 자기소개를 적어주세요\n광고·욕설·허위 인증은 금지됩니다',
          hintStyle: TextStyle(
            fontSize: 14,
            color: AppColors.textTertiary,
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: const TextStyle(
          fontSize: 20,
          color: AppColors.textPrimary,
          height: 1.5,
          fontWeight: FontWeight.w500,
        ),
      ),
      guideText: '크루팅 내용',
    );
  }

  /// 입력 카드 공통 위젯 (제목, 내용용)
  Widget _buildInputCard({
    required Widget child,
    required String guideText,
    double? height,
  }) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            guideText,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.textTertiary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 8),
          height != null ? Expanded(child: child) : child,
        ],
      ),
    );
  }
}
