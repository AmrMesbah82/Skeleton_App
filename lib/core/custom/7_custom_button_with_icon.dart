import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';

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

/*
// ── Usage ─────────────────────────────────────────────────────────────────────
customButtonWithIcon(
  title: 'Add',
  function: () {},
  textStyle: TextStyle(fontSize: 14, color: Colors.white),
  width: 160,
  height: 48,
  space: 8,
  radius: 8,
  color: AppColors.primary,
  icon: Icons.add,
  iconColor: Colors.white,
  iconSize: 20,
)
*/
