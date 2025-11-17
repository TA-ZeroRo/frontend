import 'package:flutter/material.dart';
import 'package:frontend/core/utils/toast_helper.dart';
import 'package:frontend/domain/model/mission/mission_with_template.dart';

import '../../../../../../../core/theme/app_color.dart';

class TextReviewVerificationBottomSheet extends StatefulWidget {
  final MissionWithTemplate mission;

  const TextReviewVerificationBottomSheet({
    super.key,
    required this.mission,
  });

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
            '소감문 작성',
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
          _buildTextField(),
          const SizedBox(height: 8),
          _buildCharacterCounter(),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _textController,
        maxLines: 8,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: '미션 수행 소감을 작성해주세요',
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildCharacterCounter() {
    final bool isValid = _currentLength >= _minCharacters;
    final Color textColor = isValid
        ? AppColors.primary
        : Colors.white.withValues(alpha: 0.5);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$_minCharacters자 이상 작성해주세요',
          style: TextStyle(
            color: textColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '($_currentLength/$_minCharacters)',
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final bool isValid = _currentLength >= _minCharacters;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isValid ? _handleSubmit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isValid
                ? AppColors.primary
                : AppColors.cardBackground.withValues(alpha: 0.5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor:
                AppColors.cardBackground.withValues(alpha: 0.5),
            disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
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

  void _handleSubmit() {
    if (_currentLength < _minCharacters) {
      ToastHelper.showWarning('$_minCharacters자 이상 작성해주세요');
      return;
    }

    // Mock 동작: 실제 제출은 구현하지 않음
    ToastHelper.showSuccess('소감문이 제출되었습니다');
    Navigator.of(context).pop();
  }
}
