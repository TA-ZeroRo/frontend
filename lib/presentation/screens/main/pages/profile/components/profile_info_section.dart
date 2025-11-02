import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/constants/regions.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../core/utils/toast_helper.dart';
import '../../../../../../data/data_source/storage_service.dart';
import '../state/user_controller.dart';

class ProfileInfoSection extends ConsumerStatefulWidget {
  const ProfileInfoSection({super.key});

  @override
  ConsumerState<ProfileInfoSection> createState() => _ProfileInfoSectionState();
}

class _ProfileInfoSectionState extends ConsumerState<ProfileInfoSection> {
  bool _isEditing = false;
  bool _isUploadingImage = false;
  late TextEditingController _usernameController;
  String? _tempImageUrl;
  String? _tempRegion;
  final ImagePicker _imagePicker = ImagePicker();
  final StorageService _storageService = getIt<StorageService>();

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider).value;
    _usernameController = TextEditingController(text: user?.username ?? '');
    _tempImageUrl = user?.userImg;
    _tempRegion = user?.region ?? '서울';
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
              // Header with title and action buttons
              Row(
                children: [
                  Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
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
                  ] else
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
              ),
              const SizedBox(height: 20),

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
                ],
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.all(24),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title (동일한 구조, 공간만 차지)
                SizedBox(
                  height: 48, // IconButton 기본 크기와 동일
                  child: Row(
                    children: [
                      SizedBox(width: 24), // 아이콘 공간
                      const SizedBox(width: 8),
                      SizedBox(width: 100), // 텍스트 공간
                      const Spacer(),
                      SizedBox(width: 48), // 편집 버튼 공간
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Profile content 영역 (동일한 구조와 크기 유지)
                Row(
                  children: [
                    // 프로필 사진 영역 (공간만 차지, 동일한 크기)
                    SizedBox(width: 72, height: 72),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 사용자명 영역 (동일한 높이 유지)
                          SizedBox(height: 32),
                          const SizedBox(height: 8),
                          // 지역 영역
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // 로딩 인디케이터를 중앙에 오버레이로 표시
            const Positioned.fill(
              child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
            ),
          ],
        ),
      ),
      error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
    );
  }
}
