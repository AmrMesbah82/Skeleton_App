import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_drop_down_menu.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
// REMOVED_MODULE: import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

// ignore: must_be_immutable
class UserAccessFilterDialog extends StatefulWidget {
  UserAccessFilterDialog({
    super.key,
    required this.passResetValue,
    required this.passResetState,
    required this.accountStatusValue,
    required this.accountStatusState,
    required this.resetStatus,
  });

  String? passResetValue;

  String? accountStatusValue;

  ValueChanged<String?>? passResetState;

  ValueChanged<String?>? accountStatusState;
  ValueChanged<void>? resetStatus;

  @override
  State<UserAccessFilterDialog> createState() => _CandidateFilterDialogState();
}

class _CandidateFilterDialogState extends State<UserAccessFilterDialog> {
  final HapticController hapticController = Get.put(HapticController());
  List<String> filterRequests = [
    'Requested',
    'Not Requested',
  ];
  List<String> filterRequestsInArabic = [
    'طلب',
    'ليس طلب',
  ];
  List<String> filterStatus = [
    'Active',
    'Deactivated',
    'Inactive',
    'Locked',
    'Locked With Send Request',
    'Request to Reset Password',
    'Will be Deactivated',
    'Will be Reactivated',
  ];
  List<String> filterStatusInArabic = [
    'نشط',
    'غير نشط',
    'غير مفعل',
    'مغلق',
    'مغلق مع طلب',
    'طلب لاعادة تعيين كلمة المرور',
    'سوف يعطيل',
    'سوف يتم تفعيل',
  ];
  String? requestValue;
  String? statusValue;
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? (isPortrait ? 0.1.w : 0.2.w) : 0.05.w),
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
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomDropdownButton2(
                          hint: "Request Status",
                          borded: false,
                          buttonHeight: isPortrait ? 0.05.h : 0.065.h,
                          dropdownWidth: isTablet
                              ? (isPortrait ? 0.365.w : 0.275.w)
                              : 0.42.w,
         
                          buttonPadding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 0.01.w : 0.02.w),
                          value: requestValue,
                          dropdownItems: Get.locale.toString().contains('ar')
                              ? filterRequestsInArabic
                              : filterRequests,
                          onChanged: (value) {
                            requestValue = value!;
                            setState(() {
                              widget.passResetValue =
                                  Get.locale.toString().contains('ar')
                                      ? filterRequests[
                                          filterRequestsInArabic.indexOf(value)]
                                      : value;
                              widget.passResetState!(
                                  Get.locale.toString().contains('ar')
                                      ? filterRequests[
                                          filterRequestsInArabic.indexOf(value)]
                                      : value);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 0.02.w,
                      ),
                      Expanded(
                        child: CustomDropdownButton2(
                          hint: "Account Status",
                          borded: false,
                          buttonHeight: isPortrait ? 0.05.h : 0.065.h,
                          dropdownWidth: isTablet
                              ? (isPortrait ? 0.365.w : 0.275.w)
                              : 0.42.w,
              
                          buttonPadding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 0.01.w : 0.02.w),
                          value: statusValue,
                          dropdownItems: Get.locale.toString().contains('ar')
                              ? filterStatusInArabic
                              : filterStatus,
                          onChanged: (value) {
                            setState(() {
                              statusValue = value;
                              widget.accountStatusValue =
                                  Get.locale.toString().contains('ar')
                                      ? filterStatus[
                                          filterStatusInArabic.indexOf(value!)]
                                      : value;
                              widget.accountStatusState!(
                                  Get.locale.toString().contains('ar')
                                      ? filterStatus[
                                          filterStatusInArabic.indexOf(value!)]
                                      : value);
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
                    SizedBox(
                      height: (isPortrait ? 0.04.h : 0.055.h),
                      child: MainCustomIconButton(
                        onPressed: () {
                          setState(() {
                            widget.accountStatusValue = null;
                            widget.passResetValue = null;
                            widget.resetStatus!(null);
                          });
                      
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
                           backgroundColor: MyThemeData.colorWhiteDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            side: BorderSide(
                                color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: (isPortrait ? 0.04.h : 0.055.h),
                      child: MainCustomIconButton(
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
                          backgroundColor: MyThemeData.signOut,
                          shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                        
                          ),
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
