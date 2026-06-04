import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:demo_app/core/theme/font_manager.dart';

import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/theme/theme_controller.dart';

class TitleWithSeeMore extends StatefulWidget {
  final String mainTitle;
  final VoidCallback onPressed;
  final String? imagePath;
  final bool? hideSeeMore;
  final String? stackPhoto;
  final String? upPhoto;

  const TitleWithSeeMore({
    Key? key,
    required this.mainTitle,
    required this.onPressed,
    this.imagePath,
    this.hideSeeMore = false,
    this.stackPhoto,
    this.upPhoto,
  }) : super(key: key);

  @override
  State<TitleWithSeeMore> createState() => _TitleWithSeeMoreState();
}

class _TitleWithSeeMoreState extends State<TitleWithSeeMore> {
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Row(
      children: [
        Text(
          widget.mainTitle.tr,
          style: AppFontStyle.cairoRegularStyle.copyWith(
            fontSize: isTablet
                ? (orientation
                    ? FontConstants.fontSize020.h
                    : FontConstants.fontSize030.h)
                : FontConstants.fontSize022.h,
            color: themeController.currentTheme == MyThemeData.lightTheme
                ? MyThemeData.colorBlack
                : MyThemeData.colorWhiteDark,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
        if (widget.hideSeeMore == false) Spacer(),
        if (widget.hideSeeMore == false)
          InkWell(
            onTap: widget.onPressed,
            child: widget.imagePath != null
                ? Stack(
                  children: <Widget>[
                    SvgPicture.asset(
                      widget.stackPhoto!,
                      height:orientation? 0.035.h : 0.04.h,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Transform.scale(
                          scale: 1,
                          child: CircleAvatar(
                              backgroundColor: MyThemeData.signOut,
                              radius: 0.01.h,
                              child: SvgPicture.asset(
                                widget.upPhoto!,
                                color: MyThemeData().contrastColor(),
                                height: 0.012.h,
                              )),
                        ),
                      ),
                    ),
                  ],
                )
                : Text(
                    "See More".tr,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: FontConstants.fontSize018.h,
                      fontWeight: Get.locale.toString().contains('en')
                          ? FontWeight.w600
                          : FontWeight.w500,
                      decoration: TextDecoration.underline,
                      height: 0.002.h,
                      color: MyThemeData.blue,
                    ),
                  ),
          ),
      ],
    );
  }
}
