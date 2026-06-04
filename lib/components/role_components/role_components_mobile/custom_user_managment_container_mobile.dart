// ignore_for_file: unrelated_type_equality_checks, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/employees/presentation/controller/employee_controller.dart';
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';

import '../../../features/skeleton/roles/domain/entity/user_permission_entity.dart';

/// Date Created :13/May/2024
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit :13/May/2024
/// Objectives: this screen widget is responsible for showing the roles_module for each member in the company,
///  this container behaves dynamically according to each member responsibilites.
///
class CustomUserManagementContainerMobile extends StatefulWidget {
  final UserPermissionEntity userPermissionEntity;
  final bool isLast;
  final bool? isRow;
  final void Function()? onPressedEdit;
  final void Function()? onPressedDelete;

  const CustomUserManagementContainerMobile({
    Key? key,
    required this.userPermissionEntity,
    required this.isLast,
    required this.onPressedEdit,
    this.isRow = false,
    required this.onPressedDelete,
  }) : super(key: key);

  @override
  State<CustomUserManagementContainerMobile> createState() =>
      _CustomUserManagementContainerMobileState();
}

class _CustomUserManagementContainerMobileState
    extends State<CustomUserManagementContainerMobile> {
  final HapticController hapticController = Get.put(HapticController());
  EmployeeController addEmployeeController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final TextStyle blackTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize: isPortrait
          ? FontConstants.fontSize015.h
          : FontConstants.fontSize024.h,
      color: themeController.currentTheme == MyThemeData.lightTheme
          ? MyThemeData.colorBlack
          : MyThemeData.colorWhiteDark,
      fontWeight: Get.locale.toString().contains('en')
          ? FontWeight.w600
          : FontWeight.w500,
    );

    final TextStyle greyTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize: isPortrait
          ? FontConstants.fontSize015.h
          : FontConstants.fontSize024.h,
      color: themeController.currentTheme == MyThemeData.lightTheme
          ? MyThemeData.colorDarkGrey
          : MyThemeData.colorGreydark,
      fontWeight: Get.locale.toString().contains('en')
          ? FontWeight.w600
          : FontWeight.w500,
    );

    return Padding(
      padding: EdgeInsets.only(
          top: isPortrait ? 0 : 0.03.h, bottom: isPortrait ? (widget.isLast ==true? 0: 0.015.h) : 0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
          // color: themeController.currentTheme == MyThemeData.lightTheme
          //     ? MyThemeData.colorLightGrey
          //     : MyThemeData.darkBackGround,
          borderRadius: BorderRadius.circular(7),
        ),
        padding: EdgeInsets.symmetric(
            vertical: isPortrait ? 0.01.h : 0.02.h,
            horizontal: isPortrait ? 0.02.w : 0.02.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Column 1: Rounded Image
                Container(
                  width: isPortrait ? 0.045.h : 0.07.h,
                  height: isPortrait ? 0.045.h : 0.07.h,
                  decoration: BoxDecoration(
                    borderRadius: null,
                    shape: BoxShape.circle,
                    image: widget.userPermissionEntity.imagePath.contains('assets')
                        ? DecorationImage(
                            image: AssetImage(widget.userPermissionEntity.imagePath),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: NetworkImage(widget.userPermissionEntity.imagePath),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(width: 0.02.w),

                // Column 2: Employee Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            // color: Colors.amber,
                            width: 0.6.w,
                            child: Text(
                              '${widget.userPermissionEntity.userName.capitalize as String}',
                              style: AppFontStyle.cairoRegularStyle.copyWith(
                                  fontSize: isPortrait
                                      ? FontConstants.fontSize016.h
                                      : FontConstants.fontSize030.h,
                                  color: themeController.currentTheme ==
                                          MyThemeData.lightTheme
                                      ? MyThemeData.colorBlack
                                      : MyThemeData.colorWhiteDark,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4),
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: widget.onPressedEdit,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: MyThemeData.lightPrimary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                width: 0.07.w,
                                height: 0.07.w,
                                padding: EdgeInsets.all(0.007.h),
                                child: SvgPicture.asset(
                                  "assets/icons/editIconReq.svg",
                                  color: MyThemeData().contrastColor(),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.01.h),
            Row(
              children: [
                Text(
                  '${'Access Info'.tr}: ',
                  style: greyTextStyle,
                ),
                Expanded(
                  child: Text(
                    '${widget.userPermissionEntity.accessName!.capitalize as String}',
                    style: blackTextStyle,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.005.h),
            Row(
              children: [
                Text(
                  '${'From'.tr}: ',
                  style: greyTextStyle,
                ),
                Container(
                  width: 0.3.w,
                  //   color: Colors.amber,
                  child: Text(
                    Get.locale.toString().contains('en')
                        ? '${'${widget.userPermissionEntity.startDate!.capitalize as String}'}'
                        : convertToArabicDate(
                            '${'${widget.userPermissionEntity.startDate!.capitalize as String}'}'),
                    style: blackTextStyle,
                  ),
                ),
                SizedBox(
                  width: 0.015.w,
                ),
                Text(
                  '${'To'.tr}: ',
                  style: greyTextStyle,
                ),
                Container(
                  width: 0.28.w,
                  //     color: Colors.amber,
                  child: Text(
                    Get.locale.toString().contains('en')
                        ? '${widget.userPermissionEntity.endDate!.capitalize as String}'
                        : convertToArabicDate(
                            widget.userPermissionEntity.endDate!.capitalize as String),
                    style: blackTextStyle,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: widget.onPressedDelete,
                  child: Container(
                      decoration: BoxDecoration(
                        color: MyThemeData.block,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: 0.07.w,
                      height: 0.07.w,
                      padding: EdgeInsets.all(0.007.h),
                      child: SvgPicture.asset(
                        "assets/icons/trachReq.svg",
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
