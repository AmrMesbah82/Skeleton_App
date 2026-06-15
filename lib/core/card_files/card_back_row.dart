//Date Created :28/August/2023
// Developer Name : Mazen shabaan
//App Version : Version tablet
// Date of Last Edit :3/October/2023 by mazen
// Objectives: this class  created to customize the row of each data in the grey back in the card
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/core/theme/app_colors.dart';

import '../theme/app_colors.dart';

// ignore: must_be_immutable
class CardBackDataRow extends StatelessWidget {
  CardBackDataRow(
      {super.key,
      required this.cardHeight,
      required this.isCard,
      required this.pointWidth,
      // ignore: non_constant_identifier_names
      required this.Data,
      required this.isHorizontalCard});
  final double cardHeight;
  bool isCard;
  final double? pointWidth;
  // ignore: non_constant_identifier_names
  final String Data;
  bool isHorizontalCard;

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Row(
      children: [
        SizedBox(
          width: isHorizontalCard == true ? cardHeight * .15 : cardHeight * .1,
          height: isHorizontalCard == true ? cardHeight * .15 : cardHeight * .1,
          child: SvgPicture.asset(
            'assets/icons/card_back_icon.svg',
          ),
        ),
        SizedBox(
          width: isCard == true ? 0.015.w : 0.03.w,
        ),
        SizedBox(
          width: pointWidth ?? .4.w,
          child: FittedBox(
            alignment: Get.locale.toString().contains('ar')
                ? Alignment.centerRight
                : Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              Data,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Data == 'Add something to share'.tr
                      ? Theme.of(context).colorScheme.onSecondary
                      : AppColors.text,
                  height: isTablet
                      ? isCard
                          ? 0.001.h
                          : 0.0015.h
                      : 0.002.h,
                  fontSize: FontConstants.fontSize020.h),
            ),
          ),
        ),
      ],
    );
  }
}
