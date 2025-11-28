import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/utils/toast_helper.dart';
import '../../../../../../data/data_source/storage_service.dart';
import '../../../../entry/state/auth_controller.dart';
import '../../../../../../domain/model/user/user.dart';
import '../../campaign/models/campaign_data.dart';
import 'profile_avatar.dart';

/// 프로필 수정 다이얼로그
class ProfileEditDialog extends ConsumerStatefulWidget {
  final User user;

  const ProfileEditDialog({super.key, required this.user});

  @override
  ConsumerState<ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends ConsumerState<ProfileEditDialog> {
  late TextEditingController _nameController;
  String? _selectedProvince;
  String? _selectedCity;
  XFile? _selectedImage;
  bool _removeImage = false;
  bool _isLoading = false;

  /// 지역 목록 (도) - '전체' 제외
  List<String> get _provinces => regions.where((r) => r != '전체').toList();

  /// 선택된 도에 따른 시 목록
  List<String> get _cities {
    if (_selectedProvince == null) return [];
    final cities = citiesByRegion[_selectedProvince];
    if (cities == null) return [];
    return cities.where((c) => c != '전체').toList();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.username);
    _parseUserRegion();
  }

  /// 사용자 지역을 도와 시로 파싱
  void _parseUserRegion() {
    final userRegion = widget.user.region;
    if (userRegion.isEmpty) {
      _selectedProvince = null;
      _selectedCity = null;
      return;
    }

    // "경기도 고양시" 형식을 파싱
    final parts = userRegion.split(' ');
    if (parts.length >= 2) {
      // "경기도"에서 "도" 제거하여 "경기"로 변환
      final province = parts[0].replaceAll('도', '').replaceAll('시', '');
      final city = parts[1];

      // regions 목록에 있는지 확인
      if (_provinces.contains(province)) {
        _selectedProvince = province;
        // citiesByRegion에 해당 도가 있고, 시가 목록에 있는지 확인
        final cities = citiesByRegion[province];
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
      // 도만 있는 경우
      final province = parts[0].replaceAll('도', '').replaceAll('시', '');
      if (_provinces.contains(province)) {
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

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
              if ((_selectedImage != null || widget.user.userImg != null) &&
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
          _removeImage = false; // 새 이미지 선택 시 제거 플래그 리셋
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
          _removeImage = false; // 새 이미지 선택 시 제거 플래그 리셋
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

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl = widget.user.userImg;

      // 새 이미지가 선택된 경우 업로드
      if (_selectedImage != null) {
        final storageService = getIt<StorageService>();
        final imageFile = File(_selectedImage!.path);
        imageUrl = await storageService.updateProfileImage(
          userId: widget.user.id,
          imageFile: imageFile,
          oldImageUrl: widget.user.userImg,
        );
      } else if (_removeImage) {
        // 사진 제거 선택 시
        if (widget.user.userImg != null) {
          final storageService = getIt<StorageService>();
          await storageService.deleteProfileImage(widget.user.userImg!);
        }
        imageUrl = null;
      }

      // 도와 시를 합쳐서 지역 문자열 생성
      String regionText = '';
      if (_selectedProvince != null) {
        regionText = _selectedProvince!;
        if (_selectedCity != null) {
          regionText = '$regionText $_selectedCity';
        }
      }

      if (regionText.isEmpty) {
        ToastHelper.showError('지역을 선택해주세요');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final updatedUser = widget.user.copyWith(
        username: _nameController.text.trim(),
        region: regionText,
        userImg: imageUrl,
      );

      await ref.read(authProvider.notifier).updateProfile(updatedUser);

      if (mounted) {
        Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '프로필 수정',
                    style: AppTextStyle.titleLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 프로필 이미지
              Center(
                child: GestureDetector(
                  onTap: _showImagePicker,
                  child: Stack(
                    children: [
                      _selectedImage != null
                          ? ClipOval(
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: AppColors.cardBackground,
                                  border: Border.all(
                                    color: AppColors.onPrimary.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 2,
                                  ),
                                ),
                                child: Image.file(
                                  File(_selectedImage!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : _removeImage
                          ? ProfileAvatar(
                              imageUrl: null,
                              size: 120,
                              backgroundColor: AppColors.cardBackground,
                            )
                          : ProfileAvatar(
                              imageUrl: widget.user.userImg,
                              size: 120,
                              backgroundColor: AppColors.cardBackground,
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
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
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // 이름 입력
              Text(
                '이름',
                style: AppTextStyle.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: '이름을 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.textTertiary.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.textTertiary.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: AppTextStyle.bodyLarge,
              ),
              const SizedBox(height: 24),
              // 도 선택
              Text(
                '지역 (도)',
                style: AppTextStyle.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedProvince,
                decoration: InputDecoration(
                  hintText: '도를 선택하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.textTertiary.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.textTertiary.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                items: _provinces.map((province) {
                  return DropdownMenuItem(
                    value: province,
                    child: Text(province, style: AppTextStyle.bodyLarge),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProvince = value;
                    _selectedCity = null; // 도 변경 시 시 초기화
                  });
                },
              ),
              const SizedBox(height: 24),
              // 시 선택
              Text(
                '지역 (시/군/구)',
                style: AppTextStyle.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: InputDecoration(
                  hintText: _selectedProvince == null
                      ? '먼저 도를 선택하세요'
                      : '시/군/구를 선택하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.textTertiary.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.textTertiary.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                items: _cities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city, style: AppTextStyle.bodyLarge),
                  );
                }).toList(),
                onChanged: _selectedProvince == null
                    ? null
                    : (value) {
                        setState(() {
                          _selectedCity = value;
                        });
                      },
              ),
              const SizedBox(height: 32),
              // 저장 버튼
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.onPrimary,
                          ),
                        ),
                      )
                    : Text(
                        '저장',
                        style: AppTextStyle.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
