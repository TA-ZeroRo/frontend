import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/constants/regions.dart';
import '../state/profile_controller.dart';

class ProfileInfoSection extends ConsumerStatefulWidget {
  const ProfileInfoSection({super.key});

  @override
  ConsumerState<ProfileInfoSection> createState() => _ProfileInfoSectionState();
}

class _ProfileInfoSectionState extends ConsumerState<ProfileInfoSection> {
  bool _isEditing = false;
  late TextEditingController _usernameController;
  String? _tempImageUrl;
  DateTime? _tempBirthDate;
  String? _tempRegion;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider);
    _usernameController = TextEditingController(text: profile.username);
    _tempImageUrl = profile.userImg;
    _tempBirthDate = profile.birthDate;
    _tempRegion = profile.region;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_isEditing) {
      // 저장 로직 - 이름 유효성 검사
      final trimmedName = _usernameController.text.trim();

      if (trimmedName.isEmpty) {
        // 이름이 비어있으면 경고 문구 표시하고 편집 모드 유지
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('이름을 입력해주세요.'),
            backgroundColor: Color.fromRGBO(255, 86, 69, 1),
            duration: Duration(seconds: 2),
          ),
        );
        return; // 편집 모드 유지
      }

      // 이름이 있으면 저장 진행
      final notifier = ref.read(profileProvider.notifier);
      notifier.updateProfile(
        username: trimmedName,
        userImg: _tempImageUrl,
        birthDate: _tempBirthDate,
        region: _tempRegion,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('프로필이 업데이트되었습니다.'),
          backgroundColor: Color.fromRGBO(116, 205, 124, 1),
        ),
      );

      setState(() => _isEditing = false);
    } else {
      // 편집 모드 시작 - 현재 값으로 초기화
      final profile = ref.read(profileProvider);
      _usernameController.text = profile.username;
      _tempImageUrl = profile.userImg;
      _tempBirthDate = profile.birthDate;
      _tempRegion = profile.region;
      setState(() => _isEditing = true);
    }
  }

  void _cancelEdit() {
    final profile = ref.read(profileProvider);
    setState(() {
      _isEditing = false;
      _usernameController.text = profile.username;
      _tempImageUrl = profile.userImg;
      _tempBirthDate = profile.birthDate;
      _tempRegion = profile.region;
    });
  }

  void _toggleAvatar() {
    setState(() {
      _tempImageUrl = _tempImageUrl == null
          ? 'https://picsum.photos/200'
          : null;
    });
  }

  /// 월별 일수 계산 함수 (윤년 고려)
  int _getDaysInMonth(int year, int month) {
    if (month == 2) {
      // 윤년 계산
      bool isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    } else if ([4, 6, 9, 11].contains(month)) {
      return 30;
    } else {
      return 31;
    }
  }

  /// Picker 아이템 텍스트 스타일 (일관성 유지)
  TextStyle get _pickerTextStyle => AppTextStyle.bodyLarge.copyWith(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w600,
  );

  Future<void> _selectBirthDate() async {
    int selectedYear = _tempBirthDate?.year ?? 2000;
    int selectedMonth = _tempBirthDate?.month ?? 1;
    int selectedDay = _tempBirthDate?.day ?? 1;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // 현재 선택된 년월에 대한 일수 계산
            int maxDays = _getDaysInMonth(selectedYear, selectedMonth);

            // 선택된 일이 해당 월의 최대 일수를 초과하면 조정
            if (selectedDay > maxDays) {
              selectedDay = maxDays;
            }

            return Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            '취소',
                            style: AppTextStyle.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Text(
                          '생년월일',
                          style: AppTextStyle.titleLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _tempBirthDate = DateTime(
                                selectedYear,
                                selectedMonth,
                                selectedDay,
                              );
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            '완료',
                            style: AppTextStyle.bodyLarge.copyWith(
                              color: AppColors.primaryAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Picker
                  Expanded(
                    child: Row(
                      children: [
                        // Year picker
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedYear - 1900,
                            ),
                            itemExtent: 40,
                            onSelectedItemChanged: (int index) {
                              setModalState(() {
                                selectedYear = 1900 + index;
                                // 년도 변경 시 일수 재계산 (윤년 체크)
                                int maxDays = _getDaysInMonth(
                                  selectedYear,
                                  selectedMonth,
                                );
                                if (selectedDay > maxDays) {
                                  selectedDay = maxDays;
                                }
                              });
                            },
                            children: List<Widget>.generate(
                              DateTime.now().year - 1900 + 1,
                              (int index) => Center(
                                child: Text(
                                  '${1900 + index}년',
                                  style: _pickerTextStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Month picker
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedMonth - 1,
                            ),
                            itemExtent: 40,
                            onSelectedItemChanged: (int index) {
                              setModalState(() {
                                selectedMonth = index + 1;
                                // 월 변경 시 일수 재계산
                                int maxDays = _getDaysInMonth(
                                  selectedYear,
                                  selectedMonth,
                                );
                                if (selectedDay > maxDays) {
                                  selectedDay = maxDays;
                                }
                              });
                            },
                            children: List<Widget>.generate(
                              12,
                              (int index) => Center(
                                child: Text(
                                  '${index + 1}월',
                                  style: _pickerTextStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Day picker
                        Expanded(
                          child: CupertinoPicker(
                            key: ValueKey(
                              '$selectedYear-$selectedMonth',
                            ), // 년월 변경 시 재생성
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedDay - 1,
                            ),
                            itemExtent: 40,
                            onSelectedItemChanged: (int index) {
                              selectedDay = index + 1;
                            },
                            children: List<Widget>.generate(
                              maxDays, // 해당 월의 실제 일수만큼만 생성
                              (int index) => Center(
                                child: Text(
                                  '${index + 1}일',
                                  style: _pickerTextStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _selectRegion() async {
    String selectedProvince = '서울특별시';
    String selectedCity = '종로구';

    // 현재 저장된 지역이 있으면 파싱
    if (_tempRegion != null && _tempRegion!.contains(' ')) {
      final parts = _tempRegion!.split(' ');
      if (parts.length == 2) {
        selectedProvince = parts[0];
        selectedCity = parts[1];
      }
    }

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final cities = KoreanRegions.cities[selectedProvince] ?? [];

            // 선택된 도가 바뀌면 해당 도의 첫 번째 시로 초기화
            if (!cities.contains(selectedCity)) {
              selectedCity = cities.isNotEmpty ? cities.first : '';
            }

            int provinceIndex = KoreanRegions.provinces.indexOf(
              selectedProvince,
            );
            int cityIndex = cities.indexOf(selectedCity);

            if (provinceIndex == -1) provinceIndex = 0;
            if (cityIndex == -1) cityIndex = 0;

            return Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            '취소',
                            style: AppTextStyle.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Text(
                          '지역',
                          style: AppTextStyle.titleLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _tempRegion = KoreanRegions.getFullAddress(
                                selectedProvince,
                                selectedCity,
                              );
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            '완료',
                            style: AppTextStyle.bodyLarge.copyWith(
                              color: AppColors.primaryAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Picker
                  Expanded(
                    child: Row(
                      children: [
                        // Province picker
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: provinceIndex,
                            ),
                            itemExtent: 40,
                            onSelectedItemChanged: (int index) {
                              setModalState(() {
                                selectedProvince =
                                    KoreanRegions.provinces[index];
                                // 도가 바뀌면 해당 도의 첫 번째 시로 초기화
                                final newCities =
                                    KoreanRegions.cities[selectedProvince] ??
                                    [];
                                selectedCity = newCities.isNotEmpty
                                    ? newCities.first
                                    : '';
                              });
                            },
                            children: KoreanRegions.provinces.map((
                              String province,
                            ) {
                              return Center(
                                child: Text(province, style: _pickerTextStyle),
                              );
                            }).toList(),
                          ),
                        ),
                        // City picker
                        Expanded(
                          child: CupertinoPicker(
                            key: ValueKey(selectedProvince), // 도가 바뀔 때 재생성
                            scrollController: FixedExtentScrollController(
                              initialItem: cityIndex,
                            ),
                            itemExtent: 40,
                            onSelectedItemChanged: (int index) {
                              selectedCity = cities[index];
                            },
                            children: cities.map((String city) {
                              return Center(
                                child: Text(city, style: _pickerTextStyle),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final displayImageUrl = _isEditing ? _tempImageUrl : profile.userImg;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and action buttons
          Row(
            children: [
              Icon(
                Icons.person_rounded,
                color: AppColors.primaryAccent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '프로필 정보',
                style: AppTextStyle.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // 편집 모드에 따라 버튼 표시
              if (_isEditing) ...[
                // 취소 버튼
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed: _cancelEdit,
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppColors.error,
                      size: 20,
                    ),
                    tooltip: '취소',
                  ),
                ),
                const SizedBox(width: 8),
                // 저장 버튼
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryAccent.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _toggleEdit,
                    icon: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    tooltip: '저장',
                  ),
                ),
              ] else
                // 수정 버튼
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed: _toggleEdit,
                    icon: Icon(
                      Icons.edit_rounded,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                    tooltip: '편집',
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Profile content
          Row(
            children: [
              // 프로필 사진
              GestureDetector(
                onTap: _isEditing ? _toggleAvatar : null,
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryAccent.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey[100],
                          backgroundImage:
                              (displayImageUrl != null &&
                                  displayImageUrl.isNotEmpty)
                              ? NetworkImage(displayImageUrl)
                              : null,
                          child:
                              (displayImageUrl == null ||
                                  displayImageUrl.isEmpty)
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: AppColors.textSecondary,
                                )
                              : null,
                        ),
                      ),
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.cardShadow,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isEditing)
                      TextField(
                        controller: _usernameController,
                        style: AppTextStyle.headlineSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: '이름을 입력하세요',
                          hintStyle: AppTextStyle.headlineSmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primaryAccent,
                              width: 2,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primaryAccent,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                        ),
                      )
                    else
                      Text(
                        profile.username.isNotEmpty ? profile.username : '김오띠',
                        style: AppTextStyle.headlineSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 12),

                    // Stats cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            '총 포인트',
                            '${profile.totalPoints}',
                            Icons.stars_rounded,
                            AppColors.primaryAccent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            '연속 일수',
                            '${profile.continuousDays}일',
                            Icons.calendar_today_rounded,
                            AppColors.secondaryAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 추가 정보 섹션 (펼쳐지는 애니메이션)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: _isEditing
                ? Column(
                    children: [
                      const SizedBox(height: 24),
                      // 생년월일 입력
                      _buildExpandedInfoField(
                        label: '생년월일',
                        icon: Icons.cake_rounded,
                        onTap: _selectBirthDate,
                        value: _tempBirthDate != null
                            ? DateFormat(
                                'yyyy년 MM월 dd일',
                              ).format(_tempBirthDate!)
                            : '선택해주세요',
                        hasValue: _tempBirthDate != null,
                      ),
                      const SizedBox(height: 16),
                      // 지역 입력
                      _buildExpandedInfoField(
                        label: '지역',
                        icon: Icons.location_on_rounded,
                        onTap: _selectRegion,
                        value: _tempRegion ?? '선택해주세요',
                        hasValue: _tempRegion != null,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedInfoField({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required String value,
    required bool hasValue,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryAccent.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryAccent, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: hasValue
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                      fontWeight: hasValue
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textTertiary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyle.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
