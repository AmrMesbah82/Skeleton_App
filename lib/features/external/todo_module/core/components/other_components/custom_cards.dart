// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/features/external/main_core/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/main_core_theme_controller.dart';
import 'package:demo_app/features/external/todo_module/core/constants/enum.dart';
import 'package:demo_app/features/external/todo_module/core/constants/haptic_controller.dart';
import 'package:demo_app/features/external/todo_module/core/constants/image_paths.dart';
import 'package:demo_app/features/external/todo_module/core/constants/screen_size.dart';
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';

class CustomCard extends StatefulWidget {
  final String name;
  final Widget? icon;
  final bool isSwitchTile;
  final bool hideIcon;
  final bool showCurrency;
  bool currentValue;
  final Function(bool)? onSwitchChanged;
  final Function()? onTap;
  final int index;
  int? selectIndex;
  CustomCard({
    super.key,
    required this.name,
    this.icon,
    this.isSwitchTile = false,
    this.currentValue = false,
    this.hideIcon = false,
    this.showCurrency = false,
    this.onSwitchChanged,
    this.onTap,
    this.index = 0,
    this.selectIndex,
  });

  @override
  CustomCardState createState() => CustomCardState();
}

class CustomCardState extends State<CustomCard> {
  bool switchValue = false;
  MainCoreThemeController themeController = Get.find<MainCoreThemeController>();
  bool isEnglish = Get.locale.toString().contains('en');
  final ToDoHapticController hapticController =
      Get.find<ToDoHapticController>();

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    final orientation = MediaQuery.of(context).orientation;
    return LayoutBuilder(
      builder: (context, constraints) {
        final trailingWidget = widget.isSwitchTile
            ? Transform.scale(
                scale:
                    MediaQuery.of(context).size.shortestSide > 600 ? 1.2 : 2.2,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.currentValue = !widget.currentValue;
                    });
                    widget.onSwitchChanged?.call(widget.currentValue);
                  },
                  child: SvgPicture.asset(
                    widget.currentValue
                        ? 'assets/icons/NewSwitchOn.svg'
                        // ignore: unrelated_type_equality_checks
                        : mainCoreThemeController.currentTheme ==
                                MyThemeData.lightTheme
                            ? 'assets/icons/NewSwitchOff.svg'
                            : 'assets/icons/NewSwitchOff.svg',
                  ),
                ),
              )
            : Transform.rotate(
                angle: Get.locale.toString().contains('en') ? 3.13 : 0,
                child: Transform.scale(
                  scale: MediaQuery.of(context).size.shortestSide > 600
                      ? (orientation == Orientation.portrait ? 0.7 : 1)
                      : 1.3,
                  child: SvgPicture.asset(
                    // ignore: deprecated_member_use
                    color: MediaQuery.of(context).size.shortestSide > 600
                        ? (widget.selectIndex == widget.index
                            ? MyThemeData.colorWhite
                            : null)
                        : Theme.of(context).colorScheme.secondaryContainer,
                    ImagePaths.getImagePath(
                      context,
                      'back_icon',
                    ),
                  ),
                ),
              );

        return GestureDetector(
          onTap: () {
            hapticController.triggerHapticFeedback(
                vibration: VibrateType.mediumImpact,
                hapticFeedback: HapticFeedback.mediumImpact);
            if (widget.onTap != null) {
              widget.onTap!();
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.shortestSide > 600
                    ? (orientation == Orientation.portrait ? 0.01.w : 0.01.w)
                    : 0.06.w),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.01.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.icon != null)
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: orientation == Orientation.portrait
                                ? 0.0
                                : 0.006.h),
                        child: widget.icon,
                      ),
                    if (widget.icon != null)
                      SizedBox(
                          width: isTablet
                              ? (orientation == Orientation.portrait
                                  ? 0.01.h
                                  : 0.02.h)
                              : 0.015.h),
                    Container(
                      //  color: Colors.red,
                      width: widget.icon != null
                          ? isTablet
                              ? (orientation == Orientation.portrait
                                  ? 0.2.w
                                  : 0.17.w)
                              : 0.55.w
                          : isTablet
                              ? (orientation == Orientation.portrait
                                  ? 0.25.w
                                  : 0.19.w)
                              : 0.65.w,
                      padding: EdgeInsets.only(
                        top: isTablet
                            ? (orientation == Orientation.portrait
                                ? 0.002.h
                                : 0.008.h)
                            : 0,
                        bottom: isTablet
                            ? (orientation == Orientation.portrait
                                ? 0.002.h
                                : 0.008.h)
                            : 0,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Get.locale.toString().contains('en')
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Text(
                          widget.name.tr,
                          maxLines: 1,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                            fontSize: isTablet
                                ? (orientation == Orientation.portrait
                                    ? FontConstants.fontSize014.h
                                    : FontConstants.fontSize026.h)
                                : FontConstants.fontSize020.h,
                            color: isTablet
                                ? (widget.selectIndex != null &&
                                        widget.selectIndex == widget.index
                                    ? MyThemeData.colorWhite
                                    : Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer)
                                : Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                            height: isTablet
                                ? (orientation == Orientation.portrait
                                    ? 2
                                    : 0.0014.h)
                                : 0.0022.h,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    if (widget.showCurrency == true &&
                        MediaQuery.of(context).size.shortestSide < 600)
                      SizedBox(
                        width: 0.05.w,
                      ),
                    Spacer(),
                    if (widget.hideIcon ==
                        false /*&& (isTablet && widget.isSwitchTile ==true)*/)
                      Container(
                        //    color: Colors.amber,
                        width: 0.050.w,
                        height: 0.030.h,
                        child: GestureDetector(
                          onTap: widget.onTap,
                          child: trailingWidget,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
