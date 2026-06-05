// GRCThemeController is now in lib/core/theme/grc_theme_controller.dart.
// This file re-exports it so all existing imports continue to compile.
import 'package:get/get.dart';
import 'package:demo_app/core/theme/grc_theme_controller.dart';

export 'package:demo_app/core/theme/grc_theme_controller.dart';

final GRCThemeController themeController = Get.put(GRCThemeController());
