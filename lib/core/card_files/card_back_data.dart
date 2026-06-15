//Date Created :28/August/2023
// Developer Name : Mazen shabaan
//App Version : Version tablet
// Date of Last Edit :5/October/2023 by mazen
// Objectives: this class  created to control the grey back of the card data
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:demo_app/core/card_files/card_back_row.dart';

import 'package:demo_app/core/theme/app_font_size.dart';

class CardBackData extends StatelessWidget {
  const CardBackData({
    super.key,
    this.pointWidth,
    this.isCard = false,
    required this.isHorizontalCard,
    this.bullet1 = '',
    this.bullet2 = '',
    this.bullet3 = '',
  });
  final double? pointWidth;
  final bool isCard;
  final bool isHorizontalCard;
  final String bullet1;
  final String bullet2;
  final String bullet3;

  @override
  Widget build(BuildContext context) {
    double cardHeight = .28.h;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    // ignore: non_constant_identifier_names
    final String Data1 = bullet1 == '' ? 'Add something to share'.tr : bullet1;
    // ignore: non_constant_identifier_names
    final String Data2 = bullet2 == '' ? 'Add something to share'.tr : bullet2;
    // ignore: non_constant_identifier_names
    final String Data3 = bullet3 == '' ? 'Add something to share'.tr : bullet3;
    Widget spacing() {
      return SizedBox(
        height: isHorizontalCard == true
            ? cardHeight * .09
            : isTablet
                ? cardHeight * .04
                : cardHeight * .07,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.026.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isHorizontalCard == true ? 0.02.h : 0.004.h),
              CardBackDataRow(
                cardHeight: cardHeight,
                isCard: isCard,
                pointWidth: pointWidth,
                Data: bullet1 == '' ? Data1 : bullet1,
                isHorizontalCard: isHorizontalCard,
              ),
              spacing(),
              CardBackDataRow(
                cardHeight: cardHeight,
                isCard: isCard,
                pointWidth: pointWidth,
                Data: bullet2 == '' ? Data2 : bullet2,
                isHorizontalCard: isHorizontalCard,
              ),
              spacing(),
              CardBackDataRow(
                cardHeight: cardHeight,
                isCard: isCard,
                pointWidth: pointWidth,
                Data: bullet3 == '' ? Data3 : bullet3,
                isHorizontalCard: isHorizontalCard,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
