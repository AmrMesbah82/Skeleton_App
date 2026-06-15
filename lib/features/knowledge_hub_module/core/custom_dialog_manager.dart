import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Stub: CustomDialogManager
class CustomDialogManager {
  static Future<void> showDialogFlow({
    required BuildContext context,
    String? confirmLottie,
    String? confirmTitle,
    String? confirmSubtitle,
    String? confirmYesText,
    String? confirmNoText,
    VoidCallback? onConfirm,
    bool comment = false,
    String? successLottie,
    String? successTitle,
    String? successSubtitle,
    String? successButtonText,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(confirmTitle ?? 'Confirm'.tr),
        content: confirmSubtitle != null ? Text(confirmSubtitle) : null,
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(confirmNoText ?? 'Cancel'.tr)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(confirmYesText ?? 'Yes'.tr)),
        ],
      ),
    );
    if (confirmed == true) onConfirm?.call();
  }
}
