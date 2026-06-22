import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/custom/34-custom_gridview_with_animation.dart';
import 'package:demo_app/core/custom/9_filter_tab_with_container.dart';
import 'package:demo_app/core/widgets/grc/custom_botton.dart';
import 'package:demo_app/features/employee/domain/entities/employee_entity.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/widgets/table_widget.dart';
import 'package:demo_app/features/services_management_module/presentation/s3_create_master_services/ui/pages/master_upload_toggle.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/dashboard_permissions.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/service_permissions.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/services_permissions_sections.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;

import 'package:demo_app/core/custom/34-custom_gridview_with_animation.dart';
import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/modules_enum.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/widgets/services_management/custom_grid_view.dart';
import 'package:demo_app/core/widgets/services_management/custom_pop_up.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/core/widgets/services_management/search_widget.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/features/services_management_module/presentation/s10_employee_action/ui/pages/employee_services_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/pages/dashboard_admin_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/pages/details_services_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/info_text.dart';
import 'package:demo_app/features/services_management_module/presentation/s7_approvals/ui/pages/approval_request_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s8_dashboard/ui/pages/dashboard_management_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/ui/pages/create_new_services_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/data/firebase_draft_repository.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/pages/details_switch_screen_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/pages/sla_screen_page_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/pages/select_services_provider_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/ui/pages/upload_file_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/widgets/export_file.dart';

class ManagementWidget extends StatefulWidget {
  final List<ServicesHistoryModel> allServices;
  final List<ServicesHistoryModel> filteredModel;
  final Map<String, Map<String, dynamic>> selectedProviders;
  final Map<String, int> doneServicesCount;
  final TextEditingController searchController;
  final bool isGridViewChoose;
  final bool isMobile;
  final bool isArabic;
  final bool lightMode;
  final EmployeeEntityPro? employeeEntity;
  final String Function(dynamic) formatStartDate;
  final Function(BuildContext, String?) getLocalizedDurationUnit;
  final Widget Function(List<ServicesHistoryModel>) filterWidget;
  final Widget Function(BuildContext) approvalAndServicesRequest;
  final VoidCallback onToggleGridView;
  final VoidCallback onToggleTableView;

  const ManagementWidget({
    Key? key,
    required this.allServices,
    required this.filteredModel,
    required this.selectedProviders,
    required this.doneServicesCount,
    required this.searchController,
    required this.isGridViewChoose,
    required this.isMobile,
    required this.isArabic,
    required this.lightMode,
    required this.employeeEntity,
    required this.formatStartDate,
    required this.getLocalizedDurationUnit,
    required this.filterWidget,
    required this.approvalAndServicesRequest,
    required this.onToggleGridView,
    required this.onToggleTableView,

  }) : super(key: key);

  @override
  State<ManagementWidget> createState() => _ManagementWidgetState();
}

class _ManagementWidgetState extends State<ManagementWidget> with TickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  // Local state to store loaded providers
  Map<String, Map<String, dynamic>> _loadedProviders = {};
  Map<String, int> _loadedDoneServicesCount = {};

  @override
  void initState() {
    super.initState();

    // Initialize animation controller starting from 0
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
      value: 0.0, // Start from invisible
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.elasticOut,
      ),
    );

    // Load providers for all services
     _loadProviders();        // ← existing line
     _loadDoneServicesCount(); // ← ADD THIS LINE

    // Trigger initial animation after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _flipController.forward();
      }
    });
  }

  /// 🔥 NEW: Load providers from Firestore for all services
  Future<void> _loadProviders() async {

    final Map<String, Map<String, dynamic>> loadedProviders = {};

    for (final service in widget.allServices) {
      final serviceId = service.currentId;
      if (serviceId.isEmpty || serviceId.startsWith('draft_')) continue;

      try {
        // METHOD 1: Try from service object first (fastest)
        if (service.currentProviderServices.isNotEmpty) {
          final provider = service.currentProviderServices.first;
          loadedProviders[serviceId] = {
            'firstName': provider.firstName ?? '',
            'lastName': provider.lastName ?? '',
            'email': provider.email ?? '',
            'gender': provider.gender ?? '',
            'role': provider.role ?? '',
            'title': provider.title ?? '',
            'phone': provider.mobilePhone?.phone ?? '',
            'firstNameInArabic': provider.firstNameInArabic ?? '',
            'lastNameInArabic': provider.lastNameInArabic ?? '',
          };
          continue;
        }

        // METHOD 2: Try from widget.selectedProviders cache (passed from parent)
        if (widget.selectedProviders.containsKey(serviceId)) {
          final cachedProvider = widget.selectedProviders[serviceId];
          if (cachedProvider != null && cachedProvider.isNotEmpty) {
            loadedProviders[serviceId] = Map<String, dynamic>.from(cachedProvider);
            continue;
          }
        }

        // METHOD 3: Fetch from Firestore
        final fetchedProvider = await selectServiceProvider(serviceId);
        if (fetchedProvider != null) {
          loadedProviders[serviceId] = fetchedProvider;
        }
      } catch (e) {
      }
    }

    if (mounted) {
      setState(() {
        _loadedProviders = loadedProviders;
      });
    }
  }

  Future<void> _loadDoneServicesCount() async {

    final Map<String, int> doneCounts = {};
    final collectionPath = getBaseUrl(FirestoreCollections.requestServices);

    try {
      final allRequests = await FirebaseFirestore.instance
          .collection(collectionPath)
          .get();

      for (final doc in allRequests.docs) {
        final data = doc.data();

        // 🔥 FIX: Parent_Service_Id is an ARRAY, extract first element
        final rawParentId = data['Parent_Service_Id'];
        String parentId = '';
        if (rawParentId is List && rawParentId.isNotEmpty) {
          parentId = rawParentId.first.toString().trim();
        } else if (rawParentId is String) {
          parentId = rawParentId.trim();
        }

        if (parentId.isEmpty) continue;

        // 🔥 FIX: state is also an ARRAY, extract first element
        final rawState = data['state'];
        String stateValue = '';
        if (rawState is List && rawState.isNotEmpty) {
          stateValue = rawState.first.toString().toLowerCase().trim();
        } else if (rawState is String) {
          stateValue = rawState.toLowerCase().trim();
        }

        final isDone = stateValue == 'done';

        if (isDone) {
          doneCounts[parentId] = (doneCounts[parentId] ?? 0) + 1;
        }
      }
    } catch (e) {
    }

    for (final service in widget.allServices) {
      final count = doneCounts[service.currentId] ?? 0;
    }

    if (mounted) {
      setState(() {
        _loadedDoneServicesCount = doneCounts;
      });
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _handleToggleView(bool isGrid) {
    // Reset animation first
    _flipController.reset();

    // Change the view
    if (isGrid) {
      widget.onToggleGridView();
    } else {
      widget.onToggleTableView();
    }

    // Trigger animation after a short delay to ensure rebuild
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _flipController.forward();
      }
    });
  }

  @override
  void didUpdateWidget(ManagementWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If data changed and animation is complete, restart it
    if (oldWidget.filteredModel.length != widget.filteredModel.length) {
      _flipController.reset();
      // Reload providers when services change
      _loadProviders();
      _loadDoneServicesCount();
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          _flipController.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeController = Get.find<MainCoreEmployeeController>();

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.isMobile ?
            Get.find<MainCoreEmployeeController>().isHasPermission(
              module: Modules.services,
              section:ServicePermissionsSections.requestedServices,
              permission: null,
            ) ?
            customButtonAnimation(
              title: S.of(context).requestedServices,
              function: () {
                navigateTo(context, EmployeeLayoutScreenServices());
              },
              textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                color: AppColors.textButton,
              ),
              width: widget.isMobile ? 160.w : 180.w,
              height: 38.h,
              radius: 8.r,
              color: AppColors.primary,
            ) : SizedBox():
            Expanded(child: widget.filterWidget(widget.allServices)),
            widget.isMobile ? Spacer() : SizedBox(width: 10.w),

            widget.isMobile ? SizedBox() : customButton(
                title: "Bulk Upload",
                function: () {
                  navigateTo(context, const MasterUploadToggle());
                },
                textStyle:widget.isMobile ? AppTextStyles.font14BlackCairoMedium.copyWith(
                  color: AppColors.textButton,
                ): AppTextStyles.font16BlackMediumCairo.copyWith(
                  color: AppColors.textButton,
                ),
                width: 135.w,
                height: 38.h,
                radius: 8.r
            ),

            SizedBox(
              width: 20.w,
            ),
            // if (Get.find<MainCoreEmployeeController>().isHasPermission(
            //   module: Modules.services,
            //   section:ServicePermissionsSections.dashboardPermissions,
            //   permission: null,
            // ))
            //   if (Get.find<MainCoreEmployeeController>().isHasPermission(
            //     module: Modules.services,
            //     section:ServicePermissionsSections.dashboardPermissions,
            //     permission: DashboardPermissions.adminDashboard ,
            //   ))
                Row(
                  children: [
                    customButtonAnimation(
                      title: S.of(context).adminDashboard,
                      function: () {
                        navigateTo(context, AdminDashBordLayout());
                      },
                      textStyle:widget.isMobile ? AppTextStyles.font14BlackCairoMedium.copyWith(
                        color: AppColors.textButton,
                      ): AppTextStyles.font16BlackMediumCairo.copyWith(
                        color: AppColors.textButton,
                      ),
                      width: widget.isMobile ? 140.w : 170.w,
                      height: 38.h,
                      radius: 8.r,
                      color: AppColors.primary,
                    ),
                  ],
                ),

          ],
        ),
        SizedBox(height: 15.sp),
        widget.approvalAndServicesRequest(context),
        SizedBox(height: 15.sp),
        Row(
          children: [
            // Approval
            if(Get.find<MainCoreEmployeeController>().isHasPermission(
              module: Modules.services,
              section: ServicePermissionsSections.approvalPermissions,
              permission: null,
            )

            )
              widget.isMobile ?   customButtonAnimation(
                title: S.of(context).approvals,
                function: () {
                  navigateTo(context, ApprovalToggle());
                },
                textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                  color: AppColors.textButton,
                ),
                width: widget.isMobile ? 160.w : 135.w,
                height: 38.h,
                radius: 8.r,
                color: AppColors.primary,
              ) : SizedBox(),
          ],
        ),
        widget.isMobile ? SizedBox(height: 15.sp) : SizedBox(),
        widget.isMobile ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: widget.filterWidget(widget.allServices)) : SizedBox(),
        widget.isMobile ? SizedBox(height: 15.sp) : SizedBox(),
          _buildActionButtons(context, employeeController),
        SizedBox(height: 10.sp),
        _buildViewToggleRow(context, employeeController),
        SizedBox(height: 10.sp),
        _buildContentView(context),
        SizedBox(height: 10.sp),
      ],
    );
  }

  Widget _buildActionButtons(
      BuildContext context,
      MainCoreEmployeeController employeeController,
      ) {
    return Row(
      children: [
        AppSearchTextField(
          controller: widget.searchController,
          onChanged: (_) {},
        ),
        SizedBox(width: 10.sp),

        // Only Create Service button
          // if (employeeController.isHasPermission(
          //   module: Modules.services,
          //   section: ServicePermissionsSections.servicesPermissions,
          //   permission: ServicePermissions.createService,
          // ) &&
          //     !employeeController.isHasPermission(
          //       module: Modules.services,
          //       permission: ServicePermissions.bulkUpload,
          //       section: ServicePermissionsSections.servicesPermissions,
          //     ))
          _buildCreateServiceButton(context),

        // Only Bulk Upload button
        if (employeeController.isHasPermission(
          module: Modules.services,
          permission: ServicePermissions.bulkUpload,
          section: ServicePermissionsSections.servicesPermissions,
        ) &&
            !employeeController.isHasPermission(
              module: Modules.services,
              permission: ServicePermissions.createService,
              section: ServicePermissionsSections.servicesPermissions,
            ))
          _buildBulkUploadButton(context),

        // Both Create and Bulk Upload (Popup Menu)
        if (employeeController.isHasPermission(
          module: Modules.services,
          permission: ServicePermissions.createService,
          section: ServicePermissionsSections.servicesPermissions,
        ) &&
            employeeController.isHasPermission(
              module: Modules.services,
              permission: ServicePermissions.bulkUpload,
              section: ServicePermissionsSections.servicesPermissions,
            ))
          _buildPopupMenuButton(context),
      ],
    );
  }

  Widget _buildCreateServiceButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateTo(context, CreateNewServicesLayout());
      },
      child: Container(
        width: widget.isMobile ? 38.sp : (isTabletLandscape(context) ? 165.sp : 165.sp),
        height: 38.h,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.transparent),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.5.sp),
        child: widget.isMobile
            ? Center(
          child: SvgPicture.asset(
            "assets/headsvg.svg",
            width: 16.sp,
            height: 16.sp,
            color: AppColors.textButton,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/headsvg.svg",
              width: 16.sp,
              height: 16.sp,
              color: AppColors.textButton,
            ),
            SizedBox(width: 8.sp),
            FittedBox(
              child: Text(
                S.of(context).createService,
                style: AppTextStyles.font16BlackMediumCairo.copyWith(
                  color: AppColors.textButton,
                ),
              ),
            ),
            SizedBox(width: 4.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildBulkUploadButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateTo(context, ToggleUploadFile());
      },
      child: Container(
        width: widget.isMobile ? 38.sp : (isTabletLandscape(context) ? 160.sp : 160.sp),
        height: 38.h,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.transparent),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.5.sp),
        child: widget.isMobile
            ? Center(
          child: SvgPicture.asset(
            "assets/headsvg.svg",
            width: 16.sp,
            height: 16.sp,
            color: AppColors.textButton,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/headsvg.svg",
              width: 16.sp,
              height: 16.sp,
              color: AppColors.textButton,
            ),
            SizedBox(width: 8.sp),
            FittedBox(
              child: Text(
                S.of(context).bulkUpload,
                style: AppTextStyles.font16BlackMediumCairo.copyWith(
                  color: AppColors.textButton,
                ),
              ),
            ),
            SizedBox(width: 4.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMenuButton(BuildContext context) {
    return CustomPopupMenuButton(
      height: 38,
      width: widget.isMobile ? 38 : (isTabletLandscape(context) ? 175 : 175),
      title: widget.isMobile ? "" : S.of(context).createService,
      iconPath: "assets/headsvg.svg",
      backgroundColor: AppColors.primary,
      iconColor: AppColors.textButton,
      onSelected: (value) {
        if (value == 'addServices') {
          navigateTo(context, CreateNewServicesLayout());
        } else if (value == 'bulkUpload') {
          navigateTo(context, ToggleUploadFile());
        }
      },
      options: [
        PopupOption(
          value: 'addServices',
          label: S.of(context).addService,
        ),
        PopupOption(
          value: 'bulkUpload',
          label: S.of(context).bulkUpload,
        ),
      ],
    );
  }

  Future<Map<String, dynamic>?> selectServiceProvider(String serviceId) async {
    final doc = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .doc(serviceId)
        .get();
    if (doc.exists && doc.data() != null) {
      final providerData = doc.data()!['providerServices'];

      // Handle list format
      if (providerData is List && providerData.isNotEmpty) {
        final lastEntry = providerData.last;
        if (lastEntry is String) {
          try {
            final decoded = jsonDecode(lastEntry) as List;
            if (decoded.isNotEmpty) {
              return decoded[0] as Map<String, dynamic>;
            }
          } catch (e) {
          }
        }
      }
    }

    return null;
  }

  var selectedIndex = 1;
  Widget _buildViewToggleRow(
      BuildContext context,
      MainCoreEmployeeController employeeController,
      )
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

        if (employeeController.isHasPermission(
          module: Modules.services,
          permission: ServicePermissions.exportRequestedServices,
          section: ServicePermissionsSections.servicesPermissions,
        ))
          _buildExportButton(context),
        widget.isMobile ? SizedBox() : _buildViewToggleButtons(context),

      ],
    );
  }

  Widget _buildExportButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {

        try {

          // Build provider map by fetching from Firestore
          Map<String, Map<String, dynamic>> exportProviders = {};

          // Process each service
          for (int i = 0; i < widget.filteredModel.length; i++) {
            final service = widget.filteredModel[i];
            final serviceId = service.currentId;

            if (serviceId.isNotEmpty && !serviceId.startsWith('draft_')) {

              try {
                // METHOD 1: Try from service object first (fastest)
                if (service.currentProviderServices.isNotEmpty) {
                  final provider = service.currentProviderServices.first;
                  exportProviders[serviceId] = {
                    'firstName': provider.firstName ?? '',
                    'lastName': provider.lastName ?? '',
                    'email': provider.email ?? '',
                    'gender': provider.gender ?? '',
                    'role': provider.role ?? '',
                    'title': provider.title ?? '',
                    'phone': provider.mobilePhone?.phone ?? '',
                    'firstNameInArabic': provider.firstNameInArabic ?? '',
                    'lastNameInArabic': provider.lastNameInArabic ?? '',
                  };
                  continue;
                }

                // METHOD 2: Try from _loadedProviders cache (local state)
                if (_loadedProviders.containsKey(serviceId)) {
                  final cachedProvider = _loadedProviders[serviceId];
                  if (cachedProvider != null && cachedProvider.isNotEmpty) {
                    exportProviders[serviceId] = Map<String, dynamic>.from(cachedProvider);
                    continue;
                  }
                }

                // METHOD 3: Fetch from Firestore (your selectServiceProvider function)
                final fetchedProvider = await selectServiceProvider(serviceId);
                if (fetchedProvider != null) {
                  exportProviders[serviceId] = fetchedProvider;
                }
              } catch (e) {
              }
            } else if (serviceId.startsWith('draft_')) {
            }
          }

          // // Close loading dialog
          // if (Navigator.canPop(context)) {
          //   Navigator.pop(context);
          // }

          // Open export dialog with populated data
          await showGeneralDialog(
            context: context,
            barrierDismissible: false,
            barrierLabel: '',
            barrierColor: AppColors.black.withOpacity(0.54),
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) {
              return ExportDialog(
                filteredModel: widget.filteredModel,
                selectedProviders: exportProviders,
                formatStartDate: widget.formatStartDate,
              );
            },
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              final scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
                  .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack));
              final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
                  .animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));

              return ScaleTransition(
                scale: scaleAnimation,
                child: FadeTransition(opacity: fadeAnimation, child: child),
              );
            },
          );
        } catch (e, stackTrace) {

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          Get.snackbar(
            'Error',
            'Failed to prepare export data',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.red,
            colorText: AppColors.white,
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.isMobile ? 0 : 8.sp),
        child: Container(
          width: widget.isMobile ? 38.sp : 100.sp,
          height: 38.sp,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: widget.isMobile
              ? Center(
            child: SvgPicture.asset(
              "assets/upload_file.svg",
              fit: BoxFit.scaleDown,
              width: 20.sp,
              height: 20.sp,
              color: AppColors.textButton,
              semanticsLabel: 'Export',
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/upload_file.svg",
                fit: BoxFit.scaleDown,
                width: 20.sp,
                height: 20.sp,
                color: AppColors.textButton,
                semanticsLabel: 'Export',
              ),
              SizedBox(width: 8.sp),
              Text(
                S.of(context).export,
                style: AppTextStyles.font16BlackMediumCairo.copyWith(
                  color: AppColors.textButton,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewToggleButtons(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _handleToggleView(false),
          child: Container(
            width: 38.sp,
            height: 38.sp,
            decoration: BoxDecoration(
              color: !widget.isGridViewChoose
                  ? AppColors.primary
                  : AppColors.card,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/tableView.svg",
                width: 20.sp,
                height: 20.sp,
                fit: BoxFit.scaleDown,
                semanticsLabel: 'Table View',
                color: !widget.isGridViewChoose
                    ? AppColors.textButton
                    : Theme.of(context).brightness == Brightness.light
                    ? AppColors.black
                    : AppColors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.sp),
        GestureDetector(
          onTap: () => _handleToggleView(true),
          child: Container(
            width: 38.sp,
            height: 38.sp,
            decoration: BoxDecoration(
              color: widget.isGridViewChoose
                  ? AppColors.primary
                  : AppColors.card,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/gridView.svg",
                width: 20.sp,
                height: 20.sp,
                fit: BoxFit.scaleDown,
                semanticsLabel: 'Grid View',
                color: widget.isGridViewChoose
                    ? AppColors.textButton
                    : Theme.of(context).brightness == Brightness.light
                    ? AppColors.black
                    : AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildContentView(BuildContext context) {
    if (widget.filteredModel.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/empty.json',
              width: 300.sp,
              height: 300.sp,
              fit: BoxFit.cover,
              repeat: true,
              animate: true,
            ),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: _flipController,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (_flipController.value * 0.2), // Scale from 0.8 to 1.0
          child: Opacity(
            opacity: _flipController.value,
            child: _buildView(context),
          ),
        );
      },
    );
  }

  Widget _buildView(BuildContext context) {
    if (widget.isGridViewChoose) {
      return _buildGridView(context);
    } else {
      // 🔥 FIXED: Use _loadedProviders instead of widget.selectedProviders
      return ServiceTableWidget(
        filteredModel: widget.filteredModel,
        selectedProviders: _loadedProviders,
        locale: Localizations.localeOf(context).languageCode,
      );
    }
  }

  Widget _buildGridView(BuildContext context) {
    return AnimatedCustomGridView(
      itemCount: widget.filteredModel.length,
      crossAxisCount: CrossAxisCountHelperResponsive.getCrossAxisCountForDefaultTabletResponsive(context),
      mainAxisExtent: 85.sp,
      mainAxisSpacing: 15.sp,
      crossAxisSpacing: 15.sp,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      animationDuration: const Duration(milliseconds: 800), // Duration for each card
      staggerDelay: const Duration(milliseconds: 100), // Delay between cards
      curve: Curves.easeOutCubic,
      itemBuilder: (context, index) {
        final service = widget.filteredModel[index];
        final duration = service.currentDurationOfServices;
        final unit = widget.getLocalizedDurationUnit(
          context,
          service.currentSelectedDurationUnit,
        );

        return _buildServiceCardWithGesture(context, service, duration, unit);
      },
    );
  }

  Widget _buildServiceCardWithGesture(
      BuildContext context,
      ServicesHistoryModel service,
      String duration,
      String unit,
      ) {
    return GestureDetector(
      onTap: () async {
        final isDraft = service.currentState.toLowerCase().trim() == 'draft';
        final cubit = ServicesManagerCubit.get(context);

        if (isDraft) {
          // 🔥 CHECK IF IT'S A FIREBASE DRAFT WITH PAGE TRACKING
          final draftWithPage = await cubit.getDraftWithPage(service.currentId);

          if (draftWithPage != null) {
            // Navigate to specific page based on saved progress
            _navigateToDraftPage(context, draftWithPage);
          } else {
            // Fallback: old SharedPrefs draft or new draft without page info
            navigateTo(
              context,
              CreateNewServicesLayout(editingModel: service),
            );
          }
        } else {
          // Existing active/inactive service flow
          final serviceId = service.currentId;
          if (serviceId.isNotEmpty) {
            await cubit.getRequestedServices(serviceId);
            await cubit.getStatistics(serviceId);
            navigateTo(
              context,
              ToggleDetailsServicesLayout(createServicesModel: service),
            );
          }
        }
      },
      child: _buildServiceCardContent(context, service, duration, unit),
    );
  }

  /// 🔥 NEW: Navigate to correct page based on draft progress
  void _navigateToDraftPage(BuildContext context, DraftWithPage draftWithPage) {
    final page = draftWithPage.currentPage;
    final model = draftWithPage.model;
    final draftId = draftWithPage.draftId;

    switch (page) {
      case FirebaseDraftRepository.pageCreateService:
      // Page 1: Basic info
        navigateTo(
          context,
          CreateNewServicesLayout(editingModel: model, docId: draftId),
        );
        break;

      case FirebaseDraftRepository.pageSelectProvider:
      // Page 2: Provider selection
        navigateTo(
          context,
          ServicesProviderLayout(
            editingModel: model,
            docId: draftId,
          ),
        );
        break;

      case FirebaseDraftRepository.pageDetailsApproval:
      // Page 3: Details & approval
        navigateTo(
          context,
          DetailsToggleScreen(
            editingModel: model,
            docId: draftId,
          ),
        );
        break;

      case FirebaseDraftRepository.pageSlaNotification:
      // Page 4: SLA & notifications
        navigateTo(
          context,
          ToggleSlaScreen(editingModel: model),
        );
        break;

      default:
      // Unknown page, start from beginning
        navigateTo(
          context,
          CreateNewServicesLayout(editingModel: model, docId: draftId),
        );
    }
  }

  Widget _buildServiceCardContent(
      BuildContext context,
      ServicesHistoryModel service,
      String duration,
      String unit,
      )
  {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              right: 10.sp,
              left: widget.isArabic ? 10.sp : 0.sp,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildServiceImage(context, service),
                SizedBox(width: widget.isArabic ? 0.sp : 5.sp),
                Expanded(
                  child: _buildServiceInfo(context, service, duration, unit),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
          child: _buildStartDate(context, service),
        ),
      ],
    );
  }

  Widget _buildServiceImage(BuildContext context, ServicesHistoryModel service) {
    return Container(
      width: 60.w,
      height: 60.h,
      margin: EdgeInsets.only(top: 10.sp, bottom: 10.sp, left: 10.sp),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors. background,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: (service.currentImageUrl.isNotEmpty)
          ? ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: CachedNetworkImage(
          imageUrl: service.currentImageUrl,
          width: 80.sp,
          height: 80.sp,
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: AppColors.secondaryText.withOpacity(.3),
            highlightColor: AppColors.background.withOpacity(.5),
            child: Container(
              width: 80.sp,
              height: 80.sp,
              decoration: BoxDecoration(
                color: AppColors.secondaryText.withOpacity(.1),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          errorWidget: (context, url, error) {
            return SvgPicture.asset(
              'assets/svgItemCard.svg',
              width: 40.sp,
              height: 40.sp,
              color: AppColors.secondaryText,
              fit: BoxFit.scaleDown,
            );
          },
        ),
      )
          : SvgPicture.asset(
        'assets/svgItemCard.svg',
        width: 30.w,
        height: 30.h,
        color: AppColors.secondaryText,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildServiceInfo(
      BuildContext context,
      ServicesHistoryModel service,
      String duration,
      String unit,
      ) {
    return Padding(
      padding: EdgeInsets.only(top: 11.sp, bottom: 10.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Padding(
            padding:  EdgeInsets.only(top: 3.h),
            child: _buildServiceName(context, service),
          )),
          //vSizedBox(height: widget.isMobile ? 0.h : 4.h),
          Expanded(child: _buildDoneServicesCount(context, service)),
         //  SizedBox(height: widget.isMobile ? 0.h : 4.h),
          Expanded(child: _buildDuration(context, duration, unit)),
        ],
      ),
    );
  }

  Widget _buildServiceName(BuildContext context, ServicesHistoryModel service) {
    final serviceName = Localizations.localeOf(context).languageCode == 'ar'
        ? service.currentServiceNameArabic
        : service.currentServiceNameEnglish;

    return Text(
      FormatHelper.capitalize(serviceName),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.font14BlackCairoMedium.copyWith(
        color: AppColors.text,
      ),
    );
  }

  Widget _buildDoneServicesCount(BuildContext context, ServicesHistoryModel service) {
    // 🔥 Priority: local Firestore count > parent widget count > "-"
    final count = _loadedDoneServicesCount[service.currentId]
        ?? widget.doneServicesCount[service.currentId];

    return Row(
      children: [
        Text(
          "${S.of(context).doneServices}: ",
          style: AppTextStyles.font12BlackCairoRegular.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        Text(
          "${count ?? '-'}",
          style: AppTextStyles.font12BlackCairoRegular.copyWith(
            color: AppColors.text,
          ),
        ),
      ],
    );
  }

  Widget _buildDuration(BuildContext context, String duration, String unit) {
    // Parse duration to check if we need plural form
    int? durationValue = int.tryParse(duration);
    String displayUnit = unit;

    // Only modify unit if we successfully parsed the duration
    if (durationValue != null) {
      final l = S.of(context);
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';

      // Get the canonical unit type
      String canonicalUnit = _getCanonicalUnit(unit.toLowerCase().trim());

      // Apply pluralization logic
      displayUnit = _getPluralizedUnit(context, canonicalUnit, durationValue, isArabic);
    }

    return Row(
      children: [
        Text(
          "${S.of(context).duration}: ",
          style: AppTextStyles.font12BlackCairoRegular.copyWith(
              color: AppColors.secondaryText
          ),
        ),
        Text(
          FormatHelper.capitalize("$duration $displayUnit"),
          style: AppTextStyles.font12BlackCairoRegular.copyWith(
              color: AppColors.text
          ),
        ),
      ],
    );
  }

// Helper method to get canonical unit type
  String _getCanonicalUnit(String unit) {
    if (unit.contains('hour') || unit == 'h' || unit == 'hr' || unit == 'hrs' ||
        unit.contains('ساعة')) {
      return 'hour';
    } else if (unit.contains('minute') || unit == 'm' || unit == 'min' || unit == 'mins' ||
        unit.contains('دقيقة')) {
      return 'minute';
    } else if (unit.contains('second') || unit == 's' || unit == 'sec' || unit == 'secs' ||
        unit.contains('ثانية')) {
      return 'second';
    } else if (unit.contains('week') || unit == 'w' || unit == 'wk' || unit == 'wks' ||
        unit.contains('أسبوع')) {
      return 'week';
    } else if (unit.contains('day') || unit == 'd' ||
        unit.contains('يوم')) {
      return 'day';
    } else if (unit.contains('month') || unit == 'mo' ||
        unit.contains('شهر')) {
      return 'month';
    } else if (unit.contains('year') || unit == 'y' || unit == 'yr' || unit == 'yrs' ||
        unit.contains('سنة')) {
      return 'year';
    }
    return unit;
  }

// Helper method to get pluralized unit
  String _getPluralizedUnit(BuildContext context, String canonicalUnit, int value, bool isArabic) {
    final l = S.of(context);

    // For value of 1, use singular form
    if (value == 1) {
      switch (canonicalUnit) {
        case 'hour':
          return isArabic ? 'ساعة' : 'hour';
        case 'minute':
          return isArabic ? 'دقيقة' : 'minute';
        case 'second':
          return isArabic ? 'ثانية' : 'second';
        case 'week':
          return isArabic ? 'أسبوع' : 'week';
        case 'day':
          return isArabic ? 'يوم' : 'day';
        case 'month':
          return isArabic ? 'شهر' : 'month';
        case 'year':
          return isArabic ? 'سنة' : 'year';
        default:
          return canonicalUnit;
      }
    }

    // For value > 1, use plural form
    switch (canonicalUnit) {
      case 'hour':
        return isArabic ? 'ساعات' : 'hours';
      case 'minute':
        return isArabic ? 'دقائق' : 'minutes';
      case 'second':
        return isArabic ? 'ثوانٍ' : 'seconds';
      case 'week':
        return isArabic ? 'أسابيع' : 'weeks';
      case 'day':
        return isArabic ? 'أيام' : 'days';
      case 'month':
        return isArabic ? 'أشهر' : 'months';
      case 'year':
        return isArabic ? 'سنوات' : 'years';
      default:
        return canonicalUnit;
    }
  }

  Widget _buildStartDate(BuildContext context, ServicesHistoryModel service) {
    return Padding(
      padding: EdgeInsets.only(right: 0.sp, left: 0.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Text(
                "${S.of(context).startDate}: ",
                style: AppTextStyles.font10BlackCairoRegular.copyWith(
                    color: AppColors.secondaryText
                ),
              ),
              _buildStartDateValue(context, service),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartDateValue(BuildContext context, ServicesHistoryModel service) {
    final isDraft = service.currentState.toLowerCase().trim() == 'draft';

    if (isDraft) {
      return Text(
        '-',
        style: AppTextStyles.font10BlackCairoRegular.copyWith(
            color: AppColors.text
        ),
      );
    }

    try {
      if (service.timestamps.isNotEmpty) {
        final timestamp = Timestamp.fromMillisecondsSinceEpoch(
          service.timestamps[0],
        );
        return Text(
          widget.formatStartDate(timestamp),
          style: AppTextStyles.font10BlackCairoRegular.copyWith(
              color: AppColors.text
          ),
        );
      }
    } catch (e) {
    }

    return Text(
      '-',
      style: AppTextStyles.font10BlackCairoRegular.copyWith(
          color: AppColors.text
      ),
    );
  }
}
