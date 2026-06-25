import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:demo_app/core/theme/app_colors.dart';


Widget customButton({
  required BuildContext context,
  required String title,
  required VoidCallback function,
  double? width,
  double? height,
  double radius = 8,
  Color? color,
  Color? textColor,
  Color? borderColor,
  TextStyle? textStyle,
}) {
  final isDark = context.isDarkMode;

  return GestureDetector(
    onTap: function,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? AppColors.primary,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? Colors.transparent),
      ),
      child: Center(
        child: Text(
          title,
          style:
              textStyle ??
              TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor ?? (isDark ? Colors.white : Colors.black),
              ),
        ),
      ),
    ),
  );
}

Widget customButtonWithIcon({
  required String title,
  required VoidCallback function,
  required TextStyle textStyle,
  required double width,
  required double height,
  required double space,
  required double radius,
  required Color color,
  required IconData icon,
  required Color iconColor,
  required double iconSize,
}) {
  return GestureDetector(
    onTap: function,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: iconColor),
          SizedBox(width: space),
          Text(title, style: textStyle),
        ],
      ),
    ),
  );
}

Widget customButtonWithImage({
  required String title,
  required VoidCallback function,
  required TextStyle textStyle,
  double? width,
  required double height,
  required double space,
  required double radius,
  required Color color,
  required String image,
  required double widthImage,
  required double heightImage,
  required Color colorBorder,
  Color? svgColor,
  EdgeInsets? padding, // ✅ Optional padding for Row
}) {
  return GestureDetector(
    onTap: function,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: colorBorder),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: title.trim().isEmpty
          ? Center(
              // ✅ Center SVG if no title
              child: SvgPicture.asset(
                image,
                color: svgColor,
                height: heightImage,
                width: widthImage,
                fit: BoxFit.scaleDown,
              ),
            )
          : Padding(
              padding:
                  padding ?? EdgeInsets.zero, // ✅ Use custom padding or none
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    image,
                    height: heightImage,
                    width: widthImage,
                    color: svgColor,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: space),
                  Text(title, style: textStyle),
                ],
              ),
            ),
    ),
  );
}

// import 'package:flutter/material.dart';
// import 'package:knowticed_app/core/theming/text_styles.dart';

// Widget textButtonWithoutIcon({
//   required String text,
//   required VoidCallback onPressed,
//   Color textColor = AppColors.mainBlack,
//   Color backgroundColor = AppColors.mainColor,
//   required double fontSize,
//   FontWeight fontWeight = FontWeight.w500,
//   double? horizontalPadding,
//   double? verticalPadding,
//   double? borderRadius,
//   double? buttonWidth,
//   double? buttonHeight,
// }) {
//   return TextButton(
//     onPressed: onPressed,
//     style: ButtonStyle(
//       shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//         RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(borderRadius ?? 8),
//         ),
//       ),
//       backgroundColor: WidgetStatePropertyAll(backgroundColor),
//       padding: WidgetStateProperty.all<EdgeInsets>(
//         EdgeInsets.symmetric(
//           horizontal: horizontalPadding ?? 12,
//           vertical: verticalPadding ?? 6,
//         ),
//       ),
//       // fixedSize: WidgetStateProperty.all(
//       //   Size(buttonWidth?.w ?? 100.w, buttonHeight?.h ?? 40.h),
//       // ),
//     ),
//     child: Center(
//       child: Text(
//         text,
//         style: TextStyle(
//           color: textColor,
//           fontSize: fontSize,
//           fontWeight: fontWeight,
//         ),
//       ),
//     ),
//   );
// }

// Widget customedTextButton({
//   required String text,
//   required VoidCallback onPressed,
//   Color textColor = AppColors.mainBlack,
//   Color backgroundColor = AppColors.mainColor,
//   required double fontSize,
//   FontWeight fontWeight = FontWeight.w500,
//   double? horizontalPadding,
//   double? verticalPadding,
//   double? borderRadius,
//   double? buttonWidth,
//   double? buttonHeight,
// }) {
//   return TextButton(
//     onPressed: onPressed,
//     style: ButtonStyle(
//       shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//         RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(borderRadius ?? 8),
//         ),
//       ),
//       backgroundColor: WidgetStatePropertyAll(backgroundColor),
//       padding: WidgetStateProperty.all<EdgeInsets>(
//         EdgeInsets.symmetric(
//           horizontal: horizontalPadding ?? 12,
//           vertical: verticalPadding ?? 6,
//         ),
//       ),
//       // fixedSize: WidgetStateProperty.all(
//       //   Size(buttonWidth?.w ?? 100.w, buttonHeight?.h ?? 40.h),
//       // ),
//     ),
//     child: Center(
//       child: Text(
//         text,
//         style: TextStyles.font14BlackCairoSemiBold.copyWith(
//           color: textColor,
//           fontSize: fontSize,
//           fontWeight: fontWeight,
//         ),
//       ),
//     ),
//   );
// }
