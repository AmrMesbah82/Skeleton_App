import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/grc/custom_botton.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/ui/widgets/name_and_description_action_buttons_row.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/ui/widgets/name_and_description_success_dialog.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/ui/widgets/service_form_fields.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/ui/widgets/status_toggle_widget.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/service_permissions.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/services_permissions_sections.dart';
import 'package:lottie/lottie.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/modules_enum.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/pages/select_services_provider_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/controller/create_service_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/controller/create_service_state.dart';

class CreateServiceScreen extends StatelessWidget {
  final ServicesHistoryModel? editingModel;
  final String? docId;

  const CreateServiceScreen({
    super.key,
    this.editingModel,
    this.docId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateServiceCubit(
        ServicesManagerCubit.get(context),
      )..initialize(
        editingModel: editingModel,
        docId: docId,
      ),
      child: _CreateServiceView(editingModel: editingModel),
    );
  }
}

class _CreateServiceView extends StatelessWidget {
  final ServicesHistoryModel? editingModel;

  const _CreateServiceView({required this.editingModel});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateServiceCubit, CreateServiceState>(
      // ✅ FIX: Don't re-fire listener when we restore Loaded→Loaded after navigation
      listenWhen: (previous, current) {
        if (current is CreateServiceLoaded && previous is CreateServiceLoaded) {
          return false;
        }
        return true;
      },
      listener: (context, state) => _handleStateChanges(context, state),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SideFrameMasterServices(
            titleText: S.of(context).services,
            onFirstTap: () => navigateTo(context, LayoutScreenServices()),
            secondTitle: _getSecondTitle(context),
            child: const SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: _FormContent(),
            ),
          ),
        ),
      ),
    );
  }

  String _getSecondTitle(BuildContext context) {
    final state = context.read<CreateServiceCubit>().state;
    if (state is! CreateServiceLoaded) return S.of(context).creatingNewService;

    final isDraft = editingModel != null &&
        (editingModel!.currentState == "draft" ||
            editingModel!.currentDurationOfServices == "-" ||
            editingModel!.currentDurationOfServices.isEmpty);

    if (editingModel != null) {
      final name = Localizations.localeOf(context).languageCode == 'ar'
          ? editingModel!.currentServiceNameArabic
          : editingModel!.currentServiceNameEnglish;
      return isDraft
          ? "${S.of(context).draft} $name"
          : "${S.of(context).Editing} $name";
    }
    return S.of(context).creatingNewService;
  }

  void _handleStateChanges(BuildContext context, CreateServiceState state) {
    if (state is CreateServiceError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message.tr),
          backgroundColor: AppColors.red,
        ),
      );
    } else if (state is CreateServiceDuplicateName) {
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';

      final title =
      isArabic ? 'خطاء في تكرار البيانات' : 'Duplicate Info Name';
      final message = isArabic
          ? 'اسم الخدمة "${state.duplicateValue}" موجود بالفعل. الرجاء اختيار اسم آخر.'
          : 'Service name "${state.duplicateValue}" already exists. Please choose another name.';

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Container(
            width: 500.w,
            padding: EdgeInsets.all(24.sp),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  width: 100.w,
                  height: 100.h,
                  "assets/lottie/rejected.json",
                  fit: BoxFit.fill,
                  repeat: false,
                ),
                SizedBox(height: 16.h),
                Text(
                  title,
                  style: AppTextStyles.font16BlackSemiBoldCairo.copyWith(
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font14BlackCairoMedium.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    customButton(
                      width: 100.w,
                      height: 38.h,
                      title: S.of(context).ok,
                      color: AppColors.primary,
                      textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                        color: AppColors.textButton,
                      ),
                      function: () {
                        Navigator.pop(dialogContext);
                        context
                            .read<CreateServiceCubit>()
                            .resetToDuplicateState();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else if (state is CreateServiceImageUploaded) {
      _showSuccessDialog(context, 'imageUploadedSuccessfully'.tr);
    } else if (state is CreateServiceNavigateToProviders) {
      // ✅ FIX: Navigate to providers page
      // The cubit already restored loaded state after emitting this,
      // so when user presses back, the form is fully functional again.
      navigateTo(
        context,
        ServicesProviderLayout(
          docId: state.docId,
          editingModel: state.formData.isEditMode
              ? _buildModelFromState(state.formData)
              : null,
        ),
      );
    }
  }

  ServicesHistoryModel _buildModelFromState(dynamic formData) {
    return ServicesHistoryModel.createNew(
      id: formData.docId ?? '',
      state: formData.state,
      status: formData.isActive ? "active" : "inactive",
      serviceNameEnglish: formData.serviceNameEn,
      serviceNameArabic: formData.serviceNameAr,
      serviceDescriptionEnglish: formData.descriptionEn,
      serviceDescriptionArabic: formData.descriptionAr,
      durationOfServices: formData.durationValue,
      selectedDurationUnit: formData.durationUnit,
      imageUrl: formData.imageUrl ?? '',
      providerServices: formData.providers,
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => SuccessDialog(message: message),
    );
  }
}

class _FormContent extends StatelessWidget {
  const _FormContent();

  @override
  Widget build(BuildContext context) {
    final hasPermission =
    Get.find<MainCoreEmployeeController>().isHasPermission(
      module: Modules.services,
      permission: ServicePermissions.changeServiceStatus,
      section: ServicePermissionsSections.servicesPermissions,
    );

    return Column(
      children: [
        // Section Title
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              S.of(context).serviceDetails,
              style: AppTextStyles.font14BlackCairoMedium.copyWith(
                color: AppColors.text,
              ),
            ),
            const Spacer(),
            if (hasPermission) const _StatusToggleSection(),
          ],
        ),
        SizedBox(height: 8.sp),

        const ServiceFormFields(),

        SizedBox(height: 20.sp),

        ActionButtonsRow(
          onDiscard: () => Navigator.pop(context),
        ),

        SizedBox(height: 20.sp),
      ],
    );
  }
}

class _StatusToggleSection extends StatelessWidget {
  const _StatusToggleSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateServiceCubit, CreateServiceState>(
      // ✅ Also rebuild when coming back from NavigateToProviders
      // since we now restore to Loaded state
      buildWhen: (previous, current) => current is CreateServiceLoaded,
      builder: (context, state) {
        if (state is! CreateServiceLoaded) return const SizedBox.shrink();

        final isEditMode = state.formData.isEditMode;
        final hasDocId = state.formData.docId != null;

        return (isEditMode && hasDocId)
            ? const StatusToggleWidget()
            : const SizedBox.shrink();
      },
    );
  }
}
