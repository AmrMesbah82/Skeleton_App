import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/helper/services_management/circle_progress.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';

class RequestsListWidget extends StatelessWidget {
  final bool isLoadingRequests;
  final List<Map<String, dynamic>> displayedItems;
  final Map<String, String> stateTranslationsAr;
  final Map<String, String> enToArDepartments;
  final Function(Map<String, dynamic>)? onItemTap;

  const RequestsListWidget({
    Key? key,
    required this.isLoadingRequests,
    required this.displayedItems,
    required this.stateTranslationsAr,
    required this.enToArDepartments,
    this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoadingRequests) {
      return _buildLoadingState(context);
    }

    if (displayedItems.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildRequestsList(context);
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: CircleProgress(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64.sp,
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.secondaryText
                : AppColors.grey,
          ),
          SizedBox(height: 16.sp),
          Text(
            isArabic ? "لا توجد طلبات" : "No requests found",
            style: AppTextStyles.font16BlackMediumCairo.copyWith(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.secondaryText
                  : AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsList(BuildContext context) {
    return ListView.builder(
      itemCount: displayedItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return RequestItemCard(
          item: displayedItems[index],
          stateTranslationsAr: stateTranslationsAr,
          enToArDepartments: enToArDepartments,
          onTap: onItemTap,
        );
      },
    );
  }
}

class RequestItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final Map<String, String> stateTranslationsAr;
  final Map<String, String> enToArDepartments;
  final Function(Map<String, dynamic>)? onTap;

  const RequestItemCard({
    Key? key,
    required this.item,
    required this.stateTranslationsAr,
    required this.enToArDepartments,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rawState = item["status"]?.toString() ?? '';
    final state = rawState.trim().toLowerCase();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final lightMode = Theme.of(context).brightness == Brightness.light;

    final statusColor = _getStatusColor(state);

    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(item);
        }
      },
      child: Stack(
        alignment: AlignmentGeometry.topRight,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 6.sp),
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: lightMode
                  ? AppColors.white
                  : AppColors.chatBackground,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildServiceNameAndStatus(context, isArabic, lightMode, state, statusColor),
                SizedBox(height: 6.sp),
                _buildServiceRequester(context, isArabic, lightMode),
                SizedBox(height: 6.sp),
                _buildDepartment(context, isArabic, lightMode),
                SizedBox(height: 6.sp),
                _buildServiceProvider(context, isArabic, lightMode),
                _buildRequestDate(context, lightMode, state, statusColor),
              ],
            ),
          ),
          Positioned(
            top: 10.h,
            right: isArabic ? null :  10.w,
            left: isArabic ?  10.w : null,
            child: Row(
              children: [
                Text(
                  "${S.of(context).Status}: ",
                  style: AppTextStyles.font8SecondaryBlackRegularCairo.copyWith(
                    color: lightMode
                        ? AppColors.secondaryText
                        : AppColors.grey,
                  ),
                ),
                Text(
                  isArabic
                      ? (stateTranslationsAr[state] ?? state)
                      : FormatHelper.capitalize(state),
                  style: AppTextStyles.font8SecondaryBlackRegularCairo.copyWith(
                    color: statusColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Color _getStatusColor(String state) {
    return switch (state) {
      'pending' => const Color(0XFFFF814A),
      'done' => const Color(0xff4BB609),
      'approved' => AppColors.green!,
      'rejected' => const Color(0xffDF1C1C),
      'cancel' => const Color(0xFFDF0C0C),
      'inprogress' => const Color(0xffE5B800),
      'breached sla' || 'branchsla' => const Color(0xFFB00020),
      _ => AppColors.grey!,
    };
  }

  Widget _buildServiceNameAndStatus(BuildContext context, bool isArabic, bool lightMode, String state, Color statusColor) {
    return Row(
      children: [
        Container(
          width: 30.sp,
          height: 30.sp,
          decoration: BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: SvgPicture.asset(
            "assets/images/details/Group (1).svg",
            width: 12.sp,
            height: 12.sp,
            fit: BoxFit.scaleDown,
          ),
        ),
        SizedBox(width: 5.sp),
        Expanded(
          child: Row(
            children: [
              Text(
                FormatHelper.capitalize(isArabic
                    ? item['serviceNameArabic'] ?? ''
                    : item['serviceName'] ?? ''),
                style: AppTextStyles.font12BlackMediumCairo.copyWith(
                  color: lightMode
                      ? AppColors.blackButton
                      : AppColors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),

            ],
          ),
        ),

      ],
    );
  }

  Widget _buildServiceRequester(BuildContext context, bool isArabic, bool lightMode) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/images/details/User Plus.svg",
          width: 12.sp,
          height: 12.sp,
          fit: BoxFit.scaleDown,
        ),
        SizedBox(width: 6.sp),
        Text(
          "${FormatHelper.capitalize(S.of(context).ServiceRequestor)}: ",
          style: AppTextStyles.font10BlackCairoRegular.copyWith(
            color: lightMode
                ? AppColors.secondaryText
                : AppColors.grey,
          ),
        ),
        ClipOval(
          child: SvgPicture.asset(
            item["gender"] == "male"
                ? "assets/male.svg"
                : "assets/female.svg",
            width: 20.sp,
            height: 20.sp,
            fit: BoxFit.scaleDown,
          ),
        ),
        SizedBox(width: 4.sp),
        Expanded(
          child: Text(
            FormatHelper.capitalize(isArabic
                ? "${item["firstNameRequesterArabic"] ?? ''} ${item["lastNameRequesterArabic"] ?? ''}"
                : "${item["firstNameRequester"] ?? ''} ${item["lastNameRequester"] ?? ''}"),
            style: AppTextStyles.font10BlackCairoRegular.copyWith(
              color: lightMode
                  ? AppColors.blackButton
                  : AppColors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDepartment(BuildContext context, bool isArabic, bool lightMode) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/images/details/Case.svg",
          width: 12.sp,
          height: 12.sp,
          fit: BoxFit.scaleDown,
          color: AppColors.secondaryText,
        ),
        SizedBox(width: 6.sp),
        Text(
          FormatHelper.capitalize("${S.of(context).Department}: "),
          style: AppTextStyles.font10BlackCairoRegular.copyWith(
            color: lightMode
                ? AppColors.secondaryText
                : AppColors.grey,
          ),
        ),
        SizedBox(width: 2.sp),
        Text(
          FormatHelper.capitalize(isArabic
              ? enToArDepartments[item["department"]] ?? item["department"]
              : item["department"]),
          style: AppTextStyles.font10BlackCairoRegular.copyWith(
            color: lightMode
                ? AppColors.blackButton
                : AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceProvider(BuildContext context, bool isArabic, bool lightMode) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/images/details/User Plus.svg",
          width: 12.sp,
          height: 12.sp,
          fit: BoxFit.scaleDown,
        ),
        SizedBox(width: 6.sp),
        Text(
          FormatHelper.capitalize("${S.of(context).serviceProvider}: "),
          style: AppTextStyles.font10BlackCairoRegular.copyWith(
            color: lightMode
                ? AppColors.secondaryText
                : AppColors.grey,
          ),
        ),
        ClipOval(
          child: SvgPicture.asset(
            item["gender"] == "male"
                ? "assets/male.svg"
                : "assets/female.svg",
            width: 20.sp,
            height: 20.sp,
            fit: BoxFit.scaleDown,
          ),
        ),
        SizedBox(width: 4.sp),
        Expanded(
          child: Text(
            FormatHelper.capitalize(isArabic
                ? "${item["firstNameProviderArabic"] ?? ''} ${item["lastNameProviderArabic"] ?? ''}"
                : "${item["firstNameProvider"] ?? ''} ${item["lastNameProvider"] ?? ''}"),
            style: AppTextStyles.font10BlackCairoRegular.copyWith(
              color: lightMode
                  ? AppColors.blackButton
                  : AppColors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildRequestDate(BuildContext context, bool lightMode,String state, Color statusColor) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

        Spacer(),
        Text(
          FormatHelper.capitalize("${S.of(context).RequestedDate}: "),
          style: AppTextStyles.font8SecondaryBlackRegularCairo.copyWith(
            color: lightMode
                ? AppColors.secondaryText
                : AppColors.grey,
          ),
        ),
        Text(
          item["requestDate"] != null
              ? _formatDate(item["requestDate"], Localizations.localeOf(context).languageCode)
              : 'N/A',
          style: AppTextStyles.font8SecondaryBlackRegularCairo.copyWith(
            color: lightMode
                ? AppColors.blackButton
                : AppColors.white,
          ),
        ),

      ],
    );
  }
  String _formatDate(String? dateString, String locale) {
    if (dateString == null || dateString.isEmpty) {
      return 'N/A';
    }

    try {
      DateTime date;

      // Handle different date formats
      if (dateString.contains(' - ')) {
        // Format like "2025-08-18 - 21:54"
        String datePart = dateString.split(' - ')[0];
        date = DateTime.parse(datePart);
      } else if (dateString.contains('T')) {
        // ISO format like "2025-08-18T21:54:00"
        date = DateTime.parse(dateString);
      } else if (dateString.contains(' ')) {
        // Format like "2025-08-18 21:54:00"
        String datePart = dateString.split(' ')[0];
        date = DateTime.parse(datePart);
      } else {
        // Simple date format like "2025-08-18"
        date = DateTime.parse(dateString);
      }

      if (locale == 'ar') {
        // Arabic month names
        const arabicMonths = [
          'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
          'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
        ];
        return '${date.day} ${arabicMonths[date.month - 1]} ${date.year}';
      } else {
        // English format: "18 Aug 2023"
        const englishMonths = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        return '${date.day} ${englishMonths[date.month - 1]} ${date.year}';
      }
    } catch (e) {
      // If all parsing fails, try to extract just the date part manually
      if (dateString.contains('-')) {
        List<String> parts = dateString.split('-');
        if (parts.length >= 3) {
          try {
            int year = int.parse(parts[0]);
            int month = int.parse(parts[1]);
            int day = int.parse(parts[2].split(' ')[0]); // Remove time part if exists

            if (locale == 'ar') {
              const arabicMonths = [
                'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
                'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
              ];
              return '$day ${arabicMonths[month - 1]} $year';
            } else {
              const englishMonths = [
                'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
              ];
              return '$day ${englishMonths[month - 1]} $year';
            }
          } catch (e2) {
            return dateString; // Return original if manual parsing also fails
          }
        }
      }
      return dateString; // Return original string if all parsing fails
    }
  }
}
