/// Purpose: A widget that displays the settings svg icon in main setting page .
/// Author : Mohamed Elrashidy
/// Created At: 11/11/2024
import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo_app/core/theme/app_theme.dart';

class SettingsSvgIcon extends StatelessWidget {
  SettingsSvgIcon({required this.path,super.key});
  String path;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
        width: 16.w,
        height: 16.h,
        fit: BoxFit.scaleDown,
        path,
        color: AppColors.textButton
    );
  }
}
