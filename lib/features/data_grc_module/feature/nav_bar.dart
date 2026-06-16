// GRCThemeController is now in lib/core/theme/grc_theme_controller.dart.
// This file re-exports it so all existing imports continue to compile.
import 'package:demo_app/core/theme/theme_controller.dart';
import 'package:get/get.dart';



final ThemeController themeController = Get.put(ThemeController());
