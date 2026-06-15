/// ************************ FILE INFO ******************** ///
/// FILE NAME: system_logs_appbar.dart
/// PURPOSE: this file contains the system logs appbar.
/// AUTHOR: Mohamed Elrashidy
/// REFACTORED AT: 2/2/2025

import 'dart:io';
import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import 'package:demo_app/core/theme/new_theme.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/core/widgets/custom_svg.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/app_search_text_field.dart';
import 'package:demo_app/core/widgets/custom_drop_down_menu.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/widgets/form_fields/custom_search.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/roles/system_logs/presentation/controller/system_logs_controller.dart';
import 'package:demo_app/features/roles/system_logs/presentation/ui/widgets/download_logs_dialog.dart';
import 'package:demo_app/features/roles/system_logs/presentation/ui/widgets/filter_dialog.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../account_status/utils/account_status_helper.dart';
import '../../../utils/system_logs_constants.dart';

class SystemLogsAppBar extends StatefulWidget {
  SystemLogsAppBar();

  bool isFilterDataShow = false;
  String? delayValue;
  String? roleValue = Get.find<SystemLogsController>().status;

  @override
  State<SystemLogsAppBar> createState() => _SystemLogsAppBarState();
}

class _SystemLogsAppBarState extends State<SystemLogsAppBar> {
  final HapticController hapticController = Get.put(HapticController());
  SystemLogsController systemLogsController = Get.find();

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;
    var lightMode = Theme.of(context).brightness == Brightness.light;
    bool isDesktop = Platform.isLinux || Platform.isMacOS || Platform.isWindows;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return GetBuilder<SystemLogsController>(builder: (controller) {
      return Padding(
        padding: EdgeInsets.only(bottom: isPortrait ? 0.01.h : 0.02.h),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: isPortrait
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: <Widget>[


              AppSearchTextField(controller: controller.searchController, onChanged: (value) {
        controller.searchAndFilterLogs();
        },),

              isMobile ? SizedBox(width: 10.w) : SizedBox(),

             isMobile ? GestureDetector(
               onTap: () {
                 hapticController.triggerHapticFeedback(
                     vibration: VibrateType.lightImpact,
                     hapticFeedback: HapticFeedback.lightImpact);
                 setState(() {
                   widget.isFilterDataShow = !widget.isFilterDataShow;
                 });
                 showDialog(
                   context: context,
                   builder: (BuildContext context) {
                     return FilterDialog(
                       employessScreen: true,
                       roleValue: widget.roleValue,
                       delayValue: widget.delayValue,
                       dropDownItems: [],
                     );
                   },
                 );
               },
               child: Container(
                 width: 38.sp,
                 height: 38.sp,
                 decoration: BoxDecoration(
                     color: lightMode ? ColorAppLight.whiteColor : ColorAppDark.chatBackground,
                     borderRadius: BorderRadius.circular(8.r)
                 ),
                 child: SizedBox(
                   child: CustomSvg(
                     assetPath: "assets/images/filter_table.svg",
                     width: 10.w,
                     height: 10.h,
                     fit: BoxFit.scaleDown,
                     color: lightMode ? ColorAppLight.blackButton : ColorAppDark.titleValue,
                   ),
                 ),
               ),
             ) :



             Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isPortrait ? 0.015.w : 0.015.w),
                child: GestureDetector(
                  onTap: () {
                    hapticController.triggerHapticFeedback(
                        vibration: VibrateType.lightImpact,
                        hapticFeedback: HapticFeedback.lightImpact);
                    setState(() {
                      widget.isFilterDataShow = !widget.isFilterDataShow;
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FilterDialog(
                          employessScreen: true,
                          roleValue: widget.roleValue,
                          delayValue: widget.delayValue,
                          dropDownItems: [],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: isPortrait ? 0.04.h : 0.055.h,
                    width: isPortrait ? 0.13.w : 0.1.w,
                    decoration: BoxDecoration(
                        color: systemLogsController.isFilter
                            ? MyThemeData.signOut
                            : Theme.of(context).colorScheme.inversePrimary,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.transparent)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Transform.scale(
                          scale: isDesktop
                              ? AccountStatusHelper.getIconSize(context)
                              : 1.3,
                          child: SvgPicture.asset(
                              "assets/images/filter_table.svg",
                              color: widget.isFilterDataShow
                                  ? MyThemeData().contrastColor()
                                  : Theme.of(context).colorScheme.scrim),
                        ),
                        Text(
                          "Filter".tr,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: isPortrait
                                  ? FontConstants.fontSize024.w
                                  : FontConstants.fontSize016.w,
                              fontWeight: FontWeight.w500,
                              height: isPortrait ? 1.6 : 1.8,
                              color: widget.isFilterDataShow
                                  ? MyThemeData().contrastColor()
                                  : Theme.of(context).colorScheme.scrim),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              isMobile ? SizedBox(width: 10.w) : SizedBox(),











             isMobile ? SizedBox(): CustomDropdownButton2(
                hint: "Sort".tr,
                borded: false,
                buttonHeight: isTablet
                    ? isPortrait
                        ? 0.04.h
                        : 0.055.h
                    : 0.04.h,
                buttonWidth: isTablet
                    ? isPortrait
                        ? 0.21.w
                        : 0.14.w
                    : 0.22.w,
                dropdownWidth: isTablet
                    ? isPortrait
                        ? 0.21.w
                        : 0.14.w
                    : 0.11.w,
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              
                buttonPadding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 0.01.w : 0.02.w),
                value: controller.sortValue.tr,
                dropdownItems: SystemLogsConstants.sortListInArabic,
                onChanged: (value) {
                  setState(() {
                    controller.sortValue = value!;
                    controller.sortLogs(Get.locale!.toString().contains('en')
                        ? value
                        : SystemLogsConstants.sortList[SystemLogsConstants
                            .sortListInArabic
                            .indexOf(value)]);
                  });
                },
              ),

              isMobile ? GestureDetector(
                onTap: (){},
                child: Container(
                  width: 38.sp,
                  height: 38.sp,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8.r)
                  ),
                  child: SizedBox(
                    child: CustomSvg(
                      assetPath: "assets/icons/exportsquare.svg",
                      width: 10.w,
                      height: 10.h,
                      fit: BoxFit.scaleDown,
                      color: ColorAppLight.buttonTextColor,
                    ),
                  ),
                ),
              ) : Padding(
                padding: EdgeInsets.only(
                    left: Get.locale.toString().contains('en') ? 0.015.w : 0,
                    right: Get.locale.toString().contains('en') ? 0 : 0.015.w),
                child: SizedBox(
                  height: (isPortrait ? 0.04.h : 0.055.h),
                  child: MainCustomIconButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return SystemLogsDownloadDialog();
                          });
                    },
                    buttonText: "Export".tr,
                    widgetIcon: "assets/icons/exportsquare.svg",
                    buttonStyle: ElevatedButton.styleFrom(
                      backgroundColor: MyThemeData.signOut,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
