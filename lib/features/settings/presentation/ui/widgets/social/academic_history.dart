// ignore_for_file: must_be_immutable, prefer_const_declarations, unused_local_variable, deprecated_member_use, duplicate_ignore, no_leading_underscores_for_local_identifiers, unrelated_type_equality_checks, sdk_version_since, use_build_context_synchronously

import 'dart:io';
import 'package:demo_app/core/theme/new_theme.dart';
import 'package:demo_app/features/services_mangment_module/core/custom_reasponsive_filed.dart';
import 'package:demo_app/features/inventory_module/core/drop_down.dart' hide CustomDropdownFormFieldCalender;
import 'package:demo_app/features/services_mangment_module/core/custom_drop_down_calender.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/core/widgets/custom_svg.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/shared_components/custom_black_button.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/core/theme/app_colors.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/services_mangment_module/core/new_theme.dart';
import 'package:demo_app/features/settings/presentation/controller/settings_controller.dart';

import 'package:demo_app/core/shared_components/timeline_widget.dart';
import '../../../../../../core/helper/haptic_controller.dart';
import '../../../../../../core/widgets/form_fields/profile_textfield.dart';
import '../../../../../../core/helper/validator.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../../core/helper/format_helper.dart';
// REMOVED_MODULE: import '../../../../../../external/inventory_module/core/custom_button_widget.dart';
// REMOVED_MODULE: import '../../../../../../external/inventory_module/core/drop_down.dart' hide CustomDropdownFormFieldCalender;
// REMOVED_MODULE: import '../../../../../../external/inventory_module/core/text_field.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/core/custom_drop_down_calender.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/core/custom_reasponsive_filed.dart';
import 'package:demo_app/features/services_mangment_module/core/custom_textformfield.dart';
import '../../../controller/social_controller.dart';
import '../settings_header.dart';

class AcademicHistory extends StatefulWidget {
  AcademicHistory({super.key});

  @override
  State<AcademicHistory> createState() => _AcademicHistoryState();
}

class _AcademicHistoryState extends State<AcademicHistory> {
  SocialController socialController = Get.find<SettingsController>().socialController;
  SettingsController settingsController = Get.find<SettingsController>();
  final HapticController hapticController = Get.find<HapticController>();

  bool isTablet = MediaQuery.of(Get.context!).size.width > 600;

  @override
  void initState() {
    super.initState();
    // Capitalize existing data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _capitalizeExistingData();
    });
  }

  void _capitalizeExistingData() {
    bool hasChanges = false;
    for (var fieldSet in socialController.academicHistoryFields) {
      if (fieldSet['university']?.text.isNotEmpty ?? false) {
        String currentText = fieldSet['university']!.text;
        String capitalizedText = FormatHelper.capitalize(currentText);
        if (currentText != capitalizedText) {
          fieldSet['university']!.text = capitalizedText;
          hasChanges = true;
        }
      }
    }
    if (hasChanges) setState(() {});
  }

  void _deleteAcademicEntry(int index) {
    setState(() {
      socialController.removeAcademicHistoryField(index);
    });
  }

  void _addNewAcademicEntry() {
    hapticController.triggerHapticFeedback(
      vibration: VibrateType.lightImpact,
      hapticFeedback: HapticFeedback.lightImpact,
    );
    setState(() {
      socialController.addAcademicHistoryField();
    });
  }

  List<Map<String, String>> _getDegreeItems() {
    bool isArabic = Get.locale?.languageCode == 'ar';
    return [
      {
        "key": "bachelor",
        "value": FormatHelper.capitalize(isArabic ? "درجة البكالوريوس" : "Bachelor's Degree")
      },
      {
        "key": "master",
        "value": FormatHelper.capitalize(isArabic ? "درجة الماجستير" : "Master's Degree")
      },
      {
        "key": "phd",
        "value": FormatHelper.capitalize(isArabic ? "درجة الدكتوراه" : "PhD")
      },
      {
        "key": "diploma",
        "value": FormatHelper.capitalize(isArabic ? "دبلوم" : "Diploma")
      },
      {
        "key": "certificate",
        "value": FormatHelper.capitalize(isArabic ? "شهادة" : "Certificate")
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    var isMobile = context.isPhone;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // Ensure there's always at least one academic history field
    if (socialController.academicHistoryFields.isEmpty) {
      socialController.addAcademicHistoryField();
    }

    // ── Only render the LAST entry ────────────────────────────────────────
    final int lastIndex = socialController.academicHistoryFields.length - 1;
    final fieldSet = socialController.academicHistoryFields[lastIndex];

    final String graduateFromValue = fieldSet['graduateFrom']!.text;
    final String yearValue = fieldSet['yearOfGraduation']!.text;
    final bool isValidDegree = ['bachelor', 'master', 'phd', 'diploma', 'certificate']
        .contains(graduateFromValue);

    return Container(
      decoration: !isTablet
          ? BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.card,
      )
          : null,
      padding: EdgeInsets.only(
        top: 15.sp,
        right: 0.sp,
        left: 0.sp,
        bottom: isMobile ? 15.sp : 0.sp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          SettingsHeader(
            imagePath: 'assets/acadmic_history.svg',
            text: FormatHelper.capitalize('Academic History'.tr),
          ),

          SizedBox(height: 10.sp),

          // ── Last entry only ───────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delete button row — only visible when there are multiple entries
                if (socialController.academicHistoryFields.length > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => _deleteAcademicEntry(lastIndex),
                        child: Container(
                          padding: EdgeInsets.all(6.sp),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: CustomSvg(
                            assetPath: "assets/removed.svg",
                            width: 15.sp,
                            fit: BoxFit.fill,
                            height: 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 12.sp),

                // First Row: Degree + University
                buildResponsiveFields(
                  context: context,
                  left: CustomDropdownFormFieldFinal(
                    label: FormatHelper.capitalize(S.of(context).graduationFrom),
                    selectedValue: isValidDegree ? graduateFromValue : null,
                    items: _getDegreeItems(),
                    onChanged: (value) {
                      _updateAcademicField(lastIndex, 'graduateFrom', value ?? '');
                      fieldSet['graduateFrom']!.text = value ?? '';
                      setState(() {});
                    },
                    widthIcon: 16,
                    buttonPadding: EdgeInsets.symmetric(horizontal: 8.sp),
                    heightIcon: 16,
                    height: 36,
                    hint: Text(
                      FormatHelper.capitalize(S.of(context).chooseDegree),
                      style: StyleText.fontSize10Weight500.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                  right: CustomValidatedTextFieldInv(
                    label: FormatHelper.capitalize(S.of(context).universityOrInstitute),
                    hint: FormatHelper.capitalize(
                      isArabic ? 'اكتب هنا' : S.of(context).textHere,
                    ),
                    height: 36,
                    textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                    controller: fieldSet['university']!,
                    autoCapitalize: true,
                    onChanged: (value) {
                      _updateAcademicField(lastIndex, 'university', value.trim());
                    },
                  ),
                ),

                SizedBox(height: 12.sp),

                // Second Row: Graduation Year
                buildResponsiveFields(
                  context: context,
                  left: CustomDropdownFormFieldCalender(
                    selectedValue: yearValue.isEmpty ? null : yearValue,
                    items: List.generate(
                      50,
                          (i) {
                        int year = DateTime.now().year - i;
                        return {"key": year.toString(), "value": year.toString()};
                      },
                    ),
                    onChanged: (value) {
                      _updateAcademicField(lastIndex, 'yearOfGraduation', value ?? '');
                      fieldSet['yearOfGraduation']!.text = value ?? '';
                      setState(() {});
                    },
                    widthIcon: 16,
                    heightIcon: 16,
                    height: 36,
                    label: FormatHelper.capitalize(S.of(context).graduationYear),
                    spaceHeight: 6,
                    hint: Text(
                      FormatHelper.capitalize('Select Date'.tr),
                      style: StyleText.fontSize10Weight500.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                  right: Center(),
                ),
              ],
            ),
          ),

          SizedBox(height: 15.sp),

          // Add More button
          GestureDetector(
            onTap: _addNewAcademicEntry,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 18.sp),
                  SizedBox(width: 8.sp),
                  Text(
                    S.of(context).more,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateAcademicField(int index, String fieldName, String value) {
    if (index >= 0 && index < socialController.academicHistoryFields.length) {
      // field is updated directly via controller reference
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}