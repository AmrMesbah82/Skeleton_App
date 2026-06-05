// ignore_for_file: unused_local_variable, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/features/external/main_core/core/theme/my_theme.dart';
import 'package:demo_app/features/external/todo_module/core/constants/haptic_controller.dart';
import 'package:demo_app/features/external/todo_module/core/constants/mode_changer.dart';
import 'package:demo_app/features/external/todo_module/core/constants/screen_size.dart';
import 'package:demo_app/features/external/todo_module/core/widgets/custom_appbar_mobile.dart';

import '../../constants/enum.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key});

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  Languages? selectedLanguage = Languages.english;
  final box = GetStorage();
  String? localeData;
  final ToDoHapticController hapticController =
      Get.find<ToDoHapticController>();

  @override
  void initState() {
    super.initState();
    localeData = box.read<String>('LocaleData');
    selectedLanguage = localeData.toString().contains('ar')
        ? Languages.arabic
        : Languages.english;
  }

  void toggleLangSwitch(Languages language) {
    setState(() {
      selectedLanguage = language;
    });

    var locale = language == Languages.arabic
        ? const Locale('ar', 'EG')
        : const Locale('en', 'US');
    Get.updateLocale(locale);
    box.write('LocaleData', locale.toString());
  }

  Widget _buildLanguageRadioTile(Languages language, String label,
      {bool? trailing}) {
    final orientation = MediaQuery.of(context).orientation;
    final isSelected = selectedLanguage == language;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    return MediaQuery.of(context).size.shortestSide > 600
        ? Padding(
            padding: EdgeInsets.only(
              top: 0.02.w,
              right: Get.locale.toString().contains('ar')
                  ? 0
                  : orientation == Orientation.landscape
                      ? 0.05.w
                      : 0,
              left: Get.locale.toString().contains('en')
                  ? 0
                  : orientation == Orientation.landscape
                      ? 0.05.w
                      : 0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: isSelected
                      ? MyThemeData.lightPrimary
                      : const Color(0xFFCCCCCC),
                ),
              ),
              child: GestureDetector(
                onTap: trailing != true
                    ? () {
                        toggleLangSwitch(language);
                        hapticController.triggerHapticFeedback(
                            vibration: VibrateType.mediumImpact,
                            hapticFeedback: HapticFeedback.mediumImpact);
                      }
                    : null,
                child: RadioListTile<Languages>(
                  title: Row(
                    children: [
                      SizedBox(
                        width: 0.13.w,
                        child: Text(
                          label.tr,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                            fontSize: orientation == Orientation.portrait
                                ? FontConstants.fontSize018.h
                                : FontConstants.fontSize022.h,
                            color: selectedLanguage == language
                                ? Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                : MyThemeData.colorGrey,
                            fontWeight: FontWeight.w400,
                            height: orientation == Orientation.portrait
                                ? 0.0013.h
                                : 0.0018.h,
                          ),
                        ),
                      ),
                      if (trailing != null) SizedBox(width: 0.02.w),
                      if (trailing != null)
                        Padding(
                          padding: EdgeInsets.only(
                            top: orientation == Orientation.portrait
                                ? 0
                                : 0.00.h,
                          ),
                          child: Container(
                            height: orientation == Orientation.landscape
                                ? 0.04.h
                                : null,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                color: Colors.black, // Black border color
                                width: 1.0, // Border width
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: orientation == Orientation.landscape
                                    ? 0.025.h
                                    : 0.025.w,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Coming Soon'.tr,
                                    style:
                                        AppFontStyle.cairoRegularStyle.copyWith(
                                      fontSize:
                                          orientation == Orientation.portrait
                                              ? FontConstants.fontSize012.h
                                              : FontConstants.fontSize018.h,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      fontWeight: FontWeight.w400,
                                      height:
                                          orientation == Orientation.portrait
                                              ? 0.0013.h
                                              : 0.00.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  value: language,
                  groupValue: selectedLanguage,
                  onChanged: trailing != true
                      ? (value) {
                          hapticController.triggerHapticFeedback(
                              vibration: VibrateType.mediumImpact,
                              hapticFeedback: HapticFeedback.mediumImpact);
                          toggleLangSwitch(language);
                        }
                      : null,
                  activeColor: MyThemeData.lightPrimary,
                  selected: selectedLanguage == language,
                ),
              ),
            ),
          )
        : Padding(
            padding:
                EdgeInsets.symmetric(vertical: 0.01.h, horizontal: 0.045.w),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: isSelected
                      ? MyThemeData.lightPrimary
                      : const Color(0xFFCCCCCC),
                ),
              ),
              child: GestureDetector(
                onTap: trailing != true
                    ? () {
                        hapticController.triggerHapticFeedback(
                            vibration: VibrateType.mediumImpact,
                            hapticFeedback: HapticFeedback.mediumImpact);
                        toggleLangSwitch(language);
                      }
                    : null,
                child: RadioListTile<Languages>(
                  title: Row(
                    children: [
                      SizedBox(
                        width: 0.25.w,
                        child: Text(
                          label.tr,
                          style: TextStyle(
                            fontSize: orientation == Orientation.portrait
                                ? FontConstants.fontSize022.h
                                : FontConstants.fontSize022.h,
                            color: selectedLanguage == language
                                ? Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                : MyThemeData.colorGrey,
                            fontWeight: FontWeight.w400,
                            height: orientation == Orientation.portrait
                                ? 0.0022.h
                                : 0.0029.h,
                          ),
                        ),
                      ),
                      if (trailing != null) SizedBox(width: 0.02.w),
                      if (trailing != null)
                        Padding(
                          padding: EdgeInsets.only(
                              top: orientation == Orientation.portrait
                                  ? 0
                                  : 0.01.h),
                          child: Container(
                            height: orientation == Orientation.landscape
                                ? 0.04.h
                                : null,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                color: Colors.black, // Black border color
                                width: 1.0, // Border width
                              ),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 0.025.w),
                              child: Row(
                                children: [
                                  Text(
                                    'Coming Soon'.tr,
                                    style:
                                        AppFontStyle.cairoRegularStyle.copyWith(
                                      fontSize:
                                          orientation == Orientation.portrait
                                              ? FontConstants.fontSize014.h
                                              : FontConstants.fontSize018.h,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      fontWeight: FontWeight.w400,
                                      height:
                                          orientation == Orientation.portrait
                                              ? 0.002.h
                                              : 0.00.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  value: language,
                  groupValue: selectedLanguage,
                  onChanged: trailing != true
                      ? (value) {
                          hapticController.triggerHapticFeedback(
                              vibration: VibrateType.mediumImpact,
                              hapticFeedback: HapticFeedback.mediumImpact);
                          toggleLangSwitch(language);
                        }
                      : null,
                  activeColor: MyThemeData.lightPrimary,
                  selected: selectedLanguage == language,
                ),
              ),
            ),
          );
  }

  Widget buildTabletView() {
    final orientation = MediaQuery.of(context).orientation;
    return Container(
      height: orientation == Orientation.portrait
          ? Mode.owner
              ? 0.9.h
              : 0.8.h
          : 0.77.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 0.03.h, right: 0.02.w, left: 0.02.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Language'.tr,
              style: TextStyle(
                fontSize: orientation == Orientation.portrait
                    ? FontConstants.fontSize020.h
                    : FontConstants.fontSize028.h,
                color: Theme.of(context).colorScheme.secondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.01.h),
            SizedBox(height: 0.010.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLanguageRadioTile(Languages.english, 'English'),
                    _buildLanguageRadioTile(Languages.arabic, 'Arabic'),
                    _buildLanguageRadioTile(Languages.hindi, 'Hindi',
                        trailing: true),
                    _buildLanguageRadioTile(Languages.turkish, 'Turkish',
                        trailing: true),
                    _buildLanguageRadioTile(Languages.mandarin, 'Mandarin',
                        trailing: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMobileView() {
    final orientation = MediaQuery.of(context).orientation;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBarMobile(
            showIcon: true,
            isHome: true,
            showMoreIcon: false,
            title: "Language",
          ),
          _buildLanguageRadioTile(Languages.english, 'English'),
          _buildLanguageRadioTile(Languages.arabic, 'Arabic'),
          _buildLanguageRadioTile(Languages.hindi, 'Hindi', trailing: true),
          _buildLanguageRadioTile(Languages.turkish, 'Turkish', trailing: true),
          _buildLanguageRadioTile(Languages.mandarin, 'Mandarin',
              trailing: true),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;

    return Scaffold(
      body: isTablet ? buildTabletView() : buildMobileView(),
    );
  }
}
