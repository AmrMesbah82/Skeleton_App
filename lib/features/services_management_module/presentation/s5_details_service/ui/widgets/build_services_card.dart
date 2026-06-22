import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';

import 'package:demo_app/core/helper/format_helper.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';

Color _getBorderColor(String state) {
  switch (state.toLowerCase()) {
    case 'pending':
      return const Color(0xFFFF814A); // orange
    case 'done':
      return Color(0xFF4BB609); // Or any other color for "done"
    case 'approved':
      return const Color(0xFF4BB609); // green
    case 'rejected':
    case 'cancel':
      return const Color(0xFFDF0C0C); // red
    case 'inprogress':
      return const Color(0xFFFFCC00); // yellow
    case 'breached sla':
      return const Color(0xFFB00020); // dark red
    default:
      return AppColors.lightGrey!; // normal
  }
}

Map<String, dynamic> getStatusStyle(
    String status,
    bool isArabic,
    bool lightMode,
    ) {
  final labelMap = {
    "approved": isArabic ? "معتمد" : "Approved",
    "pending": isArabic ? "قيد الانتظار" : "Pending",
    "rejected": isArabic ? "مرفوض" : "Rejected",
    "done": isArabic ? "منجز" : "Done",
    "cancel": isArabic ? "ملغي" : "Canceled",
    "inprogress": isArabic ? "قيد التنفيذ" : "In Progress",
    "breached sla": isArabic ? "تجاوز الاتفاق" : "Breached SLA",
  };

  return {
    "label": labelMap[status.toLowerCase()] ?? (isArabic ? "غير معروف" : "Unknown"),
    "color": _getBorderColor(status),
  };
}

Widget buildServiceCardFromMap(Map<String, dynamic> item, BuildContext context) {
  final model = item["model"] as ServicesHistoryModel;
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  final lightMode = Theme.of(context).brightness == Brightness.light;

  // Get department controller
  final departmentController = Get.find<MainCoreDepartmentController>();

  // ✅ Get department ID and translate it dynamically
  final rawDepartmentId = model.currentDepartmentRequester;
  final department = rawDepartmentId.isNotEmpty
      ? departmentController.getDepartmentName(rawDepartmentId, !isArabic)
      : "-";

  // ✅ Get service name using the correct getter
  final String serviceName = isArabic
      ? (model.currentServiceNameArabic.isNotEmpty
      ? model.currentServiceNameArabic
      : "-")
      : (model.currentServiceNameEnglish.isNotEmpty
      ? model.currentServiceNameEnglish
      : "-");

  // ✅ Get requester name using the correct getters
  final String requesterFirstName = isArabic
      ? model.currentFirstNameRequesterArabic
      : model.currentFirstNameRequester;

  final String requesterLastName = isArabic
      ? model.currentLastNameRequesterArabic
      : model.currentLastNameRequester;

  final requestor = "$requesterFirstName $requesterLastName".trim().isNotEmpty
      ? "$requesterFirstName $requesterLastName".trim()
      : "-";

  // ✅ Get request date
  final requestDate = DateFormat('dd MMM yyyy', Localizations.localeOf(context).languageCode)
      .format(model.currentDurationOfServicesTimestamp.toDate());

  final provider = item["provider"] ?? "-";

  final status = item["status"]?.toString().toLowerCase() ?? "-";
  final statusInfo = getStatusStyle(status, isArabic, lightMode);
  final translatedStatus = statusInfo["label"];
  final statusColor = statusInfo["color"];

  final jobTitle = isArabic
      ? model.currentJobTitleRequesterArabic
      : model.currentJobTitleRequester;

  // Debug prints

  return Stack(
    children: [
      Container(
        margin: EdgeInsets.only(bottom: 14.sp),
        padding: EdgeInsets.all(14.sp),
        decoration: BoxDecoration(
          color: lightMode ? AppColors.white : AppColors.chatBackground,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Row: Service Name
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 30.sp,
                  height: 30.sp,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: SvgPicture.asset(
                    "assets/headsvg.svg",
                    width: 12.sp,
                    height: 12.sp,
                    fit: BoxFit.scaleDown,
                    color: AppColors.secondaryText,
                    semanticsLabel: 'Icon',
                  ),
                ),
                SizedBox(width: 5.sp),
                Expanded(
                  child: Text(
                    serviceName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font16BlackMediumCairo.copyWith(
                      color: lightMode
                          ? AppColors.blackButton
                          : AppColors.white,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.sp),

            /// Row: Requester
            Row(
              children: [
                SvgPicture.asset(
                  "assets/images/details/User Plus.svg",
                  fit: BoxFit.scaleDown,
                  color: lightMode
                      ? AppColors.secondaryText
                      : AppColors.whiteShadow,
                ),
                SizedBox(width: 6.sp),
                Text(
                  "${S.of(context).serviceRequester}: ",
                  style: AppTextStyles.font12BlackCairoRegular.copyWith(
                    color: lightMode
                        ? AppColors.secondaryText
                        : AppColors.grey,
                  ),
                ),
                SizedBox(width: 2.sp),
                ClipOval(
                  child: SvgPicture.asset(
                    "assets/male.svg",
                    fit: BoxFit.scaleDown,
                    width: 25.sp,
                    height: 25.sp,
                  ),
                ),
                SizedBox(width: 4.sp),
                Expanded(
                  child: Text(
                    FormatHelper.capitalize(requestor),
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font12BlackCairoRegular.copyWith(
                      color: lightMode
                          ? AppColors.blackButton
                          : AppColors.white,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 6.sp),

            /// Row: Requested Date
            Row(
              children: [
                SvgPicture.asset(
                  "assets/images/details/Calendar.svg",
                  fit: BoxFit.scaleDown,
                  color: lightMode
                      ? AppColors.secondaryText
                      : AppColors.whiteShadow,
                ),
                SizedBox(width: 6.w),
                Text(
                  "${S.of(context).RequestedDate}: ",
                  style: AppTextStyles.font12BlackCairoRegular.copyWith(
                    color: lightMode
                        ? AppColors.secondaryText
                        : AppColors.grey,
                  ),
                ),
                Text(
                  requestDate,
                  style: AppTextStyles.font12BlackCairoRegular.copyWith(
                    color: lightMode
                        ? AppColors.blackButton
                        : AppColors.white,
                  ),
                ),
              ],
            ),

            SizedBox(height: 6.sp),

            /// Row: Service Provider
            Row(
              children: [
                SvgPicture.asset(
                  "assets/images/details/User Plus.svg",
                  fit: BoxFit.scaleDown,
                  color: lightMode
                      ? AppColors.secondaryText
                      : AppColors.whiteShadow,
                ),
                SizedBox(width: 6.w),
                Text(
                  "${S.of(context).serviceProvider}: ",
                  style: AppTextStyles.font12BlackCairoRegular.copyWith(
                    color: lightMode
                        ? AppColors.secondaryText
                        : AppColors.grey,
                  ),
                ),
                SizedBox(width: 2.w),
                ClipOval(
                  child: SvgPicture.asset(
                    "assets/male.svg",
                    fit: BoxFit.scaleDown,
                    width: 25.sp,
                    height: 25.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    FormatHelper.capitalize(provider),
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font12BlackCairoRegular.copyWith(
                      color: lightMode
                          ? AppColors.blackButton
                          : AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Positioned(
        top: 7.sp,
        right: isArabic ? null : 7.sp,
        left: isArabic ? 7.sp : null,
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/status.svg",
              fit: BoxFit.scaleDown,
              color: lightMode
                  ? AppColors.secondaryText
                  : AppColors.whiteShadow,
            ),
            SizedBox(width: 2.w),
            Text(
              "${S.of(context).status}: ",
              style: AppTextStyles.font12BlackCairoRegular.copyWith(
                color: lightMode
                    ? AppColors.secondaryText
                    : AppColors.grey,
              ),
            ),
            Text(
              translatedStatus,
              style: AppTextStyles.font12SecondaryBlackCairoMedium.copyWith(
                color: statusColor,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
