// ignore_for_file: unrelated_type_equality_checks

import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/theme/theme_controller.dart';

// ignore: must_be_immutable
class CustomCheckbox extends StatefulWidget {
  CustomCheckbox(
      {super.key,
      required this.isChecked,
      required this.onCheckboxState,
      this.isBottomSheet = false});
  bool isChecked;
  final ValueChanged<bool> onCheckboxState;
  bool isBottomSheet;

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  final ThemeController themeController = Get.put(ThemeController());
  final HapticController hapticController = Get.put(HapticController());
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return InkWell(
      onTap: () {
        hapticController.triggerHapticFeedback(
            vibration: VibrateType.mediumImpact,
            hapticFeedback: HapticFeedback.mediumImpact);
        setState(() {
          widget.isChecked = !widget.isChecked;
          widget.onCheckboxState(widget.isChecked);
        });
      },
      child: widget.isChecked
          ? SvgPicture.asset(
              themeController.currentTheme == MyThemeData.lightTheme
                  ? 'assets/icons/CheckListOn.svg'
                  : 'assets/icons/CheckListOff.svg',
                  color: MyThemeData.lightPrimary,
              height: isPortrait == true
                  ? widget.isBottomSheet == true
                      ? 0.023.h
                      : 0.025.h
                  : 0.035.h,
            )
          : SvgPicture.asset(
              'assets/icons/checkBoxNotChecked.svg',
              color: MyThemeData.lightPrimary,
              height: isPortrait == true
                  ? widget.isBottomSheet == true
                      ? 0.023.h
                      : 0.025.h
                  : 0.035.h,
            ),
    );
  }
}
