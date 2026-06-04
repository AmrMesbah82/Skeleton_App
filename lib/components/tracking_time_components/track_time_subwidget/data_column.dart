import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/screen_size.dart';

// ignore: must_be_immutable
class ColumnData extends StatefulWidget {
  ColumnData({super.key, required this.title, required this.data});
  String title;
  String data;
  @override
  State<ColumnData> createState() => _ColumnDataState();
}

class _ColumnDataState extends State<ColumnData> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Padding(
      padding: EdgeInsets.only(
          right: Get.locale.toString().contains('en') ? 0.02.w : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title.tr,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: isTablet
                    ? isPortrait ? FontConstants.fontSize021.h : FontConstants.fontSize024.h
                    : FontConstants.fontSize016.h,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.scrim,
              )),
          Padding(
            padding: EdgeInsets.only(top: 0.01.h),
            child: Text(widget.data.tr,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: isTablet
                      ? isPortrait ? FontConstants.fontSize020.h : FontConstants.fontSize024.h
                      : FontConstants.fontSize016.h,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.inverseSurface,
                )),
          ),
        ],
      ),
    );
  }
}
