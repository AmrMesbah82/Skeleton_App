import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/form_fields/profile_textfield.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/helper/validator.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/pages/tablet/tablet_settings_health_insurance.dart';


class AcamdemicHistoryUpadte extends StatefulWidget {
  const AcamdemicHistoryUpadte({super.key});

  @override
  State<AcamdemicHistoryUpadte> createState() => _AcamdemicHistoryUpadteState();
}

class _AcamdemicHistoryUpadteState extends State<AcamdemicHistoryUpadte> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 0.32.w,
              child: textfieled(
                isReadOnly: false,
                context,
                (value) {
                  insuranceName2 = value.trim().toLowerCase();
                },
                (value) {
                  return Validator.name(
                      value,
                      Get.locale.toString().contains('en')
                          ? "Invalid Name"
                          : "اسم غير صالح");
                },
                'Graduated From'.tr, // hintText
                null,
                null, // prefixIcon
                controller: null,
              ),
            ),
            SizedBox(
              width: 0.32.w,
              child: textfieled(
                isReadOnly: false,
                context,
                (value) {
                  insuranceName2 = value.trim().toLowerCase();
                },
                (value) {
                  return Validator.name(
                      value,
                      Get.locale.toString().contains('en')
                          ? "Invalid Name"
                          : "اسم غير صالح");
                },
                'Graduated From'.tr, // hintText
                null,
                null, // prefixIcon
                controller: null,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 0.32.w,
              child: textfieled(
                isReadOnly: false,
                context,
                (value) {
                  insuranceName2 = value.trim().toLowerCase();
                },
                (value) {
                  return Validator.name(
                      value,
                      Get.locale.toString().contains('en')
                          ? "Invalid Name"
                          : "اسم غير صالح");
                },
                'University'.tr, // hintText
                null,
                null, // prefixIcon
                controller: null,
              ),
            ),
            SizedBox(
              width: 0.32.w,
              child: textfieled(
                isReadOnly: false,
                context,
                (value) {
                  insuranceName2 = value.trim().toLowerCase();
                },
                (value) {
                  return Validator.name(
                      value,
                      Get.locale.toString().contains('en')
                          ? "Invalid Name"
                          : "اسم غير صالح");
                },
                'University'.tr, // hintText
                null,
                null, // prefixIcon
                controller: null,
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 0.32.w,
              child: textfieled(
                isReadOnly: false,
                context,
                (value) {
                  insuranceName2 = value.trim().toLowerCase();
                },
                (value) {
                  return Validator.insurancePolicyNumber(
                      value,
                      Get.locale.toString().contains('en')
                          ? "Invalid Number"
                          : "رقم غير صالح");
                },
                'Year of Graduation'.tr, // hintText
                null,
                null, // prefixIcon
                controller: null,
              ),
            ),
            SizedBox(
              width: 0.32.w,
              child: textfieled(
                isReadOnly: false,
                context,
                (value) {
                  insuranceName2 = value.trim().toLowerCase();
                },
                (value) {
                  return Validator.insurancePolicyNumber(
                      value,
                      Get.locale.toString().contains('en')
                          ? "Invalid Number"
                          : "رقم غير صالح");
                },
                'Year of Graduation'.tr, // hintText
                null,
                null, // prefixIcon
                controller: null,
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 0.32.w,
              child: textfieled(
                isReadOnly: false,
                context,
                (value) {
                  insuranceName2 = value.trim().toLowerCase();
                },
                (value) {
                  return Validator.gpa(
                    value,
                  );
                },
                'GPA'.tr, // hintText
                null,
                null, // prefixIcon
                controller: null,
              ),
            ),
            SizedBox(
              width: 0.32.w,
              child: textfieled(
                isReadOnly: false,
                context,
                (value) {
                  insuranceName2 = value.trim().toLowerCase();
                },
                (value) {
                  return Validator.gpa(
                    value,
                  );
                },
                'GPA'.tr, // hintText
                null,
                null, // prefixIcon
                controller: null,
              ),
            )
          ],
        )
      ],
    );
  }
}
