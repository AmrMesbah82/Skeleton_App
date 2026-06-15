import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
// REMOVED_MODULE: import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

class InfoWithBulletList extends StatefulWidget {
  final List<String>? skillsTexts;

  const InfoWithBulletList({Key? key, this.skillsTexts}) : super(key: key);

  @override
  State<InfoWithBulletList> createState() => _InfoWithBulletListState();
}

class _InfoWithBulletListState extends State<InfoWithBulletList> {
  @override
  Widget build(BuildContext context) {
    final bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return isVertical ? _buildVerticalList() : _buildHorizontalList();
  }

  Widget _buildVerticalList() {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        ((widget.skillsTexts!.length + 1) / 2).ceil(),
        (rowIndex) {
           final start = rowIndex * 2;
        final end = (rowIndex + 1) * 2;
          return Padding(
            padding: EdgeInsets.only(bottom: 0.01.h),
            child: Row(
              children: widget.skillsTexts!
                .sublist(start, end.clamp(0, widget.skillsTexts!.length)) 
                .map((text) {
                return Expanded(
                  child: Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\u25CF',
                        style: AppFontStyle.cairoRegularStyle.copyWith(
                          fontSize: FontConstants.fontSize015.h,
                          color: themeController.currentTheme ==
                                  MyThemeData.lightTheme
                              ? MyThemeData.colorDarkGrey
                              : MyThemeData.colorGreydark,
                          fontWeight: FontWeight.w400,
                           height:  1.6
                        ),
                      ),
                      SizedBox(width: 0.01.w),
                      Flexible(
                        child: Text(
                            Get.locale.toString().contains('en')
                            ? text.tr.capitalize ?? ''
                            : convertNumberToArabic(text.tr.capitalize ?? ''),
                          maxLines: 14,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: FontConstants.fontSize015.h,
                            color: themeController.currentTheme ==
                                    MyThemeData.lightTheme
                                ? MyThemeData.colorBlack
                                : MyThemeData.colorWhiteDark,
                            fontWeight: FontWeight.w400,
                            height:  1.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalList() {
    return ListView.builder(
padding: EdgeInsets.zero,
      itemCount: ((widget.skillsTexts!.length + 2) / 3).floor(),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final start = index * 3;
        final end = (index + 1) * 3;
        return Padding(
          padding: EdgeInsets.only(bottom: 0.01.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.skillsTexts!
                .sublist(start, end.clamp(0, widget.skillsTexts!.length))
                .map((text) {
              return Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '\u25CF',
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: FontConstants.fontSize020.h,
                        color: themeController.currentTheme ==
                                MyThemeData.lightTheme
                            ? MyThemeData.colorDarkGrey
                            : MyThemeData.colorGreydark,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 0.01.w),
                    Flexible(
                      child: Text(
                        Get.locale.toString().contains('en')
                            ? text.tr.capitalize ?? ''
                            : convertNumberToArabic(text.tr.capitalize ?? ''),
                        maxLines: 14,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: FontConstants.fontSize020.h,
                          color: themeController.currentTheme ==
                                  MyThemeData.lightTheme
                              ? MyThemeData.colorBlack
                              : MyThemeData.colorWhiteDark,
                          fontWeight: FontWeight.w400,
                          height: 1.8,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
