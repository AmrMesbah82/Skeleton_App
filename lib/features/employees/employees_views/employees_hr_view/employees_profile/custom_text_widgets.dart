import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/employees/employees_views/employees_hr_view/employees_profile/employee_profile_screen.dart';
import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart';

class CustomTextWidget extends StatefulWidget {
  final String text;
  final int index;
  final int selectedIndex;

  CustomTextWidget({
    required this.text,
    required this.index,
    required this.selectedIndex,
  });

  @override
  State<CustomTextWidget> createState() => _CustomTextWidgetState();
}

class _CustomTextWidgetState extends State<CustomTextWidget> {
  @override
  Widget build(BuildContext context) {
    final HapticController hapticController = Get.put(HapticController());
    return GestureDetector(
      onTap: () {
        hapticController.triggerHapticFeedback(
            vibration: VibrateType.lightImpact,
            hapticFeedback: HapticFeedback.lightImpact);
        final employeeProfileState? state =
            context.findAncestorStateOfType<employeeProfileState>();
        if (state != null) {
          state.setSelectedContainerIndexEmployee(widget.index);
        }
        state?.setSelectedContainerIndexEmployee(widget.index);
      },
      child: Container(
        height: 0.05.h,
        color: widget.index == widget.selectedIndex
            ? MyThemeData.signOut
            : Theme.of(context).colorScheme.inversePrimary,
        child: Center(
          child: Text(
            widget.text.tr,
            style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: widget.index == widget.selectedIndex
                    ? FontConstants.fontSize022.h
                    : FontConstants.fontSize020.h,
                color: themeController.currentTheme == MyThemeData.lightTheme
                    ? MyThemeData.colorBlack
                    : widget.index == widget.selectedIndex
                        ? MyThemeData.colorBlack
                        : MyThemeData.colorWhiteDark,
                fontWeight: widget.index == widget.selectedIndex
                    ? FontWeight.w600
                    : FontWeight.w500,
                height: 0.0018.h),
          ),
        ),
      ),
    );
  }
}
