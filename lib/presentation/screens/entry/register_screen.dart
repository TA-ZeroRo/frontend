import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/constants/regions.dart';
import '../../../core/utils/toast_helper.dart';
import '../../../data/data_source/storage_service.dart';
import '../../routes/router_path.dart';
import 'state/auth_controller.dart';
import 'privacy_policy_modal.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  String? _selectedProvince;
  String? _selectedCity;
  String? _selectedLocation;
  File? _selectedImage;
  bool _isConsentGiven = false;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _handleRegister(BuildContext context, WidgetRef ref) async {
    final authState = ref.read(authProvider);

    try {
      String? imageUrl;

      // 이미지가 선택된 경우 Supabase Storage에 업로드
      if (_selectedImage != null) {
        final userId = Supabase.instance.client.auth.currentSession?.user.id;
        if (userId != null) {
          final storageService = getIt<StorageService>();
          imageUrl = await storageService.uploadProfileImage(
            userId: userId,
            imageFile: _selectedImage!,
          );
        }
      }

      await ref
          .read(authProvider.notifier)
          .register(
            nickname: authState.registerNickname,
            region: _selectedLocation ?? authState.registerLocation,
            userImg: imageUrl,
          );

      // 회원가입 성공 시 메인 화면으로 이동
      if (context.mounted) {
        context.go(RoutePath.main);
      }
    } catch (e) {
      if (!context.mounted) return;

      // 에러 토스트 표시
      ToastHelper.showError('회원가입 실패: ${e.toString()}');
    }
  }

  void _updateSelectedLocation() {
    if (_selectedProvince != null && _selectedCity != null) {
      _selectedLocation = KoreanRegions.getFullAddress(
        _selectedProvince!,
        _selectedCity!,
      );
      ref
          .read(authProvider.notifier)
          .updateRegisterLocation(_selectedLocation!);
    } else {
      _selectedLocation = null;
    }
  }

  Future<void> _showPrivacyPolicy() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const PrivacyPolicyModal();
      },
    );

    if (result == true) {
      setState(() {
        _isConsentGiven = true;
      });
    }
  }

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
              const SizedBox(height: 12),
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '프로필 사진 선택',
                          style: AppTextStyle.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Selection Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildImagePickerCard(
                            icon: Icons.camera_alt_rounded,
                            label: '카메라 촬영',
                            onTap: () {
                              Navigator.pop(context);
                              _pickImageFromCamera();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildImagePickerCard(
                            icon: Icons.photo_library_rounded,
                            label: '앨범에서 선택',
                            onTap: () {
                              Navigator.pop(context);
                              _pickImageFromGallery();
                            },
                          ),
                        ),
                      ],
                    ),
                    if (_selectedImage != null) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() => _selectedImage = null);
                          },
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.error,
                          ),
                          label: Text(
                            '사진 제거',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePickerCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTextStyle.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError('카메라 오류: $e');
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError('갤러리 오류: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go(RoutePath.login),
          color: AppColors.onPrimary,
        ),
        title: Text(
          '회원가입',
          style: AppTextStyle.headlineSmall.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Welcome Title
              Text(
                '환영합니다!',
                style: AppTextStyle.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '기본 정보만 입력하면 시작할 수 있어요',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 24),

              // Profile Image Section
              _buildSectionHeader(
                icon: Icons.camera_alt_outlined,
                title: '프로필 사진',
              ),
              const SizedBox(height: 12),
              Center(
                child: GestureDetector(
                  onTap: _showImagePicker,
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cardShadow,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: _selectedImage != null
                              ? Image.file(_selectedImage!, fit: BoxFit.cover)
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: AppColors.cardGradient,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.photo_library_outlined,
                                      size: 40,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                            border: Border.all(
                              color: AppColors.background,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            size: 18,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Nickname Section
              _buildSectionHeader(
                icon: Icons.person_outline_rounded,
                title: '닉네임',
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.textTertiary.withValues(alpha: 0.2),
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
                  onChanged: authNotifier.updateRegisterNickname,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: '닉네임을 입력해주세요',
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
              ),

              const SizedBox(height: 20),

              // Location Section
              _buildSectionHeader(
                icon: Icons.location_on_outlined,
                title: '거주지',
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // 시도 선택 Autocomplete
                  Expanded(
                    child: Autocomplete<String>(
                      optionsBuilder: (textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return KoreanRegions.provinces;
                        }
                        return KoreanRegions.provinces.where(
                          (province) =>
                              province.contains(textEditingValue.text),
                        );
                      },
                      onSelected: (value) {
                        setState(() {
                          _selectedProvince = value;
                          _selectedCity = null;
                          _updateSelectedLocation();
                        });
                        FocusScope.of(context).nextFocus();
                      },
                      fieldViewBuilder:
                          (context, controller, focusNode, onFieldSubmitted) {
                            if (_selectedProvince != null &&
                                controller.text.isEmpty) {
                              controller.text = _selectedProvince!;
                            }
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: '시/도',
                                hintStyle: AppTextStyle.bodyMedium.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                                filled: true,
                                fillColor: AppColors.cardBackground,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.textTertiary.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.textTertiary.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    focusNode.requestFocus();
                                    final text = controller.text;
                                    controller.text = '';
                                    controller.text = text;
                                    controller.selection = TextSelection.collapsed(
                                      offset: text.length,
                                    );
                                  },
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              constraints: const BoxConstraints(maxHeight: 200),
                              width: MediaQuery.of(context).size.width / 2 - 26,
                              decoration: BoxDecoration(
                                color: AppColors.cardBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  final option = options.elementAt(index);
                                  return InkWell(
                                    onTap: () => onSelected(option),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      child: Text(
                                        option,
                                        style: AppTextStyle.bodyMedium.copyWith(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 시/군/구 선택 Autocomplete
                  Expanded(
                    child: Autocomplete<String>(
                      optionsBuilder: (textEditingValue) {
                        final cities = _selectedProvince != null
                            ? KoreanRegions.cities[_selectedProvince] ?? []
                            : <String>[];
                        if (textEditingValue.text.isEmpty) {
                          return cities;
                        }
                        return cities.where(
                          (city) => city.contains(textEditingValue.text),
                        );
                      },
                      onSelected: (value) {
                        setState(() {
                          _selectedCity = value;
                          _updateSelectedLocation();
                        });
                        FocusScope.of(context).unfocus();
                      },
                      fieldViewBuilder:
                          (context, controller, focusNode, onFieldSubmitted) {
                            if (_selectedCity != null &&
                                controller.text.isEmpty) {
                              controller.text = _selectedCity!;
                            }
                            // 시도 변경 시 시/군/구 초기화
                            if (_selectedCity == null &&
                                controller.text.isNotEmpty) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                controller.clear();
                              });
                            }
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              enabled: _selectedProvince != null,
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: '시/군/구',
                                hintStyle: AppTextStyle.bodyMedium.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                                filled: true,
                                fillColor: AppColors.cardBackground,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.textTertiary.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.textTertiary.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.textTertiary.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: _selectedProvince != null
                                      ? () {
                                          focusNode.requestFocus();
                                          final text = controller.text;
                                          controller.text = '';
                                          controller.text = text;
                                          controller.selection = TextSelection.collapsed(
                                            offset: text.length,
                                          );
                                        }
                                      : null,
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: _selectedProvince != null
                                        ? AppColors.textSecondary
                                        : AppColors.textTertiary,
                                  ),
                                ),
                              ),
                            );
                          },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              constraints: const BoxConstraints(maxHeight: 200),
                              width: MediaQuery.of(context).size.width / 2 - 26,
                              decoration: BoxDecoration(
                                color: AppColors.cardBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  final option = options.elementAt(index);
                                  return InkWell(
                                    onTap: () => onSelected(option),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      child: Text(
                                        option,
                                        style: AppTextStyle.bodyMedium.copyWith(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Privacy Policy Consent
              _buildSectionHeader(
                icon: Icons.verified_user_outlined,
                title: '약관 동의',
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.textTertiary.withValues(alpha: 0.2),
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
                    Expanded(
                      child: GestureDetector(
                        onTap: _showPrivacyPolicy,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '(필수) ',
                                style: AppTextStyle.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              TextSpan(
                                text: '개인정보 수집 및 이용 동의',
                                style: AppTextStyle.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: _isConsentGiven,
                        onChanged: (value) {
                          setState(() {
                            _isConsentGiven = value ?? false;
                          });
                        },
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: BorderSide(
                          color: AppColors.textTertiary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      authNotifier.isRegisterFormValid() &&
                          !authState.isLoading &&
                          _isConsentGiven
                      ? () => _handleRegister(context, ref)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.textTertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.primary.withValues(alpha: 0.3),
                  ),
                  child: authState.isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.onPrimary,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '시작하기',
                              style: AppTextStyle.bodyLarge.copyWith(
                                color:
                                    authNotifier.isRegisterFormValid() &&
                                        _isConsentGiven
                                    ? AppColors.onPrimary
                                    : AppColors.cardBackground,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (authNotifier.isRegisterFormValid() &&
                                _isConsentGiven) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 18,
                                color: AppColors.onPrimary,
                              ),
                            ],
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: AppTextStyle.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              subtitle,
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
