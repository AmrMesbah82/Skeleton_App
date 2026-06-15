import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/features/todo_module/core/constants/screen_size.dart';
import 'package:demo_app/core/theme/my_theme.dart';

class MainYellowButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool isSign;
  final bool isChat;
  final Color? buttonColor;
  final Color? textColor;
  final bool isReviewPage;

  const MainYellowButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.isSign = false,
    this.isChat = false,
    this.isReviewPage = false,
    this.buttonColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SizedBox(
      height: isSign == true
          ? 0.06.h
          : isReviewPage == true
              ? 0.04.h
              : 0.05.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor ?? MyThemeData.bubbleColor,
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
                    : isReviewPage == true
                        ? (isVertical
                            ? FontConstants.fontSize024.w
                            : FontConstants.fontSize021.h)
                        : isVertical
                            ? FontConstants.fontSize019.h
                            : FontConstants.fontSize021.h,
                color: textColor ?? MyThemeData.colorBlack,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
