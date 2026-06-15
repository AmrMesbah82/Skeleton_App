import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';

import '../../theme/app_colors.dart';


class SideFrameDesktop extends StatelessWidget {
  final String titleText;
  final Widget? child;

  const SideFrameDesktop({
    super.key,
    required this.titleText,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80.sp,
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.white
              : AppColors.chatBackground,
          child: Column(
            children: [
              SizedBox(height: 26.h),
              Image.asset(
                'assets/images/surface1.png',
                width: 49.sp,
                height: 39.sp,
              ),
              SizedBox(height: 44.sp),
              Container(
                width: 55.sp,
                height: 55.sp,
                decoration: BoxDecoration(
                  color: const Color(0xffE5B800),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Image.asset(
                  "assets/images/head1.png",
                  width: 16.sp,
                  height: 20.sp,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 90.sp,
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.white
                    : AppColors.chatBackground,
                child: Row(
                  children: [
                    Spacer(),

                    SvgPicture.asset(
                      "assets/images/Bell.svg",
                      semanticsLabel: 'Dart Logo',
                      color: Theme.of(context).brightness == Brightness.light ? Colors.grey : Colors.white,
                    ),
                    SizedBox(width: 30.sp),
                    Row(
                      children: [
                        Image(image: AssetImage("assets/images/person.png")),
                        SizedBox(width: 10.sp),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Amro Handousa",style: AppTextStyles.font16BlackMediumCairo.copyWith(color: Theme.of(context).brightness == Brightness.light ? AppColors.blackButton : AppColors.white),
                            ),

                            Text("Employee",style: AppTextStyles.font14BlackCairoMedium.copyWith(color: Theme.of(context).brightness == Brightness.light ? AppColors.secondaryText : AppColors.white)),

                          ],
                        ),


                      ],
                    ),
                    SizedBox(width: 18.w),

                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.background
                      : AppColors.background,
                  padding: EdgeInsets.only(
                    top: 10.sp,
                    left: 15.sp,
                    right: 38.sp,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titleText,
                          style:
                          AppTextStyles.font28BlackMediumCairo.copyWith(color: Theme.of(context).brightness == Brightness.light ?AppColors.blackButton : AppColors.white ),
                        ),
                        SizedBox(height: 20.sp),
                        if (child != null) child!,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
