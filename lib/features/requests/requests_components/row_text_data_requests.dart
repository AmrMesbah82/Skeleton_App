import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

class RowTextRequests extends StatelessWidget {
  const RowTextRequests(
      {super.key, required this.imageUrl, required this.text,this.text2});
  final String imageUrl;
  final String text;
  final String? text2;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: text2!=null?CrossAxisAlignment.start:CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          imageUrl,
          color: Theme.of(context).colorScheme.inverseSurface,
          height: 0.04.w,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02.w),
          child: Container(
        //    color: Colors.amber,
            width: 0.3.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text.tr,
                  
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: FontConstants.fontSize014.h,
                      height:text2!=null?1.4: 1.8,
                      color: Theme.of(context).colorScheme.inverseSurface,
                      fontWeight: FontWeight.w400),
                ),
                text2!=null? Text(
                  text2!.tr,
              
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: FontConstants.fontSize014.h,
                      height: 1.8,
                      color: Theme.of(context).colorScheme.inverseSurface,
                      fontWeight: FontWeight.w400),
                ):const SizedBox.shrink(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
