import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
// REMOVED_MODULE: import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

import '../../../utils/system_logs_constants.dart';

class SystemLogsTableHeader extends StatefulWidget {
  const SystemLogsTableHeader();

  @override
  State<SystemLogsTableHeader> createState() => _SystemLogsTableHeaderState();
}

class _SystemLogsTableHeaderState extends State<SystemLogsTableHeader> {
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    List<Widget> rowChildren = [];

    rowChildren.add(Container());
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            color: themeController.currentTheme == MyThemeData.lightTheme
                ? MyThemeData.colorBlack
                : Color(0xFF171717),
          ),
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: 0.015.h, horizontal: 0.02.w),
            child: Row(children: [
              for (int i = 0;
                  i < SystemLogsConstants.systemLogsItems.length;
                  i++)
                Container(
                  width: isPortrait ? 0.2.w : 0.17.w,
                  child: Text(
                    SystemLogsConstants.systemLogsItems[i].name.tr,
                    textAlign: TextAlign.center,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isPortrait
                          ? FontConstants.fontSize015.h
                          : FontConstants.fontSize013.w,
                      fontWeight: FontWeight.w500,
                      color: MyThemeData.colorWhite,
                      height: 1.5,
                    ),
                  ),
                )
            ]),
          ),
        ),
      ],
    );
  }
}
