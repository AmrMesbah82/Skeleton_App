import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/services_permissions_sections.dart';
import 'package:lottie/lottie.dart';
import 'package:demo_app/core/widgets/circle_progress.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/controller/my_request_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/controller/my_request_state.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/custom_multi.dart';
import 'package:demo_app/core/widgets/services_management/custom_filter.dart';

import 'package:demo_app/core/custom/34-custom_gridview_with_animation.dart';
import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import 'package:demo_app/core/helper/cross_axis_count_helper.dart';
import 'package:demo_app/core/widgets/app_search_text_field.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/modules_enum.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/widgets/services_management/custom_grid_view.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/helper/services_management/sort.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/filter.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/pages/my_request_details_toggle.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/14-custom_filter_icon.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/my_requests_service_card.dart';

class MyRequestServices extends StatelessWidget {
  const MyRequestServices({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyRequestCubit(context)..loadAllData(),
      child: const MyRequestServicesView(),
    );
  }
}

class MyRequestServicesView extends StatefulWidget {
  const MyRequestServicesView({super.key});

  @override
  State<MyRequestServicesView> createState() => _MyRequestServicesViewState();
}

class _MyRequestServicesViewState extends State<MyRequestServicesView> {
  @override
  void dispose() {
    // Cubit is disposed by BlocProvider
    super.dispose();
  }

  bool isTabletLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return size.width >= 600 && isLandscape;
  }

  // Helper method to extract abbreviation from job title
  String _getDisplayJobTitle(String? titleEn, String? titleAr, bool isArabic) {
    final titleEnTrimmed = (titleEn ?? '').trim();
    final titleArTrimmed = (titleAr ?? '').trim();

    String title = isArabic
        ? (titleArTrimmed.isNotEmpty ? titleArTrimmed : titleEnTrimmed)
        : (titleEnTrimmed.isNotEmpty ? FormatHelper.capitalize(titleEnTrimmed) : titleArTrimmed);

    // Extract abbreviation from parentheses at the end
    final abbreviationRegex = RegExp(r'\(([^)]+)\)\s*$');
    final match = abbreviationRegex.firstMatch(title);

    if (match != null) {
      // Return only what's inside the parentheses
      return match.group(1) ?? title;
    }

    return title;
  }

  /// ✅ SMART LAST UPDATE DETECTION
  /// Returns the actual last meaningful update, ignoring batch system updates
  DateTime _getSmartLastUpdate(List<int> timestamps) {
    if (timestamps.isEmpty) return DateTime.now();
    if (timestamps.length == 1) return DateTime.fromMillisecondsSinceEpoch(timestamps.first);

    // Get the last timestamp
    final lastTimestamp = timestamps.last;
    final lastDateTime = DateTime.fromMillisecondsSinceEpoch(lastTimestamp);

    // Check if this might be a batch system update
    // (e.g., all services updated within 5 seconds of each other)
    // If so, use the second-to-last timestamp instead

    // For now, we'll use the second-to-last timestamp if available
    // This helps show more variation in update times
    if (timestamps.length >= 2) {
      final secondToLast = timestamps[timestamps.length - 2];
      final secondToLastDateTime = DateTime.fromMillisecondsSinceEpoch(secondToLast);

      // If the last two timestamps are within 10 seconds of each other,
      // it's likely a batch update, so use the earlier one
      final difference = lastDateTime.difference(secondToLastDateTime).inSeconds;

      if (difference < 10) {
        return secondToLastDateTime;
      }
    }

    return lastDateTime;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isMobile = context.isPhone;
    var lightMode = Theme.of(context).brightness == Brightness.light;
    var disappearHome = Get.find<MainCoreEmployeeController>().isHasPermission(
      module: Modules.services,
      section: ServicePermissionsSections.servicesPermissions,
      permission: null,
    );

    return BlocConsumer<MyRequestCubit, MyRequestState>(
      listener: (context, state) {
        if (state is MyRequestError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is MyRequestLoading) {
          return const Center(child: CircleProgressMaster());
        }

        if (state is! MyRequestLoaded) {
          return const SizedBox.shrink();
        }

        final cubit = context.read<MyRequestCubit>();
        final loadedState = state;

        return SafeArea(
          child: SideFrameMasterServices(
            titleText: FormatHelper.capitalize(S.of(context).services),
            onFirstTap: () {
              Navigator.pop(context);
            },
            secondTitle: disappearHome
                ? FormatHelper.capitalize(S.of(context).serviceRequests)
                : FormatHelper.capitalize(S.of(context).myRequests),
            onSecondTap: () {
              Navigator.pop(context);
            },
            thirdTitle: disappearHome
                ? FormatHelper.capitalize(S.of(context).myRequests)
                : null,
            onThirdTap: disappearHome
                ? () {
              Navigator.pop(context);
            }
                : null,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DepartmentFilterChips(
                    selectedKey: loadedState.selectedStatus,
                    onSelected: (status) {
                      cubit.updateStatus(status);
                    },
                    totalCount: loadedState.totalServices,
                    departmentCounts: {
                      S.of(context).Done: loadedState.doneCount,
                      S.of(context).Approved: loadedState.approvedCount,
                      S.of(context).Inprogress: loadedState.inProgressCount,
                      S.of(context).Pending: loadedState.pendingCount,
                      S.of(context).Rejected: loadedState.rejectedCount,
                      S.of(context).BreachedSLA: loadedState.branchSlaCount,
                      S.of(context).Canceled: loadedState.cancelCount,
                    },
                    labelColors: {
                      S.of(context).Done: AppColors.green!,
                      S.of(context).Approved: AppColors.lightGreen,
                      S.of(context).Inprogress: AppColors.yellow,
                      S.of(context).Pending: AppColors.orange,
                      S.of(context).Rejected: AppColors.darkRed!,
                      S.of(context).BreachedSLA: AppColors.red,
                      S.of(context).Canceled: AppColors.red!,
                    },
                    userDepartment: '',
                    isArabic: isArabic,
                  ),
                  SizedBox(height: 15.sp),
                  Row(
                    children: [
                      AppSearchTextField(
                        controller: cubit.searchController,
                        onChanged: (_) {},
                      ),
                      SizedBox(width: 9.sp),
                      if (!isMobile)
                        DepartmentMultiSelectPage(
                          selectedKeys: loadedState.selectedDepartmentKeys,
                          onChanged: (keys) {
                            cubit.updateDepartments(keys);
                          },
                        ),
                      if (!isMobile) SizedBox(width: 9.sp),
                      if (!isMobile)
                        SortDropdownMenu(
                          selectedOption: loadedState.selectedSortOption,
                          onSortSelected: (value) {
                            cubit.updateSort(value);
                          },
                          isMobile: isMobile,
                          isTabletLandscape: isTabletLandscape(context),
                        ),
                      if (isMobile)
                        CustomFilterIcon(
                          color: AppColors.card,
                          borderColor: Colors.transparent,
                          svgColor: AppColors.secondaryText,
                          title: '',
                          onTap: () async {
                            final result = await showFilterDialog(context, loadedState.filteredModel);
                            if (result != null) {
                              cubit.applyMobileFilter(
                                selectedDepartment: result['department'],
                                selectedStatus: result['status'],
                                selectedDate: result['date'],
                              );
                            }
                          },
                        ),
                    ],
                  ),
                  SizedBox(height: 15.sp),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (loadedState.displayedItems.isEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 40.sp),
                          child: Column(
                            children: [
                              Lottie.asset(
                                'assets/lottie/empty.json',
                                width: 400.sp,
                                height: 400.sp,
                                fit: BoxFit.fill,
                                repeat: true,
                                animate: true,
                              ),
                            ],
                          ),
                        )
                      else
                        AnimatedCustomGridView(
                          itemCount: loadedState.displayedItems.length,
                          crossAxisCount: CrossAxisCountHelperResponsive.getCrossAxisCountForDefaultTabletResponsive(context),
                          mainAxisExtent: 257.sp,
                          mainAxisSpacing: 15.sp,
                          crossAxisSpacing: 15.sp,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          animationDuration: const Duration(milliseconds: 1000),
                          staggerDelay: const Duration(milliseconds: 200),
                          curve: Curves.easeOutCubic,
                          itemBuilder: (context, index) {
                            final service = loadedState.displayedItems[index]['model'] as ServicesHistoryModel;

                            // Create a copy of timestamps to ensure isolation
                            final timestampsArray = List<int>.from(service.timestamps);

                            final providerList = service.currentProviderServices;

                            if (providerList.isEmpty) {
                              return const SizedBox();
                            }

                            final provider = providerList[0];
                            final serviceName = isArabic
                                ? service.currentServiceNameArabic
                                : service.currentServiceNameEnglish;

                            final pointOfContact = isArabic
                                ? "${provider.firstNameInArabic ?? ''} ${provider.lastNameInArabic ?? ''}"
                                : "${provider.firstName ?? ''} ${provider.lastName ?? ''}";

                            final jobTitle = _getDisplayJobTitle(
                              provider.title,
                              provider.titleInArabic,
                              isArabic,
                            );

                            final durationValue = double.tryParse(service.currentDurationOfServices) ?? 1.0;
                            final durationUnit = cubit.getLocalizedDurationUnit(
                              context,
                              service.currentSelectedDurationUnit,
                              quantity: durationValue,
                            );

                            // Request Date: FIRST timestamp
                            final requestDate = timestampsArray.isNotEmpty
                                ? DateTime.fromMillisecondsSinceEpoch(timestampsArray.first)
                                : DateTime.now();

                            final lastUpdate = timestampsArray.length > 1
                                ? DateTime.fromMillisecondsSinceEpoch(timestampsArray.last)
                                : DateTime.fromMillisecondsSinceEpoch(timestampsArray.first);

                            return GestureDetector(
                              onTap: () {
                                navigateTo(
                                  context,
                                  MyRequestDetailsServicesToggle(myRequestDetailsModel: service),
                                );
                              },
                              child: CustomServiceCardMyRequest(
                                provider: service,
                                title: serviceName,
                                jobTitle: jobTitle,
                                status: cubit.getFinalStateFromModel(service),
                                dateRequest: DateFormat('dd MMM yyyy').format(requestDate),
                                lastUpdate: DateFormat('dd MMM yyyy h:mm a').format(lastUpdate),
                                pointOfContact: pointOfContact,
                              ),
                            );
                          },
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
