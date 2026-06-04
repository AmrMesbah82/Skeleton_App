import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/welcome_screen/views/mobile_view/nav_bar.dart';

class ReusableElevatedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool isSign;
  final bool isChat;

  const ReusableElevatedButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.isSign = false,
    this.isChat = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
        
    return Container(
      height: isSign == true ? 0.06.h : 0.05.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: MyThemeData.bubbleColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isChat == true
                ? SvgPicture.asset(
                    "assets/icons/messageScreen.svg",
                    height: 0.03.h,
                  )
                : SizedBox.shrink(),
            isChat == true
                ? SizedBox(
                    width: 0.02.w,
                  )
                : SizedBox.shrink(),
            Text(
              buttonText.tr,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: isSign == true
                    ? FontConstants.fontSize024.h
                    : !isVertical ? FontConstants.fontSize025.h : FontConstants.fontSize019.h,
                color: MyThemeData().contrastColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
