import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

// ignore: must_be_immutable
class FaceBackGround extends StatefulWidget {
  FaceBackGround(
      {super.key,
      // ignore: non_constant_identifier_names
      required this.ImageAddress,
      required this.cardHeight,
      required this.isHorizontalCard});
  bool isHorizontalCard;
  double cardHeight;
  // ignore: non_constant_identifier_names
  String ImageAddress;

  @override
  State<FaceBackGround> createState() => _FaceBackGroundState();
}

class _FaceBackGroundState extends State<FaceBackGround> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.isHorizontalCard == true
          ? widget.cardHeight * 1.35
          : widget.cardHeight,
      width: widget.isHorizontalCard == true ? 0.4.w : double.infinity,
      child: SvgPicture.asset(
        widget.ImageAddress, //'assets/images/card.svg',
        fit: BoxFit.fill,
      ),
    );
  }
}
