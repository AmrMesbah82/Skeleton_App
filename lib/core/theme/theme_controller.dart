// // ignore_for_file: sdk_version_since
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:demo_app/core/theme/font_manager.dart';
// import 'package:demo_app/core/theme/my_theme.dart';
// import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';
// import 'package:demo_app/features/skeleton/settings/presentation/controller/add_company_controller.dart';
// // REMOVED_MODULE: import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';
// import '../../features/external/main_core/core/theme/app_theme.dart'
// as mainCoreAppTheme;
// // REMOVED_MODULE: import '../../features/external/messaging_package/interface/controller/messaging_init_controller.dart';
// import 'app_theme.dart';
import 'package:demo_app/features/skeleton/system_logs/presentation/controller/system_logs_controller.dart';
//
// class ThemeController extends GetxController {
//   final storage = GetStorage();
//   late Rx<ThemeData> currentTheme;
//   final RxBool isInitialized = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     currentTheme = MyThemeData.lightTheme.obs;
//
//     // Load theme data synchronously first
//     _loadThemeDataSync();
//
//     // Then initialize theme systems
//     Future.microtask(() {
//       initTheme(withMessage: false);
//       isInitialized.value = true;
//     });
//
//     // Setup listener for system UI updates
//     ever(currentTheme, (_) {
//       if (isInitialized.value) {
//         Future.microtask(() => updateSystemUIOverlayStyle());
//       }
//     });
//   }
//
//   void _loadThemeDataSync() {
//     print('🎨 [ThemeController] Loading theme from storage...');
//
//     // Load theme mode
//     final savedTheme = storage.read('theme');
//
//     if (savedTheme != null) {
//       if (savedTheme == 'darkMode') {
//         currentTheme.value = MyThemeData.darkTheme;
//         AppTheme.isDark = true;
//         mainCoreAppTheme.AppTheme.isDark = true; // ✅ Sync main core
//         print('🎨 [ThemeController] Loaded DARK theme from storage');
//       } else {
//         currentTheme.value = MyThemeData.lightTheme;
//         AppTheme.isDark = false;
//         mainCoreAppTheme.AppTheme.isDark = false; // ✅ Sync main core
//         print('🎨 [ThemeController] Loaded LIGHT theme from storage');
//       }
//     } else {
//       currentTheme.value = MyThemeData.lightTheme;
//       AppTheme.isDark = false;
//       mainCoreAppTheme.AppTheme.isDark = false; // ✅ Sync main core
//       print('🎨 [ThemeController] No saved theme, using LIGHT theme');
//     }
//
//     // Load and apply colors
//     final primaryColor = storage.read('primaryColor');
//     if (primaryColor != null) {
//       MyThemeData.lightPrimary = Color(int.parse(primaryColor));
//       MyThemeData.switchSettings = Color(int.parse(primaryColor));
//       print('🎨 [ThemeController] Loaded primary color: $primaryColor');
//     }
//
//     final secondaryColor = storage.read('secondaryColor');
//     if (secondaryColor != null) {
//       MyThemeData.signOut = Color(int.parse(secondaryColor));
//       MyThemeData.barColor = Color(int.parse(secondaryColor));
//       MyThemeData.bubbleColor = Color(int.parse(secondaryColor));
//       print('🎨 [ThemeController] Loaded secondary color: $secondaryColor');
//     }
//
//     // ✅ CRITICAL: Synchronize AppTheme with loaded state
//     AppTheme.setCurrentThemeColors();
//     mainCoreAppTheme.AppTheme.setCurrentThemeColors(); // ✅ Sync main core colors
//
//     print('🎨 [ThemeController] Theme sync completed - isDark: ${AppTheme.isDark}');
//   }
//
//   void updateSystemUIOverlayStyle() {
//     if (Get.context != null) {
//       bool isTablet = MediaQuery.of(Get.context!).size.shortestSide > 600;
//       if (isTablet) {
//         updateSystemUIOverlayStyleTablet();
//       } else {
//         updateSystemUIOverlayStyleMobile();
//       }
//     }
//   }
//
//   void updateSystemUIOverlayStyleMobile() {
//     if (currentTheme.value == MyThemeData.lightTheme) {
//       SystemChrome.setSystemUIOverlayStyle(
//         SystemUiOverlayStyle(
//           statusBarColor: MyThemeData.colorLightGrey,
//           statusBarIconBrightness: Brightness.dark,
//           statusBarBrightness: Brightness.light,
//         ),
//       );
//     } else {
//       SystemChrome.setSystemUIOverlayStyle(
//         SystemUiOverlayStyle(
//           statusBarColor: MyThemeData.colorBlack,
//           statusBarIconBrightness: Brightness.light,
//           statusBarBrightness: Brightness.dark,
//         ),
//       );
//     }
//   }
//
//   void updateSystemUIOverlayStyleTablet() {
//     if (currentTheme.value == MyThemeData.lightTheme) {
//       SystemChrome.setSystemUIOverlayStyle(
//         SystemUiOverlayStyle(
//           statusBarColor: MyThemeData.colorWhite,
//           statusBarIconBrightness: Brightness.dark,
//           statusBarBrightness: Brightness.light,
//         ),
//       );
//     } else {
//       SystemChrome.setSystemUIOverlayStyle(
//         SystemUiOverlayStyle(
//           statusBarColor: MyThemeData.dark,
//           statusBarIconBrightness: Brightness.light,
//           statusBarBrightness: Brightness.dark,
//         ),
//       );
//     }
//   }
//
//   void toggleTheme() {
//     print('🎨 [ThemeController] Theme toggle started - Current: ${currentTheme.value == MyThemeData.lightTheme ? "Light" : "Dark"}');
//
//     // Toggle theme mode
//     if (currentTheme.value == MyThemeData.lightTheme) {
//       currentTheme.value = MyThemeData.darkTheme;
//       storage.write('theme', 'darkMode');
//       AppTheme.isDark = true;
//       mainCoreAppTheme.AppTheme.isDark = true; // ✅ Sync main core
//       print('🎨 [ThemeController] Switched to DARK theme');
//     } else {
//       currentTheme.value = MyThemeData.lightTheme;
//       storage.write('theme', 'lightMode');
//       AppTheme.isDark = false;
//       mainCoreAppTheme.AppTheme.isDark = false; // ✅ Sync main core
//       print('🎨 [ThemeController] Switched to LIGHT theme');
//     }
//
//     // Log action
//     systemLogsController.systemLogsAction('change theme');
//
//     // ✅ Update color maps
//     AppTheme.setCurrentThemeColors();
//     mainCoreAppTheme.AppTheme.setCurrentThemeColors();
//     print('🎨 Color map updated - isDark: ${AppTheme.isDark}');
//
// // Log action
//     systemLogsController.systemLogsAction('change theme');
//
//
//
//
//     // ✅ CRITICAL: Update color maps BEFORE toggling other modules
//     print('🎨 [ThemeController] Updating color maps...');
//     AppTheme.setCurrentThemeColors();
//     mainCoreAppTheme.AppTheme.setCurrentThemeColors();
//
//     // Synchronize all theme systems
//     print('🎨 [ThemeController] Updating theme in all modules...');
//     mainCoreThemeController.toggleTheme();
//     AppTheme.interfaceToggleTheme();
//
//     try {
//       if (Get.isRegistered<MessagingInitController>()) {
//         Get.find<MessagingInitController>()
//             .messagingConfigurations
//             .toggleTheme();
//       }
//     } catch (e) {
//       print('⚠️ [ThemeController] Error updating messaging theme: $e');
//     }
//
//     // Note: This toggles isDark again, but we already set it above
//     // mainCoreAppTheme.AppTheme.toggleTheme();
//
//     // Update UI in post frame callback
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       updateSystemUIOverlayStyle();
//       Get.forceAppUpdate();
//       print('🎨 [ThemeController] Theme toggle completed - isDark: ${AppTheme.isDark}');
//     });
//   }
//
//   initTheme({bool withMessage = true}) {
//     print('🎨 [ThemeController] Initializing theme...');
//
//     final int primaryColor =
//     int.parse(storage.read('primaryColor') ?? '0xFFFFDE59');
//     final int secondaryColor =
//     int.parse(storage.read('secondaryColor') ?? '0xFFE5B800');
//     Color primary = Color(primaryColor);
//     Color secondary = Color(secondaryColor);
//
//     // ✅ FIX: Use the actual theme state from currentTheme
//     bool isDark = currentTheme.value == MyThemeData.darkTheme;
//
//     print('🎨 [ThemeController] Primary color: $primary');
//     print('🎨 [ThemeController] Secondary color: $secondary');
//     print('🎨 [ThemeController] Dark mode: $isDark (from currentTheme)');
//     print('🎨 [ThemeController] AppTheme.isDark: ${AppTheme.isDark}');
//     print('🎨 [ThemeController] mainCoreAppTheme.AppTheme.isDark: ${mainCoreAppTheme.AppTheme.isDark}');
//
//     // ✅ Ensure all theme systems are in sync
//     AppTheme.isDark = isDark;
//     mainCoreAppTheme.AppTheme.isDark = isDark;
//
//     // Initialize messaging module if needed
//     if (withMessage) {
//       // REMOVED_MODULE: try {
//         if (Get.isRegistered<MessagingInitController>()) {
//           Get.find<MessagingInitController>()
//               .messagingConfigurations
//               .initTheme(primary, secondary, isDark);
//         }
//       } catch (e) {
//         print('⚠️ [ThemeController] Error initializing messaging theme: $e');
//       }
//     }
//
//     // Initialize other theme systems with correct dark mode state
//     AppTheme.interfaceInitTheme(primary, secondary, isDark);
//     mainCoreAppTheme.AppTheme.initTheme(primary, secondary, isDark);
//
//     // ✅ CRITICAL: Update color maps after init
//     AppTheme.setCurrentThemeColors();
//     mainCoreAppTheme.AppTheme.setCurrentThemeColors();
//
//     print('🎨 [ThemeController] Theme initialization completed');
//   }
//
//   CompanyController addCompanyController = Get.put(CompanyController());
//
//   void updatePrimaryColor() {
//     print('🎨 [ThemeController] Updating primary color...');
//
//     final String? colorValue =
//     addCompanyController.company!.status! == 'active'
//         ? addCompanyController
//         .company!.primaryColor!.primaryColor?.lastOrNull
//         : null;
//
//     print('🎨 [ThemeController] Primary color from company: $colorValue');
//
//     storage.write('primaryColor', colorValue);
//
//     MyThemeData.lightPrimary = colorValue != null
//         ? Color(int.parse(colorValue))
//         : const Color(0xFFFFDE59);
//
//     MyThemeData.switchSettings = colorValue != null
//         ? Color(int.parse(colorValue))
//         : const Color(0xFFFFDE59);
//
//     print('🎨 [ThemeController] Primary color set to: ${MyThemeData.lightPrimary}');
//
//     // Refresh current theme to apply new color
//     if (currentTheme.value == MyThemeData.lightTheme) {
//       currentTheme.value = MyThemeData.lightTheme;
//       MyThemeData().contrastColor();
//     } else {
//       currentTheme.value = MyThemeData.darkTheme;
//       MyThemeData().contrastColor();
//     }
//
//     // Update modules AFTER setting the storage values
//     updateModulesBranding();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Get.forceAppUpdate();
//     });
//
//     print('🎨 [ThemeController] Primary color update completed');
//   }
//
//   void updateSecondaryColor() {
//     print('🎨 [ThemeController] Updating secondary color...');
//
//     final String? colorValue =
//     addCompanyController.company!.status! == 'active'
//         ? addCompanyController
//         .company!.secondaryColor!.secondaryColor?.lastOrNull
//         : null;
//
//     print('🎨 [ThemeController] Secondary color from company: $colorValue');
//
//     storage.write('secondaryColor', colorValue);
//
//     MyThemeData.signOut = colorValue != null
//         ? Color(int.parse(colorValue))
//         : const Color(0xFFE5B800);
//
//     MyThemeData.barColor = colorValue != null
//         ? Color(int.parse(colorValue))
//         : const Color(0xFFE5B800);
//
//     MyThemeData.bubbleColor = colorValue != null
//         ? Color(int.parse(colorValue))
//         : const Color(0xFFE5B800);
//
//     print('🎨 [ThemeController] Secondary color set to: ${MyThemeData.signOut}');
//
//     // Refresh current theme to apply new color
//     if (currentTheme.value == MyThemeData.lightTheme) {
//       currentTheme.value = MyThemeData.lightTheme;
//     } else {
//       currentTheme.value = MyThemeData.darkTheme;
//     }
//
//     // Update modules AFTER setting the storage values
//     updateModulesBranding();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Get.forceAppUpdate();
//     });
//
//     print('🎨 [ThemeController] Secondary color update completed');
//   }
//
//   updateModulesBranding() {
//     print('🎨 [ThemeController] Updating modules branding...');
//
//     final int primaryColor =
//     int.parse(storage.read('primaryColor') ?? '0xFFFFDE59');
//     final int secondaryColor =
//     int.parse(storage.read('secondaryColor') ?? '0xFFE5B800');
//
//     try {
//       if (Get.isRegistered<MessagingInitController>()) {
//         Get.find<MessagingInitController>()
//             .messagingConfigurations
//             .updateBrandingColors(
//             Color(primaryColor), Color(secondaryColor));
//       }
//     } catch (e) {
//       print('⚠️ [ThemeController] Error updating messaging branding: $e');
//     }
//
//     mainCoreAppTheme.AppTheme.interfaceUpdateBrandingColors(
//         Color(primaryColor), Color(secondaryColor));
//     AppTheme.interfaceUpdateBrandingColors(
//         Color(primaryColor), Color(secondaryColor));
//
//     // ✅ Update color maps after branding changes
//     AppTheme.setCurrentThemeColors();
//     mainCoreAppTheme.AppTheme.setCurrentThemeColors();
//
//     print('🎨 [ThemeController] Modules branding updated');
//   }
//
//   void updateFonts() {
//     print('🎨 ========== UPDATE FONTS START ==========');
//     print('🎨 Step 1: Reading current storage values...');
//
//     String? currentFontInStorage = storage.read('font');
//     String? currentArabicFontInStorage = storage.read('font_arabic');
//
//     print('🎨 Current storage - font: $currentFontInStorage');
//     print('🎨 Current storage - font_arabic: $currentArabicFontInStorage');
//
//     print('🎨 Step 2: Checking company status...');
//     print('🎨 Company status: ${addCompanyController.company?.status}');
//
//     // ✅ FIX: Only update from company data if storage is null or empty
//     // This preserves user's font selection in branding screen
//     if (currentFontInStorage == null || currentFontInStorage.isEmpty) {
//       print('🎨 Storage font is empty, loading from company data...');
//       storage.write(
//           'font',
//           addCompanyController.company!.status! == 'active'
//               ? addCompanyController
//               .company!.englishFont!.englishFont?.lastOrNull?.capitalize
//               : null);
//       currentFontInStorage = storage.read('font');
//       print('🎨 Loaded from company - font: $currentFontInStorage');
//     } else {
//       print('🎨 Using existing storage font: $currentFontInStorage');
//     }
//
//     if (currentArabicFontInStorage == null || currentArabicFontInStorage.isEmpty) {
//       print('🎨 Storage Arabic font is empty, loading from company data...');
//       storage.write(
//           'font_arabic',
//           addCompanyController.company!.status! == 'active'
//               ? addCompanyController
//               .company!.arabicFont!.arabicFont?.lastOrNull?.capitalize
//               : null);
//       currentArabicFontInStorage = storage.read('font_arabic');
//       print('🎨 Loaded from company - font_arabic: $currentArabicFontInStorage');
//     } else {
//       print('🎨 Using existing storage Arabic font: $currentArabicFontInStorage');
//     }
//
//     print('🎨 Step 3: Applying fonts to theme...');
//     print('🎨 Current locale: ${Get.locale.toString()}');
//     print('🎨 Is Arabic: ${Get.locale.toString().contains('ar')}');
//
//     MyThemeData.font = Get.locale.toString().contains('ar')
//         ? currentArabicFontInStorage ?? 'Vazirmatn'
//         : currentFontInStorage ?? 'Cairo';
//
//     print('🎨 MyThemeData.font set to: ${MyThemeData.font}');
//
//     AppFontStyle.cairoRegularStyle = TextStyle(
//       color: Colors.black,
//       fontFamily: Get.locale.toString().contains('ar')
//           ? currentArabicFontInStorage ?? 'Vazirmatn'
//           : currentFontInStorage ?? 'Cairo',
//       fontWeight: FontWeight.normal,
//       fontSize: 17,
//     );
//
//     print('🎨 AppFontStyle.cairoRegularStyle updated');
//     print('🎨 Font family: ${AppFontStyle.cairoRegularStyle.fontFamily}');
//
//     print('🎨 Step 4: Forcing UI update...');
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Get.forceAppUpdate();
//       print('🎨 UI update forced');
//     });
//
//     print('🎨 ========== UPDATE FONTS END ==========');
//   }
//
//
//     void loadThemeFromStorage() {
//     // This method is now replaced by _loadThemeDataSync() in onInit
//     // Keep it for backward compatibility if called elsewhere
//     _loadThemeDataSync();
//   }
// }

// ignore_for_file: sdk_version_since
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:demo_app/features/skeleton/settings/presentation/controller/add_company_controller.dart';
// REMOVED_MODULE: import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';
import '../../features/external/main_core/core/theme/app_theme.dart'
as mainCoreAppTheme;
// REMOVED_MODULE: import '../../features/external/messaging_package/interface/controller/messaging_init_controller.dart';
import 'app_theme.dart';
import 'package:demo_app/features/skeleton/system_logs/presentation/controller/system_logs_controller.dart';

class ThemeController extends GetxController {
  SystemLogsController get systemLogsController => Get.find<SystemLogsController>();
  final storage = GetStorage();
  late Rx<ThemeData> currentTheme;
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentTheme = MyThemeData.lightTheme.obs;

    // Load theme data synchronously first
    _loadThemeDataSync();

    // Then initialize theme systems
    Future.microtask(() {
      initTheme(withMessage: false);
      isInitialized.value = true;
    });

    // Setup listener for system UI updates
    ever(currentTheme, (_) {
      if (isInitialized.value) {
        Future.microtask(() => updateSystemUIOverlayStyle());
      }
    });
  }

  void _loadThemeDataSync() {
    print('🎨 [ThemeController] Loading theme from storage...');

    // Load theme mode
    final savedTheme = storage.read('theme');

    if (savedTheme != null) {
      if (savedTheme == 'darkMode') {
        currentTheme.value = MyThemeData.darkTheme;
        AppTheme.isDark = true;
        mainCoreAppTheme.AppTheme.isDark = true; // ✅ Sync main core
        print('🎨 [ThemeController] Loaded DARK theme from storage');
      } else {
        currentTheme.value = MyThemeData.lightTheme;
        AppTheme.isDark = false;
        mainCoreAppTheme.AppTheme.isDark = false; // ✅ Sync main core
        print('🎨 [ThemeController] Loaded LIGHT theme from storage');
      }
    } else {
      currentTheme.value = MyThemeData.lightTheme;
      AppTheme.isDark = false;
      mainCoreAppTheme.AppTheme.isDark = false; // ✅ Sync main core
      print('🎨 [ThemeController] No saved theme, using LIGHT theme');
    }

    // Load and apply colors
    final primaryColor = storage.read('primaryColor');
    if (primaryColor != null) {
      MyThemeData.lightPrimary = Color(int.parse(primaryColor));
      MyThemeData.switchSettings = Color(int.parse(primaryColor));
      print('🎨 [ThemeController] Loaded primary color: $primaryColor');
    }

    final secondaryColor = storage.read('secondaryColor');
    if (secondaryColor != null) {
      MyThemeData.signOut = Color(int.parse(secondaryColor));
      MyThemeData.barColor = Color(int.parse(secondaryColor));
      MyThemeData.bubbleColor = Color(int.parse(secondaryColor));
      print('🎨 [ThemeController] Loaded secondary color: $secondaryColor');
    }

    // ✅ CRITICAL: Synchronize AppTheme with loaded state
    AppTheme.setCurrentThemeColors();
    mainCoreAppTheme.AppTheme.setCurrentThemeColors(); // ✅ Sync main core colors

    print('🎨 [ThemeController] Theme sync completed - isDark: ${AppTheme.isDark}');
  }

  void updateSystemUIOverlayStyle() {
    if (Get.context != null) {
      bool isTablet = MediaQuery.of(Get.context!).size.shortestSide > 600;
      if (isTablet) {
        updateSystemUIOverlayStyleTablet();
      } else {
        updateSystemUIOverlayStyleMobile();
      }
    }
  }

  void updateSystemUIOverlayStyleMobile() {
    if (currentTheme.value == MyThemeData.lightTheme) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: MyThemeData.colorLightGrey,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: MyThemeData.colorBlack,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      );
    }
  }

  void updateSystemUIOverlayStyleTablet() {
    if (currentTheme.value == MyThemeData.lightTheme) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: MyThemeData.colorWhite,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: MyThemeData.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      );
    }
  }

  void toggleTheme() {
    print('🎨 [ThemeController] Theme toggle started - Current: ${currentTheme.value == MyThemeData.lightTheme ? "Light" : "Dark"}');

    // Toggle theme mode
    if (currentTheme.value == MyThemeData.lightTheme) {
      currentTheme.value = MyThemeData.darkTheme;
      storage.write('theme', 'darkMode');
      AppTheme.isDark = true;
      mainCoreAppTheme.AppTheme.isDark = true; // ✅ Sync main core
      print('🎨 [ThemeController] Switched to DARK theme');
    } else {
      currentTheme.value = MyThemeData.lightTheme;
      storage.write('theme', 'lightMode');
      AppTheme.isDark = false;
      mainCoreAppTheme.AppTheme.isDark = false; // ✅ Sync main core
      print('🎨 [ThemeController] Switched to LIGHT theme');
    }

    // Log action
    systemLogsController.systemLogsAction('change theme');

    // ✅ CRITICAL: Update color maps BEFORE toggling other modules
    print('🎨 [ThemeController] Updating color maps...');
    AppTheme.setCurrentThemeColors();
    mainCoreAppTheme.AppTheme.setCurrentThemeColors();

    // Synchronize all theme systems
    print('🎨 [ThemeController] Updating theme in all modules...');
    mainCoreThemeController.toggleTheme();
    AppTheme.interfaceToggleTheme();

    try {
      // REMOVED_MODULE: if (Get.isRegistered<MessagingInitController>()) {
      // REMOVED_MODULE: Get.find<MessagingInitController>()
      // REMOVED_MODULE: .messagingConfigurations
      // REMOVED_MODULE: .toggleTheme();
    } catch (e) {
      print('⚠️ [ThemeController] Error updating messaging theme: $e');
    }

    // Update UI in post frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateSystemUIOverlayStyle();
      Get.forceAppUpdate();
      print('🎨 [ThemeController] Theme toggle completed - isDark: ${AppTheme.isDark}');
    });
  }

  initTheme({bool withMessage = true}) {
    print('🎨 [ThemeController] Initializing theme...');

    final int primaryColor =
    int.parse(storage.read('primaryColor') ?? '0xFFFFDE59');
    final int secondaryColor =
    int.parse(storage.read('secondaryColor') ?? '0xFFE5B800');
    Color primary = Color(primaryColor);
    Color secondary = Color(secondaryColor);

    // ✅ FIX: Use the actual theme state from currentTheme
    bool isDark = currentTheme.value == MyThemeData.darkTheme;

    print('🎨 [ThemeController] Primary color: $primary');
    print('🎨 [ThemeController] Secondary color: $secondary');
    print('🎨 [ThemeController] Dark mode: $isDark (from currentTheme)');
    print('🎨 [ThemeController] AppTheme.isDark: ${AppTheme.isDark}');
    print('🎨 [ThemeController] mainCoreAppTheme.AppTheme.isDark: ${mainCoreAppTheme.AppTheme.isDark}');

    // ✅ Ensure all theme systems are in sync
    AppTheme.isDark = isDark;
    mainCoreAppTheme.AppTheme.isDark = isDark;

    // Initialize messaging module if needed
    if (withMessage) {
      // REMOVED_MODULE: try {
      // REMOVED_MODULE: if (Get.isRegistered<MessagingInitController>()) {
      // REMOVED_MODULE: Get.find<MessagingInitController>()
      // REMOVED_MODULE: .messagingConfigurations
      // REMOVED_MODULE: .initTheme(primary, secondary, isDark);
      // REMOVED_MODULE: }
      // REMOVED_MODULE: } catch (e) {
      // REMOVED_MODULE: print('⚠️ [ThemeController] Error initializing messaging theme: $e');
      // REMOVED_MODULE: }
    }

    // Initialize other theme systems with correct dark mode state
    AppTheme.interfaceInitTheme(primary, secondary, isDark);
    mainCoreAppTheme.AppTheme.initTheme(primary, secondary, isDark);

    // ✅ CRITICAL: Update color maps after init
    AppTheme.setCurrentThemeColors();
    mainCoreAppTheme.AppTheme.setCurrentThemeColors();

    print('🎨 [ThemeController] Theme initialization completed');
  }

  CompanyController addCompanyController = Get.put(CompanyController());

  // ✅ FIXED: Check GetStorage FIRST for employee branding, fallback to company branding
  void updatePrimaryColor() {
    print('🎨 [ThemeController] ========== UPDATE PRIMARY COLOR START ==========');

    // Step 1: Check if there's already a value in GetStorage (employee branding)
    String? existingColorInStorage = storage.read('primaryColor');
    print('🎨 [ThemeController] Step 1 - Existing primaryColor in storage: $existingColorInStorage');

    String? colorValue;

    // Step 2: If storage is empty, load from company branding
    if (existingColorInStorage == null || existingColorInStorage.isEmpty) {
      print('🎨 [ThemeController] Step 2 - Storage is empty, loading from company branding...');
      print('🎨 [ThemeController] Company status: ${addCompanyController.company?.status}');

      colorValue = addCompanyController.company?.status == 'active'
          ? addCompanyController.company?.primaryColor?.primaryColor?.lastOrNull
          : null;

      print('🎨 [ThemeController] Primary color from company: $colorValue');

      if (colorValue != null && colorValue.isNotEmpty) {
        storage.write('primaryColor', colorValue);
        print('🎨 [ThemeController] ✅ Wrote company color to storage: $colorValue');
      }
    } else {
      // Use existing storage value (employee branding)
      colorValue = existingColorInStorage;
      print('🎨 [ThemeController] Step 2 - Using existing storage value (employee branding): $colorValue');
    }

    // Step 3: Apply the color to theme
    print('🎨 [ThemeController] Step 3 - Applying color to theme...');

    MyThemeData.lightPrimary = colorValue != null && colorValue.isNotEmpty
        ? Color(int.parse(colorValue))
        : const Color(0xFFFFDE59);

    MyThemeData.switchSettings = colorValue != null && colorValue.isNotEmpty
        ? Color(int.parse(colorValue))
        : const Color(0xFFFFDE59);

    print('🎨 [ThemeController] ✅ MyThemeData.lightPrimary set to: ${MyThemeData.lightPrimary}');

    // Step 4: Refresh current theme to apply new color
    print('🎨 [ThemeController] Step 4 - Refreshing theme...');
    if (currentTheme.value == MyThemeData.lightTheme) {
      currentTheme.value = MyThemeData.lightTheme;
      MyThemeData().contrastColor();
    } else {
      currentTheme.value = MyThemeData.darkTheme;
      MyThemeData().contrastColor();
    }

    // Step 5: Update modules AFTER setting the storage values
    print('🎨 [ThemeController] Step 5 - Updating modules branding...');
    updateModulesBranding();

    // Step 6: Force UI update
    print('🎨 [ThemeController] Step 6 - Forcing UI update...');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.forceAppUpdate();
      print('🎨 [ThemeController] ✅ UI update forced');
    });

    print('🎨 [ThemeController] ========== UPDATE PRIMARY COLOR END ==========');
  }

  // ✅ FIXED: Check GetStorage FIRST for employee branding, fallback to company branding
  void updateSecondaryColor() {
    print('🎨 [ThemeController] ========== UPDATE SECONDARY COLOR START ==========');

    // Step 1: Check if there's already a value in GetStorage (employee branding)
    String? existingColorInStorage = storage.read('secondaryColor');
    print('🎨 [ThemeController] Step 1 - Existing secondaryColor in storage: $existingColorInStorage');

    String? colorValue;

    // Step 2: If storage is empty, load from company branding
    if (existingColorInStorage == null || existingColorInStorage.isEmpty) {
      print('🎨 [ThemeController] Step 2 - Storage is empty, loading from company branding...');
      print('🎨 [ThemeController] Company status: ${addCompanyController.company?.status}');

      colorValue = addCompanyController.company?.status == 'active'
          ? addCompanyController.company?.secondaryColor?.secondaryColor?.lastOrNull
          : null;

      print('🎨 [ThemeController] Secondary color from company: $colorValue');

      if (colorValue != null && colorValue.isNotEmpty) {
        storage.write('secondaryColor', colorValue);
        print('🎨 [ThemeController] ✅ Wrote company color to storage: $colorValue');
      }
    } else {
      // Use existing storage value (employee branding)
      colorValue = existingColorInStorage;
      print('🎨 [ThemeController] Step 2 - Using existing storage value (employee branding): $colorValue');
    }

    // Step 3: Apply the color to theme
    print('🎨 [ThemeController] Step 3 - Applying color to theme...');

    MyThemeData.signOut = colorValue != null && colorValue.isNotEmpty
        ? Color(int.parse(colorValue))
        : const Color(0xFFE5B800);

    MyThemeData.barColor = colorValue != null && colorValue.isNotEmpty
        ? Color(int.parse(colorValue))
        : const Color(0xFFE5B800);

    MyThemeData.bubbleColor = colorValue != null && colorValue.isNotEmpty
        ? Color(int.parse(colorValue))
        : const Color(0xFFE5B800);

    print('🎨 [ThemeController] ✅ MyThemeData.signOut set to: ${MyThemeData.signOut}');

    // Step 4: Refresh current theme to apply new color
    print('🎨 [ThemeController] Step 4 - Refreshing theme...');
    if (currentTheme.value == MyThemeData.lightTheme) {
      currentTheme.value = MyThemeData.lightTheme;
    } else {
      currentTheme.value = MyThemeData.darkTheme;
    }

    // Step 5: Update modules AFTER setting the storage values
    print('🎨 [ThemeController] Step 5 - Updating modules branding...');
    updateModulesBranding();

    // Step 6: Force UI update
    print('🎨 [ThemeController] Step 6 - Forcing UI update...');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.forceAppUpdate();
      print('🎨 [ThemeController] ✅ UI update forced');
    });

    print('🎨 [ThemeController] ========== UPDATE SECONDARY COLOR END ==========');
  }

  updateModulesBranding() {
    print('🎨 [ThemeController] Updating modules branding...');

    final int primaryColor =
    int.parse(storage.read('primaryColor') ?? '0xFFFFDE59');
    final int secondaryColor =
    int.parse(storage.read('secondaryColor') ?? '0xFFE5B800');

    try {
      // REMOVED_MODULE: if (Get.isRegistered<MessagingInitController>()) {
      // REMOVED_MODULE: Get.find<MessagingInitController>()
      // REMOVED_MODULE: .messagingConfigurations
      // REMOVED_MODULE: .updateBrandingColors(
      // REMOVED_MODULE: Color(primaryColor), Color(secondaryColor));
    } catch (e) {
      print('⚠️ [ThemeController] Error updating messaging branding: $e');
    }

    mainCoreAppTheme.AppTheme.interfaceUpdateBrandingColors(
        Color(primaryColor), Color(secondaryColor));
    AppTheme.interfaceUpdateBrandingColors(
        Color(primaryColor), Color(secondaryColor));

    // ✅ Update color maps after branding changes
    AppTheme.setCurrentThemeColors();
    mainCoreAppTheme.AppTheme.setCurrentThemeColors();

    print('🎨 [ThemeController] Modules branding updated');
  }

  void updateFonts() {
    print('🎨 ========== UPDATE FONTS START ==========');
    print('🎨 Step 1: Reading current storage values...');

    String? currentFontInStorage = storage.read('font');
    String? currentArabicFontInStorage = storage.read('font_arabic');

    print('🎨 Current storage - font: $currentFontInStorage');
    print('🎨 Current storage - font_arabic: $currentArabicFontInStorage');

    print('🎨 Step 2: Checking company status...');
    print('🎨 Company status: ${addCompanyController.company?.status}');

    // ✅ FIX: Only update from company data if storage is null or empty
    // This preserves user's font selection in branding screen
    if (currentFontInStorage == null || currentFontInStorage.isEmpty) {
      print('🎨 Storage font is empty, loading from company data...');
      storage.write(
          'font',
          addCompanyController.company!.status! == 'active'
              ? addCompanyController
              .company!.englishFont!.englishFont?.lastOrNull?.capitalize
              : null);
      currentFontInStorage = storage.read('font');
      print('🎨 Loaded from company - font: $currentFontInStorage');
    } else {
      print('🎨 Using existing storage font: $currentFontInStorage');
    }

    if (currentArabicFontInStorage == null || currentArabicFontInStorage.isEmpty) {
      print('🎨 Storage Arabic font is empty, loading from company data...');
      storage.write(
          'font_arabic',
          addCompanyController.company!.status! == 'active'
              ? addCompanyController
              .company!.arabicFont!.arabicFont?.lastOrNull?.capitalize
              : null);
      currentArabicFontInStorage = storage.read('font_arabic');
      print('🎨 Loaded from company - font_arabic: $currentArabicFontInStorage');
    } else {
      print('🎨 Using existing storage Arabic font: $currentArabicFontInStorage');
    }

    print('🎨 Step 3: Applying fonts to theme...');
    print('🎨 Current locale: ${Get.locale.toString()}');
    print('🎨 Is Arabic: ${Get.locale.toString().contains('ar')}');

    MyThemeData.font = Get.locale.toString().contains('ar')
        ? currentArabicFontInStorage ?? 'Vazirmatn'
        : currentFontInStorage ?? 'Cairo';

    print('🎨 MyThemeData.font set to: ${MyThemeData.font}');

    AppFontStyle.cairoRegularStyle = TextStyle(
      color: Colors.black,
      fontFamily: Get.locale.toString().contains('ar')
          ? currentArabicFontInStorage ?? 'Vazirmatn'
          : currentFontInStorage ?? 'Cairo',
      fontWeight: FontWeight.normal,
      fontSize: 17,
    );

    print('🎨 AppFontStyle.cairoRegularStyle updated');
    print('🎨 Font family: ${AppFontStyle.cairoRegularStyle.fontFamily}');

    print('🎨 Step 4: Forcing UI update...');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.forceAppUpdate();
      print('🎨 UI update forced');
    });

    print('🎨 ========== UPDATE FONTS END ==========');
  }

  void loadThemeFromStorage() {
    // This method is now replaced by _loadThemeDataSync() in onInit
    // Keep it for backward compatibility if called elsewhere
    _loadThemeDataSync();
  }
}