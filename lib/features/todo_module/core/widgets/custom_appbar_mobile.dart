// ignore_for_file: unrelated_type_equality_checks
import 'package:auto_size_text/auto_size_text.dart';
import 'package:demo_app/core/nav_bar_package.dart/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/core/theme/app_theme.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/custom_icon_button.dart';
import 'package:demo_app/features/todo_module/core/constants/image_paths.dart';
import 'package:demo_app/features/todo_module/core/constants/screen_size.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/controllers/todo_controller.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/ui/pages/tablet/todo_home_screen_tablet.dart';
import 'package:page_transition/page_transition.dart';

import 'package:demo_app/core/stubs/module_page_stubs.dart';

//Date:April/3/2023
//by: Bassem Mohamed
//lastUpdate:April/17/2023

// This is a custom app bar widget in Flutter. It is a StatefulWidget widget that
// takes optional parameters: a title (required), an icon and an onPressed function.
// The build method returns a Column widget wrapped in a Padding widget.
// The column contains a logo (loaded from an SVG file), the title, and the optional icon.
// If the icon is not provided, the widget returns an empty SizedBox.
// The logo and text are styled using the theme data provided by the parent widget.
// The .h and .w suffixes used in the SizedBox widgets are likely custom extensions
// to make the widget responsive to the screen size.

class CustomAppBarMobile extends StatefulWidget {
  const CustomAppBarMobile({
    super.key,
    this.title,
    this.isEdit = false,
    this.isHome = false,
    this.isMessage = false,
    this.isYellowContainer = false,
    this.onPressed,
    this.onIconPressed,
    this.imagePath,
    this.showMoreIcon = false,
    this.onTapUp,
    required this.showIcon,
    this.isEmployees = false,
    this.isProject = false,
  });

  final String? title;
  final String? imagePath;
  final bool showIcon;
  final bool? isEdit;
  final bool? isMessage;
  final bool? isHome;
  final bool? isYellowContainer;
  final bool? showMoreIcon;
  final void Function()? onPressed;
  final void Function()? onIconPressed;
  final Function(TapUpDetails)? onTapUp;
  final bool isEmployees;
  final bool isProject;

  @override
  State<CustomAppBarMobile> createState() => _CustomAppBarMobileState();
}

class _CustomAppBarMobileState extends State<CustomAppBarMobile> {
  late String currentImagePath;

  @override
  void initState() {
    super.initState();
    currentImagePath = widget.imagePath ?? 'assets/images/edit.png';
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return GetBuilder<TodoController>(builder: (controller) {
      return SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isHome == true) SizedBox(height: .014.h),
            if (widget.isHome == true)
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        Get.locale.toString().contains('en') ? 0.04.w : 0.04.w),
                child: Row(
                  children: [
                    SizedBox(
                      width: .05.h,
                      height: .045.h,
                      child: SvgPicture.asset(
                        ImagePaths.getImagePath(context, 'logo'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        // PersistentNavBarNavigator.pushNewScreen(
                        //   context,
                        //   screen: SettingsScreen(),
                        //   withNavBar: false,
                        // );
                      },
                      child: SvgPicture.asset(
                        "assets/icons/SettingHome.svg",
                        color:
                            AppTheme.isDark == true ? AppColors.darkGrey : null,
                      ),
                    ),
                    SizedBox(width: 0.03.w),
                    if (widget.isMessage == false)
                      GestureDetector(
                        onTap: () {
                          // PersistentNavBarNavigator.pushNewScreen(
                          //   context,
                          //   screen: const MessagesScreen(),
                          //   withNavBar: false,
                          // );
                        },
                        child: SvgPicture.asset(
                            "assets/icons/message_without_notif.svg",
                            color: AppTheme.isDark == true
                                ? AppColors.darkGrey
                                : null),

                        /// Notification with red dot

                        // child: SvgPicture.asset(
                        //   "assets/icons/notificationRedDot.svg",
                        //   fit: BoxFit.fill,
                        // ),
                      ),
                    SizedBox(width: 0.03.w),
                    GestureDetector(
                      onTap: () {
                        // PersistentNavBarNavigator.pushNewScreen(
                        //   context,
                        //   screen: const NotificationScreenMobile(),
                        //   withNavBar: false,
                        // );
                      },
                      child: SvgPicture.asset(
                        "assets/icons/bellIcon.svg",
                        color:
                            AppTheme.isDark == true ? AppColors.darkGrey : null,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.isMessage == true) SizedBox(height: .015.h),
            if (widget.title != null && widget.isMessage == false)
              SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(
                left: widget.showIcon && Get.locale.toString().contains('en')
                    ? 0.0.w
                    : 0.04.w,
                right: widget.showIcon && Get.locale.toString().contains('ar')
                    ? 0.0.w
                    : 0.04.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: widget.showIcon,
                    child: IconButton(
                      onPressed: isTablet
                          ? () {
                              controller.clearControllers();
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: TodoHomeScreenTablet(),
                                ),
                              );
                            }
                          : () {
                              controller.clearControllers();
                              Navigator.pop(context);
                            },
                      icon: Transform.translate(
                        offset: Offset(-0.005.w, -0.005.h),
                        child: Transform.rotate(
                          angle:
                              Get.locale.toString().contains('ar') ? 3.13 : 0,
                          child: Transform.scale(
                            scale: 0.0013.h,
                            child: SvgPicture.asset(
                              'assets/icons/arrowright2.svg',
                              fit: BoxFit.fitWidth,
                              colorFilter: ColorFilter.mode(
                                  AppColors.text, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (widget.title != null)
                    Expanded(
                      // Use Expanded to occupy available space
                      child: AutoSizeText(
                        widget.title!.tr,
                        style: AppTextStyles.font10BlackCairoMediam.copyWith(
                          height: 1.3,
                          fontSize: widget.showIcon ? 20 : 30,
                          color: AppColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (widget.title != null && widget.showMoreIcon == true)
                    Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(0.01.h),
                        child: SvgPicture.asset(
                          "assets/icons/blackAddIcon.svg",
                        )),
                  if (widget.isEdit != false)
                    CustomIconButton(
                      buttonText: 'Create Board'.tr,
                      imagePath: 'assets/icons/board.svg',
                      isOwnerHome: true,
                      onPressed: widget.onIconPressed!,
                    ),
                  if (widget.imagePath != null)
                    widget.isEmployees
                        ? GestureDetector(
                            onTapUp: widget.onTapUp,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.all(0.01.h),
                                child: SvgPicture.asset(
                                  "assets/icons/blackAddIcon.svg",
                                )),
                          )
                        : widget.isProject
                            ? GestureDetector(
                                onTap: widget.onIconPressed,
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.all(0.01.h),
                                    child: SvgPicture.asset(
                                      "assets/icons/shareIcon.svg",
                                    )),
                              )
                            : Row(
                                children: [
                                  /* GestureDetector(
                                    onTap: () {
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen:
                                            const NotificationScreenMobile(),
                                        withNavBar: false,
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      "assets/icons/bellIcon.svg",
                                      color: AppTheme.isDark == true
                                          ? AppColors.darkGrey
                                          : null,
                                      fit: BoxFit.fill,
                                    ),
                                  ),*/
                                  SizedBox(width: 0.03.w),
                                  GestureDetector(
                                    onTap: () {
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: Settings(),
                                        withNavBar: false,
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      "assets/icons/SettingHome.svg",
                                      color: AppTheme.isDark == true
                                          ? AppColors.darkGrey
                                          : null,
                                    ),
                                  ),
                                  SizedBox(width: 0.03.w),
                                  GestureDetector(
                                    onTap: widget.onIconPressed,
                                    child: SvgPicture.asset(
                                      widget.imagePath!,
                                    ),
                                  ),
                                ],
                              ),
                ],
              ),
            ),
            // if (widget.title != null && widget.isMessage == false && widget.isEdit == false)
            //   SizedBox(
            //     height: .014.h,
            //   ),
          ],
        ),
      );
    });
  }
}
