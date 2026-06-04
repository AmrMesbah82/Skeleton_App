///******************** FILE INFO ********************///
/// Purpose: Editable version of emergency contact information section
/// Author: Assistant
/// Created At: 2025
/// Updated: Editable fields for emergency contact information with controllers passed from parent
import '../../../../../external/main_core/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/settings/presentation/controller/settings_controller.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../external/services_mangment_module/core/custom_textformfield.dart';
import '../../controller/health_insurance_controller.dart';
import 'settings_header.dart';

class EditableEmergencyContactInformationSection extends StatelessWidget {
  final bool isFirstContact; // true for 1st contact, false for 2nd contact

  // Controllers passed from parent
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController relationshipController;
  final TextEditingController emailController;
  final TextEditingController mobilePhoneController;
  final TextEditingController languageController;
  final TextEditingController countryController;
  final TextEditingController provinceController;
  final TextEditingController cityController;
  final TextEditingController streetController;

  const EditableEmergencyContactInformationSection({
    super.key,
    this.isFirstContact = true,
    required this.firstNameController,
    required this.lastNameController,
    required this.relationshipController,
    required this.emailController,
    required this.mobilePhoneController,
    required this.languageController,
    required this.countryController,
    required this.provinceController,
    required this.cityController,
    required this.streetController,
  });

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    // Header text based on which contact
    final headerText = isFirstContact
        ? S.of(context).emergencyContact
        : S.of(context).secondEmergencyContact;

    return Column(
      children: [

        isMobile ? SizedBox(height: 15.sp) : SizedBox(),

        SettingsHeader(
          imagePath: 'assets/Emergency Contact.svg',
          text: headerText,
        ),
        SizedBox(height: 15.sp),

        // First Row/Column: First Name, Last Name, Relationship
        isMobile
            ? Column(
          children: [


            CustomValidatedTextFieldMaster(
              label: 'First Name'.tr,
              hint: 'Enter Your First Name'.tr,
              fillColor: AppColors.card,
              controller: firstNameController,
              height: 36,
              enabled: true,
              submitted: false,
            ),
            isMobile ? SizedBox(height: 0,) : SizedBox(height: 10),
            CustomValidatedTextFieldMaster(
              label: 'Last Name'.tr,
              fillColor: AppColors.card,
              hint: 'Enter Your Last Name'.tr,
              controller: lastNameController,
              height: 36,
              enabled: true,
              submitted: false,
            ),
            isMobile ? SizedBox(height: 0,) : SizedBox(height: 10),
            CustomValidatedTextFieldMaster(
              label: 'Relationship'.tr,
              fillColor: AppColors.card,
              hint: 'Enter Contact Relation'.tr,
              controller: relationshipController,
              height: 36,
              enabled: true,
              submitted: false,
            ),
          ],
        )
            : Row(
          children: [
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: 'First Name'.tr,
                hint: 'Enter Your First Name'.tr,
                controller: firstNameController,
                height: 36,
                fillColor: AppColors.card,
                enabled: true,
                submitted: false,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: 'Last Name'.tr,
                hint: 'Enter Your Last Name'.tr,
                controller: lastNameController,
                fillColor: AppColors.card,
                height: 36,
                enabled: true,
                submitted: false,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: 'Relationship'.tr,
                hint: 'Enter Contact Relation'.tr,
                controller: relationshipController,
                height: 36,
                enabled: true,
               fillColor: AppColors.card,
                submitted: false,
              ),
            ),
          ],
        ),

        // Second Row/Column: Email, Mobile Phone, Language
        isMobile
            ? Column(
          children: [
            CustomValidatedTextFieldMaster(
              label: 'Email'.tr,
              hint: 'Enter Your Email'.tr,
              controller: emailController,
              height: 36,
              enabled: true,
              fillColor: AppColors.card,
              submitted: false,
            ),
            isMobile ? SizedBox(height: 0,) : SizedBox(height: 16),
            CustomValidatedTextFieldMaster(
              label: S.of(context).phoneNumber,
              hint: 'Enter Your Mobile Phone'.tr,
              controller: mobilePhoneController,
              height: 36,
              fillColor: AppColors.card,
              enabled: true,
              submitted: false,
              onlyDigits: true,
            ),
            isMobile ? SizedBox(height: 0,) : SizedBox(height: 16),
            CustomValidatedTextFieldMaster(
              label: 'Language'.tr,
              hint: S.of(context).enterLanguage,
              controller: languageController,
              height: 36,
              enabled: true,
              fillColor: AppColors.card,
              submitted: false,
            ),
          ],
        )
            : Row(
          children: [
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: 'Email'.tr,
                hint: 'Enter Your Email'.tr,
                controller: emailController,
                fillColor: AppColors.card,
                height: 36,
                enabled: true,
                submitted: false,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: S.of(context).phoneNumber,
                hint: S.of(context).enterPhoneNumber,
                fillColor: AppColors.card,
                controller: mobilePhoneController,
                height: 36,
                enabled: true,
                submitted: false,
                onlyDigits: true,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: 'Language'.tr,
                hint: S.of(context).enterLanguage,
                fillColor: AppColors.card,
                controller: languageController,
                height: 36,
                enabled: true,
                submitted: false,
              ),
            ),
          ],
        ),

        // Third Row/Column: Country, Province, City
        isMobile
            ? Column(
          children: [
            CustomValidatedTextFieldMaster(
              label: 'Country'.tr,
              hint: 'Enter Your Country'.tr,
              controller: countryController,
              height: 36,
              enabled: true,
              fillColor: AppColors.card,
              submitted: false,
            ),
            isMobile ? SizedBox(height: 0,) : SizedBox(height: 16),
            CustomValidatedTextFieldMaster(
              label: 'Province'.tr,
              hint: 'Enter Your State Or Province'.tr,
              controller: provinceController,
              height: 36,
              enabled: true,
              fillColor: AppColors.card,
              submitted: false,
            ),
            isMobile ? SizedBox(height: 0,) : SizedBox(height: 16),
            CustomValidatedTextFieldMaster(
              label: 'City'.tr,
              hint: 'Enter Your City'.tr,
              controller: cityController,
              height: 36,
              enabled: true,
              fillColor: AppColors.card,
              submitted: false,
            ),
          ],
        )
            : Row(
          children: [
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: 'Country'.tr,
                hint: 'Enter Your Country'.tr,
                controller: countryController,
                height: 36,
                enabled: true,
                submitted: false,
                fillColor: AppColors.card,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: 'Province'.tr,
                hint: 'Enter Your State Or Province'.tr,
                controller: provinceController,
                height: 36,
                enabled: true,
                fillColor: AppColors.card,
                submitted: false,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: 'City'.tr,
                hint: 'Enter Your City'.tr,
                controller: cityController,
                height: 36,
                enabled: true,
                submitted: false,
                fillColor: AppColors.card,
              ),
            ),
          ],
        ),

        // Fourth Row: Street (full width on both mobile and desktop)
        CustomValidatedTextFieldMaster(
          label: S.of(context).street,
          hint: 'Enter Your Street Address'.tr,
          controller: streetController,
          height: 36,
          fillColor: AppColors.card,
          enabled: true,
          submitted: false,
        ),
      ],
    );
  }
}