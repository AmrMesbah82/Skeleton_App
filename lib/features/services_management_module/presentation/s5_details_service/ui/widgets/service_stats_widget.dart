import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/dialog.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/services_dialog.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/data/service_stats_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/info_text.dart';

class ServiceStatsWidget extends StatelessWidget {
  final ServiceStatsModel stats;

  const ServiceStatsWidget({
    required this.stats,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isPhone;
    final isTablet = context.isTablet;
    final lightMode = Theme.of(context).brightness == Brightness.light;

    return isMobile ? _buildMobileLayout(context, lightMode) : _buildTabletLayout(context, lightMode, isTablet);
  }

  Widget _buildMobileLayout(BuildContext context, bool lightMode) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: lightMode ? AppColors.white : AppColors.chatBackground,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.sp),
              child: Column(
                children: [
                  OurServicesDialog(
                    color: AppColors.lightGreen,
                    title: S.of(context).Approved,
                    image: "assets/state_icon/approve_icon.svg",
                    number: "${stats.approved}",
                  ),
                  SizedBox(height: 15.sp),
                  OurServicesDialog(
                    color: AppColors.lightGreen,
                    title: S.of(context).Done,
                    image: "assets/state_icon/done_icon.svg",
                    number: "${stats.done}",
                  ),
                  SizedBox(height: 15.sp),
                  OurServicesDialog(
                    color: AppColors.secondaryPrimary,
                    title: S.of(context).Inprogress,
                    image: "assets/state_icon/inprogress_icon.svg",
                    number: "${stats.inprogress}",
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 10.sp),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: lightMode ? AppColors.white : AppColors.chatBackground,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.sp),
              child: Column(
                children: [
                  OurServicesDialog(
                    color: AppColors.orange,
                    title: S.of(context).Pending,
                    image: "assets/state_icon/pending_icon.svg",
                    number: "${stats.pending}",
                  ),
                  SizedBox(height: 15.sp),
                  OurServicesDialog(
                    color: AppColors.red,
                    title: S.of(context).Rejected,
                    image: "assets/state_icon/rejected_icon.svg",
                    number: "${stats.rejected}",
                  ),
                  SizedBox(height: 15.sp),
                  OurServicesDialog(
                    color: AppColors.red,
                    title: S.of(context).Canceled,
                    image: "assets/state_icon/cancel.svg",
                    number: "${stats.cancel}",
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, bool lightMode, bool isTablet) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(15.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OurServicesDialog(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  color: AppColors.green,
                  title: S.of(context).Done,
                  image: "assets/state_icon/done_icon.svg",
                  number: "${stats.done}",
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.sp),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OurServicesDialog(
                        color: AppColors.lightGreen,
                        title: S.of(context).approved,
                        image: "assets/state_icon/approve_icon.svg",
                        number: "${stats.approved}",
                      ),
                      SizedBox(height: 13.sp),
                      OurServicesDialog(
                        color: Color(0xffE5B800),
                        title: S.of(context).Inprogress,
                        image: "assets/state_icon/inprogress_icon.svg",
                        number: "${stats.inprogress}",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: !isTabletLandscape(context) ? 10.sp : 65.sp),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: lightMode ? AppColors.white : AppColors.chatBackground,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.sp),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OurServicesDialog(
                        color: AppColors.orange,
                        title: S.of(context).Pending,
                        image: "assets/state_icon/pending_icon.svg",
                        number: "${stats.pending}",
                      ),
                      SizedBox(height: 13.sp),
                      OurServicesDialog(
                        color: AppColors.red,
                        title: S.of(context).Rejected,
                        image: "assets/state_icon/rejected_icon.svg",
                        number: "${stats.rejected}",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: !isTabletLandscape(context) ? 10.sp : 65.sp),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: lightMode ? AppColors.white : AppColors.chatBackground,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.sp),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OurServicesDialog(
                        color: AppColors.red,
                        title: S.of(context).Canceled,
                        image: "assets/state_icon/cancel.svg",
                        number: "${stats.cancel}",
                      ),
                      SizedBox(height: 13.sp),
                      OurServicesDialog(
                        color: AppColors.red,
                        title: S.of(context).BreachedSLA,
                        image: "assets/state_icon/sla_icon.svg",
                        number: "${stats.branchsla}",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }



  Widget _buildTabletLayoutNew (BuildContext context, bool lightMode, bool isTablet) {
    return Column(
      children: [



        Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Expanded(
                  child: OurServicesDialog(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    color: AppColors.green,
                    title: S.of(context).Done,
                    image: "assets/state_icon/done_icon.svg",
                    number: "${stats.done}",
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 15.sp),

        Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Expanded(
                  child: OurServicesDialog(
                    color: AppColors.lightGreen,
                    title: S.of(context).approved,
                    image: "assets/state_icon/approve_icon.svg",
                    number: "${stats.approved}",
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: OurServicesDialog(
                    color: Color(0xffE5B800),
                    title: S.of(context).Inprogress,
                    image: "assets/state_icon/inprogress_icon.svg",
                    number: "${stats.inprogress}",
                  ),
                ),
                Expanded(
                  child: OurServicesDialog(
                    color: AppColors.red,
                    title: S.of(context).Canceled,
                    image: "assets/state_icon/cancel.svg",
                    number: "${stats.cancel}",
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 15.sp),

        Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Expanded(
                  child: OurServicesDialog(
                    color: AppColors.red,
                    title: S.of(context).BreachedSLA,
                    image: "assets/state_icon/sla_icon.svg",
                    number: "${stats.branchsla}",
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: OurServicesDialog(
                    color: AppColors.orange,
                    title: S.of(context).Pending,
                    image: "assets/state_icon/pending_icon.svg",
                    number: "${stats.pending}",
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: OurServicesDialog(
                    color: AppColors.red,
                    title: S.of(context).Rejected,
                    image: "assets/state_icon/rejected_icon.svg",
                    number: "${stats.rejected}",
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
