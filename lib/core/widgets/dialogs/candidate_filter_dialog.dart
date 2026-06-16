import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_drop_down_menu.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/enumeration/enum.dart';

import 'package:demo_app/core/helper/haptic_controller.dart';

import 'package:demo_app/core/theme/app_font_size.dart';

// ignore: must_be_immutable
class CandidateFilterDialog extends StatefulWidget {
  CandidateFilterDialog(
      {super.key,
      required this.genderValue,
      this.expValue,
      this.submittedValue,
      this.expState,
      required this.genderState,
      required this.submittedState,
      required this.ageValue,
      required this.ageState,
      required this.ageDropDownItems,
      required this.expDropDownItems});

  String? genderValue;
  String? expValue;
  String? submittedValue;
  String? ageValue;

  List<String> ageDropDownItems;
  
   
  List<String> expDropDownItems;

  ValueChanged<String?>? genderState;
  ValueChanged<String?>? expState;
  ValueChanged<String?>? submittedState;
  ValueChanged<String?>? ageState;

  @override
  State<CandidateFilterDialog> createState() => _CandidateFilterDialogState();
}

class _CandidateFilterDialogState extends State<CandidateFilterDialog> {
 

  final HapticController hapticController = Get.put(HapticController());

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? (isPortrait ? 0.1.w : 0.2.w) : 0.1.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        height: null,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isPortrait ? 0.025.w : 0.015.w,
              vertical: isPortrait ? 0.015.h : 0.015.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FiltersAppBar(
                imageUrl: "assets/icons/headerFilterIcon.svg",
                title: "Filter",
                iconColor: AppColors.colorWhite,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomDropdownButton2(
                          hint: "Gender",
                          borded: false,
                          buttonHeight: isPortrait ? 0.05.h : 0.065.h,
                          dropdownWidth: isTablet ? 0.22.w : 0.35.w,
                        
                          buttonPadding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 0.01.w : 0.02.w),
                          value: widget.genderValue!.tr,
                          dropdownItems: [
                            'Male'.tr,
                            'Female'.tr,
                          ],
                          onChanged: (value) {
                            setState(() {
                              widget.genderValue = value;
                              widget.genderState!(value);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 0.02.w,
                      ),
                      Expanded(
                        child: CustomDropdownButton2(
                          hint: "Age",
                          borded: false,
                          buttonHeight: isPortrait ? 0.05.h : 0.065.h,
                          dropdownWidth: isTablet ? 0.22.w : 0.35.w,
                        
                          buttonPadding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 0.01.w : 0.02.w),
                          value: widget.ageValue!.tr,
                          dropdownItems: widget.ageDropDownItems,
                          onChanged: (value) {
                            setState(() {
                              widget.ageValue = value;
                              widget.ageState!(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.02.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomDropdownButton2(
                          hint: "Posted By",
                          borded: false,
                          buttonHeight: isPortrait ? 0.05.h : 0.065.h,
                          dropdownWidth: isTablet ? 0.22.w : 0.35.w,
                         
                          buttonPadding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 0.01.w : 0.02.w),
                          value: widget.expValue!.tr,
                          dropdownItems: widget.expDropDownItems,
                          onChanged: (value) {
                            setState(() {
                              widget.expValue = value;
                              widget.expState!(value);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 0.02.w,
                      ),
                      Expanded(
                        child: CustomDropdownButton2(
                          hint: "Submitted",
                          borded: false,
                          buttonHeight: isPortrait ? 0.05.h : 0.065.h,
                          dropdownWidth: isTablet ? 0.22.w : 0.35.w,
                      
                          buttonPadding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 0.01.w : 0.02.w),
                          value: widget.submittedValue!.tr,
                          dropdownItems: ['Cover Letter'.tr, 'Portfolio'.tr],
                          onChanged: (value) {
                            setState(() {
                              widget.submittedValue = value;
                              widget.submittedState!(widget.submittedValue);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 0.02.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.015.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MainCustomIconButton(
                      onPressed: () {
                        hapticController.triggerHapticFeedback(
                            vibration: VibrateType.mediumImpact,
                            hapticFeedback: HapticFeedback.mediumImpact);
                      },
                      buttonText: "Reset".tr,

                      buttonStyle: ElevatedButton.styleFrom(
                        minimumSize: isTablet
                            ? isPortrait
                                ? Size(0.15.w, 0.045.h)
                                : Size(0.07.w, 0.05.h)
                            : Size(0.36.w, 0.05.h),
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.shadow),
                        ),
                      ),
                    ),
                    MainCustomIconButton(
                      onPressed: () {
                        hapticController.triggerHapticFeedback(
                            vibration: VibrateType.heavyImpact,
                            hapticFeedback: HapticFeedback.heavyImpact);

                        Navigator.pop(context);
                      },
                      buttonText: "Apply".tr,

                      buttonStyle: ElevatedButton.styleFrom(
                        minimumSize: isTablet
                            ? isPortrait
                                ? Size(0.15.w, 0.045.h)
                                : Size(0.07.w, 0.05.h)
                            : Size(0.36.w, 0.05.h),
                        backgroundColor: AppColors.signOut,
                        shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.shadow),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
