import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Stub: ConfirmationDialog — shows a lottie + title + message confirmation.
class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.lottiePath,
  });
  final String title;
  final String message;
  final String? lottiePath;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'.tr)),
      ],
    );
  }
}
