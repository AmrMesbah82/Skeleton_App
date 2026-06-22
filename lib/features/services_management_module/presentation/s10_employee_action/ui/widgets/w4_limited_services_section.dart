import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';







class LimitedServiceAvailabilityWidget extends StatelessWidget {
   LimitedServiceAvailabilityWidget({super.key});
  final List<String> special = ["Marketing", "HR", "Finance"];
  @override
  Widget build(BuildContext context) {
    return   Row(
      children: [
        SvgPicture.asset(
          "assets/images/details/Buildings.svg",
          semanticsLabel: 'Dart Logo',
        ),
        SizedBox(width: 2.w),
        Text(
          "Limited Service Availability:",
          style: AppTextStyles.font14BlackCairoRegular,
        ),
        SizedBox(width: 11.w),

        SizedBox(
          height: 30.h,
          width: 300.w,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  // Add some spacing
                  height: 28.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color:AppColors.grey
                  ),
                  child: Center(
                    child: Text(
                      special[index],
                      style: AppTextStyles.font12BlackCairoRegular,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
