import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/constants/regions.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../core/utils/toast_helper.dart';
import '../../../../../../data/data_source/storage_service.dart';
import '../state/user_controller.dart';
import '../state/chart_controller.dart';

class ProfileInfoSection extends ConsumerStatefulWidget {
  const ProfileInfoSection({super.key});

  @override
  ConsumerState<ProfileInfoSection> createState() => _ProfileInfoSectionState();
}

class _ProfileInfoSectionState extends ConsumerState<ProfileInfoSection>
    with TickerProviderStateMixin {
  bool _isEditing = false;
  bool _isUploadingImage = false;
  late TextEditingController _usernameController;
  String? _tempImageUrl;
  String? _tempRegion;
  final ImagePicker _imagePicker = ImagePicker();
  final StorageService _storageService = getIt<StorageService>();

  // 차트 관련 변수
  late ScrollController _chartScrollController;
  late AnimationController _chartAnimationController;
  double _currentMaxY = 100.0;
  double _targetMaxY = 100.0;
  bool suspendedAnimation = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider).value;
    _usernameController = TextEditingController(text: user?.username ?? '');
    _tempImageUrl = user?.userImg;
    _tempRegion = user?.region ?? '서울';

    // 차트 초기화
    _chartScrollController = ScrollController();
    _chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _chartAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentMaxY = _targetMaxY;
          suspendedAnimation = false;
        });
        _chartAnimationController.reset();
      }
    });
    // 초기 최대값 설정 (동적 계산)
    _calculateDynamicScaling();

    // 차트 초기화 시 가장 오른쪽(최신 데이터)으로 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToLatest();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _chartScrollController.dispose();
    _chartAnimationController.dispose();
    super.dispose();
  }

  void _calculateDynamicScaling() {
    final chartData = ref.read(chartProvider);
    if (chartData.isEmpty) {
      _currentMaxY = 100.0;
      _targetMaxY = 100.0;
      return;
    }
    _targetMaxY = ref
        .read(chartProvider.notifier)
        .calculateDynamicMaxY(chartData);
    _currentMaxY = _targetMaxY;
  }

  void _scrollToLatest() {
    const double pointWidth = 60.0; // 각 데이터 포인트의 너비

    // 완전히 오른쪽 끝으로 스크롤하기 위해 최대 스크롤 위치 계산
    final chartData = ref.read(chartProvider);
    final double totalWidth = chartData.length * pointWidth;

    // 스크롤 가능한 최대 위치는 (전체 너비 - 뷰포트 너비)
    // 완전히 오른쪽 끝으로 가도록 약간의 여백을 더함
    final double maxScroll = math.max(
      0,
      totalWidth, // 전체 너비로 스크롤해서 완전히 오른쪽 끝으로 이동
    );

    // 부드러운 애니메이션으로 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chartScrollController.hasClients) {
        _chartScrollController.animateTo(
          maxScroll,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
        );
      }
    });
  }

  double _getNiceInterval(double maxValue, int targetTickCount) {
    if (maxValue <= 0) return 1;
    final roughInterval = maxValue / targetTickCount;
    final magnitude = math
        .pow(10, roughInterval.toString().split('.')[0].length - 1)
        .toDouble();
    return (roughInterval / magnitude).ceil() * magnitude;
  }

  void _toggleEdit() {
    if (_isEditing) {
      // 저장 로직 - 이름 유효성 검사
      final trimmedName = _usernameController.text.trim();

      if (trimmedName.isEmpty) {
        // 이름이 비어있으면 경고 문구 표시하고 편집 모드 유지
        ToastHelper.showWarning('이름을 입력해주세요.');
        return; // 편집 모드 유지
      }

      // 이름이 있으면 저장 진행
      final notifier = ref.read(userProvider.notifier);
      notifier.updateUserInfo(
        username: trimmedName,
        userImg: _tempImageUrl,
        region: _tempRegion,
      );

      ToastHelper.showSuccess('프로필이 업데이트되었습니다.');

      setState(() => _isEditing = false);
    } else {
      // 편집 모드 시작 - 현재 값으로 초기화
      final user = ref.read(userProvider).value;
      _usernameController.text = user?.username ?? '';
      _tempImageUrl = user?.userImg;
      _tempRegion = user?.region ?? '서울';
      setState(() => _isEditing = true);
    }
  }

  void _cancelEdit() {
    final user = ref.read(userProvider).value;
    setState(() {
      _isEditing = false;
      _usernameController.text = user?.username ?? '';
      _tempImageUrl = user?.userImg;
      _tempRegion = user?.region ?? '서울';
    });
  }

  /// 프로필 이미지 선택 바텀시트 표시
  Future<void> _selectProfileImage() async {
    if (!_isEditing) return;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.textTertiary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    Text(
                      '프로필 사진 변경',
                      style: AppTextStyle.titleLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              // Options
              _buildImagePickerOption(
                icon: Icons.camera_alt_rounded,
                label: '카메라로 촬영',
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              _buildImagePickerOption(
                icon: Icons.photo_library_rounded,
                label: '갤러리에서 선택',
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              if (_tempImageUrl != null)
                _buildImagePickerOption(
                  icon: Icons.delete_outline_rounded,
                  label: '이미지 제거',
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _tempImageUrl = null);
                  },
                  isDestructive: true,
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  /// 이미지 선택 옵션 위젯
  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? AppColors.error : AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: AppTextStyle.bodyLarge.copyWith(
                color: isDestructive ? AppColors.error : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 카메라로 이미지 촬영
  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        await _uploadImage(File(pickedFile.path));
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError('카메라 오류: $e');
      }
    }
  }

  /// 갤러리에서 이미지 선택
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        await _uploadImage(File(pickedFile.path));
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError('갤러리 오류: $e');
      }
    }
  }

  /// 이미지 업로드
  Future<void> _uploadImage(File imageFile) async {
    setState(() => _isUploadingImage = true);

    try {
      final user = ref.read(userProvider).value;
      if (user == null) {
        throw Exception('사용자 정보를 찾을 수 없습니다');
      }

      // Supabase Storage에 업로드
      final imageUrl = await _storageService.updateProfileImage(
        userId: user.id,
        imageFile: imageFile,
        oldImageUrl: _tempImageUrl,
      );

      setState(() {
        _tempImageUrl = imageUrl;
        _isUploadingImage = false;
      });

      if (mounted) {
        ToastHelper.showSuccess('프로필 사진이 업로드되었습니다.');
      }
    } catch (e) {
      setState(() => _isUploadingImage = false);

      if (mounted) {
        ToastHelper.showError('업로드 실패: $e');
      }
    }
  }

  /// Picker 아이템 텍스트 스타일 (일관성 유지)
  TextStyle get _pickerTextStyle => AppTextStyle.bodyLarge.copyWith(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w600,
  );

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
                color: AppColors.cardBackground,
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
                          color: AppColors.textTertiary.withValues(alpha: 0.2),
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
                              color: AppColors.primary,
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
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) {
        final displayImageUrl = _isEditing ? _tempImageUrl : user.userImg;

        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile content
              Row(
                children: [
                  // 프로필 사진
                  GestureDetector(
                    onTap: _isEditing ? _selectProfileImage : null,
                    child: Stack(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 34,
                            backgroundColor: AppColors.cardBackground,
                            child: CircleAvatar(
                              radius: 32,
                              backgroundColor: AppColors.background,
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
                                      size: 36,
                                      color: AppColors.textSecondary,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        // 로딩 인디케이터
                        if (_isUploadingImage)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.textPrimary.withValues(
                                  alpha: 0.5,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.onPrimary,
                                  strokeWidth: 3,
                                ),
                              ),
                            ),
                          ),
                        // 편집 모드 카메라 아이콘
                        if (_isEditing && !_isUploadingImage)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.cardBackground,
                                  width: 2,
                                ),
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
                                color: AppColors.onPrimary,
                                size: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.textTertiary.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.primary,
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
                            user.username,
                            style: AppTextStyle.headlineSmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: 8),
                        // 지역 표시 (편집 모드가 아닐 때는 읽기 전용, 편집 모드일 때는 클릭 가능)
                        GestureDetector(
                          onTap: _isEditing ? _selectRegion : null,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 14,
                                color: _isEditing
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _isEditing
                                    ? (_tempRegion?.isNotEmpty == true
                                          ? _tempRegion!
                                          : '지역 선택')
                                    : (user.region.isNotEmpty
                                          ? user.region
                                          : '미설정'),
                                style: AppTextStyle.bodySmall.copyWith(
                                  color: _isEditing
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 편집 모드에 따라 버튼 표시 (이름과 지역 오른쪽에 배치)
                  if (_isEditing) ...[
                    const SizedBox(width: 8),
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
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: _toggleEdit,
                        icon: const Icon(
                          Icons.check_rounded,
                          color: AppColors.onPrimary,
                          size: 20,
                        ),
                        tooltip: '저장',
                      ),
                    ),
                  ] else ...[
                    const SizedBox(width: 8),
                    // 수정 버튼
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.textTertiary.withValues(alpha: 0.3),
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
                ],
              ),
              // 차트 섹션 추가
              const SizedBox(height: 24),
              _buildChart(),
            ],
          ),
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(
          minHeight: 320, // 프로필 정보 + 차트 영역을 포함한 최소 높이
        ),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 3)),
      ),
      error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
    );
  }

  // 차트 빌드 메서드
  Widget _buildChart() {
    final chartData = ref.watch(chartProvider);
    final List<_ScoreData> scoreData = chartData
        .map((data) => _ScoreData(data.date, data.score))
        .toList();

    if (scoreData.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.textTertiary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.trending_up_outlined,
                size: 40,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: 12),
              Text(
                '아직 성과 데이터가 없습니다',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textTertiary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.textTertiary.withValues(alpha: 0.4),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  // 확장된 세로 레이블 영역 (전체 높이에 걸쳐)
                  Container(
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: AppColors.textTertiary.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        // 차트 영역 레이블 (150px) - 가로 격자선과 정확히 매칭
                        Expanded(
                          flex: 3, // 차트 영역 비율
                          child: Stack(
                            children: List.generate(6, (index) {
                              final interval = _getNiceInterval(
                                _currentMaxY,
                                5,
                              );
                              final value = ((5 - index) * interval).toInt();
                              final yRatio = value / _currentMaxY;
                              // 가로 격자선과 동일한 공식으로 Y 위치 계산
                              final chartHeight = 150.0;
                              final yPosition =
                                  chartHeight -
                                  (yRatio * (chartHeight - 40)) -
                                  20;

                              return Positioned(
                                left: 0,
                                top: yPosition - 10, // 텍스트 중앙 정렬
                                right: 0,
                                child: Center(
                                  child: Text(
                                    value >= 1000
                                        ? '${(value / 1000).toStringAsFixed(1)}K'
                                        : value.toString(),
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        // 날짜 레이블 영역 (50px) - 비우기, 차트와 일치하는 구분선
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: AppColors.textTertiary.withValues(
                                  alpha: 0.4,
                                ),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Scrollbar(
                      controller: _chartScrollController,
                      thumbVisibility: true,
                      thickness: 4,
                      radius: const Radius.circular(4),
                      child: SingleChildScrollView(
                        controller: _chartScrollController,
                        scrollDirection: Axis.horizontal,
                        child: Builder(
                          builder: (context) {
                            // 차트가 빌드된 후 최신 위치로 스크롤
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted &&
                                  _chartScrollController.hasClients) {
                                _scrollToLatest();
                              }
                            });
                            return SizedBox(
                              width: scoreData.length * 60.0,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 150,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: CustomPaint(
                                            painter: _CustomChartPainter(
                                              data: scoreData,
                                              interval: _getNiceInterval(
                                                _currentMaxY,
                                                5,
                                              ),
                                              maxY: _currentMaxY,
                                              chartHeight: 150.0,
                                            ),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Stack(
                                            children: scoreData.asMap().entries.map((
                                              entry,
                                            ) {
                                              final index = entry.key;
                                              final scoreDataItem = entry.value;
                                              final x = (index * 60.0) + 30;
                                              final maxY = suspendedAnimation
                                                  ? _targetMaxY
                                                  : _currentMaxY;
                                              final yRatio =
                                                  scoreDataItem.score / maxY;
                                              final chartHeight = 150.0;
                                              final yPosition =
                                                  chartHeight -
                                                  (yRatio *
                                                      (chartHeight - 40)) -
                                                  20;
                                              return Positioned(
                                                left: x - 15,
                                                top: yPosition - 25,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 2,
                                                      ),
                                                  child: Text(
                                                    '${scoreDataItem.score}점',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: CustomPaint(
                                            painter: _HorizontalGridPainter(
                                              interval: _getNiceInterval(
                                                _currentMaxY,
                                                5,
                                              ),
                                              maxY: _currentMaxY,
                                              chartHeight: 150.0,
                                            ),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: CustomPaint(
                                            painter: _VerticalGridPainter(
                                              dataCount: scoreData.length,
                                              pointWidth: 60.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: AppColors.textTertiary
                                              .withValues(alpha: 0.4),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: scoreData.map((data) {
                                        return SizedBox(
                                          width: 60.0,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 16.0,
                                              ),
                                              child: Text(
                                                DateFormat(
                                                  'M/d',
                                                ).format(data.date),
                                                style: TextStyle(
                                                  color: AppColors.textPrimary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 차트 데이터 클래스
class _ScoreData {
  final DateTime date;
  final int score;
  _ScoreData(this.date, this.score);
}

// 커스텀 차트 그래프 페인터
class _CustomChartPainter extends CustomPainter {
  final List<_ScoreData> data;
  final double interval;
  final double maxY;
  final double chartHeight;

  _CustomChartPainter({
    required this.data,
    required this.interval,
    required this.maxY,
    required this.chartHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final scoreData = data[i];
      final x = (i * 60.0) + 30;
      final yRatio = scoreData.score / maxY;
      final y = chartHeight - (yRatio * (chartHeight - 40)) - 20;
      final point = Offset(x, y);

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }

      canvas.drawCircle(
        point,
        6,
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        point,
        6,
        Paint()
          ..color = AppColors.cardBackground
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CustomChartPainter oldDelegate) {
    return data != oldDelegate.data ||
        interval != oldDelegate.interval ||
        maxY != oldDelegate.maxY ||
        chartHeight != oldDelegate.chartHeight;
  }
}

// 가로 격자선 페인터
class _HorizontalGridPainter extends CustomPainter {
  final double interval;
  final double maxY;
  final double chartHeight;

  _HorizontalGridPainter({
    required this.interval,
    required this.maxY,
    required this.chartHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textTertiary.withValues(alpha: 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= 5; i++) {
      final value = i * interval;
      final yRatio = value / maxY;
      final y = chartHeight - (yRatio * (chartHeight - 40)) - 20;
      if (y >= 20 && y <= chartHeight - 20) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_HorizontalGridPainter oldDelegate) {
    return interval != oldDelegate.interval ||
        maxY != oldDelegate.maxY ||
        chartHeight != oldDelegate.chartHeight;
  }
}

// 세로 격자선 페인터
class _VerticalGridPainter extends CustomPainter {
  final int dataCount;
  final double pointWidth;

  _VerticalGridPainter({required this.dataCount, required this.pointWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textTertiary.withValues(alpha: 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < dataCount; i++) {
      final x = i * pointWidth + (pointWidth / 2);
      if (x < size.width) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_VerticalGridPainter oldDelegate) {
    return dataCount != oldDelegate.dataCount ||
        pointWidth != oldDelegate.pointWidth;
  }
}
