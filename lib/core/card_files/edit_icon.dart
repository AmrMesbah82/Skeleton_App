//Date Created :21/September/2023
// Developer Name : Mazen shabaan
//App Version : Version tablet
// Date of Last Edit :2/October/2023 by mazen
// Objectives: this class  created to customize the edit icon in card widget
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

// ignore: must_be_immutable
class EditIcon extends StatefulWidget {
  EditIcon({
    super.key,
    required this.isHorizontalCard,
    required this.cardHeight,
    required this.onTap,
  });
  bool isHorizontalCard;
  double cardHeight;
  Function()? onTap;
  @override
  State<EditIcon> createState() => _EditIconState();
}

class _EditIconState extends State<EditIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: EdgeInsets.only(
          top: 0.017.h, // 0.02.h
          left: Get.locale.toString().contains('en')
              ? widget.isHorizontalCard == true
                  ? 0.07.w
                  : 0.0.w
              : 0,
          right: Get.locale.toString().contains('en')
              ? 0
              : widget.isHorizontalCard == true
                  ? 0.07.w
                  : 0.0.w,
        ), //0.08.w
        child: SizedBox(
          width: widget.isHorizontalCard == true
              ? widget.cardHeight * .16
              : widget.cardHeight * .1, // .14
          height: widget.isHorizontalCard == true
              ? widget.cardHeight * .16
              : widget.cardHeight * .1, //.14
          child: SvgPicture.asset(
            'assets/icons/card_edit_icon.svg',
          ),
        ),
      ),
    );
  }
}
