import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/helper_method.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/info_text.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/enumeration/enum.dart' as FormatHelper;
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';


class EmployeeCardTabletWidget extends StatelessWidget {
  final Map<String, dynamic> providerStats;

  const EmployeeCardTabletWidget({
    required this.providerStats,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;

    final departmentText = providerStats["department"]?.toString() ?? 'N/A';
    final fullName = providerStats["name"]?.toString() ?? 'N/A';
    final jobTitle = providerStats["title"]?.toString() ?? 'N/A';
    final role = providerStats["role"]?.toString() ?? '';

    final gender = (providerStats["gender"]?.toString().toLowerCase() == 'female')
        ? "assets/female.svg"
        : "assets/male.svg";

    final doneServices = providerStats["done"]?.toString() ?? '0';
    final totalHours = (providerStats["hours"] as num?)?.toStringAsFixed(1) ?? '0.0';
    final breachedSLA = providerStats["breached"]?.toString() ?? '0';

    return Row(
      children: [
        Container(
          width: 50.sp,
          height: 50.sp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: lightMode
                  ? AppColors.secondaryText.withOpacity(0.2)
                  : AppColors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: ClipOval(
            child: SvgPicture.asset(
              gender,
              fit: BoxFit.cover,
              width: 50.sp,
              height: 50.sp,
            ),
          ),
        ),
        SizedBox(width: !isTabletLandscape(context) ? 10.sp : 15.sp),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      FormatHelper.capitalize(fullName),
                      style: AppTextStyles.font16BlackSemiBoldCairo.copyWith(
                        color: lightMode ? AppColors.blackButton : AppColors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (role.isNotEmpty) ...[
                    SizedBox(width: 8.sp),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 2.sp),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        FormatHelper.capitalize(role),
                        style: AppTextStyles.font10BlackCairoRegular.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 6.sp),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      FormatHelper.capitalize(departmentText),
                      style: AppTextStyles.font13SecondaryBlackCairo.copyWith(
                        color: lightMode ? AppColors.secondaryText : AppColors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.sp),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      FormatHelper.capitalize(jobTitle),
                      style: AppTextStyles.font13SecondaryBlackCairo.copyWith(
                        color: lightMode ? AppColors.secondaryText : AppColors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: infoBox(
                  context,
                  "${S.of(context).DoneServices}:",
                  doneServices,
                  Colors.transparent,
                ),
              ),
              SizedBox(width: !isTabletLandscape(context) ? 8.sp : 12.sp),
              Expanded(
                child: infoBox(
                  context,
                  "${S.of(context).TotalHours}:",
                  totalHours,
                  Colors.transparent,
                ),
              ),
              SizedBox(width: !isTabletLandscape(context) ? 8.sp : 12.sp),
              Expanded(
                child: infoBox(
                  context,
                  "${S.of(context).BreachedSLA}:",
                  breachedSLA,
                  AppColors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
