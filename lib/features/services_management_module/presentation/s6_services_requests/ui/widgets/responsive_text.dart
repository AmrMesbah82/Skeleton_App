import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';

Map<String, String> departmentTranslations = {
  "Marketing": "التسويق",
  "Sales": "المبيعات",
  "HR": "شؤون الموظفين",
  "Executive": "الإدارة التنفيذية",
  "Customer Support": "دعم العملاء",
  "Operations": "العمليات",
  "Finance": "المالية",
  "Information Technology": "تقنية المعلومات",
  "Human Resources": "الموارد البشرية",
  "Data Management": "إدارة البيانات",
  "Compliance & Legal": "الامتثال والقانون",
  "Software": "البرمجيات",
};

String getLocalizedDepartment(String key, bool isArabic) {
  return isArabic ? (departmentTranslations[key] ?? key) : key;
}

String getLocalizedDurationUnit(
    BuildContext context,
    String? rawUnit, {
      num? quantity,
    }) {
  final localizer = S.of(context);
  if (rawUnit == null) return '';

  final k = rawUnit.trim().toLowerCase();

  String canonical;
  switch (k) {
    case 'h':
    case 'hr':
    case 'hrs':
    case 'hour':
    case 'hours':
      canonical = 'hours';
      break;

    case 'm':
    case 'min':
    case 'mins':
    case 'minute':
    case 'minutes':
      canonical = 'minutes';
      break;

    case 's':
    case 'sec':
    case 'secs':
    case 'second':
    case 'seconds':
      canonical = 'seconds';
      break;

    case 'w':
    case 'wk':
    case 'wks':
    case 'week':
    case 'weeks':
      canonical = 'week';
      break;

    case 'd':
    case 'day':
    case 'days':
      canonical = 'day';
      break;
    case 'mo':
    case 'month':
    case 'months':
      canonical = 'month';
      break;
    case 'y':
    case 'yr':
    case 'yrs':
    case 'year':
    case 'years':
      canonical = 'year';
      break;

    default:
      return rawUnit;
  }

  switch (canonical) {
    case 'hours':
      return localizer.hours;
    case 'minutes':
      return localizer.minutes;
    case 'seconds':
      return localizer.seconds;
    case 'week':
      return localizer.week;
    case 'day':
      return localizer.day;
    case 'month':
      return localizer.month;
    case 'year':
      return localizer.year;
    default:
      return rawUnit;
  }
}

// ✅ Helper function to extract phone data
String _extractPhoneData(dynamic phoneData, String fieldName) {

  if (phoneData == null) {
    return '';
  }

  String result = '';

  if (phoneData is String) {
    // Remove brackets from string like "[965]" -> "965"
    result = phoneData.replaceAll(RegExp(r'[\[\]]'), '').trim();
  } else if (phoneData is List && phoneData.isNotEmpty) {
    // Extract first element from list
    result = phoneData[0].toString();
  } else {
    result = phoneData.toString();
  }

  return result;
}

// ✅ Helper function to format complete phone number
String _formatPhoneNumber(Map<String, dynamic>? mobilePhone) {

  if (mobilePhone == null) {
    return '-';
  }

  final countryCode = _extractPhoneData(mobilePhone['countryCode'], 'countryCode');
  final phone = _extractPhoneData(mobilePhone['phone'], 'phone');

  if (countryCode.isNotEmpty && phone.isNotEmpty) {
    final formatted = "+$countryCode $phone";
    return FormatHelper.capitalize(formatted);
  }

  return '-';
}

Widget buildProviderServiceDetailsServices({
  required BuildContext context,
  required String owningDepartment,
  required String durationUnit,
  required Map<String, dynamic> provider,
  required ServicesHistoryModel requestModel,
}) {

  final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  final isMobile = context.isPhone;
  final isTabletLandscape = MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).orientation == Orientation.landscape;

  final leftColumn = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomRowDetailsMaster(
        data: FormatHelper.capitalize(
          isArabic
              ? "${provider['firstNameInArabic'] ?? '-'} ${provider['lastNameInArabic'] ?? '-'}"
              : "${provider['firstName'] ?? '-'} ${provider['lastName'] ?? '-'}",
        ),
        image: "assets/images/details/User Plus.svg",
        title: FormatHelper.capitalize("${S.of(context).serviceProvider}: "),
        imagePerson: (provider['gender'] ?? 'male') == "male"
            ? "assets/male.svg"
            : "assets/female.svg",
      ),
      SizedBox(height: 6.sp),
      CustomRowDetailsMaster(
        data: FormatHelper.capitalize(provider['email'] ?? '-'),
        image: "assets/images/details/sms.svg",
        title: FormatHelper.capitalize("${S.of(context).email}: "),
      ),
      SizedBox(height: 12.sp),
      CustomRowDetailsMaster(
        data:
        "${FormatHelper.capitalize(requestModel.currentDurationOfServices ?? '')} ${getLocalizedDurationUnit(context, durationUnit)}",
        image: "assets/images/details/Group 1000004482.svg",
        title: FormatHelper.capitalize("${S.of(context).durationOfService}: "),
      ),
    ],
  );

  final rightColumn = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      isMobile ? SizedBox() : SizedBox(height: 8.sp),

      CustomRowDetailsMaster(
        data: FormatHelper.capitalize(
          isArabic ? provider['titleInArabic'] ?? '-' : provider['title'] ?? '-',
        ),
        image: "assets/images/details/Case.svg",
        title: FormatHelper.capitalize("${S.of(context).jobTitle}: "),
      ),
      SizedBox(height: 11.sp),

      // ✅ FIXED: Mobile/Tablet phone display
      CustomRowDetailsMaster(
        data: _formatPhoneNumber(provider['mobilePhone']),
        image: "assets/images/details/Phone Rounded.svg",
        title: FormatHelper.capitalize("${S.of(context).phone}: "),
      ),

      SizedBox(height: 12.sp),
      CustomRowDetailsMaster(
        data: FormatHelper.capitalize(
          requestModel.currentApprovalCycle?.isEmpty ?? true
              ? (isArabic ? "لا يحتاج إلى موافقة" : "Doesn't Need Approval")
              : (isArabic ? "يحتاج إلى موافقة" : "Need Approval"),
        ),
        image: "assets/services_module/approval_icons.svg",
        title: FormatHelper.capitalize("${S.of(context).approvals}: "),
      ),
    ],
  );

  if (isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        leftColumn,
        SizedBox(height: 10.sp),
        rightColumn,
      ],
    );
  } else {
    var isTablet = MediaQuery.sizeOf(context).width >= 600 &&
        MediaQuery.sizeOf(context).width < 900;

    if (isTablet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomRowDetailsMaster(
                  data: FormatHelper.capitalize(
                    isArabic
                        ? "${provider['firstNameInArabic'] ?? '-'} ${provider['lastNameInArabic'] ?? '-'}"
                        : "${provider['firstName'] ?? '-'} ${provider['lastName'] ?? '-'}",
                  ),
                  image: "assets/images/details/User Plus.svg",
                  title: FormatHelper.capitalize("${S.of(context).serviceProvider}: "),
                  imagePerson: (provider['gender'] ?? 'male') == "male"
                      ? "assets/male.svg"
                      : "assets/female.svg",
                ),
                SizedBox(height: 6.sp),
                CustomRowDetailsMaster(
                  data: FormatHelper.capitalize(provider['email'] ?? '-'),
                  image: "assets/images/details/sms.svg",
                  title: FormatHelper.capitalize("${S.of(context).email}: "),
                ),
                SizedBox(height: 12.sp),
                CustomRowDetailsMaster(
                  data:
                  "${FormatHelper.capitalize(requestModel.currentDurationOfServices ?? '')} ${getLocalizedDurationUnit(context, durationUnit)}",
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
                    isArabic ? provider['titleInArabic'] ?? '-' : provider['title'] ?? '-',
                  ),
                  image: "assets/images/details/Case.svg",
                  title: FormatHelper.capitalize("${S.of(context).jobTitle}: "),
                ),
                SizedBox(height: 11.sp),

                // ✅ FIXED: Tablet phone display
                CustomRowDetailsMaster(
                  data: _formatPhoneNumber(provider['mobilePhone']),
                  image: "assets/images/details/Phone Rounded.svg",
                  title: FormatHelper.capitalize("${S.of(context).phone}: "),
                ),

                SizedBox(height: 12.sp),
                CustomRowDetailsMaster(
                  data: FormatHelper.capitalize(
                    requestModel.currentApprovalCycle?.isEmpty ?? true
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
    } else {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomRowDetailsMaster(
                  data: FormatHelper.capitalize(
                    isArabic
                        ? "${provider['firstNameInArabic'] ?? '-'} ${provider['lastNameInArabic'] ?? '-'}"
                        : "${provider['firstName'] ?? '-'} ${provider['lastName'] ?? '-'}",
                  ),
                  image: "assets/images/details/User Plus.svg",
                  title: FormatHelper.capitalize("${S.of(context).serviceProvider}: "),
                  imagePerson: (provider['gender'] ?? 'male') == "male"
                      ? "assets/male.svg"
                      : "assets/female.svg",
                ),
              ),
              Expanded(
                child: CustomRowDetailsMaster(
                  data: FormatHelper.capitalize(provider['email'] ?? '-'),
                  image: "assets/images/details/sms.svg",
                  title: FormatHelper.capitalize("${S.of(context).email}: "),
                ),
              ),
              Expanded(
                child: CustomRowDetailsMaster(
                  data: FormatHelper.capitalize(
                    requestModel.currentApprovalCycle?.isEmpty ?? true
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
                    isArabic ? provider['titleInArabic'] ?? '-' : provider['title'] ?? '-',
                  ),
                  image: "assets/images/details/Case.svg",
                  title: FormatHelper.capitalize("${S.of(context).jobTitle}: "),
                ),
              ),
              Expanded(
                // ✅ FIXED: Desktop phone display
                child: CustomRowDetailsMaster(
                  data: _formatPhoneNumber(provider['mobilePhone']),
                  image: "assets/images/details/Phone Rounded.svg",
                  title: FormatHelper.capitalize("${S.of(context).phone}: "),
                ),
              ),
              Expanded(
                child: CustomRowDetailsMaster(
                  data:
                  "${FormatHelper.capitalize(requestModel.currentDurationOfServices ?? '')} ${getLocalizedDurationUnit(context, durationUnit)}",
                  image: "assets/images/details/Group 1000004482.svg",
                  title: FormatHelper.capitalize("${S.of(context).durationOfService}: "),
                ),
              ),
            ],
          )
        ],
      );
    }
  }
}

class CustomRowDetailsMaster extends StatelessWidget {
  const CustomRowDetailsMaster({
    super.key,
    required this.image,
    required this.title,
    required this.data,
    this.imagePerson,
    this.unit,
  });

  final String image;
  final String title;
  final String data;
  final String? imagePerson;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          image,
          semanticsLabel: 'Icon',
          width: 17.sp,
          height: 17.sp,
          fit: BoxFit.fill,
        ),
        SizedBox(width: 4.sp),
        Text(
          FormatHelper.capitalize(title),
          style: isMobile
              ? AppTextStyles.font12BlackCairoRegular.copyWith(
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.secondaryText
                : AppColors.grey,
          )
              : AppTextStyles.font14BlackCairoRegular.copyWith(
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.secondaryText
                : AppColors.grey,
          ),
        ),
        if (imagePerson != null)
          Row(
            children: [
              ClipOval(
                child: SvgPicture.asset(
                  imagePerson!,
                  fit: BoxFit.cover,
                  width: 28.w,
                  height: 28.h,
                  semanticsLabel: 'Dart Logo',
                ),
              ),
              SizedBox(width: 5.w),
            ],
          ),
        Row(
          children: [
            Text(
              FormatHelper.capitalize(data),
              style: isMobile
                  ? AppTextStyles.font12BlackCairoRegular.copyWith(
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.blackButton
                    : AppColors.white,
              )
                  : AppTextStyles.font14BlackCairoRegular.copyWith(
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.blackButton
                    : AppColors.white,
              ),
            ),
            if (unit != null && unit!.isNotEmpty) ...[
              SizedBox(width: 2.w),
              Text(
                FormatHelper.capitalize(unit!),
                style: isMobile
                    ? AppTextStyles.font12BlackCairoRegular.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.blackButton
                      : AppColors.white,
                )
                    : AppTextStyles.font14BlackCairoRegular.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.blackButton
                      : AppColors.white,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
