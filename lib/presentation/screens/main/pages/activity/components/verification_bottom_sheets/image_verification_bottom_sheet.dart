import 'package:flutter/material.dart';
import 'package:frontend/core/utils/toast_helper.dart';
import 'package:frontend/domain/model/mission/mission_with_template.dart';

import '../../../../../../../core/theme/app_color.dart';

class ImageVerificationBottomSheet extends StatefulWidget {
  final MissionWithTemplate mission;

  const ImageVerificationBottomSheet({
    super.key,
    required this.mission,
  });

  @override
  State<ImageVerificationBottomSheet> createState() =>
      _ImageVerificationBottomSheetState();
}

class _ImageVerificationBottomSheetState
    extends State<ImageVerificationBottomSheet> {
  String? _selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildContent(),
          _buildSubmitButton(),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40),
          const Text(
            '사진 인증',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.mission.missionTemplate.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.mission.missionTemplate.description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          _buildImageSelectionButtons(),
          if (_selectedImagePath != null) ...[
            const SizedBox(height: 24),
            _buildImagePreview(),
          ],
        ],
      ),
    );
  }

  Widget _buildImageSelectionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildImagePickerButton(
            icon: Icons.camera_alt,
            label: '카메라',
            onTap: () => _handleImageSelection('camera'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildImagePickerButton(
            icon: Icons.photo_library,
            label: '갤러리',
            onTap: () => _handleImageSelection('gallery'),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePickerButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              color: AppColors.primary,
              size: 48,
            ),
            SizedBox(height: 8),
            Text(
              '이미지 미리보기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            '제출하기',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _handleImageSelection(String source) {
    // Mock 동작: 이미지 선택 기능은 구현하지 않음
    ToastHelper.showInfo('이미지 선택 기능은 곧 구현됩니다');
    setState(() {
      _selectedImagePath = 'mock_image_path';
    });
  }

  void _handleSubmit() {
    if (_selectedImagePath == null) {
      ToastHelper.showWarning('이미지를 선택해주세요');
      return;
    }

    // Mock 동작: 실제 제출은 구현하지 않음
    ToastHelper.showSuccess('이미지가 제출되었습니다');
    Navigator.of(context).pop();
  }
}
