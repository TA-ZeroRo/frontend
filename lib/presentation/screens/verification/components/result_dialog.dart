import 'package:flutter/material.dart';

class VerificationResultDialog extends StatelessWidget {
  final bool isValid;
  final double confidence;
  final String reason;
  final VoidCallback onConfirm;

  const VerificationResultDialog({
    required this.isValid,
    required this.confidence,
    required this.reason,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const Color positiveColor = Color(0xFF74CD7C);
    const Color errorColor = Color(0xFFFF5645);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            color: isValid ? positiveColor : errorColor,
            size: 32,
          ),
          const SizedBox(width: 8),
          Text(
            isValid ? '인증 성공!' : '인증 실패',
            style: TextStyle(
              color: isValid ? positiveColor : errorColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('정확도: ${(confidence * 100).toStringAsFixed(1)}%'),
          const SizedBox(height: 8),
          Text('사유: $reason'),
        ],
      ),
      actions: [TextButton(onPressed: onConfirm, child: const Text('확인'))],
    );
  }
}
