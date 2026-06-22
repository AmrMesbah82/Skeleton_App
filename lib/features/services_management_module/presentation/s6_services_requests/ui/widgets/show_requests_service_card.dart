import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/reuse_text.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/features/notification/data/models/notification_data_model.dart';
import 'package:demo_app/features/notification/data/repository/notification_services.dart';
import 'package:demo_app/features/notification/data/repository/notification_template_service.dart';
import 'package:demo_app/features/notification/notification_page_confg.dart';

import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/services_management_module/data/models/requested_model.dart';
import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/pages/my_request_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/responsive_text.dart';

class CustomServiceCard extends StatelessWidget {
  final String serviceName;
  final String owningDepartment;
  final String serviceProvider;
  final String jobTitle;
  final String durationOfServices;
  final String approval;
  final ServicesHistoryModel model;

  CustomServiceCard({
    super.key,
    required this.serviceName,
    required this.owningDepartment,
    required this.serviceProvider,
    required this.jobTitle,
    required this.durationOfServices,
    required this.approval,
    required this.model,
  });

  var employeeEntity = Get.find<MainCoreEmployeeController>().employeeEntity!;

  final NotificationTemplateService _templateService = NotificationTemplateService();

  // ✅ Helper function to format duration with proper plural forms
  String _formatDuration(String duration, String unit, bool isArabic) {
    try {
      final durationValue = int.tryParse(duration) ?? 0;

      if (isArabic) {
        // Arabic plural rules
        if (unit.toLowerCase().contains('day') || unit.toLowerCase().contains('يوم')) {
          if (durationValue == 1) {
            return '$durationValue يوم';
          } else if (durationValue == 2) {
            return '$durationValue يومين';
          } else {
            return '$durationValue أيام';
          }
        } else if (unit.toLowerCase().contains('week') || unit.toLowerCase().contains('أسبوع')) {
          if (durationValue == 1) {
            return '$durationValue أسبوع';
          } else if (durationValue == 2) {
            return '$durationValue أسبوعين';
          } else {
            return '$durationValue أسابيع';
          }
        } else if (unit.toLowerCase().contains('month') || unit.toLowerCase().contains('شهر')) {
          if (durationValue == 1) {
            return '$durationValue شهر';
          } else if (durationValue == 2) {
            return '$durationValue شهرين';
          } else {
            return '$durationValue أشهر';
          }
        } else if (unit.toLowerCase().contains('year') || unit.toLowerCase().contains('سنة')) {
          if (durationValue == 1) {
            return '$durationValue سنة';
          } else if (durationValue == 2) {
            return '$durationValue سنتين';
          } else {
            return '$durationValue سنوات';
          }
        }
      } else {
        // English plural rules
        if (unit.toLowerCase().contains('day') || unit.toLowerCase().contains('يوم')) {
          return durationValue == 1 ? '$durationValue day' : '$durationValue days';
        } else if (unit.toLowerCase().contains('week') || unit.toLowerCase().contains('أسبوع')) {
          return durationValue == 1 ? '$durationValue week' : '$durationValue weeks';
        } else if (unit.toLowerCase().contains('month') || unit.toLowerCase().contains('شهر')) {
          return durationValue == 1 ? '$durationValue month' : '$durationValue months';
        } else if (unit.toLowerCase().contains('year') || unit.toLowerCase().contains('سنة')) {
          return durationValue == 1 ? '$durationValue year' : '$durationValue years';
        }
      }

      // Fallback: return original if no match
      return '$duration $unit';
    } catch (e) {
      return '$duration $unit';
    }
  }

  // ✅ NEW: Get owning department using MainCore
  Future<Map<String, String>> _getOwningDepartment() async {
    try {

      final employeeController = Get.find<MainCoreEmployeeController>();

      if (employeeController.employeeEntity == null) {
        return {'english': '', 'arabic': ''};
      }

      final requesterEmail = employeeController.employeeEntity!.email ?? '';

      // Get employee's department ID
      final employeeEntity = employeeController.mapOfEmployeesWithEmailKey[requesterEmail];

      if (employeeEntity == null) {
        return {'english': '', 'arabic': ''};
      }

      final departmentId = employeeEntity.departmentId ?? '';

      if (departmentId.isEmpty) {
        return {'english': '', 'arabic': ''};
      }

      // Get department names from MainCoreDepartmentController
      final deptController = Get.find<MainCoreDepartmentController>();

      final deptNameEnglish = deptController.getDepartmentName(departmentId, true);
      final deptNameArabic = deptController.getDepartmentName(departmentId, false);

      return {
        'english': deptNameEnglish,
        'arabic': deptNameArabic,
      };
    } catch (e) {
      return {'english': '', 'arabic': ''};
    }
  }

  // ✅ NEW: Get service names and duration from CreateServices collection
  Future<Map<String, String>> _getServiceDataFromCreateServices() async {
    try {

      // ✅ FIX: Use parentServiceId to get the original service from CreateServices
      final parentServiceId = model.currentId;

      if (parentServiceId.isEmpty) {

        // ✅ FALLBACK: Try using currentId if parentServiceId is empty
        final fallbackId = model.currentId;

        if (fallbackId.isEmpty) {
          return {
            'serviceNameEnglish': '',
            'serviceNameArabic': '',
            'duration': '',
            'unit': '',
          };
        }

        // Use fallback ID
        final serviceId = fallbackId;
      }

      final serviceId = parentServiceId.isNotEmpty ? parentServiceId : model.currentId;

      if (serviceId.isEmpty) {
        return {
          'serviceNameEnglish': '',
          'serviceNameArabic': '',
          'duration': '',
          'unit': '',
        };
      }

      // Get company ID from SharedPreferences or your config
      final prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getString('companyId') ?? '14031841';

      // Path: /Demo/{companyId}/Createdemo_app/{serviceId}
      final docRef = FirebaseFirestore.instance
          .collection('Demo')
          .doc(companyId)
          .collection('CreateServices')
          .doc(serviceId);

      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        return {
          'serviceNameEnglish': '',
          'serviceNameArabic': '',
          'duration': '',
          'unit': '',
        };
      }

      final data = docSnapshot.data();

      if (data == null) {
        return {
          'serviceNameEnglish': '',
          'serviceNameArabic': '',
          'duration': '',
          'unit': '',
        };
      }

      // Extract service names (English & Arabic)
      String serviceNameEnglish = '';
      String serviceNameArabic = '';

      if (data['serviceNameEnglish'] != null) {
        if (data['serviceNameEnglish'] is List) {
          final nameList = data['serviceNameEnglish'] as List;
          serviceNameEnglish = nameList.isNotEmpty ? nameList.last.toString() : '';
        } else {
          serviceNameEnglish = data['serviceNameEnglish'].toString();
        }
      }

      if (data['serviceNameArabic'] != null) {
        if (data['serviceNameArabic'] is List) {
          final nameList = data['serviceNameArabic'] as List;
          serviceNameArabic = nameList.isNotEmpty ? nameList.last.toString() : '';
        } else {
          serviceNameArabic = data['serviceNameArabic'].toString();
        }
      }

      // Extract duration and unit from arrays (last values)
      String duration = '';
      String unit = '';

      if (data['durationOfServices'] != null) {
        if (data['durationOfServices'] is List) {
          final durationList = data['durationOfServices'] as List;
          duration = durationList.isNotEmpty ? durationList.last.toString() : '';
        } else {
          duration = data['durationOfServices'].toString();
        }
      }

      if (data['selectedDurationUnit'] != null) {
        if (data['selectedDurationUnit'] is List) {
          final unitList = data['selectedDurationUnit'] as List;
          unit = unitList.isNotEmpty ? unitList.last.toString() : '';
        } else {
          unit = data['selectedDurationUnit'].toString();
        }
      }

      return {
        'serviceNameEnglish': serviceNameEnglish,
        'serviceNameArabic': serviceNameArabic,
        'duration': duration,
        'unit': unit,
      };
    } catch (e) {
      return {
        'serviceNameEnglish': '',
        'serviceNameArabic': '',
        'duration': '',
        'unit': '',
      };
    }
  }

  // ✅ NEW: Helper to get user's language preference
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

      final isArabic = await _getUserLanguagePreference(firstApproverEmail);

      final template = await _templateService.getTemplate(
        module: 'services',
        eventType: 'needs_approval',
      );

      if (template == null || !template.isEnabled || !template.hasPush) {
        return;
      }

      String notificationTitle = isArabic ? template.subjectArabic : template.subjectEnglish;
      String notificationBody = isArabic ? template.bodyArabic : template.bodyEnglish;

      final variables = {
        'serviceName': serviceName,
        'requesterName': requesterName,
      };
      notificationTitle = _templateService.processTemplate(notificationTitle, variables);
      notificationBody = _templateService.processTemplate(notificationBody, variables);

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
      final docId = await notificationService.uploadNotification(notificationModel);

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
  }) async
  {
    if (requesterEmail.isEmpty) {
      return;
    }

    try {

      final template = await _templateService.getTemplate(
        module: 'services',
        eventType: 'request_submitted',
      );

      if (template == null || !template.isEnabled || !template.hasPush) {
        return;
      }

      String notificationTitle = isArabic ? template.subjectArabic : template.subjectEnglish;
      String notificationBody = isArabic ? template.bodyArabic : template.bodyEnglish;

      final variables = {
        'serviceName': serviceName,
      };
      notificationTitle = _templateService.processTemplate(notificationTitle, variables);
      notificationBody = _templateService.processTemplate(notificationBody, variables);

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

  @override
  Widget build(BuildContext cardContext) {
    final dateTime = Timestamp.now().toDate();
    final formatted = DateFormat("MMMdd_yyyy").format(dateTime);
    final lightMode = Theme.of(cardContext).brightness == Brightness.light;
    final isArabic = Localizations.localeOf(cardContext).languageCode == 'ar';
    final isMobile = cardContext.isPhone;

    return BlocConsumer<ServicesManagerCubit, ServicesManagerState>(
      listener: (context, state) {},
      builder: (context, state) {
        return FutureBuilder<Map<String, dynamic>>(
          // ✅ Fetch service data (names + duration) AND owning department
          future: Future.wait([
            _getServiceDataFromCreateServices(),
            _getOwningDepartment(),
          ]).then((results) {
            return {
              'serviceData': results[0] as Map<String, String>,
              'department': results[1] as Map<String, String>,
            };
          }),
          builder: (context, snapshot) {
            // ✅ Display data from CreateServices and MainCore
            String displayServiceName = serviceName;
            String displayOwningDepartment = owningDepartment;
            String displayDuration = durationOfServices;

            if (snapshot.hasData) {
              final data = snapshot.data!;
              final serviceData = data['serviceData'] as Map<String, String>;
              final deptData = data['department'] as Map<String, String>;

              // Use service name from CreateServices
              if (isArabic) {
                if (serviceData['serviceNameArabic']!.isNotEmpty) {
                  displayServiceName = serviceData['serviceNameArabic']!;
                }
              } else {
                if (serviceData['serviceNameEnglish']!.isNotEmpty) {
                  displayServiceName = serviceData['serviceNameEnglish']!;
                }
              }

              // Use department from MainCore
              if (deptData['english']!.isNotEmpty || deptData['arabic']!.isNotEmpty) {
                displayOwningDepartment = isArabic
                    ? deptData['arabic']!
                    : deptData['english']!;
              }

              // Use duration from CreateServices collection
              if (serviceData['duration']!.isNotEmpty && serviceData['unit']!.isNotEmpty) {
                displayDuration = _formatDuration(
                  serviceData['duration']!,
                  serviceData['unit']!,
                  isArabic,
                );
              }
            }

            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.white
                    : AppColors.chatBackground,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 15.sp, right: 15.sp, left: 15.sp,bottom: 15.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40.sp,
                          height: 40.sp,
                          decoration: BoxDecoration(
                            color: lightMode ? AppColors.background : AppColors.background,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: (model.currentImageUrl.isNotEmpty)
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: CachedNetworkImage(
                              imageUrl: model.currentImageUrl,
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
                                  width: 20.sp,
                                  height: 20.sp,
                                  color: lightMode
                                      ? AppColors.secondaryText
                                      : AppColors.grey,
                                  fit: BoxFit.scaleDown,
                                );
                              },
                            ),
                          )
                              : SvgPicture.asset(
                            "assets/images/headPhone.svg",
                            width: 20.sp,
                            height: 20.sp,
                            color: lightMode ? AppColors.secondaryText : AppColors.grey,
                            fit: BoxFit.scaleDown,
                            semanticsLabel: 'Dart Logo',
                          ),
                        ),
                        SizedBox(width: 8.sp),
                        Expanded(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            FormatHelper.capitalize(serviceName),
                            style: AppTextStyles.font16BlackMediumCairo.copyWith(
                              color: Theme.of(context).brightness == Brightness.light
                                  ? AppColors.blackButton
                                  : AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.sp),
                    textCorner(
                      image: "assets/own.svg",
                      label: "${S.of(context).OwningDepartment}: ",
                      content: displayOwningDepartment,
                      context: context,
                    ),
                    SizedBox(height: 5.sp),
                    textCorner(
                      image: "assets/images/details/User Plus.svg",
                      label: "${S.of(context).serviceProvider}: ",
                      content: FormatHelper.capitalize(serviceProvider),
                      context: context,
                    ),
                    SizedBox(height: 5.sp),
                    textCorner(
                      image: "assets/images/details/Case.svg",
                      label: "${S.of(context).jobTitle}: ",
                      content: FormatHelper.capitalize(jobTitle),
                      context: context,
                    ),
                    SizedBox(height: 5.sp),
                    textCorner(
                      image: "assets/images/details/Group 1000004482.svg",
                      label: "${S.of(context).durationOfService}: ",
                      content: FormatHelper.capitalize(displayDuration),
                      context: context,
                    ),
                    SizedBox(height: 5.sp),
                    textCorner(
                      image: "assets/services_module/approval_icons.svg",
                      label: "${S.of(context).approvals}: ",
                      content: FormatHelper.capitalize(approval),
                      context: context,
                    ),
                    SizedBox(height: 10.sp),
                    customButtonAnimation(
                      title: FormatHelper.capitalize(S.of(context).request),
                      function: () {
                        final random = Random().nextInt(100);
                        final dateTime = Timestamp.now().toDate();
                        final formatted = DateFormat("MMMdd_yyyy").format(dateTime);
                        final docId = "Request$random$formatted";

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => StatefulBuilder(
                            builder: (context, setState) {
                              bool isLoading = false;

                              return Dialog(
                                backgroundColor: Theme.of(context).brightness == Brightness.light
                                    ? AppColors.white
                                    : AppColors.chatBackground,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.sp),
                                  width: 411.sp,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Lottie.asset(
                                        'assets/lottie/create request.json',
                                        width: 80.sp,
                                        height: 80.sp,
                                        fit: BoxFit.scaleDown,
                                        repeat: true,
                                        animate: true,
                                      ),
                                      SizedBox(height: 8.sp),
                                      Text(
                                        FormatHelper.capitalize(S.of(context).RequestService),
                                        style: AppTextStyles.font20BlackCairoMedium.copyWith(
                                          color: Theme.of(context).brightness == Brightness.light
                                              ? AppColors.blackButton
                                              : AppColors.white,
                                        ),
                                      ),
                                      SizedBox(height: 10.sp),
                                      Text(
                                        FormatHelper.capitalize(S.of(context).AreYouSureYouWantToRequestThisService),
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.font14BlackCairoMedium.copyWith(
                                          color: Theme.of(context).brightness == Brightness.light
                                              ? AppColors.secondaryText
                                              : AppColors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 15.h),

                                      if (isLoading)
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10.h),
                                          child: CircularProgressIndicator(
                                            color: AppColors.primary,
                                            strokeWidth: 3.0,
                                          ),
                                        )
                                      else
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            customButtonAnimation(
                                              title: FormatHelper.capitalize(S.of(context).no),
                                              function: () => Navigator.pop(context),
                                              textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(color: Color(0xff2D2D2D)),
                                              width: isMobile ? 120.sp : 135.sp,
                                              height: 38.sp,
                                              radius: 8.r,
                                              color: AppColors.secondaryButton,
                                            ),
                                            SizedBox(width: 28.w),
                                            customButtonAnimation(
                                              title: FormatHelper.capitalize(S.of(context).yes),
                                              function: () async {
                                                setState(() {
                                                  isLoading = true;
                                                });

                                                try {

                                                  final employeeController = Get.find<MainCoreEmployeeController>();

                                                  if (employeeController.employeeEntity == null) {
                                                    throw Exception("Please log in first");
                                                  }

                                                  final loggedInEmployee = employeeController.employeeEntity!;
                                                  final requesterEmail = loggedInEmployee.email ?? '';

                                                  if (requesterEmail.isEmpty) {
                                                    throw Exception("Employee email is required");
                                                  }

                                                  final approvalList = model.currentApprovalCycle;
                                                  final initialState = approvalList.isEmpty ? 'approved' : 'pending';

                                                  final updatedRequest = ServicesHistoryModel.createMinimalRequest(
                                                    parentServiceId: model.currentId,
                                                    id: model.currentId,
                                                    providerServices: model.currentProviderServices,
                                                    emailRequester: requesterEmail,
                                                    approvalCycle: approvalList,
                                                    state: initialState,
                                                    status: 'active',
                                                  );

                                                  final requesterFullName = "${loggedInEmployee.firstName ?? ''} ${loggedInEmployee.lastName ?? ''}".trim();

                                                  final servicesRequestedModel = RequestedServices(
                                                    id: updatedRequest.currentId,
                                                    requestDate: formatted,
                                                    serviceProvider: updatedRequest.currentProviderServices,
                                                    serviceRequester: requesterFullName,
                                                    status: "Active",
                                                    state: initialState,
                                                  );

                                                  await ServicesManagerCubit.get(context).addRequestedService(
                                                    docId: updatedRequest.currentId,
                                                    requestModel: servicesRequestedModel,
                                                    uidUser: updatedRequest.currentId,
                                                  );

                                                  await ServicesManagerCubit.get(context).uploadRequestServices(docId, updatedRequest);

                                                  await ServicesManagerCubit.get(context).getMyRequestServices();
                                                  await ServicesManagerCubit.get(context).getMyApprovalServices(requesterEmail);

                                                  final requesterFirstName = isArabic
                                                      ? (loggedInEmployee.firstNameInArabic ?? loggedInEmployee.firstName ?? '')
                                                      : (loggedInEmployee.firstName ?? '');
                                                  final requesterLastName = isArabic
                                                      ? (loggedInEmployee.lastNameInArabic ?? loggedInEmployee.lastName ?? '')
                                                      : (loggedInEmployee.lastName ?? '');
                                                  final requesterFullNameForNotification = "$requesterFirstName $requesterLastName".trim();

                                                  final serviceNameForNotification = isArabic
                                                      ? model.currentServiceNameArabic
                                                      : model.currentServiceNameEnglish;

                                                  if (requesterEmail.isNotEmpty) {
                                                    await sendNotificationToRequester(
                                                      requesterEmail: requesterEmail,
                                                      serviceName: serviceNameForNotification,
                                                      isArabic: isArabic,
                                                    );
                                                  }

                                                  if (approvalList.isNotEmpty) {
                                                    final firstApprover = approvalList.first;
                                                    final firstApproverEmail = firstApprover.email ?? '';

                                                    if (firstApproverEmail.isNotEmpty) {
                                                      await _sendNotificationToFirstApprover(
                                                        firstApproverEmail: firstApproverEmail,
                                                        serviceName: serviceNameForNotification,
                                                        requesterName: requesterFullNameForNotification,
                                                      );
                                                    }
                                                  }

                                                  if (Navigator.of(context).canPop()) {
                                                    Navigator.of(context).pop();
                                                  }

                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder: (dialogCtx) {
                                                      Future.delayed(const Duration(seconds: 2), () {
                                                        if (Navigator.of(dialogCtx).canPop()) {
                                                          Navigator.of(dialogCtx).pop();
                                                        }
                                                        Navigator.of(cardContext).push(
                                                          MaterialPageRoute(builder: (_) => MyRequestServicesToggle()),
                                                        );
                                                      });

                                                      return Dialog(
                                                        backgroundColor: Theme.of(dialogCtx).brightness == Brightness.light
                                                            ? AppColors.white
                                                            : AppColors.chatBackground,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(vertical: 15.h),
                                                          width: 411.sp,
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Lottie.asset(
                                                                'assets/lottie/approved.json',
                                                                width: 70.w,
                                                                height: 70.h,
                                                                fit: BoxFit.scaleDown,
                                                              ),
                                                              SizedBox(height: 8.h),
                                                              Text(
                                                                FormatHelper.capitalize(S.of(dialogCtx).serviceRequested),
                                                                style: AppTextStyles.font20BlackCairoMedium.copyWith(
                                                                  color: Theme.of(dialogCtx).brightness == Brightness.light
                                                                      ? AppColors.blackButton
                                                                      : AppColors.white,
                                                                ),
                                                              ),
                                                              SizedBox(height: 10.h),
                                                              Text(
                                                                FormatHelper.capitalize(S.of(dialogCtx).YouSuccessfullyRequestedThisService),
                                                                textAlign: TextAlign.center,
                                                                style: AppTextStyles.font14BlackCairoMedium.copyWith(
                                                                  color: Theme.of(dialogCtx).brightness == Brightness.light
                                                                      ? AppColors.secondaryText
                                                                      : AppColors.grey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                } catch (e, stackTrace) {

                                                  setState(() {
                                                    isLoading = false;
                                                  });

                                                  if (!context.mounted) return;
                                                  showDialog(
                                                    context: context,
                                                    builder: (ctx) => AlertDialog(
                                                      title: Text(S.of(context).error),
                                                      content: Text(S.of(context).failedToCreateServiceRequest),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(ctx).pop();
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text(S.of(context).ok),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              },
                                              textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(color: AppColors.textButton),
                                              width: isMobile ? 120.sp : 135.sp,
                                              height: 38.sp,
                                              radius: 8.r,
                                              color: AppColors.primary,
                                            ),
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(color: AppColors.textButton),
                      height: 35.sp,
                      radius: 8.r,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
