import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo_app/core/theme/app_colors.dart';

class IconItem extends StatelessWidget {
  const IconItem({super.key, required this.icon, required this.color});
  final String icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(9.5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SvgPicture.asset(
        icon,
        height: 18.h,
        width: 18.w,
        color: AppColors.black,
      ),
    );
  }
}
