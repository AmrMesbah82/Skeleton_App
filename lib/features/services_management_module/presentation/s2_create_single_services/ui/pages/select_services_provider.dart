/// ******************* FILE INFO *******************
/// File Name: select_services_provider_page.dart
/// Description: Main provider selection page - combines all widgets
/// Created by: Amr Mesbah
/// Last Update: 6/2/2026

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services_toggle.dart';
import 'package:lottie/lottie.dart';

import 'package:demo_app/core/enumeration/enum.dart'
    as FormatHelper;
import 'package:demo_app/generated/l10n.dart';

import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/5-custom_button.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/pages/details_switch_screen_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/controller/provider_selection_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/controller/provider_selection_state.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/widgets/select_provider_action_buttons_row.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/widgets/edit_mode_banner.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/widgets/provider_grid.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/widgets/save_for_later_button.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/widgets/search_header.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/widgets/selected_provider_details.dart';

class SelectServicesProviderPage extends StatefulWidget {
  final ServicesHistoryModel? editingModel;
  final String? docId;
  final ServicesHistoryModel? editProvider;

  const SelectServicesProviderPage({
    super.key,
    this.editingModel,
    this.docId,
    this.editProvider,
  });

  @override
  State<SelectServicesProviderPage> createState() =>
      _SelectServicesProviderPageState();
}

class _SelectServicesProviderPageState
    extends State<SelectServicesProviderPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProviderSelectionCubit(
        employeeController: Get.find<MainCoreEmployeeController>(),
        departmentController: Get.find<MainCoreDepartmentController>(),
        servicesManagerCubit: ServicesManagerCubit.get(context),
      )..initialize(
          editingModel: widget.editingModel,
          docId: widget.docId,
          editProvider: widget.editProvider,
        ),
      // ✅ FIXED: Added missing 'child:' parameter
      child: BlocConsumer<ProviderSelectionCubit, ProviderSelectionState>(
        listenWhen: (previous, current) {
          // ✅ FIX: Don't re-fire listener if we're restoring back to loaded
          // Only listen when transitioning TO a nav/action state
          if (current is ProviderSelectionLoaded && previous is ProviderSelectionLoaded) {
            return false; // Normal UI update, don't trigger listener
          }
          return current is ProviderSelectionNavigateBack ||
              current is ProviderSelectionNavigateToDetails ||
              current is ProviderSelectionProviderUpdated ||
              current is ProviderSelectionSaved ||
              current is ProviderSelectionSavedToFirebase ||
              current is ProviderSelectionShowWarning ||
              current is ProviderSelectionError;
        },
        listener: _handleStateChanges,
        builder: (context, state) {
          // Handle initial and loading states
          if (state is ProviderSelectionInitial ||
              state is ProviderSelectionLoading) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Handle saving state - show loading with text
          if (state is ProviderSelectionSaving) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(S.of(context).savingDraft),
                  ],
                ),
              ),
            );
          }

          // ✅ FIXED: This state is handled in listener, show loading while navigating
          // Don't show static screen - let listener handle navigation
          if (state is ProviderSelectionSavedToFirebase) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: AppColors.green, size: 64),
                    SizedBox(height: 16),
                    Text(S.of(context).draftSavedSuccessfully),
                    SizedBox(height: 16),
                    CircularProgressIndicator(), // Show navigating indicator
                    SizedBox(height: 8),
                    Text(S.of(context).redirecting),
                  ],
                ),
              ),
            );
          }

          // Handle error state
          if (state is ProviderSelectionError) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: AppColors.red, size: 64),
                    SizedBox(height: 16),
                    Text('Error: ${state.message}'),
                    SizedBox(height: 16),
                    customButton(
                      title: 'Go Back',
                      function: () {
                        // Retry or go back
                        Navigator.pop(context);
                      },
                      width: 120.sp,
                      height: 40.sp,
                      color: AppColors.primary,
                      textColor: AppColors.textButton,
                    ),
                  ],
                ),
              ),
            );
          }

          // Only show main UI for loaded state
          if (state is! ProviderSelectionLoaded) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final cubit = context.read<ProviderSelectionCubit>();
          final data = state.data;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: SideFrameMasterServices(
                titleText: S.of(context).service,
                onFirstTap: () => _navigateToHome(context),
                secondTitle: cubit.getScreenTitle(context),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      // Section Header
                      _buildSectionHeader(context),
                      SizedBox(height: 8.sp),

                      // Edit Mode Banner (only in edit mode)
                  //    if (data.isEditMode) const EditModeBanner(),

                      // Main Card with Provider Grid
                      _buildProviderCard(context),

                      SizedBox(height: 20.sp),

                      // Action Buttons (Back & Next/Save)
                      const ActionButtonsRow(),

                      SizedBox(height: 10.sp),

// ✅          Save For Later Button — hidden in editProvider mode
                      if (data.editProvider == null)
                        const SaveForLaterButton(),

                      SizedBox(height: 20.sp),

                      SizedBox(height: 20.sp),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          FormatHelper.capitalize(S.of(context).serviceProvider),
          style: AppTextStyles.font18BlackMediumCairo.copyWith(color: AppColors.text),
        ),
      ],
    );
  }

  Widget _buildProviderCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15.sp, right: 15.sp, top: 15.sp),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          // Search Header
          SearchHeader(controller: _searchController),
          SizedBox(height: 15.sp),

          // Provider Grid
          const ProviderGrid(),
          SizedBox(height: 15.sp),

          // Selected Provider Details (appears when providers selected)
          const SelectedProviderDetails(),
        ],
      ),
    );
  }

  void _handleStateChanges(BuildContext context, ProviderSelectionState state) {
    if (state is ProviderSelectionShowWarning) {
      _showWarningDialog(context);
    } else if (state is ProviderSelectionNavigateBack) {
      // ✅ FIX: Check we're still mounted before popping
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } else if (state is ProviderSelectionProviderUpdated) {
      _showSuccessChangeProviderDialog(context);
      navigateTo(context, LayoutScreenServices());
    } else if (state is ProviderSelectionSaved) {
      _showSuccessSnackBar(context, 'Draft saved successfully!');
    } else if (state is ProviderSelectionSavedToFirebase) {
      _showSuccessSnackBar(context, 'Draft saved to Firebase!');
      Future.delayed(Duration(milliseconds: 500), () {
        navigateAndFinish(context, LayoutScreenServices());
      });
    } else if (state is ProviderSelectionNavigateToDetails) {
      _navigateToDetails(context, state);
    } else if (state is ProviderSelectionError) {
      _showErrorSnackBar(context, state.message);
    }
  }

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        title: Row(
          children: [
             Icon(Icons.warning_amber, color: AppColors.orange),
            SizedBox(width: 8.w),
            Text(S.of(context).warning),
          ],
        ),
        content: Text(S.of(context).pleaseSelectOneProviderAtLeast),
        actions: [
          customButton(
            title: S.of(context).ok,
            function: () => Navigator.pop(context),
            width: 80.sp,
            height: 36.sp,
            color: AppColors.primary,
            textColor: AppColors.textButton,
          ),
        ],
      ),
    );
  }

  void _showSuccessChangeProviderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        child: SizedBox(
          width: 500.w,
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,  // 👈 this makes height wrap content
              children: [
                Lottie.asset(
                  width: 100.w,
                  height: 100.h,
                  "assets/lottie/approved.json",
                  fit: BoxFit.fill,
                  repeat: true,
                ),
                SizedBox(height: 20.h),
                Text(
                  S.of(context).changingServiceProvider,
                  style: AppTextStyles.font20BlackCairoMedium.copyWith(color: AppColors.text),
                ),
                SizedBox(height: 18.h),
                Text(
                  S.of(context).successChangeServiceProvider,
                  style: AppTextStyles.font18BlackMediumCairo.copyWith(color: AppColors.secondaryText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.red,
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    navigateTo(context, const LayoutScreenServices());
  }

  void _navigateToDetails(
      BuildContext context, ProviderSelectionNavigateToDetails state) {
    if (state.docId != null && widget.editingModel != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailsToggleScreen(
            editingModel: state.completeModel,
            docId: state.docId,
          ),
          maintainState: true,
        ),
      );
    } else {
      navigateTo(
        context,
        DetailsToggleScreen(
          editingModel:
              widget.editingModel != null ? state.completeModel : null,
          docId: state.docId,
        ),
      );
    }
  }
}
