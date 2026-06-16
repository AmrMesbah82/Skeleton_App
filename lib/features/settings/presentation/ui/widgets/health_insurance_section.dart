///************************** FILE INFO ************************///
/// Purpose: This file contains the HealthInsuranceSection in health insurance settings page.
/// Author: Mohamed Elrashidy
/// Created At: 12/11/2023
/// Updated At: 31/10/2025
/// Updated By: Claude AI Assistant
/// Changes: Updated to fetch data from NewEmployeeModelHistory model

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/form_fields/profile_textfield.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/settings/presentation/controller/settings_controller.dart';


import '../../../../../core/widgets/country_picker_dialog.dart';
import '../../../../../core/widgets/intl_phone_field.dart';
// REMOVED: import '../../../../authentication/welcome_screen/views/mobile_view/nav_bar.dart';
import '../../../../../generated/l10n.dart';
import '../../../../employee/data/models/emplyees_model/new_employee_model.dart';
import '../../../../employee/presentation/controller/main_core_employee_controller.dart';
import '../../../../services_mangment_module/core/custom_textformfield.dart';
import '../../../../employees/presentation/controller/employee_controller.dart';
import 'settings_header.dart';

class HealthInsuranceSection extends StatelessWidget {
  HealthInsuranceSection({super.key});

  // Controllers
  final MainCoreEmployeeController employeeController = Get.find<MainCoreEmployeeController>();
  final SettingsController settingsController = Get.find();

  // Create controllers for each field
  final TextEditingController insuranceNameController = TextEditingController();
  final TextEditingController policyNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    // Get current employee's history data
    String currentUserEmail = Get.find<EmployeeController>().employee!.email?.last ?? '';

    // Find the current employee from the history model
    NewEmployeeModelHistory? currentEmployeeHistory = employeeController.allNewEmployees?.firstWhereOrNull(
            (emp) => emp.email.isNotEmpty && emp.email.last == currentUserEmail
    );

    // Get the latest values (last item in the list)
    String insuranceName = '';
    String policyNumber = '';

    if (currentEmployeeHistory != null) {
      // Get last value from history lists
      if (currentEmployeeHistory.insuranceName.isNotEmpty) {
        insuranceName = currentEmployeeHistory.insuranceName.last;
      }
      if (currentEmployeeHistory.insurancePolicyNumber.isNotEmpty) {
        policyNumber = currentEmployeeHistory.insurancePolicyNumber.last;
      }
    }

    // Initialize controllers with values
    insuranceNameController.text = capitalize(insuranceName);
    policyNumberController.text = policyNumber;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return isMobile
        ? Padding(
      padding: EdgeInsets.only(right: 15.sp,left: 15.sp,top: 15.sp),
          child: Column(
                children: [

          Padding(
            padding: EdgeInsets.only(bottom: 0.02.h, top: 0.h),
            child: SettingsHeader(
                imagePath: 'assets/dummyFile/Insurance Details_icons.svg',
                text: S.of(context).healthInsurance),
          ),


          // Insurance Name Field
          CustomValidatedTextFieldMaster(
            label: S.of(context).insuranceName,
            hint: '-',
            controller: insuranceNameController,
            enabled: false,
            submitted: false, // ✅ Disable validation
            height: 36,
            textDirection: TextDirection.ltr, // ✅ Force LTR
            maxLength: 100,
          ),
                 isMobile ? SizedBox(height: 0,) : SizedBox(height: 10.h),
          // Policy Number Field
          CustomValidatedTextFieldMaster(
            label: S.of(context).insurancePolicyNumber,
            hint: "-",
            controller: policyNumberController,
            enabled: false,
            submitted: false, // ✅ Disable validation
            textAlign: TextAlign.left, // ✅ Force left align
            height: 36,
            textDirection: TextDirection.ltr, // ✅ Force LTR
          ),
                ],
              ),
        )



        : Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 0.02.h, top: 0.01.h),
          child: SettingsHeader(
              imagePath: 'assets/Insurance Details.svg',
              text: 'Health Insurance'.tr),
        ),
        Row(
          children: [
            // Insurance Name Field
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: S.of(context).insuranceName,
                hint: "-",
                controller: insuranceNameController,
                enabled: false,
                submitted: false, // ✅ Disable validation
                height: 36,
                textDirection: TextDirection.ltr, // ✅ Force LTR
                maxLength: 100,
              ),
            ),
            SizedBox(width: 15.h),
            // Policy Number Field
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: S.of(context).insurancePolicyNumber,
                hint: "-",
                controller: policyNumberController,
                enabled: false,
                submitted: false, // ✅ Disable validation
                height: 36,
                textDirection: TextDirection.ltr, // ✅ Force LTR
                maxLength: 100,
              ),
            ),
          ],
        ),
      ],
    );
  }
}