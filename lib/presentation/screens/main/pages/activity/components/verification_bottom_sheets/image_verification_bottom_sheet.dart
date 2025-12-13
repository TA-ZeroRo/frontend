import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:frontend/core/utils/toast_helper.dart';
import 'package:frontend/domain/model/mission/mission_with_template.dart';
import 'package:frontend/presentation/screens/entry/state/auth_controller.dart';

import '../../../../../../../core/di/injection.dart';
import '../../../../../../../core/logger/logger.dart';
import '../../../../../../../core/theme/app_color.dart';
import '../../../../../../../data/data_source/mission/mission_api.dart';
import '../../../../../../../data/data_source/verification/verification_api.dart';

class ImageVerificationBottomSheet extends ConsumerStatefulWidget {
  final MissionWithTemplate mission;

  const ImageVerificationBottomSheet({super.key, required this.mission});

  @override
  ConsumerState<ImageVerificationBottomSheet> createState() =>
      _ImageVerificationBottomSheetState();
}

class _ImageVerificationBottomSheetState
    extends ConsumerState<ImageVerificationBottomSheet> {
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  final MissionApi _missionApi = getIt<MissionApi>();
  final VerificationApi _verificationApi = getIt<VerificationApi>();
  bool _isSubmitting = false;
  String _statusMessage = '';

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
    final bool isEnabled = _selectedImage != null && !_isSubmitting;

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
        child: _isSubmitting
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  if (_statusMessage.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    Text(
                      _statusMessage,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              )
            : const Text(
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

  Future<void> _handleSubmit() async {
    if (_selectedImage == null || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
      _statusMessage = '이미지 업로드 중...';
    });

    try {
      // 1. Supabase Storage에 이미지 업로드
      final supabase = Supabase.instance.client;
      final fileName =
          'mission-proofs/mission_${widget.mission.missionLog.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final bytes = await _selectedImage!.readAsBytes();

      await supabase.storage.from('zeroro-post-bucket').uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      final imageUrl =
          supabase.storage.from('zeroro-post-bucket').getPublicUrl(fileName);

      if (!mounted) return;
      setState(() => _statusMessage = 'AI 검증 중...');

      // 2. Gemini 검증 API 호출
      // TODO: MissionTemplate에 카테고리 인덱스 추가 후 사용
      final verificationResult = await _verificationApi.verifyImage(
        imageFile: _selectedImage!,
        mainCategoryIndex: 0, // 기본값 (추후 템플릿에서 가져오기)
        subCategoryIndex: 0, // 기본값 (추후 템플릿에서 가져오기)
      );

      if (!mounted) return;
      setState(() => _statusMessage = '제출 중...');

      // 3. 검증 결과 포함하여 증빙 데이터 제출
      // 모든 정상 제출은 PENDING_VERIFICATION → Console에서 최종 승인
      final response = await _missionApi.submitProof(
        logId: widget.mission.missionLog.id,
        proofData: {
          'imageUrl': imageUrl,
          'verification_result': {
            'is_valid': verificationResult.isValid,
            'confidence': verificationResult.confidence,
            'reason': verificationResult.reason,
          },
        },
      );

      if (!mounted) return;

      // 4. 상태에 따른 메시지 표시
      if (response.status == 'PENDING_VERIFICATION') {
        ToastHelper.showSuccess('제출 완료! 관리자 검토 후 포인트가 지급됩니다.');
      } else if (response.status == 'COMPLETED') {
        // 기존 미션이 이미 완료 상태였던 경우
        await ref.read(authProvider.notifier).refreshCurrentUser();
        ToastHelper.showSuccess('인증 완료! 포인트가 지급되었어요 🎉');
      } else {
        ToastHelper.showError('제출 실패: ${verificationResult.reason}');
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      CustomLogger.logger.e('미션 제출 실패', error: e);
      if (!mounted) return;
      ToastHelper.showError('제출에 실패했습니다. 다시 시도해주세요.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _statusMessage = '';
        });
      }
    }
  }
}
