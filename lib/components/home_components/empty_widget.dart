import 'package:demo_app/core/theme/grc_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/welcome_screen/views/mobile_view/nav_bar.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatefulWidget {
  final String assetPath;
  final double scale;
  const EmptyWidget({Key? key, required this.assetPath, required this.scale}) : super(key: key);

  @override
  State<EmptyWidget> createState() => _EmptyWidgetState();
}

class _EmptyWidgetState extends State<EmptyWidget> {
  @override
  Widget build(BuildContext context) {
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Padding(
      padding: EdgeInsets.only(top: 0.02.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
            color: themeController.currentTheme == MyThemeData.lightTheme
                ? MyThemeData.colorWhite
                : Theme.of(context).colorScheme.inversePrimary,
          height: !isVertical ? 0.3.h :0.2.h,
          width: double.infinity,
          child: Transform.scale(
            scale: widget.scale,
            child: Lottie.asset(
              widget.assetPath,
            ),
          ),
        ),
      ),
    );
  }
}
