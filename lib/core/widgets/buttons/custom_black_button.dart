
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:demo_app/core/theme/app_font_size.dart';


class CustomBlackButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final bool isYellow;

  const CustomBlackButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.isYellow = false,
  }) : super(key: key);

  @override
  State<CustomBlackButton> createState() => _CustomBlackButtonState();
}

class _CustomBlackButtonState extends State<CustomBlackButton> {
  @override
  Widget build(BuildContext context) {
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            widget.isYellow == true
                ? AppColors.lightPrimary
                : AppColors.colorBlack),
        foregroundColor:
            MaterialStateProperty.all<Color>(AppColors.colorWhite),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            "assets/icons/plusIcon.svg",
            height: isTablet ? (orientation ? 0.015.h : null) : null,
            color: widget.isYellow == true
                ? AppColors.textButton
                : AppColors.colorWhite,
          ),
          SizedBox(
            width: isTablet ? (orientation ? 0.015.w : 0.02.h) : 0.02.w,
          ),
          Text(
            widget.buttonText,
            maxLines: 1,
            style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: MediaQuery.of(context).size.shortestSide > 600
                    ? (orientation
                        ? FontConstants.fontSize017.h
                        : FontConstants.fontSize022.h)
                    : FontConstants.fontSize017.h,
                color: widget.isYellow == true
                    ? AppColors.textButton
                    : AppColors.colorWhite,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
