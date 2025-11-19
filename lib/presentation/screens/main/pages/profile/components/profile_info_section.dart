import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/regions.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/utils/toast_helper.dart';
import '../../../../entry/state/auth_controller.dart';
import 'profile_avatar.dart';
import 'profile_action_buttons.dart';

class ProfileInfoSection extends ConsumerStatefulWidget {
  final VoidCallback? onEditModeChanged;

  const ProfileInfoSection({
    super.key,
    this.onEditModeChanged,
  });

  @override
  ConsumerState<ProfileInfoSection> createState() => _ProfileInfoSectionState();
}

class _ProfileInfoSectionState extends ConsumerState<ProfileInfoSection> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late FocusNode _nameFocusNode;
  String? _selectedProvince;
  String? _selectedCity;
  String? _originalProvince;
  String? _originalCity;
  XFile? _selectedImage;
  bool _removeImage = false;
  bool _isLoading = false;

  /// 현재 선택된 지역을 전체 주소 형식으로 반환
  String get _currentRegionText {
    if (_selectedProvince == null) return '';
    if (_selectedCity == null) return _selectedProvince!;
    return KoreanRegions.getFullAddress(_selectedProvince!, _selectedCity!);
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).currentUser;
    _nameController = TextEditingController(text: user?.username ?? '');
    _nameFocusNode = FocusNode();
    if (user != null) {
      _parseUserRegion(user.region);
      // 원래 지역 정보 저장
      _originalProvince = _selectedProvince;
      _originalCity = _selectedCity;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  /// 사용자 지역을 도와 시로 파싱
  void _parseUserRegion(String userRegion) {
    if (userRegion.isEmpty) {
      _selectedProvince = null;
      _selectedCity = null;
      return;
    }

    // "서울특별시 종로구" 형식을 파싱
    final parts = userRegion.split(' ');
    if (parts.length >= 2) {
      final province = parts[0];
      final city = parts[1];

      if (KoreanRegions.provinces.contains(province)) {
        _selectedProvince = province;
        final cities = KoreanRegions.cities[province];
        if (cities != null && cities.contains(city)) {
          _selectedCity = city;
        } else {
          _selectedCity = null;
        }
      } else {
        _selectedProvince = null;
        _selectedCity = null;
      }
    } else if (parts.length == 1) {
      final province = parts[0];
      if (KoreanRegions.provinces.contains(province)) {
        _selectedProvince = province;
        _selectedCity = null;
      } else {
        _selectedProvince = null;
        _selectedCity = null;
      }
    } else {
      _selectedProvince = null;
      _selectedCity = null;
    }
  }

  /// 지역 선택 바텀시트 표시
  void _showLocationPicker() {
    String selectedProvince = _selectedProvince ?? KoreanRegions.provinces.first;
    var cities = KoreanRegions.cities[selectedProvince] ?? [];
    String selectedCity = _selectedCity ?? (cities.isNotEmpty ? cities.first : '');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            int provinceIndex = KoreanRegions.provinces.indexOf(selectedProvince);
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
                      color: AppColors.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
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
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close_rounded,
                            color: AppColors.onPrimary,
                          ),
                        ),
                        Text(
                          '지역',
                          style: AppTextStyle.titleLarge.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedProvince = selectedProvince;
                              _selectedCity = selectedCity;
                            });
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.check_rounded,
                            color: AppColors.onPrimary,
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
                                selectedProvince = KoreanRegions.provinces[index];
                                cities = KoreanRegions.cities[selectedProvince] ?? [];
                                selectedCity = cities.isNotEmpty ? cities.first : '';
                              });
                            },
                            children: KoreanRegions.provinces.map((String province) {
                              return Center(
                                child: Text(
                                  province,
                                  style: AppTextStyle.bodyMedium.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        // City picker
                        Expanded(
                          child: cities.isEmpty
                              ? const Center(
                                  child: Text('시/군/구가 없습니다'),
                                )
                              : CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                    initialItem: cityIndex >= cities.length
                                        ? 0
                                        : cityIndex,
                                  ),
                                  itemExtent: 40,
                                  onSelectedItemChanged: (int index) {
                                    setModalState(() {
                                      selectedCity = cities[index];
                                    });
                                  },
                                  children: cities.map((String city) {
                                    return Center(
                                      child: Text(
                                        city,
                                        style: AppTextStyle.bodyMedium.copyWith(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
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

  /// 이미지 선택 바텀시트 표시
  void _showImagePicker() {
    showModalBottomSheet(
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
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
                      '프로필 사진 선택',
                      style: AppTextStyle.titleLarge.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.onPrimary,
                    ),
                  ],
                ),
              ),
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
              if ((_selectedImage != null || ref.read(authProvider).currentUser?.userImg != null) &&
                  !_removeImage)
                _buildImagePickerOption(
                  icon: Icons.delete_outline_rounded,
                  label: '사진 제거',
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedImage = null;
                      _removeImage = true;
                    });
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

  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? AppColors.error : AppColors.textPrimary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: AppTextStyle.bodyLarge.copyWith(
                color: isDestructive ? AppColors.error : AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 카메라에서 이미지 선택
  Future<void> _pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        setState(() {
          _selectedImage = image;
          _removeImage = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError('이미지 선택에 실패했습니다');
      }
    }
  }

  /// 갤러리에서 이미지 선택
  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        setState(() {
          _selectedImage = image;
          _removeImage = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError('이미지 선택에 실패했습니다');
      }
    }
  }

  /// 프로필 저장
  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ToastHelper.showError('이름을 입력해주세요');
      return;
    }

    // 도와 시 모두 선택했는지 확인
    if (_selectedProvince == null || _selectedCity == null) {
      // 시까지 선택하지 않았으면 원래 지역으로 복원
      setState(() {
        _selectedProvince = _originalProvince;
        _selectedCity = _originalCity;
        _isEditing = false;
      });
      widget.onEditModeChanged?.call();
      ToastHelper.showError('지역을 모두 선택해주세요');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = ref.read(authProvider).currentUser;
      if (user == null) return;

      // 도와 시를 합쳐서 지역 문자열 생성
      String regionText = KoreanRegions.getFullAddress(
        _selectedProvince!,
        _selectedCity!,
      );

      // 프로필 업데이트 (이름과 지역만)
      final updatedUser = user.copyWith(
        username: _nameController.text.trim(),
        region: regionText,
      );

      await ref.read(authProvider.notifier).updateProfile(updatedUser);

      if (mounted) {
        setState(() {
          _isEditing = false;
          _selectedImage = null;
          _removeImage = false;
        });
        widget.onEditModeChanged?.call();
        ToastHelper.showSuccess('프로필이 수정되었습니다');
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError('프로필 수정에 실패했습니다: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// 편집 모드 시작
  void _startEditMode() {
    final user = ref.read(authProvider).currentUser;
    if (user != null) {
      // 편집 모드 시작 시 사용자 지역을 다시 파싱하여 표시
      // (사용자가 다른 화면에서 지역을 변경했을 수 있으므로)
      _parseUserRegion(user.region);
      // 원래 지역 정보 저장 (편집 전 현재 지역)
      _originalProvince = _selectedProvince;
      _originalCity = _selectedCity;
    }
    setState(() {
      _isEditing = true;
      // 기존 지역은 그대로 유지 (초기화하지 않음)
    });
    widget.onEditModeChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).currentUser;

    // 사용자 정보가 없으면 로딩 표시
    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final numberFormat = NumberFormat('#,###');
    final Color primaryColor = AppColors.primary;
    final Color nameTextColor = AppColors.textPrimary;
    final Color secondaryTextColor = AppColors.textSecondary;
    final Color cardFillColor = AppColors.background;
    const Color avatarBackdrop = Color(0xFFD8DDD7);
    const double avatarSize = 96;

    return Column(
      children: [
        // 상단: 좌측 정보 + 우측 프로필 이미지
        DecoratedBox(
          decoration: BoxDecoration(
            color: cardFillColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 32,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 좌측 정보 컬럼
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 사용자 이름 (편집 가능)
                      _isEditing
                          ? Container(
                              decoration: BoxDecoration(
                                color: AppColors.cardBackground,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.textTertiary.withValues(
                                    alpha: 0.2,
                                  ),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.cardShadow,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _nameController,
                                focusNode: _nameFocusNode,
                                autofocus: true,
                                style: AppTextStyle.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                                decoration: InputDecoration(
                                  hintText: '이름을 입력해주세요',
                                  hintStyle: AppTextStyle.bodyMedium.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.edit_outlined,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                  filled: false,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            )
                          : Text(
                        user.username,
                        style: AppTextStyle.headlineSmall.copyWith(
                          color: nameTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // 주소지 (편집 가능)
                      _isEditing
                          ? GestureDetector(
                              onTap: _showLocationPicker,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.cardBackground,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.textTertiary.withValues(
                                      alpha: 0.2,
                                    ),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.cardShadow,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_city_outlined,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _currentRegionText.isNotEmpty
                                            ? _currentRegionText
                                            : user.region.isNotEmpty
                                                ? user.region
                                                : '지역을 선택해주세요',
                                        style: AppTextStyle.bodyMedium.copyWith(
                                          color: (_currentRegionText.isNotEmpty ||
                                                  user.region.isNotEmpty)
                                              ? AppColors.textPrimary
                                              : AppColors.textTertiary,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: primaryColor.withValues(alpha: 0.85),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            user.region,
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // 총 포인트
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.24),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.stars_rounded,
                              size: 20,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${numberFormat.format(user.totalPoints)} 포인트',
                              style: AppTextStyle.titleMedium.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 28),
                // 우측 프로필 이미지
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 큰 원 (프로필 이미지)
                    ClipOval(
                      child: Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          color: avatarBackdrop,
                          border: Border.all(
                            color: AppColors.onPrimary.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: _selectedImage != null
                            ? Image.file(
                                File(_selectedImage!.path),
                                fit: BoxFit.cover,
                              )
                            : _removeImage
                                ? Icon(
                                    Icons.person,
                                    size: avatarSize * 0.6,
                                    color: AppColors.onPrimary.withValues(alpha: 0.5),
                                  )
                                : ProfileAvatar(
                  imageUrl: user.userImg,
                  size: avatarSize,
                  backgroundColor: avatarBackdrop,
                                  ),
                      ),
                    ),
                    // 작은 원 (카메라 아이콘) - 오른쪽 아래 (편집 모드일 때만 표시)
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showImagePicker,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.onPrimary,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: AppColors.onPrimary,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        // 하단: 액션 버튼들 (편집 모드에 따라 버튼 텍스트 변경)
        ProfileActionButtons(
          isEditing: _isEditing,
          isLoading: _isLoading,
          onEditProfile: _isEditing ? null : _startEditMode,
          onSave: _isEditing ? _saveProfile : null,
        ),
      ],
    );
  }
}
