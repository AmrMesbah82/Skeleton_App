import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/theme/theme_controller.dart';

// ignore: must_be_immutable
class ButtonColumn extends StatefulWidget {
  ButtonColumn(
      {super.key,
      required this.isChecked,
      required this.buttonText,
      required this.textUndrline,
      required this.onPressed});
  bool isChecked;
  String buttonText;
  String textUndrline;
  Function() onPressed;

  @override
  State<ButtonColumn> createState() => _ButtonColumnState();
}

class _ButtonColumnState extends State<ButtonColumn> {
  final ThemeController themeController = Get.put(ThemeController());
  final HapticController hapticController = Get.put(HapticController());
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 0.14.w : 0.01.w),
          child: MainCustomIconButton(
            onPressed: widget.onPressed,
            buttonText: widget.buttonText.tr, //'Accept',
            buttonStyle: ElevatedButton.styleFrom(
              minimumSize:
                  isTablet ? Size(0.7.w, 0.055.h) : Size(1.0.w, 0.055.h),
              backgroundColor: widget.isChecked == true
                  ? MyThemeData.signOut
                  : MyThemeData.colorGreydark,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              )),
            ),
         
          ),
        ),
        SizedBox(
          height: 0.006.h,
        ),
        TextButton(
          onPressed: () {
            hapticController.triggerHapticFeedback(
                vibration: VibrateType.mediumImpact,
                hapticFeedback: HapticFeedback.mediumImpact);
            Navigator.pop(context);
          },
          child: Text(
            widget.textUndrline.tr, //'Reject'.tr,
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: isTablet
                  ? FontConstants.fontSize020.h
                  : FontConstants.fontSize018.h,
              // ignore: unrelated_type_equality_checks
              color: themeController.currentTheme == MyThemeData.lightTheme
                  ? MyThemeData.textdeactivecolor
                  : MyThemeData.colorGreydark,
              fontWeight: FontWeight.w600,
              decoration: widget.textUndrline == 'Cancel'
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}
