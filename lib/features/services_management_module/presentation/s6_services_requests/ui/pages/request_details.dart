/// ******************* FILE INFO *******************
/// File Name: request_services_details.dart
/// Description: in page can make request on this services if need
/// Created by: Amr Mesbah
/// Last Update: 02/02/2026

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:demo_app/core/widgets/circle_progress.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services_toggle.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/services_permissions_sections.dart';
import 'package:lottie/lottie.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/approval_cycle_widget.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/request_service_dialogs.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/responsive_text.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/service_header_widget.dart';
import 'package:shimmer/shimmer.dart';

import 'package:demo_app/generated/l10n.dart';

import 'package:demo_app/features/notification/data/models/notification_data_model.dart';
import 'package:demo_app/features/notification/data/repository/notification_services.dart';
import 'package:demo_app/features/notification/data/repository/notification_template_service.dart';
import 'package:demo_app/features/notification/notification_page_confg.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/modules_enum.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/services_management_module/data/models/requested_model.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/pages/my_request_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/controller/request_services_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/show_requests_shimmer.dart';

import '../../../../data/helper/csv_helper.dart';

class RequestServicesDetails extends StatefulWidget {
  const RequestServicesDetails({required this.requestModel, super.key});
  final ServicesHistoryModel requestModel;

  @override
  State<RequestServicesDetails> createState() => _RequestServicesDetailsState();
}

class _RequestServicesDetailsState extends State<RequestServicesDetails> {
  final NotificationTemplateService _templateService = NotificationTemplateService();

  // ✅ Helper function to get user's language preference
  Future<bool> _getUserLanguagePreference(String userEmail) async {
    try {

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail.toLowerCase())
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        final languageCode = data?['languageCode'] ?? 'en';
        final isArabic = languageCode == 'ar';
        return isArabic;
      }
    } catch (e) {
    }

    return false;
  }

  // ✅ Send notification to first approver
  Future<void> _sendNotificationToFirstApprover({
    required String firstApproverEmail,
    required String serviceName,
    required String requesterName,
  }) async {
    if (firstApproverEmail.isEmpty) {
      return;
    }

    try {

      final employeeEntity = Get
          .find<MainCoreEmployeeController>()
          .employeeEntity!;
      final isArabic = await _getUserLanguagePreference(firstApproverEmail);

      final template = await _templateService.getTemplate(
        module: 'services',
        eventType: 'needs_approval',
      );

      if (template == null || !template.isEnabled || !template.hasPush) {
        return;
      }

      String notificationTitle = isArabic ? template.subjectArabic : template
          .subjectEnglish;
      String notificationBody = isArabic ? template.bodyArabic : template
          .bodyEnglish;

      final variables = {
        'serviceName': serviceName,
        'requesterName': requesterName,
      };
      notificationTitle =
          _templateService.processTemplate(notificationTitle, variables);
      notificationBody =
          _templateService.processTemplate(notificationBody, variables);

      final notificationModel = NotificationModelSystem(
        title: notificationTitle,
        body: notificationBody,
        nameOfModule: 'services',
        senderEmail: employeeEntity.email ?? '',
        receiverEmail: firstApproverEmail,
        nameOfPage: 'ApprovalRequestCard',
        isPinned: false,
        isRead: false,
        isClean: false,
      );

      final notificationService = FirestoreNotificationService();
      final docId = await notificationService.uploadNotification(
          notificationModel);

      await NotificationServiceApp.sendNotification(
        notificationTitle,
        notificationBody,
        firstApproverEmail,
      );

    } catch (e) {
    }
  }

  // ✅ Send notification to requester (confirmation)
  Future<void> sendNotificationToRequester({
    required String requesterEmail,
    required String serviceName,
    required bool isArabic,
  }) async {
    if (requesterEmail.isEmpty) {
      return;
    }

    try {

      final employeeEntity = Get
          .find<MainCoreEmployeeController>()
          .employeeEntity!;

      final template = await _templateService.getTemplate(
        module: 'services',
        eventType: 'request_submitted',
      );

      if (template == null || !template.isEnabled || !template.hasPush) {
        return;
      }

      String notificationTitle = isArabic ? template.subjectArabic : template
          .subjectEnglish;
      String notificationBody = isArabic ? template.bodyArabic : template
          .bodyEnglish;

      final variables = {
        'serviceName': serviceName,
      };
      notificationTitle =
          _templateService.processTemplate(notificationTitle, variables);
      notificationBody =
          _templateService.processTemplate(notificationBody, variables);

      final notificationModel = NotificationModelSystem(
        title: notificationTitle,
        body: notificationBody,
        nameOfModule: 'services',
        senderEmail: employeeEntity.email ?? '',
        receiverEmail: requesterEmail,
        nameOfPage: 'RequestServicesToggle',
        isPinned: false,
        isRead: false,
        isClean: false,
      );

      final notificationService = FirestoreNotificationService();
      await notificationService.uploadNotification(notificationModel);

      await NotificationServiceApp.sendNotification(
        notificationTitle,
        notificationBody,
        requesterEmail,
      );

    } catch (e) {
    }
  }

  // ✅ Helper function to format duration units with proper plural handling
  String getLocalizedDurationUnit(BuildContext context, String? unit,
      String duration) {
    try {
      final durationValue = int.tryParse(duration) ?? 0;
      final isArabic = Localizations
          .localeOf(context)
          .languageCode == 'ar';

      if (isArabic) {
        // Arabic plural rules
        switch (unit?.toLowerCase()) {
          case 'day':
          case 'days':
          case 'يوم':
          case 'أيام':
            if (durationValue == 1) return 'يوم';
            if (durationValue == 2) return 'يومين';
            return 'أيام';
          case 'week':
          case 'weeks':
          case 'أسبوع':
          case 'أسابيع':
            if (durationValue == 1) return 'أسبوع';
            if (durationValue == 2) return 'أسبوعين';
            return 'أسابيع';
          case 'month':
          case 'months':
          case 'شهر':
          case 'أشهر':
            if (durationValue == 1) return 'شهر';
            if (durationValue == 2) return 'شهرين';
            return 'أشهر';
          case 'year':
          case 'years':
          case 'سنة':
          case 'سنوات':
            if (durationValue == 1) return 'سنة';
            if (durationValue == 2) return 'سنتين';
            return 'سنوات';
          case 'hours':
            return S
                .of(context)
                .duration_unit_hours;
          case 'minutes':
            return S
                .of(context)
                .duration_unit_minutes;
          case 'seconds':
            return S
                .of(context)
                .duration_unit_seconds;
          default:
            return unit ?? '';
        }
      } else {
        // English plural rules
        switch (unit?.toLowerCase()) {
          case 'day':
          case 'days':
          case 'يوم':
          case 'أيام':
            return durationValue == 1 ? 'day' : 'days';
          case 'week':
          case 'weeks':
          case 'أسبوع':
          case 'أسابيع':
            return durationValue == 1 ? 'week' : 'weeks';
          case 'month':
          case 'months':
          case 'شهر':
          case 'أشهر':
            return durationValue == 1 ? 'month' : 'months';
          case 'year':
          case 'years':
          case 'سنة':
          case 'سنوات':
            return durationValue == 1 ? 'year' : 'years';
          case 'hours':
            return S
                .of(context)
                .duration_unit_hours;
          case 'minutes':
            return S
                .of(context)
                .duration_unit_minutes;
          case 'seconds':
            return S
                .of(context)
                .duration_unit_seconds;
          default:
            return unit ?? '';
        }
      }
    } catch (e) {
      return unit ?? '';
    }
  }

  bool isTabletLandscape(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    final isLandscape = MediaQuery
        .of(context)
        .orientation == Orientation.landscape;
    return size.width >= 600 && isLandscape;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations
        .localeOf(context)
        .languageCode == 'ar';
    final lightMode = Theme
        .of(context)
        .brightness == Brightness.light;
    final isMobile = context.isPhone;

    final formattedDurationUnit = getLocalizedDurationUnit(
      context,
      widget.requestModel.currentSelectedDurationUnit,
      widget.requestModel.currentDurationOfServices,
    );

    var disappearHome = Get.find<MainCoreEmployeeController>().isHasPermission(
      module: Modules.services,
      section: ServicePermissionsSections.servicesPermissions,
      permission: null,
    );

    return Scaffold(
      body: SafeArea(
        child: SideFrameMasterServices(
          titleText: FormatHelper.capitalize(S
              .of(context)
              .services),
          onFirstTap: () {
            navigateTo(context, LayoutScreenServices());
          },
          secondTitle: !disappearHome
              ? FormatHelper.capitalize(
            isArabic
                ? (widget.requestModel.currentServiceNameArabic.isNotEmpty
                ? widget.requestModel.currentServiceNameArabic
                : widget.requestModel.currentServiceNameEnglish)
                : widget.requestModel.currentServiceNameEnglish,
          )
              : FormatHelper.capitalize(S
              .of(context)
              .serviceRequests),
          onSecondTap: () {
            Navigator.pop(context);
          },
          thirdTitle: !disappearHome
              ? null
              : FormatHelper.capitalize(
            isArabic
                ? (widget.requestModel.currentServiceNameArabic.isNotEmpty
                ? widget.requestModel.currentServiceNameArabic
                : widget.requestModel.currentServiceNameEnglish)
                : widget.requestModel.currentServiceNameEnglish,
          ),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      FormatHelper.capitalize(S
                          .of(context)
                          .serviceDetails),
                      style: AppTextStyles.font16BlackSemiBoldCairo.copyWith(
                          color: lightMode
                              ? AppColors.blackButton
                              : AppColors.white),
                    )
                  ],
                ),
                SizedBox(height: 4.sp),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: lightMode
                        ? AppColors.white
                        : AppColors.chatBackground,
                  ),
                  child: Column(
                    children: [
                      ServiceHeaderWidget(requestModel: widget.requestModel),
                      SizedBox(height: 18.sp),

                      FutureBuilder<Map<String, dynamic>?>(
                        future: selectServiceProvider(
                            widget.requestModel.currentId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState
                              .waiting) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    masterShimmerPlaceholder(context: context,
                                        width: 200,
                                        height: 20),
                                    SizedBox(height: 10.h),
                                    masterShimmerPlaceholder(context: context,
                                        width: 150,
                                        height: 20),
                                    SizedBox(height: 10.h),
                                    masterShimmerPlaceholder(context: context,
                                        width: 180,
                                        height: 20),
                                  ],
                                ),
                                isMobile
                                    ? SizedBox()
                                    : SizedBox(width: MediaQuery
                                    .sizeOf(context)
                                    .width * .05),
                                isMobile
                                    ? SizedBox()
                                    : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    masterShimmerPlaceholder(context: context,
                                        width: 160,
                                        height: 20),
                                    SizedBox(height: 10.h),
                                    masterShimmerPlaceholder(context: context,
                                        width: 140,
                                        height: 20),
                                    SizedBox(height: 10.h),
                                    masterShimmerPlaceholder(context: context,
                                        width: 180,
                                        height: 20),
                                  ],
                                ),
                              ],
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data != null) {
                            final provider = snapshot.data!;
                            return buildProviderServiceDetailsServices(
                              context: context,
                              owningDepartment: widget.requestModel
                                  .currentDepartmentRequester,
                              durationUnit: FormatHelper.capitalize(
                                  formattedDurationUnit),
                              provider: provider,
                              requestModel: widget.requestModel,
                            );
                          } else {
                            return Center(
                              child: Text(
                                'No provider data found.',
                                style: AppTextStyles.font14BlackCairoRegular.copyWith(
                                  color: lightMode
                                      ? AppColors.secondaryText
                                      : AppColors.grey,
                                ),
                              ),
                            );
                          }
                        },
                      ),

                      SizedBox(height: 20.h),
                      if (widget.requestModel.currentApprovalCycle
                          .isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${S
                                  .of(context)
                                  .approvalCycle}: ",
                              style: AppTextStyles.font14BlackCairoRegular.copyWith(
                                  color: lightMode
                                      ? AppColors.secondaryText
                                      : AppColors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        ApprovalCycleWidgetServices(
                          approvalCycle: widget.requestModel
                              .currentApprovalCycle,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 20.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // ── BACK BUTTON ──────────────────────────────────────────
                    customButtonAnimation(
                      title: FormatHelper.capitalize(S
                          .of(context)
                          .back),
                      function: () {
                        Navigator.pop(context);
                      },
                      textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                          color: lightMode
                              ? AppColors.blackButton
                              : AppColors.white),
                      width: 150.sp,
                      height: 38.sp,
                      radius: 8.r,
                      color: lightMode ? AppColors.grey : AppColors.mediumGrey,
                    ),
                    Spacer(),
                    // ── REQUEST SERVICE BUTTON ───────────────────────────────
                    customButtonAnimation(
                      title: FormatHelper.capitalize(S
                          .of(context)
                          .requestService),
                      function: () async {
                        // ── Step 1: Confirmation ──────────────────────────────
                        final confirmed =
                        await RequestServiceDialogs.showConfirmationDialog(
                            context);

                        if (confirmed != true) {
                          return;
                        }

                        // ── Step 2: Show loading dialog ───────────────────────
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          useRootNavigator: true,
                          builder: (loadingContext) =>
                              WillPopScope(
                                onWillPop: () async => false,
                                child: Dialog(
                                  backgroundColor:
                                  Theme
                                      .of(loadingContext)
                                      .brightness == Brightness.light
                                      ? AppColors.white
                                      : AppColors.chatBackground,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r)),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 30.h, horizontal: 20.w),
                                    width: !isMobile ? 500.w : 350.w,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleProgressMaster(),
                                        SizedBox(height: 20.h),
                                        Text(
                                          FormatHelper.capitalize(
                                              S
                                                  .of(loadingContext)
                                                  .pleaseWait),
                                          style: AppTextStyles.font16BlackMediumCairo
                                              .copyWith(
                                            color: Theme
                                                .of(loadingContext)
                                                .brightness ==
                                                Brightness.light
                                                ? AppColors.blackButton
                                                : AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        );

                        try {

                          final employeeController =
                          Get.find<MainCoreEmployeeController>();

                          if (employeeController.employeeEntity == null) {
                            throw Exception("Please log in first");
                          }

                          final loggedInEmployee =
                          employeeController.employeeEntity!;
                          final requesterEmail = loggedInEmployee.email ?? '';

                          if (requesterEmail.isEmpty) {
                            throw Exception("Employee email is required");
                          }

                          final random = Random().nextInt(100);
                          final dateTime = Timestamp.now().toDate();
                          final formatted =
                          DateFormat("MMMdd_yyyy").format(dateTime);
                          final docId = "Request$random$formatted";

                          final approvalList =
                              widget.requestModel.currentApprovalCycle;
                          final initialState =
                          approvalList.isEmpty ? 'approved' : 'pending';

                          final updatedRequest =
                          ServicesHistoryModel.createMinimalRequest(
                            parentServiceId: widget.requestModel.currentId,
                            id: widget.requestModel.currentId,
                            providerServices:
                            widget.requestModel.currentProviderServices,
                            emailRequester: requesterEmail,
                            approvalCycle: approvalList,
                            state: initialState,
                            status: 'active',
                          );

                          final requesterFullName =
                          "${loggedInEmployee.firstName ??
                              ''} ${loggedInEmployee.lastName ?? ''}"
                              .trim();

                          final servicesRequestedModel = RequestedServices(
                            id: updatedRequest.currentId,
                            requestDate: formatted,
                            serviceProvider: updatedRequest
                                .currentProviderServices,
                            serviceRequester: requesterFullName,
                            status: "Active",
                            state: initialState,
                          );

                          await ServicesManagerCubit
                              .get(context)
                              .addRequestedService(
                            docId: updatedRequest.currentId,
                            requestModel: servicesRequestedModel,
                            uidUser: updatedRequest.currentId,
                          );

                          await ServicesManagerCubit.get(context)
                              .uploadRequestServices(docId, updatedRequest);

                          await ServicesManagerCubit.get(context)
                              .getMyRequestServices();
                          await ServicesManagerCubit.get(context)
                              .getMyApprovalServices(requesterEmail);

                          // ── Prepare notification data ─────────────────────
                          final requesterFirstName = isArabic
                              ? (loggedInEmployee.firstNameInArabic ??
                              loggedInEmployee.firstName ?? '')
                              : (loggedInEmployee.firstName ?? '');
                          final requesterLastName = isArabic
                              ? (loggedInEmployee.lastNameInArabic ??
                              loggedInEmployee.lastName ?? '')
                              : (loggedInEmployee.lastName ?? '');
                          final requesterFullNameForNotification =
                          "$requesterFirstName $requesterLastName".trim();

                          final serviceNameForNotification = isArabic
                              ? widget.requestModel.currentServiceNameArabic
                              : widget.requestModel.currentServiceNameEnglish;

                          // ── Fire & forget notifications ───────────────────
                          Future.microtask(() async {
                            try {
                              if (requesterEmail.isNotEmpty) {
                                await sendNotificationToRequester(
                                  requesterEmail: requesterEmail,
                                  serviceName: serviceNameForNotification,
                                  isArabic: isArabic,
                                );
                              }
                            } catch (e) {
                            }
                          });

                          Future.microtask(() async {
                            try {
                              if (approvalList.isNotEmpty) {
                                final firstApprover = approvalList.first;
                                final firstApproverEmail =
                                    firstApprover.email ?? '';
                                if (firstApproverEmail.isNotEmpty) {
                                  await _sendNotificationToFirstApprover(
                                    firstApproverEmail: firstApproverEmail,
                                    serviceName: serviceNameForNotification,
                                    requesterName:
                                    requesterFullNameForNotification,
                                  );
                                }
                              }
                            } catch (e) {
                            }
                          });

                          // ── Step 3: Close loading dialog ──────────────────
                          Navigator.of(context, rootNavigator: true).pop();

                          await Future.delayed(Duration(milliseconds: 300));

                          if (!mounted) return;

                          // ── Step 4: Timer fires → close dialog → navigate ─
                          // ✅ CRITICAL: Use Timer + Get.offAll (no context/mounted needed)
                          Future.delayed(Duration(seconds: 2), () {
                            Get.back(); // closes success dialog
                            navigateTo(context, MyRequestServicesToggle());
                          });

                          // ── Step 5: Show success dialog ───────────────────
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            useRootNavigator: true,
                            builder: (successContext) {
                              return WillPopScope(
                                onWillPop: () async => false,
                                child: Dialog(
                                  backgroundColor: Theme
                                      .of(successContext)
                                      .brightness ==
                                      Brightness.light
                                      ? AppColors.white
                                      : AppColors.chatBackground,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8.r)),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 30.h, horizontal: 20.w),
                                    width: !isMobile ? 500.w : 350.w,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Lottie.asset(
                                          'assets/lottie/approved.json',
                                          width: 80.w,
                                          height: 80.h,
                                          fit: BoxFit.scaleDown,
                                          repeat: false,
                                        ),
                                        SizedBox(height: 15.h),
                                        Text(
                                          FormatHelper.capitalize(S
                                              .of(successContext)
                                              .serviceRequested),
                                          style: AppTextStyles.font20BlackCairoMedium
                                              .copyWith(
                                            color: Theme
                                                .of(successContext)
                                                .brightness ==
                                                Brightness.light
                                                ? AppColors.blackButton
                                                : AppColors.white,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          FormatHelper.capitalize(S
                                              .of(successContext)
                                              .YouSuccessfullyRequestedThisService),
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.font14BlackCairoMedium
                                              .copyWith(
                                            color: Theme
                                                .of(successContext)
                                                .brightness ==
                                                Brightness.light
                                                ? AppColors.secondaryText
                                                : AppColors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );

                        } catch (e, stackTrace) {

                          // Close loading dialog on error
                          if (mounted) {
                            Navigator.of(context, rootNavigator: true).pop();
                          }

                          if (!mounted) return;

                          showDialog(
                            context: context,
                            builder: (errorContext) =>
                                AlertDialog(
                                  backgroundColor:
                                  Theme
                                      .of(errorContext)
                                      .brightness ==
                                      Brightness.light
                                      ? AppColors.white
                                      : AppColors.chatBackground,
                                  title: Text(
                                    FormatHelper.capitalize(
                                        S
                                            .of(errorContext)
                                            .error),
                                    style: AppTextStyles.font16BlackSemiBoldCairo
                                        .copyWith(
                                      color: Theme
                                          .of(errorContext)
                                          .brightness ==
                                          Brightness.light
                                          ? AppColors.blackButton
                                          : AppColors.white,
                                    ),
                                  ),
                                  content: Text(
                                    "Failed to create service request. Please try again.",
                                    style: AppTextStyles.font14BlackCairoRegular
                                        .copyWith(
                                      color: Theme
                                          .of(errorContext)
                                          .brightness ==
                                          Brightness.light
                                          ? AppColors.secondaryText
                                          : AppColors.grey,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(errorContext).pop(),
                                      child: Text(
                                        FormatHelper.capitalize(
                                            S
                                                .of(errorContext)
                                                .ok),
                                        style:
                                        TextStyle(color: AppColors.primary),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        }
                      },
                      textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                        color: AppColors.textButton,
                      ),
                      width: 150.sp,
                      height: 38.sp,
                      radius: 8.r,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
