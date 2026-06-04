import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class CustomRowWidget extends StatefulWidget {
  final String svgImagePath;
  final String title;
  final String value;
  final bool? isLast;
  final bool? isSkill;

  CustomRowWidget({
    required this.svgImagePath,
    required this.title,
    required this.value,
    this.isLast =false,
    this.isSkill =false,
  });

  @override
  State<CustomRowWidget> createState() => _CustomRowWidgetState();
}

class _CustomRowWidgetState extends State<CustomRowWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:   EdgeInsets.only(bottom:widget.isLast == true? 0 : 0.01.h),
      child: Container(
        width:widget.isSkill==true ? 0.3.w: 0.87.w,
      //   color: Colors.amber,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              widget.svgImagePath,
              height: 0.025.h,
            ),
            SizedBox(width: 0.02.w,),
            Text(
              widget.title.tr,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: FontConstants.fontSize018.h,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  height:widget.isSkill == true? 1.2 : 1.5),
            ),
             SizedBox(width: 0.02.w,),
            Flexible(
              child: Text(
                widget.value.capitalize!,
                maxLines: 14,
                overflow: TextOverflow.ellipsis,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: FontConstants.fontSize018.h,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
