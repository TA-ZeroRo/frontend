import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/toast_helper.dart';
import 'models/campaign_data.dart';
import 'components/recruiting_inline_calendar.dart';
import 'components/recruiting_age_picker.dart';
import 'components/recruiting_region_card.dart';

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

  // 나이 선택 관련 변수
  int _minAge = 20;
  int _maxAge = 30;
  bool _isAnyAge = false;

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  /// 나이 선택 펼침 상태 (통합)
  bool _isAgeExpanded = false;

  /// 시작일 달력 펼침 상태
  bool _isStartDateExpanded = false;

  /// 종료일 달력 펼침 상태
  bool _isEndDateExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  /// 나이 선택 토글
  void _toggleAge() {
    setState(() {
      _isAgeExpanded = !_isAgeExpanded;
      if (_isAgeExpanded) {
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
        _isAgeExpanded = false;
      }
    });
  }

  /// 종료일 달력 토글
  void _toggleEndDate() {
    setState(() {
      _isEndDateExpanded = !_isEndDateExpanded;
      if (_isEndDateExpanded) {
        _isStartDateExpanded = false;
        _isAgeExpanded = false;
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

    // 나이조건 검사
    if (_minAge > _maxAge) {
      ToastHelper.showError('최소 나이가 최대 나이보다 클 수 없습니다');
      return;
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleAge,
        borderRadius: BorderRadius.circular(12),
        child: Container(
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
                '연령층',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              const Divider(
                height: 1,
                thickness: 0.5,
                color: Color(0xFFE0E0E0),
              ),
              const SizedBox(height: 6),
              // 선택된 나이 범위 텍스트
              SizedBox(
                height: 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isAnyAge ? '상관없음' : '$_minAge대 ~ $_maxAge대',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Icon(
                      _isAgeExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 나이 조건 확장 영역 (CupertinoPicker)
  Widget _buildAgeExpansionArea() {
    if (!_isAgeExpanded) {
      return const SizedBox.shrink();
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: RecruitingAgePicker(
        minAge: _minAge,
        maxAge: _maxAge,
        isAny: _isAnyAge,
        onMinAgeChanged: (value) {
          setState(() {
            _minAge = value;
            // 유효성 검사: 최소값이 최대값보다 커지면 최대값도 같이 올림
            if (_minAge > _maxAge) {
              _maxAge = _minAge;
            }
            if (_isAnyAge) _isAnyAge = false;
          });
        },
        onMaxAgeChanged: (value) {
          setState(() {
            _maxAge = value;
            // 유효성 검사: 최대값이 최소값보다 작아지면 최소값도 같이 내림
            if (_maxAge < _minAge) {
              _minAge = _maxAge;
            }
            if (_isAnyAge) _isAnyAge = false;
          });
        },
        onAnyChanged: (value) {
          setState(() {
            _isAnyAge = value;
          });
        },
      ),
    );
  }

  /// 활동 지역 카드
  Widget _buildRegionCard() {
    return RecruitingRegionCard(
      selectedRegion: _selectedRegion,
      selectedCity: _selectedCity,
      onRegionChanged: (region) {
        setState(() {
          _selectedRegion = region;
        });
      },
      onCityChanged: (city) {
        setState(() {
          _selectedCity = city;
        });
      },
      onToggle: () {
        setState(() {
          _isAgeExpanded = false;
          _isStartDateExpanded = false;
          _isEndDateExpanded = false;
        });
      },
    );
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
}
