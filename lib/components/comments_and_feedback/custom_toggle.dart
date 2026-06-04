import 'package:demo_app/features/external/services_mangment_module/core/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/theme/my_theme.dart';



class CustomToggle extends StatefulWidget {
  final String toggleName;
  final bool isExpanded;
  final VoidCallback onToggleChanged;
  final VoidCallback onExpand;
  final VoidCallback onCollapse;
  final TextEditingController textController;

  const CustomToggle({
    Key? key,
    required this.toggleName,
    required this.isExpanded,
    required this.onToggleChanged,
    required this.onExpand,
    required this.onCollapse,
    required this.textController,
  }) : super(key: key);

  @override
  CustomToggleState createState() => CustomToggleState();
}

class CustomToggleState extends State<CustomToggle> {
  final HapticController hapticController = Get.put(HapticController());

  bool isToggled = false;
  double radius = 8;

  void toggle() {
    setState(() {
      hapticController.triggerHapticFeedback(
          vibration: VibrateType.lightImpact,
          hapticFeedback: HapticFeedback.lightImpact);
      isToggled = !isToggled;
      widget.onToggleChanged();
    });
  }

  void expand() {
    setState(() {
      widget.onExpand();
    });
  }

  void collapse() {
    setState(() {
      widget.onCollapse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isTablet = MediaQuery.of(context).size.shortestSide > 600;
    final bool isArabic = Get.locale.toString().contains('ar');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            InkWell(
              child: GestureDetector(
                onTap: () {
                  toggle();
                  hapticController.triggerHapticFeedback(
                      vibration: VibrateType.mediumImpact,
                      hapticFeedback: HapticFeedback.mediumImpact);
                },
                child: SvgPicture.asset(
                  isToggled
                      ? 'assets/icons/CheckListOn.svg'
                      : 'assets/icons/CheckListOff.svg',
                  color: isToggled ? MyThemeData.signOut : null,
                  height: isTablet
                      ? (orientation == Orientation.portrait ? 0.020.h : 0.03.h)
                      : 0.03.h,
                ),
              ),
            ),
            SizedBox(width: 0.01.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.toggleName,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: isTablet
                        ? (orientation == Orientation.portrait
                        ? FontConstants.fontSize018.h
                        : FontConstants.fontSize022.h)
                        : FontConstants.fontSize022.h,
                    color: isToggled
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : MyThemeData.colorGrey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: .01.h),
        if (isToggled)
          CustomValidatedTextFieldMaster(
            hint: isArabic ? 'اكتب هنا...' : 'Type here...',
            controller: widget.textController,
            maxLines: 3,
            maxLength: 500,
            height: 72,
            showCharCount: true,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            textStyle: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: orientation == Orientation.portrait
                  ? FontConstants.fontSize015.h
                  : FontConstants.fontSize020.h,
            ),
            fillColor: Theme.of(context).colorScheme.onBackground,
          ),
      ],
    );
  }
}