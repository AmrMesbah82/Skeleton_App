import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/employees/presentation/controller/main_core_department_controller.dart';

class GuestsContainer extends StatefulWidget {
  const GuestsContainer({
    super.key,
    required this.department,
    this.deleteEmployeeMethod,
    required this.jobTitle,
    required this.name,
    required this.profilePhoto,
    required this.nameInArabic,
    required this.departmentInArabic,
    this.status,
    this.withStatus = false,
    this.isEdit = false,
    this.isInvited = false,
  });
  final String profilePhoto;
  final String name;
  final String nameInArabic;
  final String jobTitle;
  final String department;
  final String departmentInArabic;
  final bool withStatus;
  final bool isEdit;
  final String? status;
  final void Function()? deleteEmployeeMethod;
  final bool isInvited;
  @override
  State<GuestsContainer> createState() => _GuestsContainerState();
}

class _GuestsContainerState extends State<GuestsContainer> {
  AddDepartmentController addDepartmentController =
      Get.put(AddDepartmentController());
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      width: isTablet
          ? isPortrait
              ? 0.4.w
              : 0.3.w
          : 0.83.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0.025.w, vertical: isPortrait ? 0.01.h : 0.015.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: isTablet
                  ? isPortrait
                      ? 0.025.h
                      : 0.04.h
                  : 0.03.h,
              backgroundImage: AssetImage(widget.profilePhoto),
            ),
            SizedBox(
              width: isTablet ? 0.01.w : 0.025.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Get.locale.toString().contains('ar')
                      ? widget.nameInArabic
                      : widget.name.capitalize!,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isTablet
                          ? isPortrait
                              ? FontConstants.fontSize012.h
                              : FontConstants.fontSize014.w
                          : FontConstants.fontSize018.h,
                      color: Theme.of(context).colorScheme.inverseSurface,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.015.h),
                  child: Text(
                    Get.locale.toString().contains('ar')
                        ? widget.departmentInArabic
                        : widget.department.capitalize!,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: isTablet
                            ? isPortrait
                                ? FontConstants.fontSize012.h
                                : FontConstants.fontSize012.w
                            : FontConstants.fontSize016.h,
                        color: MyThemeData.textGrey,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                  //    color: Colors.amber,
                      width: isTablet
                          ? isPortrait
                              ? 0.19.w
                              : 0.14.w
                          : 0.5.w,
                      child: Text(
                        Get.locale.toString().contains('ar')
                            ? widget.jobTitle.capitalize!.tr
                            : addDepartmentController
                                .containAbbreviation(widget.jobTitle),
                        style: AppFontStyle.cairoRegularStyle.copyWith(
                            fontSize: isTablet
                                ? isPortrait
                                    ? FontConstants.fontSize012.h
                                    : FontConstants.fontSize012.w
                                : FontConstants.fontSize014.h,
                            color: MyThemeData.textGrey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    widget.withStatus
                        ? Text(
                            widget.status?.tr ?? "Pending".tr,
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: isTablet
                                    ? isPortrait
                                        ? FontConstants.fontSize012.h
                                        : FontConstants.fontSize012.w
                                    : FontConstants.fontSize015.h,
                                color: widget.status == null
                                    ? MyThemeData.warning
                                    : (widget.status?.tr == "Pending".tr
                                        ? MyThemeData.warning
                                        : widget.status?.tr == "Rejected".tr
                                            ? MyThemeData.colorRed
                                            : MyThemeData.unBlock),
                                fontWeight: FontWeight.w600),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ],
            ),
            widget.isEdit ? const Spacer() : const SizedBox.shrink(),
            widget.isEdit
                ? Column(
                    children: [
                      GestureDetector(
                        onTap: widget.deleteEmployeeMethod,
                        child: SvgPicture.asset(
                          'assets/icons/redTrash.svg',
                          height: isTablet
                              ? isPortrait
                                  ? 0.03.h
                                  : 0.04.h
                              : 0.025.h,
                        ),
                      ),
                      widget.isInvited
                          ? Padding(
                              padding: EdgeInsets.only(top: 0.025.h),
                              child: Text(
                                "Invited".tr,
                                style: AppFontStyle.cairoRegularStyle.copyWith(
                                    fontSize: isPortrait
                                        ? FontConstants.fontSize012.h
                                        : FontConstants.fontSize010.w,
                                    fontWeight: FontWeight.w500,
                                    color: MyThemeData.unBlock),
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  )
                : widget.isInvited
                    ? Padding(
                        padding: EdgeInsets.only(top: 0.05.h),
                        child: Text(
                          "Invited".tr,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: isPortrait
                                  ? FontConstants.fontSize012.h
                                  : FontConstants.fontSize010.w,
                              fontWeight: FontWeight.w500,
                              color: MyThemeData.unBlock),
                        ),
                      )
                    : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
