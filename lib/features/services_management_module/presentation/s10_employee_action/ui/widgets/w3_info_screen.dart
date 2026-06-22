import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';






class InfoScreenWidget extends StatelessWidget {
  const InfoScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomRowDetails(
              data: "Ahmed Wael",
              image: "assets/images/details/User Plus.svg",
              title: "Service Provider:",
              imagePerson: "assets/images/person.png",
            ),
            SizedBox(height: 5.h),
            CustomRowDetails(
              data: "ahmedmohammed548@gmail.com",
              image: "assets/images/details/sms.svg",
              title: "Email:",
            ),
            SizedBox(height: 5.h),
            CustomRowDetails(
              data: "4 Week",
              image: "assets/images/details/Group 1000004482.svg",
              title: "Duration of Service:",
            ),
          ],
        ),

        SizedBox(width: MediaQuery.sizeOf(context).width * .05),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomRowDetails(
              data: "IT Systems Administrator",
              image: "assets/images/details/Case.svg",
              title: "Job Title::",
            ),
            SizedBox(height: 5.h),
            CustomRowDetails(
              data: "+201094597362",
              image: "assets/images/details/Phone Rounded.svg",
              title: "Phone Number:",
            ),
            SizedBox(height: 5.h),
            CustomRowDetails(
              data: "Needs P12_Approval_tablet",
              image: "assets/images/details/Document Add.svg",
              title: "Approval:",
            ),
          ],
        ),
      ],
    );
  }
}
class CustomRowDetails extends StatelessWidget {
  const CustomRowDetails({
    super.key,
    required this.image,
    required this.title,
    required this.data,
    this.imagePerson, // ✅ optional
  });

  final String image;
  final String title;
  final String data;
  final String? imagePerson; // ✅ nullable

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          image, // uses passed SVG icon
          semanticsLabel: 'Icon',
          width: 20.w,
          height: 20.h,
        ),
        SizedBox(width: 8.w),
        Text(title, style: AppTextStyles.font14BlackCairoRegular),
        SizedBox(width: 8.w),

        // ✅ Only show person image if it's provided
        if (imagePerson != null)
          Row(
            children: [
              Image.asset(imagePerson!, width: 32.w, height: 32.h),
              SizedBox(width: 5.w),
            ],
          ),

        // Data Text
        Text(data, style: AppTextStyles.font14BlackCairoRegular),
      ],
    );
  }
}
