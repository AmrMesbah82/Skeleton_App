import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/pages/select_services_provider_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/responsive_text.dart';

Widget buildProviderDetailsSectionMaster({
  Function()? onTap,
  bool table = false,
  required BuildContext context,
  required String duration,
  required String durationUnit,
  required Timestamp durationTimeStamp,
  required List approvalCycle,
  required EmployeeEntityModell model,
  required String state,
}) {
  final isMobile = context.isPhone;
  final EmployeeEntityModell provider = model;
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';

  // ✅ Only allow edit if state is pending or approved
  final canEdit = state.toLowerCase() == 'pending' || state.toLowerCase() == 'approved';

  // ✅ Reusable avatar + name row (no edit, no gesture)
  final avatarAndName = Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ClipOval(
        child: SvgPicture.asset(
          (provider.gender ?? 'male') == 'male'
              ? "assets/male.svg"
              : "assets/female.svg",
          width: 25.sp,
          height: 25.sp,
          fit: BoxFit.scaleDown,
        ),
      ),
      SizedBox(width: 5.sp),
      Text(
        FormatHelper.capitalize(
          isArabic
              ? "${provider.firstNameInArabic ?? '-'} ${provider.lastNameInArabic ?? '-'}"
              : "${provider.firstName ?? '-'} ${provider.lastName ?? '-'}",
        ),
        style: AppTextStyles.font14BlackCairoRegular.copyWith(
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.blackButton
              : AppColors.white,
        ),
      ),
    ],
  );

  // ✅ Single builder for the provider row — used in all 3 layout branches
  Widget buildProviderRow() {
    if (!table) {
      return CustomRowDetailsMaster(
        data: FormatHelper.capitalize(
          isArabic
              ? "${provider.firstNameInArabic ?? '-'} ${provider.lastNameInArabic ?? '-'}"
              : "${provider.firstName ?? '-'} ${provider.lastName ?? '-'}",
        ),
        image: "assets/images/details/User Plus.svg",
        title: FormatHelper.capitalize("${S.of(context).serviceProvider}: "),
        imagePerson: (provider.gender ?? 'male') == 'male'
            ? "assets/male.svg"
            : "assets/female.svg",
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/images/details/User Plus.svg",
          semanticsLabel: 'Icon',
          width: 20.sp,
          height: 20.sp,
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.secondaryText
              : AppColors.whiteShadow,
        ),
        SizedBox(width: 8.w),
        Text(
          FormatHelper.capitalize("${S.of(context).serviceProvider}: "),
          style: AppTextStyles.font14BlackCairoRegular.copyWith(
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.secondaryText
                : AppColors.grey,
          ),
        ),
        // ✅ If canEdit → wrap with GestureDetector + show edit icon
        // ✅ If !canEdit → show only avatar + name
        canEdit
            ? GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.background
                  : AppColors.background,
              borderRadius: BorderRadius.circular(4.r),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 6.sp,
              horizontal: 6.sp,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                avatarAndName,
                SizedBox(width: 15.sp),
                SvgPicture.asset(
                  "assets/lottie/edit.svg",
                  width: 16.sp,
                  height: 16.sp,
                  fit: BoxFit.scaleDown,
                ),
              ],
            ),
          ),
        )
            : avatarAndName,
      ],
    );
  }

  // ==================== LEFT COLUMN ====================

  final leftColumn = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildProviderRow(),
      SizedBox(height: 6.sp),
      CustomRowDetailsMaster(
        data: FormatHelper.capitalize(provider.email ?? '-'),
        image: "assets/images/details/sms.svg",
        title: FormatHelper.capitalize("${S.of(context).email}: "),
      ),
      SizedBox(height: 12.sp),
      CustomRowDetailsMaster(
        data: "${FormatHelper.capitalize(duration)} ${getLocalizedDurationUnitProvider(durationUnit, isArabic)}",
        image: "assets/images/details/Group 1000004482.svg",
        title: FormatHelper.capitalize("${S.of(context).durationOfService}: "),
      ),
    ],
  );

  // ==================== RIGHT COLUMN ====================

  final rightColumn = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      isMobile ? const SizedBox() : SizedBox(height: 8.sp),
      CustomRowDetailsMaster(
        data: FormatHelper.capitalize(
          isArabic ? provider.titleInArabic ?? '-' : provider.title ?? '-',
        ),
        image: "assets/images/details/Case.svg",
        title: FormatHelper.capitalize("${S.of(context).jobTitle}: "),
      ),
      SizedBox(height: 11.sp),
      CustomRowDetailsMaster(
        data: FormatHelper.capitalize(
          provider.mobilePhone?.phone?.toString().replaceAll(RegExp(r'[\[\]]'), '') ?? '-',
        ),
        image: "assets/images/details/Phone Rounded.svg",
        title: FormatHelper.capitalize("${S.of(context).phone}: "),
      ),
      SizedBox(height: 12.sp),
      CustomRowDetailsMaster(
        data: FormatHelper.capitalize(
          approvalCycle.isEmpty
              ? (isArabic ? "لا يحتاج إلى موافقة" : "Doesn't Need Approval")
              : (isArabic ? "يحتاج إلى موافقة" : "Need Approval"),
        ),
        image: "assets/services_module/approval_icons.svg",
        title: FormatHelper.capitalize("${S.of(context).approvals}: "),
      ),
    ],
  );

  // ==================== MOBILE LAYOUT ====================

  if (isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        leftColumn,
        SizedBox(height: 10.sp),
        rightColumn,
      ],
    );
  }

  // ==================== TABLET LAYOUT (600 - 900) ====================

  final isTabletCheck = MediaQuery.sizeOf(context).width >= 600 &&
      MediaQuery.sizeOf(context).width < 900;

  if (isTabletCheck) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProviderRow(),
              SizedBox(height: 6.sp),
              CustomRowDetailsMaster(
                data: FormatHelper.capitalize(provider.email ?? '-'),
                image: "assets/images/details/sms.svg",
                title: FormatHelper.capitalize("${S.of(context).email}: "),
              ),
              SizedBox(height: 12.sp),
              CustomRowDetailsMaster(
                data: "${FormatHelper.capitalize(duration)} ${getLocalizedDurationUnitProvider(durationUnit, isArabic)}",
                image: "assets/images/details/Group 1000004482.svg",
                title: FormatHelper.capitalize("${S.of(context).durationOfService}: "),
              ),
            ],
          ),
        ),
        SizedBox(width: 10.sp),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomRowDetailsMaster(
                data: FormatHelper.capitalize(
                  isArabic ? provider.titleInArabic ?? '-' : provider.title ?? '-',
                ),
                image: "assets/images/details/Case.svg",
                title: FormatHelper.capitalize("${S.of(context).jobTitle}: "),
              ),
              SizedBox(height: 11.sp),
              CustomRowDetailsMaster(
                data: FormatHelper.capitalize(provider.mobilePhone?.phone ?? '-'),
                image: "assets/images/details/Phone Rounded.svg",
                title: FormatHelper.capitalize("${S.of(context).phone}: "),
              ),
              SizedBox(height: 12.sp),
              CustomRowDetailsMaster(
                data: FormatHelper.capitalize(
                  approvalCycle.isEmpty
                      ? (isArabic ? "لا يحتاج إلى موافقة" : "Doesn't Need Approval")
                      : (isArabic ? "يحتاج إلى موافقة" : "Need Approval"),
                ),
                image: "assets/services_module/approval_icons.svg",
                title: FormatHelper.capitalize("${S.of(context).approvals}: "),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== DESKTOP/LARGE TABLET LAYOUT ====================

  return Column(
    children: [
      Row(
        children: [
          Expanded(child: buildProviderRow()),
          Expanded(
            child: CustomRowDetailsMaster(
              data: FormatHelper.capitalize(provider.email ?? '-'),
              image: "assets/images/details/sms.svg",
              title: FormatHelper.capitalize("${S.of(context).email}: "),
            ),
          ),
          Expanded(
            child: CustomRowDetailsMaster(
              data: FormatHelper.capitalize(
                approvalCycle.isEmpty
                    ? (isArabic ? "لا يحتاج إلى موافقة" : "Doesn't Need Approval")
                    : (isArabic ? "يحتاج إلى موافقة" : "Need Approval"),
              ),
              image: "assets/services_module/approval_icons.svg",
              title: FormatHelper.capitalize("${S.of(context).approvals}: "),
            ),
          ),
        ],
      ),
      SizedBox(height: 10.sp),
      Row(
        children: [
          Expanded(
            child: CustomRowDetailsMaster(
              data: FormatHelper.capitalize(
                isArabic ? provider.titleInArabic ?? '-' : provider.title ?? '-',
              ),
              image: "assets/images/details/Case.svg",
              title: FormatHelper.capitalize("${S.of(context).jobTitle}: "),
            ),
          ),
          Expanded(
            child: CustomRowDetailsMaster(
              data: FormatHelper.capitalize(
                "+${provider.mobilePhone?.countryCode?.toString().replaceAll(RegExp(r'[\[\]]'), '') ?? ''} ${provider.mobilePhone?.phone?.toString().replaceAll(RegExp(r'[\[\]]'), '') ?? '-'}",
              ),
              image: "assets/images/details/Phone Rounded.svg",
              title: FormatHelper.capitalize("${S.of(context).phone}: "),
            ),
          ),
          Expanded(
            child: CustomRowDetailsMaster(
              data: "${FormatHelper.capitalize(duration)} ${getLocalizedDurationUnitProvider(durationUnit, isArabic)}",
              image: "assets/images/details/Group 1000004482.svg",
              title: FormatHelper.capitalize("${S.of(context).durationOfService}: "),
            ),
          ),
        ],
      ),
    ],
  );
}

// ==================== HELPERS ====================

String getLocalizedDurationUnitProvider(String? unit, bool isArabic) {
  if (unit == null) return '';

  final lowerUnit = unit.toLowerCase().trim();

  final map = {
    'days': isArabic ? 'أيام' : 'days',
    'day': isArabic ? 'يوم' : 'day',
    'weeks': isArabic ? 'أسابيع' : 'weeks',
    'week': isArabic ? 'أسبوع' : 'week',
    'hours': isArabic ? 'ساعات' : 'hours',
    'hour': isArabic ? 'ساعة' : 'hour',
    'minutes': isArabic ? 'دقائق' : 'minutes',
    'minute': isArabic ? 'دقيقة' : 'minute',
  };

  return map[lowerUnit] ?? (isArabic ? 'وحدة غير معروفة' : 'Unknown Unit');
}
