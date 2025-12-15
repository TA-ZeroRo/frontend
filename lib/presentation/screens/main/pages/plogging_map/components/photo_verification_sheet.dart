import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../domain/model/plogging/photo_verification.dart';
import '../state/plogging_session_state.dart';

class PhotoVerificationSheet extends ConsumerStatefulWidget {
  const PhotoVerificationSheet({super.key});

  @override
  ConsumerState<PhotoVerificationSheet> createState() =>
      _PhotoVerificationSheetState();
}

class _PhotoVerificationSheetState
    extends ConsumerState<PhotoVerificationSheet> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 핸들바
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // 제목
          const Text(
            '플로깅 인증',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '쓰레기를 줍고 있는 모습을 촬영해주세요',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // 이미지 선택 영역
          GestureDetector(
            onTap: _selectImage,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        File(_selectedImage!.path),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '탭하여 사진 촬영',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 24),

          // 인증 가이드
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.camera_alt, size: 18, color: Colors.grey[700]),
                    const SizedBox(width: 8),
                    Text(
                      '이런 사진을 찍어주세요',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildGuideItem(
                  icon: Icons.back_hand_outlined,
                  title: '쓰레기를 들고 있는 모습',
                  example: '손에 페트병, 캔, 비닐 등',
                ),
                const SizedBox(height: 8),
                _buildGuideItem(
                  icon: Icons.shopping_bag_outlined,
                  title: '수거한 쓰레기가 담긴 봉투',
                  example: '쓰레기가 보이는 봉투',
                ),
                const SizedBox(height: 8),
                _buildGuideItem(
                  icon: Icons.pinch_outlined,
                  title: '쓰레기를 줍는 장면',
                  example: '바닥에서 집는 모습',
                ),
                const SizedBox(height: 8),
                _buildGuideItem(
                  icon: Icons.handyman_outlined,
                  title: '플로깅 장비 + 수거된 쓰레기',
                  example: '집게, 장갑 사용 중',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 제출 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedImage != null && !_isSubmitting
                  ? _submitVerification
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      '인증하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildGuideItem({
    required IconData icon,
    required String title,
    required String example,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                example,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _submitVerification() async {
    if (_selectedImage == null) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Supabase Storage에 이미지 업로드
      final supabase = Supabase.instance.client;
      final fileName =
          'plogging_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imageBytes = await File(_selectedImage!.path).readAsBytes();

      await supabase.storage.from('zeroro-post-bucket').uploadBinary(
            fileName,
            imageBytes,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      final imageUrl =
          supabase.storage.from('zeroro-post-bucket').getPublicUrl(fileName);

      final result = await ref
          .read(ploggingSessionProvider.notifier)
          .submitVerification(imageUrl: imageUrl);

      if (mounted) {
        Navigator.pop(context);
        _showResultDialog(result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증 실패: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showResultDialog(PhotoVerificationResponse? result) {
    if (result == null) return;

    final isVerified = result.verificationStatus == VerificationStatus.verified;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isVerified ? Icons.check_circle : Icons.cancel,
              color: isVerified ? Colors.green : Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              isVerified ? '인증 성공!' : '인증 실패',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (isVerified)
              Text(
                '+${result.pointsEarned}P 획득!',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              )
            else if (result.aiResult != null)
              Text(
                result.aiResult!.reason,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}

/// 인증 바텀시트 표시 함수
void showPhotoVerificationSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const PhotoVerificationSheet(),
  );
}
