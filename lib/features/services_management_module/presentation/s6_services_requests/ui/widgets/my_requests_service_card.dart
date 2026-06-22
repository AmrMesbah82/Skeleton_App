import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/info_text.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/reuse_text.dart';

import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/controller/create_services_helper.dart';

class CustomServiceCardMyRequest extends StatefulWidget {
  const CustomServiceCardMyRequest({
    required this.provider,
    required this.title,
    required this.jobTitle,
    required this.status,
    required this.dateRequest,
    required this.lastUpdate,
    required this.pointOfContact,
    super.key,
  });

  final ServicesHistoryModel provider;
  final String title;
  final String dateRequest;
  final String pointOfContact;
  final String jobTitle;
  final String status;
  final String lastUpdate;

  @override
  State<CustomServiceCardMyRequest> createState() => _CustomServiceCardMyRequestState();
}

class _CustomServiceCardMyRequestState extends State<CustomServiceCardMyRequest> {
  String owningDepartment = '-';
  String durationServices = '-';
  String displayServiceName = '-';
  String serviceImageUrl = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServiceDetails();
  }

  Future<void> _loadServiceDetails() async {
    // Get current email requester from the model
    final emailRequester = widget.provider.email_Requester.isNotEmpty
        ? widget.provider.currentEmailRequester
        : '';

    // Get current parent service ID from the model
    final parentServiceId = widget.provider.parent_Service_Id.isNotEmpty
        ? widget.provider.currentParentServiceId
        : '';

    if (parentServiceId.isEmpty || emailRequester.isEmpty) {
      setState(() {
        isLoading = false;
        displayServiceName = widget.title; // Fallback to passed title
      });
      return;
    }

    // ✅ CRITICAL FIX: Get controllers
    final employeeController = Get.find<MainCoreEmployeeController>();
    final departmentController = Get.find<MainCoreDepartmentController>();

    // Fetch service details from CreateServices
    final result = await CreateServicesHelper.getServiceDetailsFromCreateServices(
      parentServiceId: parentServiceId,
      emailRequester: emailRequester,
    );

    if (mounted) {
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';

      setState(() {
        // ========== OWNING DEPARTMENT (FROM CONTROLLERS) ==========
        // ✅ First, try to get from CreateServices result
        String owningDeptFromResult = result['owningDepartment'] ?? '-';

        if (owningDeptFromResult == '-' || owningDeptFromResult.isEmpty) {
          // ✅ Fallback: Get from employee's department ID using controller
          final employee = employeeController.getLocaleEmployee(emailRequester);
          if (employee != null && employee.departmentId != null) {
            owningDepartment = departmentController.getDepartmentName(
              employee.departmentId!,
              isArabic ? false : true, // true for English, false for Arabic
            );
          } else {
            owningDepartment = '-';
          }
        } else {
          owningDepartment = owningDeptFromResult;
        }

        // ========== SERVICE NAME (FROM CONTROLLERS OR RESULT) ==========
        String serviceNameFromResult = isArabic
            ? (result['Service_Name_Arabic'] ?? '-')
            : (result['Service_Name_English'] ?? '-');

        if (serviceNameFromResult == '-' || serviceNameFromResult.isEmpty) {
          // ✅ Fallback: Use from widget.provider
          displayServiceName = isArabic
              ? (widget.provider.service_Name_Arabic.isNotEmpty
              ? widget.provider.currentServiceNameArabic
              : widget.title)
              : (widget.provider.service_Name_English.isNotEmpty
              ? widget.provider.currentServiceNameEnglish
              : widget.title);
        } else {
          displayServiceName = serviceNameFromResult;
        }

        // ========== DURATION (FROM RESULT OR FALLBACK) ==========
        final duration = result['duration'] ?? '-';
        final unit = result['unit'] ?? '-';

        if (duration != '-' && unit != '-' && duration.isNotEmpty && unit.isNotEmpty) {
          final localizedUnit = _getLocalizedDurationUnit(unit, double.tryParse(duration) ?? 1);
          durationServices = '$duration $localizedUnit';
        } else {
          // Fallback to duration from ServicesHistoryModel
          if (widget.provider.duration_Of_Services.isNotEmpty &&
              widget.provider.selected_Duration_Unit.isNotEmpty) {
            final fallbackDuration = widget.provider.currentDurationOfServices;
            final fallbackUnit = widget.provider.currentSelectedDurationUnit;

            if (fallbackDuration.isNotEmpty && fallbackUnit.isNotEmpty) {
              final localizedUnit = _getLocalizedDurationUnit(
                  fallbackUnit,
                  double.tryParse(fallbackDuration) ?? 1
              );
              durationServices = '$fallbackDuration $localizedUnit';
            } else {
              durationServices = '-';
            }
          } else {
            durationServices = '-';
          }
        }

        // ========== SERVICE IMAGE ==========
        serviceImageUrl = widget.provider.image_Url.isNotEmpty
            ? widget.provider.currentImageUrl
            : '';

        isLoading = false;
      });
    }
  }

  String _getLocalizedDurationUnit(String rawUnit, double quantity) {
    final localizer = S.of(context);
    final k = rawUnit.trim().toLowerCase();
    final isPlural = quantity != 1;

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
        return isPlural ? localizer.hours : localizer.hour;
      case 'minutes':
        return isPlural ? localizer.minutes : localizer.minute;
      case 'seconds':
        return isPlural ? localizer.seconds : localizer.second;
      case 'week':
        return isPlural ? localizer.weeks : localizer.week;
      case 'day':
        return isPlural ? localizer.days : localizer.day;
      case 'month':
        return isPlural ? localizer.months : localizer.month;
      case 'year':
        return isPlural ? localizer.years : localizer.year;
      default:
        return rawUnit;
    }
  }

  Color _getBorderColor(String state) {
    switch (state.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF814A);
      case 'done':
      case 'approved':
        return const Color(0xFF4BB609);
      case 'rejected':
      case 'cancel':
        return const Color(0xFFDF0C0C);
      case 'in progress':
        return AppColors.yellow;
      case 'breached sla':
        return const Color(0xFFB00020);
      default:
        return AppColors.lightGrey!;
    }
  }

  String getLocalizedStatus(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return S.of(context).status_pending;
      case 'approved':
        return S.of(context).status_approved;
      case 'done':
        return S.of(context).status_done;
      case 'rejected':
        return S.of(context).status_rejected;
      case 'cancel':
        return S.of(context).status_cancel;
      case 'inprogress':
        return S.of(context).status_inprogress;
      case 'breached sla':
        return S.of(context).status_breached;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;

    return Container(
      width: 321.sp,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(right: 15.sp, left: 15.sp, top: 15.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image and Name Row
            // Service Image and Name Row
            Row(
              children: [
                Container(
                  width: 40.sp,
                  height: 40.sp,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: (serviceImageUrl.isNotEmpty)
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: CachedNetworkImage(
                      imageUrl: serviceImageUrl,
                      width: 40.sp,
                      height: 40.sp,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppColors.secondaryText.withOpacity(.3),
                        highlightColor: AppColors.background.withOpacity(.5),
                        child: Container(
                          width: 40.sp,
                          height: 40.sp,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryText.withOpacity(.5),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        return SvgPicture.asset(
                          'assets/svgItemCard.svg',
                          width: 20.sp,
                          height: 20.sp,
                          color: AppColors.secondaryText,
                          fit: BoxFit.scaleDown,
                        );
                      },
                    ),
                  )
                      : SvgPicture.asset(
                    "assets/images/headPhone.svg",
                    width: 20.sp,
                    height: 20.sp,
                    color: AppColors.secondaryText,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                SizedBox(width: 8.sp),
                // ✅ FIXED: Use Expanded instead of fixed-width SizedBox
                Expanded(
                  child: isLoading
                      ? Shimmer.fromColors(
                    baseColor: AppColors.secondaryText.withOpacity(.3),
                    highlightColor: AppColors.background.withOpacity(.5),
                    child: Container(
                      height: 16.sp,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryText.withOpacity(.5),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  )
                      : Text(
                    FormatHelper.capitalize(displayServiceName),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppTextStyles.font16BlackMediumCairo.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.sp),

            // Requested Date
            textCorner(
              image: "assets/images/details/Calendar.svg",
              label: "${S.of(context).requestedDate}: ",
              content: widget.dateRequest,
              context: context,
            ),
            SizedBox(height: 11.sp),

            // Owning Department (From CreateServices via emailRequester)
            isLoading
                ? _buildLoadingRow("assets/own.svg", S.of(context).OwningDepartment)
                : textCorner(
              image: "assets/own.svg",
              label: "${S.of(context).OwningDepartment}: ",
              content: owningDepartment,
              context: context,
            ),

            SizedBox(height: 11.sp),

            // Service Provider (Point of Contact)
            textCorner(
              image: "assets/images/details/User Plus.svg",
              label: "${S.of(context).serviceProvider}: ",
              content: widget.pointOfContact,
              context: context,
            ),
            SizedBox(height: 11.sp),

            // Job Title
            textCorner(
              image: "assets/images/details/Case.svg",
              label: "${S.of(context).jobTitle}: ",
              content: widget.jobTitle,
              context: context,
            ),
            SizedBox(height: 11.sp),

            // Duration (From CreateServices - no brackets)
            isLoading
                ? _buildLoadingRow("assets/images/details/Group 1000004482.svg", S.of(context).durationOfService)
                : textCorner(
              image: "assets/images/details/Group 1000004482.svg",
              label: "${S.of(context).durationOfService}: ",
              content: durationServices,
              context: context,
            ),

            SizedBox(height: 11.sp),

            // Status
            Row(
              children: [
                SvgPicture.asset(
                  "assets/status.svg",
                  width: 11.sp,
                  height: 11.sp,
                  fit: BoxFit.fill,
                ),
                SizedBox(width: 8.sp),
                Text(
                  FormatHelper.capitalize("${S.of(context).status}: "),
                  style: AppTextStyles.font14BlackCairoRegular.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  FormatHelper.capitalize(getLocalizedStatus(context, widget.status)),
                  style: AppTextStyles.font14BlackCairoRegular.copyWith(
                    color: _getBorderColor(widget.status),
                  ),
                ),
              ],
            ),
            SizedBox(height: 11.sp),

            // Last Update
            textCorner(
              image: "assets/images/details/Calendar.svg",
              label: "${S.of(context).lastUpdate}: ",
              content: widget.lastUpdate,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingRow(String iconPath, String label) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 11.sp,
          height: 11.sp,
          fit: BoxFit.fill,
        ),
        SizedBox(width: 8.sp),
        Text(
          "$label: ",
          style: AppTextStyles.font14BlackCairoRegular.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        SizedBox(
          width: 50.sp,
          height: 10.sp,
          child: Shimmer.fromColors(
            baseColor: AppColors.secondaryText.withOpacity(.3),
            highlightColor: AppColors.background.withOpacity(.5),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondaryText.withOpacity(.5),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
