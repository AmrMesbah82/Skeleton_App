import 'package:demo_app/features/external/data_grc_module/feature/nav_bar.dart' hide themeController;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/welcome_screen/views/mobile_view/nav_bar.dart';

class CheckRow extends StatelessWidget {
  final bool isChecked;
  final String text;

  CheckRow({required this.isChecked, required this.text});

  @override
  Widget build(BuildContext context) {
     TextStyle customTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
        fontSize: FontConstants.fontSize018.h,
        // ignore: unrelated_type_equality_checks
        color: Theme.of(context).colorScheme.scrim,
        fontWeight: FontWeight.w400,
        height: 1.5);
    return Padding(
      padding:   EdgeInsets.only(top: 0.01.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isChecked
              ? SvgPicture.asset(
                  themeController.currentTheme == MyThemeData.lightTheme
                      ? 'assets/icons/CheckListOn.svg'
                      : 'assets/icons/CheckListOff.svg',
                  color: MyThemeData.lightPrimary,
                  height: 0.025.h,
                )
              : SvgPicture.asset(
                  'assets/icons/checkBoxNotChecked.svg',
                  color: MyThemeData.lightPrimary,
                  height: 0.025.h,
                ),
          SizedBox(width: 0.01.w),
          Expanded(
            child: Text(
              text.tr,
              style: customTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
