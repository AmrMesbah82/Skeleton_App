import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
// REMOVED_MODULE: import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

// ignore: must_be_immutable
class ChartHeader extends StatefulWidget {
  final String chartText;
  String? dropDownValue;
  ValueChanged<String?>? dropDropeState;
  ChartHeader({
    Key? key,
    required this.chartText,
    this.dropDownValue,
    this.dropDropeState,
  }) : super(key: key);

  @override
  State<ChartHeader> createState() => _ChartHeaderState();
}

class _ChartHeaderState extends State<ChartHeader> {
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Padding(
      padding: EdgeInsets.only(top: 0.03.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.chartText.tr,
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: isPortrait
                  ? FontConstants.fontSize023.h
                  : FontConstants.fontSize026.h,
              // ignore: unrelated_type_equality_checks
              color: themeController.currentTheme == MyThemeData.lightTheme
                  ? MyThemeData.colorBlack
                  : MyThemeData.colorWhiteDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
