import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import '../utilties/images.dart';
import 'svg_custom.dart';

Widget buildCustomIconButton(
    {required VoidCallback function, double? size, required bool isPlus}) {
  return IconButton(
    style: ButtonStyle(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
    ),
    onPressed: function,
    icon: SizedBox(
      child: CustomSvg(
        assetPath: isPlus ? Images.miniPlusIcon : "assets/vectors/minus.svg",
        width:  10.w,
        fit: BoxFit.scaleDown,
        color: AppColors.text,
        height:  10.h,
      ),
    ),
  );
}
