import 'package:flutter/material.dart';
import 'package:frontend/core/utils/toast_helper.dart';
import 'package:frontend/domain/model/mission/mission_with_template.dart';

import '../../../../../../../core/theme/app_color.dart';

class QuizVerificationBottomSheet extends StatefulWidget {
  final MissionWithTemplate mission;

  const QuizVerificationBottomSheet({super.key, required this.mission});

  @override
  State<QuizVerificationBottomSheet> createState() =>
      _QuizVerificationBottomSheetState();
}

class _QuizVerificationBottomSheetState
    extends State<QuizVerificationBottomSheet> {
  bool _isSubmitting = false;

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
                const SizedBox(height: 32),
                _buildInfoCard(),
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
                Icons.quiz_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              '퀴즈 인증',
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

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // Light Amber/Orange background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFE082), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Color(0xFFFFB300),
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '퀴즈 미션 진행 안내',
            style: TextStyle(
              color: Color(0xFFF57F17),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '아래 버튼을 누르면 퀴즈가 시작됩니다.\n정답을 맞추면 미션이 완료됩니다.',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _handleSubmit,
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
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                '퀴즈 시작하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _isSubmitting = true;
    });

    // Mock 동작
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    ToastHelper.showSuccess('자동 제출이 완료되었습니다');
    Navigator.of(context).pop();
  }
}
