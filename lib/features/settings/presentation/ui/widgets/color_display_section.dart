// ignore_for_file: sdk_version_since

import 'package:demo_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/settings/presentation/controller/add_company_controller.dart';
import 'package:demo_app/features/settings/presentation/ui/widgets/color_picker_container.dart';


class ColorDisplaySection extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Function(Color) onPrimaryColorSelected;
  final Function(Color) onSecondaryColorSelected;

  ColorDisplaySection({
    required this.primaryColor,
    required this.secondaryColor,
    required this.onPrimaryColorSelected,
    required this.onSecondaryColorSelected,
  });

  @override
  State<ColorDisplaySection> createState() => _ColorDisplaySectionState();
}

class _ColorDisplaySectionState extends State<ColorDisplaySection> {
  CompanyController addCompanyController = Get.find();
  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    TextStyle titleTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize: isTablet
          ? (isVertical
              ? FontConstants.fontSize018.h
              : FontConstants.fontSize022.h)
          : FontConstants.fontSize015.h,
      color: Theme.of(context).colorScheme.secondaryContainer,
      height: isTablet ? (isVertical ? 2 : 1.7) : 0.002.h,
      fontWeight: FontWeight.w400,
    );

    return isVertical
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Colors".tr,
                style: StyleText.fontSize16Weight500.copyWith(
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 10.sp),
              ColorPickerContainer(

                onChanged: (value) {
                  print('priiiiii: $value');
                },
                initialColorString:
                    addCompanyController.company!.status == 'active'
                        ? addCompanyController.company!.primaryColor!
                                .primaryColor?.lastOrNull ??
                            '0xFFE5B800'
                        : '0xFFE5B800',
                fieldName: "Primary Color".tr,
                initialColor: widget.primaryColor,
                onColorSelected: widget.onPrimaryColorSelected,
              ),
              SizedBox(height: 0.015.h),
              ColorPickerContainer(
                onChanged: (value) {},
                initialColorString:
                    addCompanyController.company!.status == 'active'
                        ? addCompanyController.company!.secondaryColor!
                                .secondaryColor?.lastOrNull ??
                            '0xFFFFDE59'
                        : '0xFFFFDE59',
                fieldName: "Secondary Color".tr,
                initialColor: widget.secondaryColor,
                onColorSelected: widget.onSecondaryColorSelected,
              ),
              SizedBox(height: 0.008.h),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Colors".tr,
                style: StyleText.fontSize16Weight500.copyWith(
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ColorPickerContainer(
                          onChanged: (value) {
                            print('priiiiii: $value');
                          },
                          initialColorString:
                              addCompanyController.company?.status == 'active'
                                  ? addCompanyController
                                          .company!
                                          .primaryColor!
                                          .primaryColor
                                          ?.lastOrNull ??
                                      '0xFFE5B800'
                                  : '0xFFE5B800',
                          fieldName: "Primary Color".tr,
                          initialColor: widget.primaryColor,
                          onColorSelected: widget.onPrimaryColorSelected,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ColorPickerContainer(
                          onChanged: (value) {},
                          initialColorString:
                              addCompanyController.company?.status == 'active'
                                  ? addCompanyController
                                          .company!
                                          .secondaryColor!
                                          .secondaryColor
                                          ?.lastOrNull ??
                                      '0xFFFFDE59'
                                  : '0xFFFFDE59',
                          fieldName: "Secondary Color".tr,
                          initialColor: widget.secondaryColor,
                          onColorSelected: widget.onSecondaryColorSelected,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            ],
          );
  }
}
