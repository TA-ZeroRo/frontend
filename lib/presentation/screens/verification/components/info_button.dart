import 'package:flutter/material.dart';
import 'info_dialog.dart';

class InfoButton extends StatelessWidget {
  final String title;
  final String content;
  final String preferenceKey;

  const InfoButton({
    super.key,
    required this.title,
    required this.content,
    required this.preferenceKey,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline, color: Colors.grey),
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black54,
          builder: (_) => CustomInfoDialog(
            title: title,
            content: content,
            preferenceKey: preferenceKey,
            onClose: (_) {},
          ),
        );
      },
    );
  }
}
