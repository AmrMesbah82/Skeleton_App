import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_drop_down_menu.dart';
import 'package:demo_app/components/requests_components/requests_filter_appbar.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/employees/presentation/controller/main_core_department_controller.dart';

class RequestesFilterDialogMobile extends StatefulWidget {
  RequestesFilterDialogMobile({
    super.key,
    required this.day,
    required this.dayState,
    required this.depState,
    required this.department,
    required this.status,
    required this.statusState,
  });

  String? department;
  ValueChanged<String?> depState;
  String? status;
  ValueChanged<String?> statusState;
  String? day;
  ValueChanged<String?> dayState;

  @override
  State<RequestesFilterDialogMobile> createState() =>
      _RequestesFilterDialogMobileState();
}

class _RequestesFilterDialogMobileState
    extends State<RequestesFilterDialogMobile> {
  final HapticController hapticController = Get.put(HapticController());

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0.04.w),
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
          padding: EdgeInsets.symmetric(horizontal: 0.04.w, vertical: 0.02.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FiltersAppBar(
                imageUrl: "assets/images/filter_table.svg",
                title: "Filter",
                iconColor: MyThemeData().contrastColor(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 0.02.h,
                  ),
                  CustomDropdownButton2(
                    hint: "Choose Department",
                    borded: false,
                    buttonWidth: double.infinity,
                    buttonHeight: 0.05.h,
                    dropdownWidth: 0.84.w,
                  
                    buttonPadding: EdgeInsets.only(
                      right: Get.locale.toString().contains('en')
                          ? 0.035.w
                          : 0.02.w,
                      left: Get.locale.toString().contains('en')
                          ? 0.02.w
                          : 0.035.w,
                    ),
                    value: widget.department,
                    dropdownItems: Get.locale.toString().contains('en')
                        ? Get.find<AddDepartmentController>().departmentsEnglishName
                        : Get.find<AddDepartmentController>().departmentsArabicName,
                    onChanged: (value) {
                      setState(() {
                        widget.department = value;
                        widget.depState(widget.department);
                      });
                    },
                  ),
                  SizedBox(
                    height: 0.02.h,
                  ),
                  CustomDropdownButton2(
                    hint: "Status",
                    borded: false,
                    buttonWidth: double.infinity,
                    buttonHeight: 0.05.h,
                    dropdownWidth: 0.84.w,
                   
                    buttonPadding: EdgeInsets.only(
                      right: Get.locale.toString().contains('en')
                          ? 0.035.w
                          : 0.02.w,
                      left: Get.locale.toString().contains('en')
                          ? 0.02.w
                          : 0.035.w,
                    ),
                    value: widget.status,
                    dropdownItems: ["Pending".tr, "Approved".tr, "Rejected".tr],
                    onChanged: (value) {
                      setState(() {
                        widget.status = value;
                        widget.statusState(widget.status);
                      });
                    },
                  ),
                  SizedBox(
                    height: 0.02.h,
                  ),
                  CustomDropdownButton2(
                    hint: "Day",
                    borded: false,
                    buttonWidth: double.infinity,
                    buttonHeight: 0.05.h,
                    dropdownWidth: 0.84.w,
                  
                    buttonPadding: EdgeInsets.only(
                      right: Get.locale.toString().contains('en')
                          ? 0.035.w
                          : 0.02.w,
                      left: Get.locale.toString().contains('en')
                          ? 0.02.w
                          : 0.035.w,
                    ),
                    value: widget.day,
                    dropdownItems: ["Today".tr, "Yesterday".tr, "Last Week".tr],
                    onChanged: (value) {
                      setState(() {
                        widget.day = value;
                        widget.dayState(widget.day);
                      });
                    },
                  ),
                ],
              ),
              // SizedBox(
              //   height: 0.02.h,
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 0.0.h),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       Expanded(
              //         child: CustomElevatedButton(
              //           onPressed: () {
              //             hapticController.triggerHapticFeedback(
              //                 vibration: VibrateType.heavyImpact,
              //                 hapticFeedback: HapticFeedback.heavyImpact);

              //             setState(() {
              //               widget.department = null;
              //               widget.depState(widget.department);
              //               widget.status = null;
              //               widget.statusState(widget.status);
              //               widget.day = null;
              //               widget.dayState(widget.day);
              //             });
              //             RestartWidget.restartApp(context);
              //           },
              //           buttonText: "Reset".tr,
              //           fontSize: isTablet
              //               ? isPortrait
              //                   ? FontConstants.fontSize017.h
              //                   : FontConstants.fontSize022.h
              //               : FontConstants.fontSize016.h,
              //           fontweight: FontWeight.w600,
              //           textColor: MyThemeData.colorWhite,
              //           buttonStyle: ElevatedButton.styleFrom(
              //             minimumSize: isTablet
              //                 ? isPortrait
              //                     ? Size(0.15.w, 0.045.h)
              //                     : Size(0.07.w, 0.05.h)
              //                 : Size(0.36.w, 0.05.h),
              //             backgroundColor: MyThemeData.signOut,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: const BorderRadius.all(
              //                 Radius.circular(8),
              //               ),
              //               side: BorderSide(
              //                   color: Theme.of(context).colorScheme.shadow),
              //             ),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
