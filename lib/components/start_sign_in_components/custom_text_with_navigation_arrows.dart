import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class TextWithNavigationArrows extends StatelessWidget {
  final List<String> texts;
  final int currentIndex;
  final Function(int) onNextPressed;
  final Function(int) onPreviousPressed;

  const TextWithNavigationArrows({
    Key? key,
    required this.texts,
    required this.currentIndex,
    required this.onNextPressed,
    required this.onPreviousPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize: FontConstants.fontSize018.h,
      color: Theme.of(context).colorScheme.secondaryContainer,
      fontWeight: FontWeight.w500,
    );
    return Column(
      children: [
        Text.rich(
          TextSpan(
            text: 'Step '.tr,
            style: titleStyle.copyWith(color: MyThemeData.textGrey),
            children: [
              TextSpan(
                text: '${currentIndex + 1}',
                style: titleStyle.copyWith(color: MyThemeData.lightPrimary),
              ),
              TextSpan(
                text: ' ${"of".tr} ${texts.length}',
                style: titleStyle.copyWith(color: MyThemeData.textGrey),
              ),
            ],
          ),
        ),
        Padding(
          padding:   EdgeInsets.symmetric(horizontal: 0.1.w),
          child: Row(
            children: [
              Container(
                height: 0.08.w,
                width: 0.08.w,
                decoration: BoxDecoration(
                  color: currentIndex == 0 ? MyThemeData.colorGreydark :  MyThemeData.signOut,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: IconButton(
                  icon: Transform.rotate(
                    angle: Get.locale.toString().contains('en')?0:3.14,
                    child: SvgPicture.asset(
                      'assets/icons/backArrowSign.svg',
                       color: currentIndex  == 0 ? MyThemeData.colorBlack :  MyThemeData().contrastColor(),
                    ),
                  ),
                  onPressed: currentIndex == 0
                      ? null
                      : () => onPreviousPressed(currentIndex - 1),
                ),
              ),
              Expanded(
                child: Text(
                  texts[currentIndex].tr,
                  textAlign: TextAlign.center,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: FontConstants.fontSize023.h,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      fontWeight: FontWeight.w500,
                      height: 1.5),
                ),
              ),
              Container(
                height: 0.08.w,
                width: 0.08.w,
                decoration: BoxDecoration(
                  color: currentIndex == texts.length - 1 ? MyThemeData.colorGreydark :  MyThemeData.signOut,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: IconButton(
                  icon: Transform.rotate(
                     angle: Get.locale.toString().contains('en')?0:3.14,
                    child: SvgPicture.asset(
                      'assets/icons/arrowNextSign.svg',
                      color: currentIndex == texts.length - 1 ? MyThemeData.colorBlack :  MyThemeData().contrastColor(),
                      
                    ),
                  ),
                  onPressed: currentIndex == texts.length - 1
                    ? null
                    : () => onNextPressed(currentIndex + 1),
                ),
              ),
              
            ],
          ),
        ),
      ],
    );
  }
}
