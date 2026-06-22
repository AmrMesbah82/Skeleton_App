import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/info_text.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/enumeration/enum.dart' as FormatHelper;
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';


class EmployeeCardMobileWidget extends StatelessWidget {
  final Map<String, dynamic> providerStats;

  const EmployeeCardMobileWidget({
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 45.sp,
              height: 45.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: SvgPicture.asset(
                  gender,
                  fit: BoxFit.cover,
                  width: 45.sp,
                  height: 45.sp,
                ),
              ),
            ),
            SizedBox(width: 12.sp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FormatHelper.capitalize(fullName),
                    style: AppTextStyles.font14BlackSemiBoldCairo.copyWith(
                      color: lightMode ? AppColors.blackButton : AppColors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.sp),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          FormatHelper.capitalize(departmentText),
                          style: AppTextStyles.font12BlackCairoRegular.copyWith(
                            color: lightMode ? AppColors.secondaryText : AppColors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.sp),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          FormatHelper.capitalize(jobTitle),
                          style: AppTextStyles.font12BlackCairoRegular.copyWith(
                            color: lightMode ? AppColors.secondaryText : AppColors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (role.isNotEmpty) ...[
                    SizedBox(height: 4.sp),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.sp, vertical: 2.sp),
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
            ),
          ],
        ),
        SizedBox(height: 12.sp),
        Row(
          children: [
            Expanded(
              child: infoBox(
                context,
                "${S.of(context).DoneServices}:",
                doneServices,
                Colors.transparent,
              ),
            ),
            SizedBox(width: 8.sp),
            Expanded(
              child: infoBox(
                context,
                "${S.of(context).TotalHours}:",
                totalHours,
                Colors.transparent,
              ),
            ),
            SizedBox(width: 8.sp),
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
      ],
    );
  }
}
