import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';

/// Date Created :13/November/2023
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit :20/November/2023 By Bassem
/// Objectives: this widget is for showing the project status whether its pending , in progress, or done

class CustomProjectStatusContainer extends StatefulWidget {
  final String text;
  final int number;

  CustomProjectStatusContainer({
    required this.text,
    required this.number,
  });

  @override
  State<CustomProjectStatusContainer> createState() =>
      _CustomProjectStatusContainerState();
}

class _CustomProjectStatusContainerState
    extends State<CustomProjectStatusContainer> {
  String getPhotoAsset() {
    // Conditions to determine the appropriate photo based on the text
    if (widget.text.toLowerCase() == 'pending projects') {
      return 'assets/images/PendingProjects.svg';
    } else if (widget.text.toLowerCase() == 'projects in progress') {
      return 'assets/images/InProgressProjects.svg';
    } else if (widget.text.toLowerCase() == 'projects done') {
      return 'assets/images/DoneProjects.svg';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 0.38.h,
      //height: 75,
      padding: EdgeInsets.all(0.012.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            getPhotoAsset(),
          ),
          SizedBox(width: 0.02.h),
          Text(
            widget.text.tr,
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: FontConstants.fontSize020.h,
              color: Theme.of(context).colorScheme.tertiaryContainer,
              fontWeight: FontWeight.w600,
              //height: 0.0015.h
            ),
          ),
          Spacer(),
          Text(
            Get.locale.toString().contains('en')
                ? widget.number.toString()
                : convertNumberToArabic(widget.number.toString()),
            style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: FontConstants.fontSize026.h,
                color: themeController.currentTheme == MyThemeData.lightTheme
                    ? MyThemeData.colorBlack
                    : MyThemeData.colorWhiteDark,
                fontWeight: FontWeight.w700,
                height: 0.0025.h),
          ),
          SizedBox(width: 0.02.h),
        ],
      ),
    );
  }
}
