// Stub NavScreen — mobile nav bar not fully included in demo_app.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/home/nav_bar/presentation/ui/pages/more_page.dart';
import 'package:demo_app/features/roles/system_logs/presentation/controller/system_logs_controller.dart';
import 'package:demo_app/core/theme/grc_theme_controller.dart';

export 'package:demo_app/features/home/nav_bar/presentation/ui/pages/more_page.dart';

// Global accessor used by event controllers — lazy so it resolves after registration
SystemLogsController get systemLogsController => Get.find<SystemLogsController>();

// GRC theme controller global used by tracking/attendance components
GRCThemeController themeController = Get.put(GRCThemeController());

class NavScreen extends StatelessWidget {
  const NavScreen({super.key});
  @override
  Widget build(BuildContext context) => const MorePage();
}
