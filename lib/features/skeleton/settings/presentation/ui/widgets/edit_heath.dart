///******************** FILE INFO ********************///
/// Purpose: Editable version of health insurance section
/// Author: Assistant
/// Created At: 2025
/// Updated: Editable fields for health insurance information with controllers passed from parent

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/widgets/settings_header.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../external/main_core/core/theme/app_colors.dart';
import '../../../../../external/services_mangment_module/core/custom_textformfield.dart';
import '../../controller/settings_controller.dart';

class EditableHealthInsuranceSection extends StatelessWidget {
  // Controllers passed from parent
  final TextEditingController insuranceNameController;
  final TextEditingController insurancePolicyNumberController;

  const EditableHealthInsuranceSection({
    super.key,
    required this.insuranceNameController,
    required this.insurancePolicyNumberController,
  });

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.02.h),
          child: SettingsHeader(
            imagePath: 'assets/Insurance Details.svg',
            text: S.of(context).insuranceDetails,
          ),
        ),

        SizedBox(height: 15.sp),

        // Insurance Name and Policy Number Row
        isMobile
            ? Column(
          children: [
            CustomValidatedTextFieldMaster(
              label: 'Insurance Name'.tr,
              hint: 'Enter Insurance Name'.tr,
              controller: insuranceNameController,
              height: 36,
              fillColor: AppColors.background,
              enabled: true,
              submitted: false,
            ),
            isMobile ? SizedBox(height: 0,) : SizedBox(height: 16),
            CustomValidatedTextFieldMaster(
              label: S.of(context).insurancePolicyNumber,
              hint: 'Enter Policy Number'.tr,
              controller: insurancePolicyNumberController,
              height: 36,
              fillColor: AppColors.card,
              enabled: true,
              submitted: false,
            ),
          ],
        )
            : Row(
          children: [
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: 'Insurance Name'.tr,
                hint: 'Enter Insurance Name'.tr,
                controller: insuranceNameController,
                height: 36,
                fillColor: AppColors.card,
                enabled: true,
                submitted: false,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: S.of(context).insurancePolicyNumber,
                hint: 'Enter Policy Number'.tr,
                controller: insurancePolicyNumberController,
                height: 36,
                enabled: true,
                fillColor: AppColors.card,
                submitted: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}