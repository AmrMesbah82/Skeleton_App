import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class OrgChartCard extends StatefulWidget {
  const OrgChartCard(
      {super.key,
      required this.department,
      required this.role,
      required this.name});
  final String department;
  final String name;
  final String role;

  @override
  State<OrgChartCard> createState() => _OrgChartCardState();
}

class _OrgChartCardState extends State<OrgChartCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.18.w,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 0.018.w,
                backgroundImage: AssetImage("assets/images/profile1.png"),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.02.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.department,
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                          fontSize: FontConstants.fontSize010.w,
                          fontWeight: FontWeight.w600,
                          height: 0.0015.h,
                          color: MyThemeData.lightPrimary),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.008.h),
                  child: Text(
                    widget.name as String,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: FontConstants.fontSize021.h,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.006.h),
                  child: Text(
                    widget.role,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: FontConstants.fontSize018.h,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
