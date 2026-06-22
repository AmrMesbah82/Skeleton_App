import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/services_management_module/presentation/s10_employee_action/ui/widgets/w2_approval_cycle.dart';
import 'package:demo_app/features/services_management_module/presentation/s10_employee_action/ui/widgets/w3_info_screen.dart';
import 'package:demo_app/features/services_management_module/presentation/s10_employee_action/ui/widgets/w4_limited_services_section.dart';

class InfoCardWidget extends StatelessWidget {
   const InfoCardWidget({super.key, required this.width});

  final double width ;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.white,
      ),
      child: Column(
        children: [
          // first section photo & details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // image
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.secondaryButton,
                ),
                child: Center(
                  child: Image.asset(
                    "assets/images/headphone.png",
                    width: 38.5.w,
                    height: 38.5.h,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              // details text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Service Description:",
                      style: AppTextStyles.font14BlackCairoRegular,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "This request pertains to the ongoing support and maintenance of the organization's IT infrastructure. Ahmed Wael, as the IT Systems Administrator, oversees the management of servers, network configurations, and user support. The status remains active, indicating that all systems are functioning optimally, with regular updates being made to ensure security and efficiency.",
                      style: AppTextStyles.font13SecondaryBlackCairo,
                      textAlign: TextAlign.justify,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // info screen
          InfoScreenWidget(),

          // space
          SizedBox(height: 20.h),

          // section Limited Service Availability:
          LimitedServiceAvailabilityWidget(),

          SizedBox(height: 20.h),
          // Approval Cycle Title
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Approval Cycle:",
                style: AppTextStyles.font14BlackCairoRegular,
              ),
            ],
          ),

          // space
          SizedBox(height: 12.h),

          // Approval Cycle item
          ApprovalCycleWidget(),
        ],
      ),
    );
  }
}
