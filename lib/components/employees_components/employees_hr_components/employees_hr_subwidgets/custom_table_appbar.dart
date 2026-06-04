import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class CustomTableAppBar extends StatelessWidget {
  const CustomTableAppBar(
      {super.key,
      required this.titles,
      required this.columnsCount,
      this.offset,
      this.isEmployee,
      this.isrequested = false,
      this.padd});
  final List<String> titles;
  final int columnsCount;
  final Offset? offset;
  final double? padd;
  final bool isrequested;
  final bool? isEmployee;

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    List<Widget> rowChildren = [];
    for (int i = 0; i < columnsCount; i++) {
      if (i == 1) {
        if (padd != null) {
          rowChildren.add(Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.02.w),
            child: Text(
              titles[i],
              style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: isPortrait
                    ? FontConstants.fontSize017.h
                    : FontConstants.fontSize016.w,
                fontWeight: FontWeight.w500,
                color: MyThemeData.colorWhite,
              ),
            ),
          ));
          continue;
        }
        rowChildren.add(Transform.translate(
          offset: offset ?? const Offset(50, 0),
          child: Text(
            titles[i],
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: isTablet
                  ? isPortrait
                      ? FontConstants.fontSize017.h
                      : FontConstants.fontSize015.w
                  : FontConstants.fontSize030.w,
              fontWeight: FontWeight.w500,
              color: MyThemeData.colorWhite,
            ),
          ),
        ));
        continue;
      }
      if (padd != null) {
        if (i != 0) {
          if (i == 5) {
            rowChildren.add(Padding(
              padding: EdgeInsets.only(left: 0.085.w),
              child: Text(
                titles[i],
                style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: isPortrait
                      ? FontConstants.fontSize017.h
                      : FontConstants.fontSize015.w,
                  fontWeight: FontWeight.w500,
                  color: MyThemeData.colorWhite,
                ),
              ),
            ));
            continue;
          }
          rowChildren.add(Padding(
            padding: EdgeInsets.only(left: 0.065.w),
            child: Text(
              titles[i],
              style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: isPortrait
                    ? FontConstants.fontSize017.h
                    : FontConstants.fontSize015.w,
                fontWeight: FontWeight.w500,
                color: MyThemeData.colorWhite,
              ),
            ),
          ));
          continue;
        }
      }
      rowChildren.add(Text(
        titles[i],
        style: AppFontStyle.cairoRegularStyle.copyWith(
          fontSize: padd != null
              ? isPortrait
                  ? FontConstants.fontSize017.h
                  : FontConstants.fontSize016.w
              : isTablet
                  ? isPortrait
                      ? FontConstants.fontSize017.h
                      : FontConstants.fontSize015.w
                  : FontConstants.fontSize030.w,
          fontWeight: FontWeight.w500,
          color: MyThemeData.colorWhite,
        ),
      ));
    }
    rowChildren.add(Container());
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          color: Theme.of(context).colorScheme.onTertiaryContainer),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: isEmployee == true ? 0.01.w : padd ?? 0.02.w,
            vertical: 0.02.h),
        child: Row(
            mainAxisAlignment: padd != null
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
            children: rowChildren),
      ),
    );
  }
}
