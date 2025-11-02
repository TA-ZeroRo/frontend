import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_color.dart';
import 'package:frontend/core/utils/toast_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/category_selector.dart';
import 'components/result_dialog.dart';
import 'components/suggestion_page.dart';
import 'components/info_dialog.dart';
import 'components/info_button.dart';
import 'components/camera_picker.dart';
import 'components/gallery_picker.dart';
import 'state/image_verification_notifier.dart';

class VerifyImageScreen extends ConsumerStatefulWidget {
  const VerifyImageScreen({super.key});

  @override
  ConsumerState<VerifyImageScreen> createState() => _VerifyImageScreenState();
}

class _VerifyImageScreenState extends ConsumerState<VerifyImageScreen> {
  final List<String> _selectedImages = [];
  final CameraPicker _cameraPicker = CameraPicker();
  final GalleryPicker _galleryPicker = GalleryPicker();

  SubCategory? _selectedSubCategory;
  String? _selectedImageSource; // 'camera' or 'gallery'

  @override
  void initState() {
    super.initState();
    _maybeShowInfoDialog();
  }

  Future<void> _maybeShowInfoDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenDialog = prefs.getBool('showAuthImageDialog') ?? false;
    if (!hasSeenDialog && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black54,
          builder: (_) => CustomInfoDialog(
            title: '사진 인증이란?',
            content:
                '친환경 활동을 사진으로 증명하고 AI로 인증을 받는 기능입니다.\n\n사진을 첨부하고 카테고리를 선택하면 AI가 친환경 여부를 판단합니다.',
            preferenceKey: 'showAuthImageDialog',
            onClose: (_) {},
          ),
        );
      });
    }
  }

  Future<void> _pickFromCamera() async {
    final file = await _cameraPicker.pickImageFromCamera();
    if (file != null) {
      setState(() {
        _selectedImages.add(file.path);
        _selectedImageSource = 'camera';
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final file = await _galleryPicker.pickImageFromGallery();
    if (file != null) {
      setState(() {
        _selectedImages.add(file.path);
        _selectedImageSource = 'gallery';
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      if (_selectedImages.isEmpty) {
        _selectedImageSource = null;
      }
    });
  }

  Future<void> _requestAIAnalysis() async {
    final isImageEmpty = _selectedImages.isEmpty;
    final isCategoryNotSelected = _selectedSubCategory == null;

    if (isImageEmpty && isCategoryNotSelected) {
      _showWarning('사진을 첨부하고 카테고리를 선택해주세요');
      return;
    }

    if (isImageEmpty) {
      _showWarning('사진을 첨부해주세요');
      return;
    }

    if (isCategoryNotSelected) {
      _showWarning('카테고리를 선택해주세요');
      return;
    }

    // Trigger verification
    await ref
        .read(imageVerificationProvider.notifier)
        .verifyImage(_selectedImages.first, _selectedSubCategory!.id);
  }

  void _showWarning(String message) {
    ToastHelper.showError(message);
  }

  @override
  Widget build(BuildContext context) {
    final verificationState = ref.watch(imageVerificationProvider);

    // Listen to verification result
    ref.listen<ImageVerificationState>(imageVerificationProvider, (
      previous,
      next,
    ) {
      if (next.result != null && !next.isLoading) {
        showDialog(
          context: context,
          builder: (context) => VerificationResultDialog(
            isValid: next.result!.isValid,
            confidence: next.result!.confidence,
            reason: next.result!.reason,
            onConfirm: () {
              Navigator.of(context).pop();
              ref.read(imageVerificationProvider.notifier).reset();
            },
          ),
        );
      } else if (next.error != null) {
        _showWarning('분석 중 오류가 발생했습니다.');
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Custom AppBar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            '사진 인증',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: verificationState.isLoading
                              ? null
                              : () => _requestAIAnalysis(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: verificationState.isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text('AI 분석'),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 카테고리 선택 섹션
                          const Row(
                            children: [
                              Icon(
                                Icons.category,
                                size: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '카테고리 선택',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          CategorySelector(
                            onSubCategorySelected: (subCategory) {
                              setState(
                                () => _selectedSubCategory = subCategory,
                              );
                            },
                            onSuggestionTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SuggestionPage(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 32),

                          // 사진 첨부 섹션
                          const Row(
                            children: [
                              Icon(
                                Icons.photo_camera,
                                size: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '사진 첨부',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // 사진 표시 영역
                          if (_selectedImages.isNotEmpty) ...[
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _selectedImages.length,
                                itemBuilder: (context, index) => Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          File(_selectedImages[index]),
                                          width: 160,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () => _removeImage(index),
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // 추가 사진 버튼들 (이미지가 있을 때)
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _pickFromCamera,
                                    icon: const Icon(Icons.camera_alt_outlined),
                                    label: const Text('카메라'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          _selectedImageSource == 'camera'
                                          ? Colors.white
                                          : AppColors.primary,
                                      foregroundColor:
                                          _selectedImageSource == 'camera'
                                          ? AppColors.primary
                                          : Colors.white,
                                      side: BorderSide(
                                        color: AppColors.primary,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _pickFromGallery,
                                    icon: const Icon(
                                      Icons.photo_library_outlined,
                                    ),
                                    label: const Text('갤러리'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          _selectedImageSource == 'gallery'
                                          ? Colors.white
                                          : AppColors.primary,
                                      foregroundColor:
                                          _selectedImageSource == 'gallery'
                                          ? AppColors.primary
                                          : Colors.white,
                                      side: BorderSide(
                                        color: AppColors.primary,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            // 사진 없을 때 표시할 영역
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '친환경 활동 사진을 첨부해주세요',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // 사진 선택 버튼들 (이미지가 없을 때)
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _pickFromCamera,
                                    icon: const Icon(Icons.camera_alt_outlined),
                                    label: const Text('카메라로 촬영'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _pickFromGallery,
                                    icon: const Icon(
                                      Icons.photo_library_outlined,
                                    ),
                                    label: const Text('갤러리에서 선택'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  // 하단 정보 버튼
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InfoButton(
                          title: '사진 인증이란?',
                          content:
                              '친환경 활동을 사진으로 증명하고 AI로 인증을 받는 기능입니다.\n\n사진을 첨부하고 카테고리를 선택하면 AI가 친환경 여부를 판단합니다.',
                          preferenceKey: 'showAuthImageDialog',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // 분석 중 메시지
              if (verificationState.isLoading)
                Positioned(
                  bottom: 80,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'AI가 분석 중입니다...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
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
