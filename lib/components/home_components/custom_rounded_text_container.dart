import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
// REMOVED_MODULE: import 'package:demo_app/feature/welcome_screen/views/mobile_view/nav_bar.dart';

class RoundedTextContainer extends StatelessWidget {
  final String text;

  const RoundedTextContainer({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.01.h, horizontal: 0.025.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      width: double.infinity,
      child: Container(
        child: Text(
          text,
          style: AppFontStyle.cairoRegularStyle.copyWith(
            fontSize: FontConstants.fontSize016.h,
            // ignore: unrelated_type_equality_checks
            color: themeController.currentTheme == MyThemeData.lightTheme
                ? MyThemeData.colorDarkGrey
                : MyThemeData.colorGreydark,
            fontWeight: FontWeight.w400,
            height: 0.0016.h,
          ),
        ),
      ),
    );
  }
}
