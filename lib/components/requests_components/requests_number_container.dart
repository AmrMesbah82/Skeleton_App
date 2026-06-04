import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

// ignore: must_be_immutable
class RequestsNumberContainer extends StatefulWidget {
  RequestsNumberContainer(
      {super.key, required this.title, required this.count, this.isSelected});
  final String title;
  int count;
  bool? isSelected;
  @override
  State<RequestsNumberContainer> createState() =>
      _RequestsNumberContainerState();
}

class _RequestsNumberContainerState extends State<RequestsNumberContainer> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    List<Widget> requestContent = [
      Container(
        width: isTablet ? null : null,
        height: isTablet ? (isPortrait ? 0.045.h : 0.06.h) : 0.04.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.isSelected == true
              ? MyThemeData.barColor
              : Theme.of(context).colorScheme.inversePrimary,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 0.004.h,
              horizontal: isTablet
                  ? isPortrait
                      ? 0.02.w
                      : 0.01.w
                  : 0.03.w),
          child: Center(
            child: Text(
              // widget.count < 10 ? "${widget.count}" : "${widget.count}",
              Get.locale.toString().contains('en')
                  ? reduceNumber(widget.count)
                  : convertNumberToArabic(reduceNumber(widget.count)),
              style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: isTablet
                      ? isPortrait
                          ? FontConstants.fontSize022.h
                          : FontConstants.fontSize020.w
                      : FontConstants.fontSize018.h,
                  height: isPortrait ? 1.7 : 1.6,
                  fontWeight: FontWeight.bold,
                  color: widget.isSelected == true
                      ? MyThemeData().contrastColor()
                      : Theme.of(context).colorScheme.inverseSurface),
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: Get.locale.toString().contains('en') ? 0.015.w : 0,
            right: Get.locale.toString().contains('en') ? 0 : 0.015.w),
        child: Text(
          widget.title.tr,
          style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: isTablet
                  ? isPortrait
                      ? FontConstants.fontSize016.h
                      : FontConstants.fontSize018.w
                  : FontConstants.fontSize014.h,
              fontWeight:
                  widget.isSelected == true ? FontWeight.bold : FontWeight.w500,
              height: 1.8,
              color: widget.isSelected == true
                  ? Theme.of(context).colorScheme.onInverseSurface
                  : Theme.of(context).colorScheme.tertiaryContainer),
        ),
      ),
    ];
    return Padding(
      padding: EdgeInsets.only(
        right: Get.locale.toString().contains('en') ? 0.02.w : 0,
        left: Get.locale.toString().contains('ar') ? 0.02.w : 0,
      ),
      child: Container(
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(8),
            // color: Theme.of(context).colorScheme.inversePrimary
            ),
        child: Padding(
            padding: EdgeInsets.only(
                top: 0.01.h,
                bottom: 0.01.h,
                left: Get.locale.toString().contains('en')
                    ? 0
                    : isTablet
                        ? 0.025.w
                        : 0,
                right: Get.locale.toString().contains('en')
                    ? isTablet
                        ? 0.025.w
                        : 0.01.w
                    : 0),
            child:
                //isTablet
                Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: requestContent,
            )
            // : Column(
            //     children: requestContent,
            //   ),
            ),
      ),
    );
  }
}
