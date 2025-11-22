import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/core/utils/toast_helper.dart';
import 'package:frontend/domain/model/mission/mission_with_template.dart';

import '../../../../../../../core/theme/app_color.dart';

class ImageVerificationBottomSheet extends StatefulWidget {
  final MissionWithTemplate mission;

  const ImageVerificationBottomSheet({super.key, required this.mission});

  @override
  State<ImageVerificationBottomSheet> createState() =>
      _ImageVerificationBottomSheetState();
}

class _ImageVerificationBottomSheetState
    extends State<ImageVerificationBottomSheet> {
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
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
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildImageSelectionArea(),
                if (_selectedImage != null) ...[
                  const SizedBox(height: 24),
                  _buildImagePreview(),
                ],
                const SizedBox(height: 32),
                _buildSubmitButton(),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              '사진 인증',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          widget.mission.missionTemplate.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.mission.missionTemplate.description,
          style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildImageSelectionArea() {
    return Row(
      children: [
        Expanded(
          child: _buildSelectionCard(
            icon: Icons.camera_alt_rounded,
            label: '카메라 촬영',
            onTap: () => _handleImageSelection('camera'),
            color: const Color(0xFFE3F2FD),
            iconColor: const Color(0xFF2196F3),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSelectionCard(
            icon: Icons.photo_library_rounded,
            label: '앨범에서 선택',
            onTap: () => _handleImageSelection('gallery'),
            color: const Color(0xFFE3F2FD),
            iconColor: const Color(0xFF2196F3),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: iconColor.withValues(alpha: 0.8),
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
      height: 240,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _selectedImage != null
                ? Image.file(
                    _selectedImage!,
                    width: double.infinity,
                    height: 240,
                    fit: BoxFit.cover,
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('선택된 이미지', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _selectedImage = null;
                });
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.5),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.close, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    final bool isEnabled = _selectedImage != null;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? _handleSubmit : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          disabledBackgroundColor: Colors.grey[200],
          disabledForegroundColor: Colors.grey[400],
        ),
        child: const Text(
          '인증하기',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _handleImageSelection(String source) {
    if (source == 'camera') {
      _pickImageFromCamera();
    } else if (source == 'gallery') {
      _pickImageFromGallery();
    }
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

  void _handleSubmit() {
    if (_selectedImage == null) return;

    ToastHelper.showSuccess('이미지가 제출되었습니다');
    Navigator.of(context).pop();
  }
}
