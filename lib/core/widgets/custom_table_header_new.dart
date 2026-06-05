import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

import 'package:demo_app/core/theme/font_manager.dart';

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
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    TextStyle tableTitleTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize:
          isTablet ? FontConstants.fontSize015.w : FontConstants.fontSize030.w,
      fontWeight: FontWeight.w500,
      color: MyThemeData.colorWhite,
      height: 1.6,
    );
    List<Widget> rowChildren = [];

    for (int i = 0; i < widget.columnsCount; i++) {
      rowChildren.add(
        SizedBox(
          //   color: Colors.red,
          width: isPortrait ? 0.2.w : 0.15.w,
          child: Text(
            widget.titles[i].tr,
            textAlign: TextAlign.center,
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: isPortrait
                  ? FontConstants.fontSize017.h
                  : FontConstants.fontSize015.w,
              fontWeight: FontWeight.w500,
              color: MyThemeData.colorWhite,
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
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
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
