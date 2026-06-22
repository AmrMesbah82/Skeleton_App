import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/helper_method.dart' hide getLocalizedDurationUnit;
import 'package:demo_app/generated/l10n.dart';
import 'package:shimmer/shimmer.dart';
import 'package:demo_app/core/enumeration/enum.dart' as FormatHelper;
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/approval.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/responsive_text.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/info_text.dart';

class ServiceInfoCardWidget extends StatefulWidget {
  final ServicesHistoryModel createServicesModel;

  const ServiceInfoCardWidget({
    required this.createServicesModel,
    super.key,
  });

  @override
  State<ServiceInfoCardWidget> createState() => _ServiceInfoCardWidgetState();
}

class _ServiceInfoCardWidgetState extends State<ServiceInfoCardWidget> {
  Future<Map<String, dynamic>?>? _providerFuture;

  final Map<String, String> enToArDepartments = {
    "Executive": "الإدارة التنفيذية",
    "Customer Support": "دعم العملاء",
    "Finance": "المالية",
    "Operations": "العمليات",
    "Information Technology": "تقنية المعلومات",
    "Human Resources": "الموارد البشرية",
    "Marketing": "التسويق",
    "Sales": "المبيعات",
    "Data Management": "إدارة البيانات",
    "Compliance & Legal": "الامتثال والشؤون القانونية",
    "Software": "البرمجيات",
  };

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isPhone;
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(15.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: lightMode ? AppColors.white : AppColors.chatBackground,
          ),
          child: Column(
            children: [
              _buildHeaderSection(context, isMobile, lightMode, isArabic),
              isMobile ? SizedBox(height: 18.sp) : SizedBox(height: 18.sp),
              _buildProviderSection(context, isMobile),
              SizedBox(height: 20.sp),
              _buildDepartmentSection(context, isMobile, lightMode, isArabic),
              widget.createServicesModel.currentSelectDepartment.isEmpty
                  ? SizedBox()
                  : SizedBox(height: 20.sp),
              _buildApprovalCycleSection(context, isMobile, lightMode),
            ],
          ),
        ),
        _buildDateBadge(context, isMobile, lightMode),
      ],
    );
  }

  Widget _buildHeaderSection(BuildContext context, bool isMobile, bool lightMode, bool isArabic) {
    return Row(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        _buildServiceImage(context, isMobile, lightMode),
        SizedBox(width: 10.w),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isMobile
                  ? Text(
                isArabic
                    ? widget.createServicesModel.currentServiceDescriptionArabic
                    : widget.createServicesModel.currentServiceDescriptionEnglish,
                style: AppTextStyles.font14BlackCairoRegular.copyWith(
                  color: lightMode ? AppColors.blackButton : AppColors.white,
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/services_module/descrption_icons.svg",
                        width: 17.w,
                        height: 17.h,
                        color: AppColors.secondaryText.withOpacity(.4),
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 3.sp),
                      Text(
                        "${S.of(context).serviceDescription}",
                        style: AppTextStyles.font14BlackCairoRegular.copyWith(
                          color: lightMode ? AppColors.secondaryText : AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    FormatHelper.capitalize(
                      Localizations.localeOf(context).languageCode == 'ar'
                          ? widget.createServicesModel.currentServiceDescriptionArabic ?? ''
                          : widget.createServicesModel.currentServiceDescriptionEnglish ?? '',
                    ),
                    style: AppTextStyles.font13SecondaryBlackCairo.copyWith(
                      height: 1.5,
                      color: lightMode ? AppColors.blackButton : AppColors.white,
                    ),
                    textAlign: TextAlign.start,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceImage(BuildContext context, bool isMobile, bool lightMode) {
    return Container(
      width: isMobile ? 50.sp : !isTabletLandscape(context) ? 80.sp : 100.sp,
      height: isMobile ? 50.sp : !isTabletLandscape(context) ? 80.sp : 100.sp,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: lightMode ? AppColors.background : AppColors.background,
      ),
      child: (widget.createServicesModel.image_Url != null && widget.createServicesModel.currentImageUrl.isNotEmpty)
          ? ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: CachedNetworkImage(
          imageUrl: widget.createServicesModel.currentImageUrl,
          width: 40.sp,
          height: 40.sp,
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: lightMode
                ? AppColors.secondaryText.withOpacity(0.3)
                : AppColors.grey.withOpacity(0.3),
            highlightColor: lightMode
                ? AppColors.background
                : AppColors.background.withOpacity(0.5),
            child: Container(
              width: 40.sp,
              height: 40.sp,
              decoration: BoxDecoration(
                color: lightMode
                    ? AppColors.secondaryText.withOpacity(0.1)
                    : AppColors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          errorWidget: (context, url, error) {
            return SvgPicture.asset(
              'assets/svgItemCard.svg',
              width: 40.sp,
              height: 40.sp,
              color: lightMode ? AppColors.secondaryText : AppColors.grey,
              fit: BoxFit.fill,
            );
          },
        ),
      )
          : Center(
        child: SvgPicture.asset(
          "assets/images/headPhone.svg",
          width: isMobile ? 35.w : 50.w,
          height: isMobile ? 35.h : 50.h,
          color: lightMode ? AppColors.secondaryText : AppColors.grey,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildProviderSection(BuildContext context, bool isMobile) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _providerFuture ??= ServicesManagerCubit.get(context).computeProvider(
        providerServices: widget.createServicesModel.currentProviderServices!,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildProviderShimmer(context, isMobile);
        } else if (snapshot.hasData && snapshot.data != null) {
          final provider = snapshot.data!;
          return buildProviderServiceDetailsServices(
            owningDepartment: widget.createServicesModel.currentDepartmentRequester,
            context: context,
            durationUnit: FormatHelper.capitalize(
              getLocalizedDurationUnit(
                context,
                widget.createServicesModel.currentSelectedDurationUnit,
              ),
            ),
            provider: provider,
            requestModel: widget.createServicesModel,
          );
        } else {
          return Center(child: Text(S.of(context).Noproviderdatafound));
        }
      },
    );
  }

  Widget _buildProviderShimmer(BuildContext context, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shimmerPlaceholder(context: context, width: 200, height: 20),
            SizedBox(height: 10.h),
            _shimmerPlaceholder(context: context, width: 150, height: 20),
            SizedBox(height: 10.h),
            _shimmerPlaceholder(context: context, width: 180, height: 20),
          ],
        ),
        isMobile ? const SizedBox() : SizedBox(width: MediaQuery.sizeOf(context).width * .05),
        if (!isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerPlaceholder(context: context, width: 160, height: 20),
              SizedBox(height: 10.h),
              _shimmerPlaceholder(context: context, width: 140, height: 20),
              SizedBox(height: 10.h),
              _shimmerPlaceholder(context: context, width: 180, height: 20),
            ],
          ),
      ],
    );
  }

  Widget _shimmerPlaceholder({required BuildContext context, required double width, required double height}) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    return Shimmer.fromColors(
      baseColor: lightMode
          ? AppColors.secondaryText.withOpacity(0.3)
          : AppColors.grey.withOpacity(0.3),
      highlightColor: lightMode ? AppColors.background : AppColors.background.withOpacity(0.5),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: lightMode
              ? AppColors.secondaryText.withOpacity(0.1)
              : AppColors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }

  Widget _buildDepartmentSection(BuildContext context, bool isMobile, bool lightMode, bool isArabic) {
    if (widget.createServicesModel.currentSelectDepartment.isEmpty) {
      return SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/details/Buildings.svg",
              width: 20.sp,
              height: 20.sp,
              fit: BoxFit.fill,

            ),
            SizedBox(width: 6.sp),
            Text(
              "${S.of(context).limitServiceAvailability}:",
              style: isMobile
                  ? AppTextStyles.font12BlackCairoRegular.copyWith(
                color: lightMode ? AppColors.secondaryText : AppColors.grey,
              )
                  : AppTextStyles.font14BlackCairoRegular.copyWith(
                color: lightMode ? AppColors.secondaryText : AppColors.grey,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.sp),
        Wrap(
          spacing: 8.sp,
          runSpacing: 8.sp,
          children: widget.createServicesModel.currentSelectDepartment.map((departmentRaw) {
            String departmentKey = enToArDepartments.entries
                .firstWhere(
                  (entry) => entry.value == departmentRaw || entry.key == departmentRaw,
              orElse: () => MapEntry(departmentRaw, departmentRaw),
            )
                .key;

            final departmentText = isArabic ? enToArDepartments[departmentKey] ?? departmentKey : departmentKey;

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: lightMode ? AppColors.background : AppColors.background,
              ),
              child: Text(
                FormatHelper.capitalize(departmentText),
                style: isMobile
                    ? AppTextStyles.font12BlackCairoRegular.copyWith(
                  color: lightMode ? AppColors.blackButton : AppColors.white,
                )
                    : AppTextStyles.font14BlackCairoRegular.copyWith(
                  color: lightMode ? AppColors.blackButton : AppColors.white,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildApprovalCycleSection(BuildContext context, bool isMobile, bool lightMode) {
    if (widget.createServicesModel.currentApprovalCycle.isEmpty) {
      return SizedBox();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "${S.of(context).approvalCycle}: ",
              style: AppTextStyles.font14BlackCairoRegular.copyWith(
                color: lightMode ? AppColors.secondaryText : AppColors.grey,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.sp),
        isMobile
            ? buildApprovalCycle(context, widget.createServicesModel.currentApprovalCycle!, "assets/male.svg")
            : approvalCycleViewTablet(widget.createServicesModel.currentApprovalCycle!, context),
      ],
    );
  }

  Widget _buildDateBadge(BuildContext context, bool isMobile, bool lightMode) {
    return Padding(
      padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 10.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "${S.of(context).creationDate}: ",
            style: isMobile
                ? AppTextStyles.font10BlackCairoRegular.copyWith(
              color: lightMode ? AppColors.secondaryText : AppColors.grey,
            )
                : AppTextStyles.font12BlackCairoRegular.copyWith(
              color: lightMode ? AppColors.secondaryText : AppColors.grey,
            ),
          ),
          Text(
            DateFormat('dd MMM yyyy').format(
              widget.createServicesModel.timestamps.isNotEmpty
                  ? DateTime.fromMillisecondsSinceEpoch(widget.createServicesModel.timestamps.first)
                  : DateTime.now(),
            ),
            style: isMobile
                ? AppTextStyles.font10BlackCairoRegular.copyWith(
              color: lightMode ? AppColors.blackButton : AppColors.white,
            )
                : AppTextStyles.font12BlackCairoRegular.copyWith(
              color: lightMode ? AppColors.blackButton : AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
