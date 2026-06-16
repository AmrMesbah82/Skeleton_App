import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:demo_app/core/theme/app_font_size.dart';
// REMOVED_MODULE: import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

class CustomTableHeaderNew extends StatefulWidget {
  const CustomTableHeaderNew({
    Key? key,
    required this.titles,
    required this.columnsCount,
  }) : super(key: key);

  final List<String> titles;
  final int columnsCount;

  @override
  State<CustomTableHeaderNew> createState() => _CustomTableHeaderNewState();
}

class _CustomTableHeaderNewState extends State<CustomTableHeaderNew> {
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    List<Widget> rowChildren = [];

    for (int i = 0; i < widget.columnsCount; i++) {
      rowChildren.add(
        Container(
          //   color: Colors.red,
          width: isPortrait ? 0.2.w : 0.15.w,
          child: Text(
            widget.titles[i],
            textAlign: TextAlign.center,
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: isPortrait
                  ? FontConstants.fontSize017.h
                  : FontConstants.fontSize015.w,
              fontWeight: FontWeight.w500,
              color: AppColors.colorWhite,
              height: 1.5,
            ),
          ),
        ),
      );
    }
    rowChildren.add(Container());
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              color: themeController.currentTheme == AppColors.lightTheme
                  ? AppColors.colorBlack
                  : Color(0xFF171717)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 0.015.h,
              horizontal: 0.02.w,
            ),
            child: Row(
              children: rowChildren,
            ),
          ),
        ),
      ],
    );
  }
}
