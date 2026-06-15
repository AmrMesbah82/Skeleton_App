import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:demo_app/core/services/notifications/firebase_notification_handler.dart';
// import 'package:demo_app/core/widgets/custom_cards.dart';
// import 'package:demo_app/core/helper/biometric_controller.dart';
// import 'package:demo_app/core/helper/haptic_controller.dart';
// import 'package:demo_app/core/theme/my_theme.dart';
// import 'package:demo_app/core/theme/screen_size.dart';
// import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';
// import 'package:demo_app/core/widgets/dialogs/custom_logout_dialog.dart';
// import 'package:demo_app/core/widgets/restart_widget.dart';
// import 'package:demo_app/features/skeleton/settings/presentation/ui/pages/mobile/mobile_personal_info_screen.dart';
// import 'package:demo_app/features/skeleton/settings/presentation/controller/settings_controller.dart';
// import 'package:demo_app/features/skeleton/settings/presentation/ui/widgets/settings_svg_icon.dart';
// import 'package:demo_app/core/nav_bar_package.dart/functions.dart';
//
// import 'package:demo_app/features/skeleton/settings/presentation/ui/pages/mobile/custom_settings_appbar.dart';
// import '../../../../../../../core/dummy_data/mode_changer.dart';
// import '../../../../../../../core/enumeration/enum.dart';
// import '../../../../../../../core/theme/theme_controller.dart';
// import '../../../../../../../core/widgets/custom_appbar.dart';
// import '../about_this_app_screen.dart';
// import 'mobile_settings_additional_info.dart';
// import '../comments_and_feedback_screen.dart';
// import '../../../../settings_screen/views/language_screen.dart';
// import '../company_info_screen.dart';
// import 'social_screen_mobile.dart';
// import '../../../../settings_screen/views/terms_and_conditions.dart';
// import '../../../../../authentication/welcome_screen/views/mobile_view/mobile_sign_in.dart';
// import 'mobile_settings_health_insurance.dart';
//
// class SettingsMobileLayout extends StatelessWidget {
//   SettingsMobileLayout({super.key});
//   SettingsController settingsController = Get.find();
//   int selectedContainerIndex = 0;
//   final ThemeController themeController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     final HapticController hapticController = Get.put(HapticController());
//     final BiometricController biometricController =
//         Get.put(BiometricController());
//     return Column(
//       children: [
//         CustomAppBarMobile(showIcon: true, title: "Settings"),
//         Padding(
//           padding: EdgeInsets.only(bottom: 0.015.h),
//           child: CustomSettingsAppBar(
//             profileImagePath: settingsController
//                 .employee!.photo?.lastOrNull,
//             userName:
//                 "${settingsController.employee!.firstName!.last!.capitalize} ${settingsController.employee!.lastName!.last!.capitalize}",
//             onPressed: () {
//               // Handle Edit photo press
//             },
//             selectedContainer: selectedContainerIndex,
//           ),
//         ),
//         Expanded(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding:
//                   EdgeInsets.symmetric(horizontal: 0.04.w, vertical: 0.0.h),
//               child: Column(
//                 children: [
//                   SizedBox(height: 0.005.h),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Container(
//                         color: Theme.of(context).colorScheme.inversePrimary,
//                         child: Column(
//                           children: [
//                             CustomCard(
//                               name: 'Personal Information'.tr,
//                               icon: SettingsSvgIcon(
//                                   path: 'assets/icons/newPersonalInfoIcon.svg'),
//                               index: 0,
//                               selectIndex: selectedContainerIndex,
//                               onTap: () {
//                                 PersistentNavBarNavigator.pushNewScreen(context,
//                                     withNavBar: false,
//                                     screen: MobilePersonalInfoScreen());
//                               },
//                             ),
//                             divider(),
//                             CustomCard(
//                               name: 'Health Insurance'.tr,
//                               icon: SettingsSvgIcon(
//                                   path: 'assets/icons/newHealth.svg'),
//                               index: 0,
//                               selectIndex: selectedContainerIndex,
//                               onTap: () {
//                                 PersistentNavBarNavigator.pushNewScreen(context,
//                                     withNavBar: false,
//                                     screen: MobileSettingsHealthInsurance());
//                               //  Get.find<SettingsController>().healthInsuranceController.getData();
//                               },
//                             ),
//
//                             Mode.owner ? divider() : const SizedBox.shrink(),
//                             Mode.owner
//                                 ? CustomCard(
//                                     name: 'Company Information'.tr,
//                                     icon: SettingsSvgIcon(
//                                         path:
//                                             'assets/icons/newSubscriptionIcon.svg'),
//                                     index: 1,
//                                     selectIndex: selectedContainerIndex,
//                                     onTap: () {
//                                       PersistentNavBarNavigator.pushNewScreen(
//                                           context,
//                                           withNavBar: false,
//                                           screen: CompanyInfoScreen());
//                                     },
//                                   )
//                                 : SizedBox.shrink(),
//                             Mode.owner ? divider() : SizedBox.shrink(),
//                             Mode.owner
//                                 ? CustomCard(
//                                     name: 'Company Branding'.tr,
//                                     icon: SettingsSvgIcon(
//                                         path:
//                                             'assets/icons/newSubscriptionIcon.svg'),
//                                     index: 1,
//                                     selectIndex: selectedContainerIndex,
//                                     onTap: () {
//                                       PersistentNavBarNavigator.pushNewScreen(
//                                         context,
//                                         withNavBar: false,
//                                         screen:
//                                             CompanyInfoScreen(isBranding: true),
//                                       );
//                                     },
//                                   )
//                                 : SizedBox.shrink(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Container(
//                       color: Theme.of(context).colorScheme.inversePrimary,
//                       child: Column(
//                         children: [
//                           CustomCard(
//                             name: 'Language'.tr,
//                             index: 2,
//                             selectIndex: selectedContainerIndex,
//                             onTap: () {
//                               PersistentNavBarNavigator.pushNewScreen(context,
//                                   withNavBar: false,
//                                   screen: const LanguageScreen());
//                             },
//                           ),
//                           divider(),
//                           CustomCard(
//                             name: 'Comments And Feedbacks'.tr,
//                             index: 4,
//                             selectIndex: selectedContainerIndex,
//                             onTap: () {
//                               PersistentNavBarNavigator.pushNewScreen(context,
//                                   withNavBar: false,
//                                   screen: const CommentsAndFeedbackScreen());
//                             },
//                           ),
//                           divider(),
//                           CustomCard(
//                             name: 'About This App'.tr,
//                             index: 5,
//                             selectIndex: selectedContainerIndex,
//                             onTap: () {
//                               PersistentNavBarNavigator.pushNewScreen(context,
//                                   withNavBar: false,
//                                   screen: const AboutThisAppScreen());
//                             },
//                           ),
//                           divider(),
//                           CustomCard(
//                             name: 'Terms And Conditions'.tr,
//                             index: 6,
//                             selectIndex: selectedContainerIndex,
//                             onTap: () {
//                               PersistentNavBarNavigator.pushNewScreen(context,
//                                   withNavBar: false,
//                                   screen: const TermsConditions());
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Container(
//                         color: Theme.of(context).colorScheme.inversePrimary,
//                         child: Column(
//                           children: [
//                             CustomCard(
//                               isSwitchTile: true,
//                               name: 'Haptic Feedback'.tr,
//                               currentValue:
//                                   hapticController.isHapticEnabled.value ==
//                                       true,
//                               onSwitchChanged: (Value) {
//                                 hapticController.toggleHapticFeedback(Value);
//                                 RestartWidget.restartApp(context);
//                               },
//                             ),
//                             divider(),
//                             CustomCard(
//                               name: 'Biometrics'.tr,
//                               isSwitchTile: true,
//                               currentValue: biometricController
//                                       .isBiometricEnabled.value ==
//                                   true,
//                               onSwitchChanged: (Value) {
//                                 biometricController
//                                     .toggleBiometricFeedback(Value);
//                                 RestartWidget.restartApp(context);
//                               },
//                             ),
//                             divider(),
//                             CustomCard(
//                               name: 'Dark Mode'.tr,
//                               isSwitchTile: true,
//                               currentValue:
//                                   themeController.currentTheme.value ==
//                                       MyThemeData.darkTheme,
//                               onSwitchChanged: (Value) {
//                                 themeController.toggleTheme();
//                                 RestartWidget.restartApp(context);
//                               },
//                             ),
//                             divider(),
//                             CustomCard(
//                               name: 'Notification'.tr,
//                               isSwitchTile: true,
//                               currentValue:
//                                   settingsController.notificationEnabled,
//                               onSwitchChanged: (Value) {
//                                 settingsController.notificationEnabled = Value;
//                                 Value
//                                     ? appNotificationController
//                                         .subscribeToTopic(settingsController
//                                             .employee!.email!.last!)
//                                     : FirebaseNotificationHandler
//                                         .unsubscribeFromTopic(settingsController
//                                             .employee!.email!.last!);
//                                 settingsController.update();
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   // sign out button
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Container(
//                       color: Theme.of(context).colorScheme.inversePrimary,
//                       child: Column(
//                         children: [
//                           CustomCard(
//                             name: 'Sign Out'.tr,
//                             hideIcon: true,
//                             onTap: () async {
//                               await showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return CustomLogOutDialogBox(
//                                     title: "Sign Out",
//                                     subtitle:
//                                         "Are You Sure You Want To Sign Out?",
//                                     imagePath: "assets/images/newLogOut.json",
//                                     backgroundColor: MyThemeData.signOut,
//                                     showButtons: true,
//                                     buttonText: 'Yes',
//                                     buttoncolor: MyThemeData.signOut,
//                                     buttonFontColor:
//                                         MyThemeData().contrastColor(),
//                                     onConfirm: () {
//                                       hapticController.triggerHapticFeedback(
//                                           vibration: VibrateType.heavyImpact,
//                                           hapticFeedback:
//                                               HapticFeedback.heavyImpact);
//                                       print("yes");
//                                       Mode.hr = false;
//                                       Mode.owner = false;
//                                       Navigator.of(context).pop();
//                                       PersistentNavBarNavigator.pushNewScreen(
//                                         context,
//                                         withNavBar: false,
//                                         screen: const StartSignInMobile(),
//                                       );
//                                     },
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 0.03.h),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget divider() {
//     return Divider(
//       thickness: 0.001.h, // specify the thickness of the divider
//       height: 0.0.h,
//       // set height to 0 to avoid extra space between the items
//       indent:
//           0.06.w, // set an indent to match the leading padding of the ListTile
//       endIndent: 0.0
//           .w, // set an end indent to match the trailing padding of the ListTile
//       color: MyThemeData.dividerGrey, // set the color of the divider
//     );
//   }
// }
