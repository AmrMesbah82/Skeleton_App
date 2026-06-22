import 'dart:ui';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/services_mangment_module/core/new_theme.dart';

enum UserAccessStatus {
  all,
  active,
  scheduled, // ✅ NEW: access granted but start date is still in the future
  inactive,
  expiringSoon;

  // ✅ SOLUTION 1: Method that takes BuildContext
  Color getColor(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;

    switch (this) {
      case UserAccessStatus.all:
        return AppColors.text;
      case UserAccessStatus.active:
        return AppColors.green;
      case UserAccessStatus.scheduled:
        return Color(0xFFFF814A); // ✅ Orange — matches _getStatusColor("scheduled")
      case UserAccessStatus.inactive:
        return AppColors.red;
      case UserAccessStatus.expiringSoon:
        return Color(0xFF991010);
    }
  }
}

// Usage example:
class MyWidget extends StatelessWidget {
  final UserAccessStatus status = UserAccessStatus.active;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: status.getColor(context), // ✅ Pass context
      child: Text('Status'),
    );
  }
}