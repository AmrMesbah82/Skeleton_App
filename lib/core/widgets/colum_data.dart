// Date Created :14/November/2023
// Developer Name : Mazen shabaan
//App Version : Version 2
// Date of Last Edit :14/November/2023
// Objectives: this is a widget to customize column of the data in track time
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ColumnData extends StatefulWidget {
  ColumnData({
    super.key,
    required this.title,
    required this.data,
  });
  String title;
  String data;

  @override
  State<ColumnData> createState() => _ColumnDataState();
}

class _ColumnDataState extends State<ColumnData> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Padding(
      padding: EdgeInsets.only(
          right: Get.locale.toString().contains('en') ? 0.02.w : 0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.space,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title.tr,
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: isTablet
                  ? isPortrait
                  ? FontConstants.fontSize021.h
                  : FontConstants.fontSize024.h
                  : FontConstants.fontSize016.h,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.scrim,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.01.h),
            child: Text(
              widget.data.tr,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: isTablet
                    ? isPortrait
                    ? FontConstants.fontSize020.h
                    : FontConstants.fontSize024.h
                    : FontConstants.fontSize016.h,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          )
        ],
      ),
    );
  }
}
