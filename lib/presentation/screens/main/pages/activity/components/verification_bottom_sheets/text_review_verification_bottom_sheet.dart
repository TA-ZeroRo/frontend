import 'package:flutter/material.dart';
import 'package:frontend/core/utils/toast_helper.dart';
import 'package:frontend/domain/model/mission/mission_with_template.dart';

import '../../../../../../../core/theme/app_color.dart';

class TextReviewVerificationBottomSheet extends StatefulWidget {
  final MissionWithTemplate mission;

  const TextReviewVerificationBottomSheet({super.key, required this.mission});

  @override
  State<TextReviewVerificationBottomSheet> createState() =>
      _TextReviewVerificationBottomSheetState();
}

class _TextReviewVerificationBottomSheetState
    extends State<TextReviewVerificationBottomSheet> {
  final TextEditingController _textController = TextEditingController();
  static const int _minCharacters = 50;
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_updateCharacterCount);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updateCharacterCount() {
    setState(() {
      _currentLength = _textController.text.length;
    });
  }

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
                _buildTextField(),
                const SizedBox(height: 8),
                _buildCharacterCounter(),
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
                Icons.edit_note_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              '글쓰기 인증',
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

  Widget _buildTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: TextField(
        controller: _textController,
        maxLines: 8,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 15,
          height: 1.5,
        ),
        decoration: InputDecoration(
          hintText: '미션을 수행하며 느낀 점이나\n변화된 생각을 자유롭게 적어주세요.',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 15,
            height: 1.5,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildCharacterCounter() {
    final bool isValid = _currentLength >= _minCharacters;
    final Color textColor = isValid ? AppColors.primary : Colors.grey[500]!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!isValid)
          Text(
            '최소 $_minCharacters자 이상',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isValid
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$_currentLength / $_minCharacters',
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final bool isValid = _currentLength >= _minCharacters;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isValid ? _handleSubmit : null,
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

  void _handleSubmit() {
    if (_currentLength < _minCharacters) {
      ToastHelper.showWarning('$_minCharacters자 이상 작성해주세요');
      return;
    }

    // Mock 동작
    ToastHelper.showSuccess('소감문이 제출되었습니다');
    Navigator.of(context).pop();
  }
}
