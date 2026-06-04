import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class SwitchColumn extends StatelessWidget {
   SwitchColumn({
    super.key,
    required this.title,
    required this.subtitle,
    required this.numUnread,
    this.isDialog = false,
  });
  final String title;
  final String subtitle;
  final int numUnread;
   bool? isDialog;

  @override
  Widget build(BuildContext context) {
     
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
     //   color: Colors.amber,
          width:isDialog == true ? null : isTablet? (isPortrait? 0.16.w : 0.12.w) : 0.6.w,
          child: Text(
            title.tr.capitalize as String,
            overflow: TextOverflow.ellipsis,
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: isTablet
                  ? isPortrait
                      ? FontConstants.fontSize016.h
                      : FontConstants.fontSize016.w
                  : FontConstants.fontSize018.h,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
        ),
        Container(
       //   color: Colors.amber,
             width:isDialog == true ? null : isTablet? (isPortrait? 0.16.w : 0.12.w) : 0.6.w,
          child: Padding(
            padding: EdgeInsets.only(
                top: isTablet ? (isPortrait ? 0.005.h : 0.01.h) : 0.015.h),
            child: Text(
              subtitle.tr,
              overflow: TextOverflow.visible,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: isTablet
                    ? isPortrait
                        ? FontConstants.fontSize015.h
                        : FontConstants.fontSize015.w
                    : FontConstants.fontSize016.h,
                fontWeight: numUnread != 0 ? FontWeight.w600 : FontWeight.w400,
                color: Theme.of(context).colorScheme.scrim,
              ),
            ),
          ),
        )
      ],
    );
  }
}
