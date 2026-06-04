import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Stub: SuccessDialog
class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  static void show(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Success'.tr),
        content: message != null ? Text(message) : null,
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'.tr))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
