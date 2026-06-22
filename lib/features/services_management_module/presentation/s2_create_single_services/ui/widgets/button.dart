import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/features/employee/domain/entities/employee_entity.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services_toggle.dart';
import 'package:lottie/lottie.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/widgets/select_approval_success_dialog.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/utils/shared.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_prefs_employee.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/data/firebase_draft_repository.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/pages/sla_screen_page_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/pages/details_switch_screen_toggle.dart';

/// 🔥 Helper: Build complete model from all sources
Future<ServicesHistoryModel> _buildCompleteModelForDraft({
  required BuildContext context,
  required List<String> selectedDepartments,
  required List<EmployeeEntityPro> selectedEmployees,
  required bool requireApproval,
  required bool limitAvailability,
  required ServicesHistoryModel? editingModel,
  required String? docId,
}) async {
  // Get data from SharedPrefs or editingModel
  final nameEn = editingModel?.currentServiceNameEnglish ??
      await SharedPrefsHelper.getString('service_name_en') ?? '';
  final nameAr = editingModel?.currentServiceNameArabic ??
      await SharedPrefsHelper.getString('service_name_ar') ?? '';
  final descEn = editingModel?.currentServiceDescriptionEnglish ??
      await SharedPrefsHelper.getString('service_description_en') ?? '';
  final descAr = editingModel?.currentServiceDescriptionArabic ??
      await SharedPrefsHelper.getString('service_description_ar') ?? '';
  final durationVal = editingModel?.currentDurationOfServices ??
      await SharedPrefsHelper.getString('duration_value') ?? '';
  final durationUnit = editingModel?.currentSelectedDurationUnit ??
      await SharedPrefsHelper.getString('duration_unit') ?? '';
  final imageUrl = editingModel?.currentImageUrl ??
      await SharedPrefsHelper.getString('service_image_url') ?? '';

  // Get providers from SharedPrefs
  final providers = await SharedPrefsEmployeeHelper.getSelectedEmployees() ??
      editingModel?.currentProviderServices ?? [];

  // Convert approval employees
  final approvalModels = selectedEmployees.map((e) => EmployeeEntityModell(
    id: e.id,
    state: "pending",
    firstName: e.firstName,
    lastName: e.lastName,
    email: e.email,
    gender: e.gender,
    title: e.title,
    titleInArabic: e.titleInArabic,
    photo: e.photo,
    departmentId: e.departmentId,
    role: e.role,
    status: e.status,
    firstNameInArabic: e.firstNameInArabic,
    lastNameInArabic: e.lastNameInArabic,
    mobilePhone: (e.mobilePhone != null)
        ? ServicesMobilePhoneEntity.fromMobilePhoneEntity(e.mobilePhone!)
        : null,
  )).toList();

  return ServicesHistoryModel.createNew(
    id: editingModel?.currentId ?? docId ?? '',
    state: "draft",
    status: "draft",
    serviceNameEnglish: nameEn,
    serviceNameArabic: nameAr,
    serviceDescriptionEnglish: descEn,
    serviceDescriptionArabic: descAr,
    durationOfServices: durationVal,
    selectedDurationUnit: durationUnit,
    imageUrl: imageUrl,
    providerServices: providers,
    selectDepartment: limitAvailability ? selectedDepartments : [],
    approvalCycle: approvalModels,
    limitAvailability: limitAvailability,
    requireApproval: requireApproval,
  );
}

/// 🔥 Helper: Save draft to Firebase from Details page
Future<void> _saveDraftToFirebase({
  required BuildContext stxContext,
  required List<String> selectedDepartments,
  required List<EmployeeEntityPro> selectedEmployees,
  required bool requireApproval,
  required bool limitAvailability,
  required ServicesHistoryModel? editingModel,
  required String? docId,
}) async {
  try {

    // Show loading
    showDialog(
      context: stxContext,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Get cubit
    final cubit = ServicesManagerCubit.get(stxContext);

    // Build complete model from all data sources
    final completeModel = await _buildCompleteModelForDraft(
      context: stxContext,
      selectedDepartments: selectedDepartments,
      selectedEmployees: selectedEmployees,
      requireApproval: requireApproval,
      limitAvailability: limitAvailability,
      editingModel: editingModel,
      docId: docId,
    );

    // Save to Firebase with page 3 (DetailsToggleScreen)
    final draftId = await cubit.saveDraftToFirebase(
      model: completeModel,
      currentPage: FirebaseDraftRepository.pageDetailsApproval, // Page 3
    );

    // Close loading
   // Navigator.pop(context);

    // Show success using the imported SuccessDialog
    showDialog(
      context: stxContext,
      barrierDismissible: true,
      builder: (context) => SuccessDialogMaster(
        title: S.of(context).draftService,
        message: S.of(context).successfullyDraftedService,
        onDismiss: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LayoutScreenServices()),
          );
        },
      ),
    );

  } catch (e) {
    Navigator.pop(stxContext); // Close loading
    ScaffoldMessenger.of(stxContext).showSnackBar(
      SnackBar(content: Text('Failed to save draft: $e')),
    );
  }
}

Widget buttonFotter({
  required BuildContext context,
  required bool isEditingSubmittedService,
  required List<String> selectedDepartments,
  required List<EmployeeEntityPro> selectedEmployees,
  required bool requireApproval,
  required bool limitAvailability,
  required ServicesHistoryModel? editingModel,
  required String? docId,
  required bool navigated,
  required bool isDraft,
  required void Function() onNavigateBack,
  required void Function(ServicesHistoryModel model) onDraftSaved,
  required bool Function() onValidation,
}) {
  final shouldShowSaveForLaterButton = !isEditingSubmittedService || isDraft;

  return Column(
    children: [
      Row(
        children: [
          customButtonAnimation(
            title: S.of(context).back,
            function: (){
              Navigator.pop(context);
            },
            textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(color: const Color(0xff2D2D2D)),
            width: 150.sp,
            height: 38.sp,
            radius: 8.r,
            color: const Color(0xffCCCCCCCC).withOpacity(.8),
          ),
          const Spacer(),
          customButtonAnimation(
            title: S.of(context).next,
            function: () async {
              if (!onValidation()) {
                return;
              }

              await SharedPrefsDepartmentsHelper.saveDepartments(selectedDepartments);
              await SharedPrefsHelper.setBool('limitAvailability', limitAvailability);
              await SharedPrefsHelper.setBool('requireApproval', requireApproval);

              final selectedModels = selectedEmployees.map((e) => EmployeeEntityModell(
                id: e.id,
                state: "pending",
                firstName: e.firstName,
                middleName: e.middleName,
                lastName: e.lastName,
                email: e.email,
                gender: e.gender,
                title: e.title,
                titleInArabic: e.titleInArabic,
                photo: e.photo,
                bio: e.bio,
                departmentId: e.departmentId,
                country: e.country,
                extension: e.extension,
                homePhone: e.homePhone,
                maritalStatus: e.maritalStatus,
                lastLogin: e.lastLogin,
                activationDate: e.activationDate,
                defaultPassword: e.defaultPassword,
                firstLogin: e.firstLogin,
                firstNameInArabic: e.firstNameInArabic,
                mobilePhone: (e.mobilePhone != null)
                    ? ServicesMobilePhoneEntity.fromMobilePhoneEntity(e.mobilePhone!)
                    : null,
                language: e.language,
                middleNameInArabic: e.middleNameInArabic,
                nationality: e.nationality,
                officePhone: e.officePhone,
                passport: e.passport,
                passportExpirationDate: e.passportExpirationDate,
                password: e.password,
                postalCode: e.postalCode,
                province: e.province,
                role: e.role,
                status: e.status,
                street: e.street,
                supervisor: e.supervisor,
                workLocation: e.workLocation,
                nationalId: e.nationalId,
                nationalIdExpirationDate: e.nationalIdExpirationDate,
                lastNameInArabic: e.lastNameInArabic,
                birthDay: e.birthDay,
                carPlates: e.carPlates,
                city: e.city,
                drivingLicenseId: e.drivingLicenseId,
                deactivationDate: e.deactivationDate,
              )).toList();

              await SharedPrefsApprovalHelper.saveApprovalCycle(selectedModels);

              navigateTo(context, ToggleSlaScreen(editingModel: editingModel));
            },
            textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(color: AppColors.textButton),
            width: 150.sp,
            height: 38.sp,
            radius: 8.r,
            color: AppColors.primary,
          ),
        ],
      ),
      SizedBox(height: 10.sp),

      // Save For Later section
      if (shouldShowSaveForLaterButton)
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            customButtonAnimation(
              title: isEditingSubmittedService && isDraft
                  ? S.of(context).saveForLater
                  : isEditingSubmittedService
                  ? S.of(context).discardChange
                  : S.of(context).saveForLater,
              function: () async {
                if (isEditingSubmittedService && !isDraft) {
                  navigateTo(
                    context,
                    DetailsToggleScreen(
                      editingModel: editingModel,
                      docId: docId,
                    ),
                  );
                  return;
                }

                // 🔥 SAVE TO FIREBASE INSTEAD OF LOCAL
                await _saveDraftToFirebase(
                  stxContext: context,
                  selectedDepartments: selectedDepartments,
                  selectedEmployees: selectedEmployees,
                  requireApproval: requireApproval,
                  limitAvailability: limitAvailability,
                  editingModel: editingModel,
                  docId: docId,
                );
              },
              textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(color: const Color(0xff2D2D2D)),
              width: 150.sp,
              height: 38.sp,
              radius: 8.r,
              color: const Color(0xffCCCCCCCC).withOpacity(.8),
            ),
          ],
        ),
      SizedBox(height: 20.sp),
    ],
  );
}
