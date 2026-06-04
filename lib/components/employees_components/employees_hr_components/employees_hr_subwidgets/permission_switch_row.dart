import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';

// ignore: must_be_immutable
class PermissionSwitchRow extends StatefulWidget {
  PermissionSwitchRow(
      {super.key,
      required this.title,
      required this.isOpen,
      required this.isOpenState,
      required this.containerColor,
      });
  final String title;
  bool isOpen;
  ValueChanged<bool> isOpenState;
  final Color containerColor;

  @override
  State<PermissionSwitchRow> createState() => _PermissionSwitchRowState();
}

class _PermissionSwitchRowState extends State<PermissionSwitchRow> {
  final HapticController hapticController = Get.put(HapticController());
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.containerColor,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.015.w, vertical: 0.004.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: FontConstants.fontSize014.w,
                height: 0.002.h,
                color: Theme.of(context).colorScheme.scrim,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                setState(() {
                  setState(() {
                    widget.isOpen = !widget.isOpen;
                    widget.isOpenState(widget.isOpen);
                  });
                });
              },
              child: SvgPicture.asset(
                widget.isOpen
                    ? 'assets/icons/SwitchOn.svg'
                    // ignore: unrelated_type_equality_checks
                    : themeController.currentTheme == MyThemeData.lightTheme
                        ? 'assets/icons/SwitchOff.svg'
                        : 'assets/icons/SwitchDark.svg',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
