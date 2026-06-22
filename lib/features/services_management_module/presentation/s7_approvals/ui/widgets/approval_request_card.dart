import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/notification/data/models/notification_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/features/notification/data/repository/notification_services.dart';
import 'package:demo_app/features/notification/data/repository/notification_template_service.dart';
import 'package:demo_app/features/notification/notification_page_confg.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';
import 'package:demo_app/core/widgets/services_management/custom_dialog.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/controller/create_services_helper.dart';
import 'package:demo_app/features/services_management_module/presentation/s7_approvals/ui/pages/approval_request_details_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s7_approvals/ui/widgets/build_info_row.dart';
import 'package:demo_app/features/services_management_module/presentation/s7_approvals/ui/widgets/dialog.dart';

class ApprovalRequestCard extends StatefulWidget {
  final ServicesHistoryModel service;
  final VoidCallback onRefresh;
  final bool isTablet;
  final bool isMobile;
  final bool isLandscape;

  const ApprovalRequestCard({
    super.key,
    required this.service,
    required this.onRefresh,
    required this.isTablet,
    required this.isMobile,
    required this.isLandscape,
  });

  @override
  State<ApprovalRequestCard> createState() => _ApprovalRequestCardState();
}

class _ApprovalRequestCardState extends State<ApprovalRequestCard> {
  final TextEditingController rejectController = TextEditingController();
  final TextEditingController approveController = TextEditingController();
  late final employeeEntity;
  final prefs = SharedPreferences.getInstance();
  late final MainCoreDepartmentController departmentController;
  late final MainCoreEmployeeController employeeController;

  final NotificationTemplateService _templateService = NotificationTemplateService();

  @override
  void initState() {
    super.initState();
    employeeEntity = Get.find<MainCoreEmployeeController>().employeeEntity!;
    departmentController = Get.find<MainCoreDepartmentController>();
    employeeController = Get.find<MainCoreEmployeeController>();

    _printServiceData();
  }

  void _printServiceData() {

    // ✅ Get data from controller instead of model
    final requesterEmail = widget.service.currentEmailRequester ?? '';
    if (requesterEmail.isNotEmpty) {
      final employee = employeeController.getLocaleEmployee(requesterEmail);
      if (employee != null) {

        // Get department from controller
        if (employee.departmentId != null && employee.departmentId!.isNotEmpty) {
          final deptEn = departmentController.getEnglishDepartmentNameFromDepartmentId(departmentId: employee.departmentId!);
          final deptAr = departmentController.getArabicDepartmentNameFromDepartmentId(departmentId: employee.departmentId!);
        }
      }
    }

    if (widget.service.timestamps.isNotEmpty) {
      final firstTimestamp = widget.service.timestamps.first;
      final date = DateTime.fromMillisecondsSinceEpoch(firstTimestamp);
    }

    for (int i = 0; i < widget.service.currentApprovalCycle.length; i++) {
      final approver = widget.service.currentApprovalCycle[i];

      // Get name from controller
      final approverName = employeeController.getEmployeeName(approver.email ?? '');
    }

  }

  String _stateAsset(String state) {
    switch (state.toLowerCase()) {
      case 'done':
        return 'assets/status/done.svg';
      case 'approved':
        return 'assets/state/approved.svg';
      case 'pending':
        return 'assets/state/pending.svg';
      case 'rejected':
        return 'assets/state/reject.svg';
      case 'cancel':
        return 'assets/state/cansel.svg';
      case 'inprogress':
        return 'assets/state/inprogress_icon.svg';
      case 'branchsla':
      case 'breached sla':
        return 'assets/state/breached SLA.svg';
      default:
        return 'assets/state/pending.svg';
    }
  }

  Widget _stateBadge({
    required String label,
    required String state,
    required Color color,
  }) {
    final asset = _stateAsset(state);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            asset,
            width: 24.sp,
            height: 24.sp,
            fit: BoxFit.scaleDown,
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: AppTextStyles.font16BlackMediumCairo.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Future<void> _sendNotificationToProvider({
    required String action,
    required String providerEmail,
    required String serviceName,
    required String requesterName,
  }) async {
    if (providerEmail.isEmpty) {
      return;
    }

    try {

      final isArabic = await _getRequesterLanguagePreference(providerEmail);

      String notificationTitle;
      String notificationBody;

      if (action == 'approved') {
        final template = await _templateService.getTemplate(
          module: 'services',
          eventType: 'request_in_progress',
        );

        if (template == null || !template.isEnabled || !template.hasPush) {
          return;
        }

        notificationTitle = isArabic ? template.subjectArabic : template.subjectEnglish;
        notificationBody = isArabic ? template.bodyArabic : template.bodyEnglish;

        final variables = {
          'serviceName': serviceName,
          'requesterName': requesterName,
        };
        notificationTitle = _templateService.processTemplate(notificationTitle, variables);
        notificationBody = _templateService.processTemplate(notificationBody, variables);

      } else {
        final template = await _templateService.getTemplate(
          module: 'services',
          eventType: 'request_rejected',
        );

        if (template == null || !template.isEnabled || !template.hasPush) {
          return;
        }

        notificationTitle = isArabic ? template.subjectArabic : template.subjectEnglish;
        notificationBody = isArabic ? template.bodyArabic : template.bodyEnglish;

        final variables = {
          'serviceName': serviceName,
          'requesterName': requesterName,
          'rejectionReason': '',
        };
        notificationTitle = _templateService.processTemplate(notificationTitle, variables);
        notificationBody = _templateService.processTemplate(notificationBody, variables);

      }

      final notificationModel = NotificationModelSystem(
        title: notificationTitle,
        body: notificationBody,
        nameOfModule: 'services',
        senderEmail: employeeEntity.email ?? '',
        receiverEmail: providerEmail,
        nameOfPage: 'ServiceProviderDashboard',
        isPinned: false,
        isRead: false,
        isClean: false,
      );

      final notificationService = FirestoreNotificationService();
      final docId = await notificationService.uploadNotification(notificationModel);

      await NotificationServiceApp.sendNotification(
        notificationTitle,
        notificationBody,
        providerEmail,
      );

    } catch (notificationError) {
    }
  }

  String? _extractProviderEmail(Map<String, dynamic> docData) {
    try {
      // ✅ Check both field name variations
      final providerServices = docData['providerServices'] ?? docData['Provider_Services'];

      if (providerServices == null) {
        return null;
      }

      if (providerServices is List && providerServices.isEmpty) {
        return null;
      }

      final firstProvider = providerServices is List ? providerServices.first : providerServices;

      if (firstProvider is String) {
        final decoded = jsonDecode(firstProvider);

        if (decoded is List && decoded.isNotEmpty) {
          final provider = decoded.first;
          if (provider is Map && provider['email'] != null) {
            final email = provider['email'].toString();
            return email;
          }
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  String getLocalizedDurationUnit(
      BuildContext context,
      String? rawUnit, {
        num? quantity,
      }) {
    if (rawUnit == null || rawUnit.trim().isEmpty) return '';
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final k = rawUnit.trim().toLowerCase();

    if (RegExp(r'[\u0600-\u06FF]').hasMatch(rawUnit)) return rawUnit;

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
        canonical = 'weeks';
        break;
      case 'd':
      case 'day':
      case 'days':
        canonical = 'days';
        break;
      case 'mo':
      case 'month':
      case 'months':
        canonical = 'months';
        break;
      case 'y':
      case 'yr':
      case 'yrs':
      case 'year':
      case 'years':
        canonical = 'years';
        break;
      default:
        return rawUnit;
    }

    final isSingular = (quantity == null) ? false : (quantity == 1);

    String result;
    if (!isArabic) {
      switch (canonical) {
        case 'hours':
          result = isSingular ? 'hour' : 'hours';
        case 'minutes':
          result = isSingular ? 'minute' : 'minutes';
        case 'seconds':
          result = isSingular ? 'second' : 'seconds';
        case 'weeks':
          result = isSingular ? 'week' : 'weeks';
        case 'days':
          result = isSingular ? 'day' : 'days';
        case 'months':
          result = isSingular ? 'month' : 'months';
        case 'years':
          result = isSingular ? 'year' : 'years';
        default:
          result = rawUnit;
      }
    } else {
      switch (canonical) {
        case 'hours':
          result = isSingular ? 'ساعة' : 'ساعات';
        case 'minutes':
          result = isSingular ? 'دقيقة' : 'دقائق';
        case 'seconds':
          result = isSingular ? 'ثانية' : 'ثوانٍ';
        case 'weeks':
          result = isSingular ? 'أسبوع' : 'أسابيع';
        case 'days':
          result = isSingular ? 'يوم' : 'أيام';
        case 'months':
          result = isSingular ? 'شهر' : 'أشهر';
        case 'years':
          result = isSingular ? 'سنة' : 'سنوات';
        default:
          result = rawUnit;
      }
    }

    return result;
  }

  bool _isMyTurn(ServicesHistoryModel service, String? myEmail) {

    if (myEmail == null || myEmail.isEmpty) {
      return false;
    }

    final serviceStatus = (service.currentState ?? '').toLowerCase().trim();

    if (serviceStatus == 'cancel' || serviceStatus == 'cancelled') {
      return false;
    }

    if (serviceStatus == 'done' || serviceStatus == 'completed') {
      return false;
    }

    final list = service.currentApprovalCycle;

    final hasCancelled = list.any((approver) {
      final state = (approver.state ?? '').toLowerCase().trim();
      return (state == 'cancel' || state == 'cancelled');
    });

    if (hasCancelled) {
      return false;
    }

    final myIndex = list.indexWhere((e) => (e.email ?? '').toLowerCase() == myEmail.toLowerCase());

    if (myIndex == -1) {
      return false;
    }

    final myState = (list[myIndex].state ?? '').toLowerCase().trim();

    if (myState == 'approved') {
      return false;
    }

    if (myState == 'rejected') {
      return false;
    }

    if (myState == 'cancel' || myState == 'cancelled') {
      return false;
    }

    final isMyStateActionable = (myState.isEmpty || myState == 'normal' || myState == 'pending');

    if (!isMyStateActionable) {
      return false;
    }

    for (int i = 0; i < myIndex; i++) {
      final prev = (list[i].state ?? '').toLowerCase().trim();

      if (prev != 'approved') {
        return false;
      }
    }

    return true;
  }

  String myActionOf(ServicesHistoryModel service, String myEmail) {

    final serviceStatus = (service.currentState ?? '').toLowerCase().trim();

    if (serviceStatus == 'cancel' || serviceStatus == 'cancelled') {
      return 'cancel';
    }

    final list = service.currentApprovalCycle;

    final cancelledApprover = list.firstWhere(
          (approver) {
        final state = (approver.state ?? '').toLowerCase().trim();
        return state == 'cancel' || state == 'cancelled';
      },
      orElse: () => list.first,
    );

    final cancelledState = (cancelledApprover.state ?? '').toLowerCase().trim();
    if (cancelledState == 'cancel' || cancelledState == 'cancelled') {
      return 'cancel';
    }

    final i = list.indexWhere((e) => (e.email ?? '').toLowerCase() == myEmail.toLowerCase());

    if (i == -1) {
      return 'pending';
    }

    final s = (list[i].state ?? '').toLowerCase().trim();

    String result;
    if (s.isEmpty || s == 'normal') {
      result = 'pending';
    } else if (s == 'approved') {
      result = 'approved';
    } else if (s == 'rejected') {
      result = 'rejected';
    } else if (s == 'cancel' || s == 'cancelled') {
      result = 'cancel';
    } else {
      result = 'pending';
    }

    return result;
  }

  String localizedMyAction(BuildContext context, String act) {
    final t = S.of(context);
    final result = switch (act) {
      'approved' => t.Approved,
      'rejected' => t.Rejected,
      'cancel' || 'cancelled' => t.canceled,
      _ => t.Pending
    };
    return result;
  }

  Color myActionColor(BuildContext context, String act) {
    Color result;
    switch (act) {
      case 'approved':
        result = AppColors.lightGreen;
      case 'rejected':
        result = AppColors.red;
      case 'cancel':
      case 'cancelled':
        result = AppColors.darkRed!;
      default:
        result = AppColors.orange;
    }
    return result;
  }

  Future<bool> _getRequesterLanguagePreference(String requesterEmail) async {
    try {

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(requesterEmail.toLowerCase())
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

  Future<Map<String, String>> _getApproverName(String approverEmail) async {
    try {

      // ✅ Use controller instead of Firestore direct access
      final approverName = employeeController.getEmployeeNameEnglishArabic(approverEmail, true);
      final approverNameAr = employeeController.getEmployeeNameEnglishArabic(approverEmail, false);

      if (approverName.isNotEmpty && approverName != 'no name') {
        return {
          'en': approverName,
          'ar': approverNameAr,
        };
      }
    } catch (e) {
    }

    return {'en': 'System', 'ar': 'النظام'};
  }

  Future<void> _sendNotificationToRequester({
    required String action,
    required String requesterEmail,
    required String serviceName,
    required String approverEmail,
  }) async {
    if (requesterEmail.isEmpty) {
      return;
    }

    try {

      final isArabic = await _getRequesterLanguagePreference(requesterEmail);
      final approverNames = await _getApproverName(approverEmail);
      final approverName = isArabic ? approverNames['ar']! : approverNames['en']!;

      String notificationTitle;
      String notificationBody;

      if (action == 'approved') {
        final template = await _templateService.getTemplate(
          module: 'services',
          eventType: 'request_approved',
        );

        if (template == null || !template.isEnabled || !template.hasPush) {
          return;
        }

        notificationTitle = isArabic ? template.subjectArabic : template.subjectEnglish;
        notificationBody = isArabic ? template.bodyArabic : template.bodyEnglish;

        final variables = {
          'serviceName': serviceName,
          'approverName': approverName,
          'rejectionReason': '',
        };
        notificationTitle = _templateService.processTemplate(notificationTitle, variables);
        notificationBody = _templateService.processTemplate(notificationBody, variables);

      } else {
        final template = await _templateService.getTemplate(
          module: 'services',
          eventType: 'request_rejected',
        );

        if (template == null || !template.isEnabled || !template.hasPush) {
          return;
        }

        notificationTitle = isArabic ? template.subjectArabic : template.subjectEnglish;
        notificationBody = isArabic ? template.bodyArabic : template.bodyEnglish;

        final variables = {
          'serviceName': serviceName,
          'approverName': approverName,
          'rejectionReason': '',
        };
        notificationTitle = _templateService.processTemplate(notificationTitle, variables);
        notificationBody = _templateService.processTemplate(notificationBody, variables);

      }

      final notificationModel = NotificationModelSystem(
        title: notificationTitle,
        body: notificationBody,
        nameOfModule: 'services',
        senderEmail: approverEmail,
        receiverEmail: requesterEmail,
        nameOfPage: 'RequestServicesToggle',
        isPinned: false,
        isRead: false,
        isClean: false,
      );

      final notificationService = FirestoreNotificationService();
      final docId = await notificationService.uploadNotification(notificationModel);

      await NotificationServiceApp.sendNotification(
        notificationTitle,
        notificationBody,
        requesterEmail,
      );

    } catch (notificationError) {
    }
  }

  Future<void> _sendNotificationToNextApprover({
    required String nextApproverEmail,
    required String serviceName,
    required String requesterName,
  }) async {
    if (nextApproverEmail.isEmpty) {
      return;
    }

    try {

      final isArabic = await _getRequesterLanguagePreference(nextApproverEmail);

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
        receiverEmail: nextApproverEmail,
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
        nextApproverEmail,
      );

    } catch (notificationError) {
    }
  }

  @override
  void didUpdateWidget(covariant ApprovalRequestCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.service.currentId != widget.service.currentId) {
      approveController.clear();
      rejectController.clear();
      setState(() {});
      _printServiceData();
    }
  }

  @override
  Widget build(BuildContext context) {

    final light = Theme.of(context).brightness == Brightness.light;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final myEmail = (employeeEntity.email ?? '').toLowerCase();
    final myAction = myActionOf(widget.service, myEmail);
    final myActionLabel = localizedMyAction(context, myAction);
    final myActionClr = myActionColor(context, myAction);

    final serviceState = (widget.service.currentState ?? '').toLowerCase().trim();

    final isServiceCancelled = (serviceState == 'cancel' || serviceState == 'cancelled');
    final isServiceDone = (serviceState == 'done');
    final isMyActionCancelled = (myAction == 'cancel' || myAction == 'cancelled');

    final isTerminalState = isServiceCancelled || isServiceDone || isMyActionCancelled;

    final isMyTurnResult = _isMyTurn(widget.service, myEmail);

    final canAct = !isTerminalState &&
        (myAction == 'pending') &&
        isMyTurnResult;

    final dateRequested = widget.service.timestamps.isNotEmpty
        ? DateTime.fromMillisecondsSinceEpoch(widget.service.timestamps.first)
        : DateTime.now();

    return GestureDetector(
      onTap: () {
        navigateTo(
          context,
          ServicesApprovalDetailsToggle(
            index: 0,
            approvalModel: widget.service,
          ),
        );
      },
      child: FutureBuilder<Map<String, String>>(
        future: CreateServicesHelper.getServiceDetailsFromCreateServices(
          parentServiceId: widget.service.currentParentServiceId , // ✅ CORRECT!              ? widget.service.currentId
          emailRequester: widget.service.currentEmailRequester ?? '',
        ),
        builder: (context, snapshot) {
          // ✅ Default values - Get from controller
          String displayServiceName = '';
          String displayDepartment = '-';
          String displayDuration = '';
          String displayJobTitle = '-';
          String displayRequesterName = '-';

          // ✅ Get requester data from MainCoreEmployeeController
          final requesterEmail = widget.service.currentEmailRequester ?? '';

          if (requesterEmail.isNotEmpty) {
            // Get full name from controller
            displayRequesterName = employeeController.getEmployeeNameEnglishArabic(requesterEmail, !isArabic);

            // Get employee data from controller
            final employee = employeeController.getLocaleEmployee(requesterEmail);
            if (employee != null) {

              // Get job title
              displayJobTitle = isArabic
                  ? (employee.titleInArabic ?? employee.title ?? '-')
                  : (employee.title ?? '-');

              // Get department from controller
              if (employee.departmentId != null && employee.departmentId!.isNotEmpty) {
                displayDepartment = isArabic
                    ? (departmentController.getArabicDepartmentNameFromDepartmentId(departmentId: employee.departmentId!) ?? '-')
                    : (departmentController.getEnglishDepartmentNameFromDepartmentId(departmentId: employee.departmentId!) ?? '-');
              }
            }
          }

          // Get service name (try snapshot first, fallback to model)
          // Get service name (try snapshot first, fallback to model)
          if (snapshot.hasData && snapshot.data != null) {
            final serviceData = snapshot.data!;

            if (isArabic) {
              // ✅ FIXED: Use camelCase key
              if (serviceData.containsKey('serviceNameArabic') &&
                  serviceData['serviceNameArabic'] != null &&
                  serviceData['serviceNameArabic']!.isNotEmpty) {
                displayServiceName = serviceData['serviceNameArabic']!;
              }
            } else {
              // ✅ FIXED: Use camelCase key
              if (serviceData.containsKey('serviceNameEnglish') &&
                  serviceData['serviceNameEnglish'] != null &&
                  serviceData['serviceNameEnglish']!.isNotEmpty) {
                displayServiceName = serviceData['serviceNameEnglish']!;
              }
            }

            // Get duration from snapshot
            if (serviceData.containsKey('duration') &&
                serviceData['duration'] != null &&
                serviceData['duration']!.isNotEmpty &&
                serviceData.containsKey('unit') &&
                serviceData['unit'] != null &&
                serviceData['unit']!.isNotEmpty) {
              final durationValue = serviceData['duration']!;
              final unitValue = serviceData['unit']!;
              final localizedUnit = getLocalizedDurationUnit(context, unitValue, quantity: int.tryParse(durationValue));
              displayDuration = '$durationValue $localizedUnit';
            }
          }

          // Fallback to model if snapshot empty
          if (displayServiceName.isEmpty) {
            displayServiceName = isArabic
                ? (widget.service.currentServiceNameArabic ?? widget.service.currentServiceNameEnglish ?? '-')
                : (widget.service.currentServiceNameEnglish ?? '-');
          }

          if (displayDuration.isEmpty) {
            final durationValue = widget.service.currentDurationOfServices ?? '';
            final unitValue = widget.service.currentSelectedDurationUnit ?? '';
            if (durationValue.isNotEmpty && unitValue.isNotEmpty) {
              final localizedUnit = getLocalizedDurationUnit(context, unitValue);
              displayDuration = '$durationValue $localizedUnit';
            }
          }

          return Container(
            padding: EdgeInsets.only(right: 15.w, left: 15.w, top: 15.h),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.sp,
                      height: 40.sp,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: (widget.service.currentImageUrl != null &&
                          widget.service.currentImageUrl!.isNotEmpty)
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: CachedNetworkImage(
                          imageUrl: widget.service.currentImageUrl!,
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
                                color: AppColors.secondaryText.withOpacity(.3),
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
                        semanticsLabel: 'Service Icon',
                      ),
                    ),
                    SizedBox(width: 10.sp),
                    Expanded(
                      child: Text(
                        FormatHelper.capitalize(displayServiceName),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font16BlackMediumCairo.copyWith(
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                SizedBox(height: 5.h),
                InfoRowApproval(
                  "assets/images/details/User Plus.svg",
                  "${S.of(context).serviceRequester}: ",
                  displayRequesterName,
                ),
                SizedBox(height: 5.h),
                InfoRowApproval(
                  "assets/images/details/Calendar.svg",
                  "${S.of(context).DateRequested}: ",
                  DateFormat('dd MMM yyyy', isArabic ? 'ar' : 'en').format(dateRequested),
                ),
                SizedBox(height: 5.h),
                InfoRowApproval(
                  "assets/services_module/department.svg",
                  "${S.of(context).Department}: ",
                  displayDepartment,
                ),
                SizedBox(height: 5.h),
                InfoRowApproval(
                  "assets/images/details/Case.svg",
                  "${S.of(context).jobTitle}: ",
                  displayJobTitle,
                ),
                SizedBox(height: 5.h),
                InfoRowApproval(
                  "assets/images/details/Group 1000004482.svg",
                  "${S.of(context).durationOfService}: ",
                  displayDuration,
                ),
                SizedBox(height: 8.h),

                if (canAct) ...[
                  LayoutBuilder(
                    builder: (ctx, constraints) {
                      final gap = 12.w;
                      final btnW = (constraints.maxWidth - gap) / 2;

                      return Row(
                        children: [
                          SizedBox(
                            width: btnW,
                            height: 38.sp,
                            child: GestureDetector(
                              onTap: () {
                                CustomDialogManager.showDialogFlow(
                                  customReasonTitle: S.of(context).reasonOfRejection,
                                  context: context,
                                  confirmLottie: 'assets/lottie/rejected.json',
                                  confirmTitle: S.of(context).RejectRequest,
                                  confirmSubtitle: S.of(context).AreYouSureYouWantToRejectThisRequest,
                                  confirmYesText: S.of(context).yes,
                                  confirmNoText: S.of(context).no,
                                  onConfirm: () {},
                                  comment: true,
                                  commentRequired: true,
                                  commentController: rejectController,
                                  commentSubmitText: S.of(context).submit,
                                  commentDiscardText: S.of(context).discard,
                                  onCommentSubmit: () async {
                                    final email = employeeEntity.email;
                                    final serviceId = widget.service.currentId;
                                    final requesterEmail = widget.service.currentEmailRequester;

                                    if (email == null || email.isEmpty) {
                                      return;
                                    }

                                    try {
                                      final cubit = ServicesManagerCubit.get(context);
                                      final firestoreDocId = cubit.serviceIdToFirestoreDocId[serviceId] ?? serviceId;
                                      final tenantRoot = getBaseUrl(FirestoreCollections.requestServices);

                                      // ✅ Parse path properly
                                      final pathParts = tenantRoot.split('/');
                                      DocumentReference docRef;

                                      if (pathParts.length == 3) {
                                        docRef = FirebaseFirestore.instance
                                            .collection(pathParts[0])
                                            .doc(pathParts[1])
                                            .collection(pathParts[2])
                                            .doc(firestoreDocId);
                                      } else {
                                        docRef = FirebaseFirestore.instance
                                            .collection(tenantRoot)
                                            .doc(firestoreDocId);
                                      }

                                      final docSnapshot = await docRef.get();
                                      if (!docSnapshot.exists) {
                                        return;
                                      }

                                      final docData = docSnapshot.data() as Map<String, dynamic>;

                                      // ✅ Check both field names
                                      final approvalCycleArray = (docData['approvalCycle'] ?? docData['Approval_Cycle']) as List<dynamic>? ?? [];

                                      bool updated = false;
                                      for (int i = 0; i < approvalCycleArray.length; i++) {
                                        final item = approvalCycleArray[i];
                                        if (item is String) {
                                          try {
                                            final decoded = jsonDecode(item);
                                            if (decoded is List) {
                                              for (var emp in decoded) {
                                                if (emp is Map && (emp['email']?.toString().toLowerCase() == email.toLowerCase())) {
                                                  emp['state'] = 'rejected';
                                                  approvalCycleArray[i] = jsonEncode(decoded);
                                                  updated = true;
                                                  break;
                                                }
                                              }
                                            }
                                          } catch (e) {
                                          }
                                        }
                                        if (updated) break;
                                      }

                                      if (!updated) {
                                        return;
                                      }

                                      // ✅ Update both possible field names
                                      Map<String, dynamic> updateData = {
                                        'rejectComment': rejectController.text,
                                        'timestamps': FieldValue.arrayUnion([DateTime.now().millisecondsSinceEpoch]),
                                        'state': FieldValue.arrayUnion(['rejected']),
                                      };

                                      if (docData.containsKey('approvalCycle')) {
                                        updateData['approvalCycle'] = approvalCycleArray;
                                      }
                                      if (docData.containsKey('Approval_Cycle')) {
                                        updateData['Approval_Cycle'] = approvalCycleArray;
                                      }

                                      await docRef.update(updateData);

                                      // Send notifications
                                      if (requesterEmail != null && requesterEmail.isNotEmpty) {
                                        await _sendNotificationToRequester(
                                          action: 'rejected',
                                          requesterEmail: requesterEmail,
                                          serviceName: displayServiceName,
                                          approverEmail: email,
                                        );
                                      }

                                      final providerEmail = _extractProviderEmail(docData);
                                      if (providerEmail != null && providerEmail.isNotEmpty) {
                                        await _sendNotificationToProvider(
                                          action: 'rejected',
                                          providerEmail: providerEmail,
                                          serviceName: displayServiceName,
                                          requesterName: displayRequesterName,
                                        );
                                      }

                                      cubit.getAllServices();
                                      cubit.getMyRequestServices();
                                      cubit.loadProviderPerDocument();
                                      cubit.getMyApprovalServices(email);
                                      widget.onRefresh();
                                      setState(() {});
                                    } catch (e, st) {
                                    }
                                  },
                                  onSuccessDismissed: () {
                                    final cubit = ServicesManagerCubit.get(context);
                                    cubit.getAllServices();
                                    cubit.getMyRequestServices();
                                    cubit.loadProviderPerDocument();
                                    cubit.getMyApprovalServices(employeeEntity.email);
                                    widget.onRefresh();
                                    setState(() {});
                                  },
                                  successLottie: 'assets/lottie/rejected.json',
                                  successTitle: S.of(context).RejectRequest,
                                  successSubtitle: S.of(context).YouSuccessfullyRejectedThisRequest,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: light ? AppColors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(color: AppColors.red),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 22.sp,
                                      height: 22.sp,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.red,
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/state/reject.svg",
                                        width: 24.sp,
                                        height: 24.sp,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      S.of(context).Reject,
                                      style: AppTextStyles.font16BlackMediumCairo.copyWith(
                                        color: AppColors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: gap),
                          SizedBox(
                            width: btnW,
                            height: 38.sp,
                            child: GestureDetector(
                              onTap: () {
                                CustomDialogManager.showDialogFlow(
                                  context: context,
                                  customReasonTitle: S.of(context).reasonOfApproval,
                                  confirmLottie: 'assets/lottie/approved.json',
                                  confirmTitle: S.of(context).ApproveRequest,
                                  confirmSubtitle: S.of(context).AreYouSureYouWantToApproveThisRequest,
                                  confirmYesText: S.of(context).yes,
                                  confirmNoText: S.of(context).no,
                                  onConfirm: () {},
                                  comment: true,
                                  commentRequired: false,
                                  commentController: approveController,
                                  commentSubmitText: S.of(context).submit,
                                  commentDiscardText: S.of(context).discard,
                                  onCommentSubmit: () async {
                                    final email = employeeEntity.email;
                                    final serviceId = widget.service.currentId;
                                    final requesterEmail = widget.service.currentEmailRequester;

                                    if (email == null || email.isEmpty) {
                                      return;
                                    }

                                    try {
                                      final cubit = ServicesManagerCubit.get(context);
                                      final firestoreDocId = cubit.serviceIdToFirestoreDocId[serviceId] ?? serviceId;
                                      final tenantRoot = getBaseUrl(FirestoreCollections.requestServices);

                                      // ✅ Parse path properly
                                      final pathParts = tenantRoot.split('/');
                                      DocumentReference docRef;

                                      if (pathParts.length == 3) {
                                        docRef = FirebaseFirestore.instance
                                            .collection(pathParts[0])
                                            .doc(pathParts[1])
                                            .collection(pathParts[2])
                                            .doc(firestoreDocId);
                                      } else {
                                        docRef = FirebaseFirestore.instance
                                            .collection(tenantRoot)
                                            .doc(firestoreDocId);
                                      }

                                      final docSnapshot = await docRef.get();
                                      if (!docSnapshot.exists) {
                                        return;
                                      }

                                      final docData = docSnapshot.data() as Map<String, dynamic>;

                                      // ✅ Check both field names
                                      final approvalCycleArray = (docData['approvalCycle'] ?? docData['Approval_Cycle']) as List<dynamic>? ?? [];

                                      bool updated = false;
                                      for (int i = 0; i < approvalCycleArray.length; i++) {
                                        final item = approvalCycleArray[i];
                                        if (item is String) {
                                          try {
                                            final decoded = jsonDecode(item);
                                            if (decoded is List) {
                                              for (var emp in decoded) {
                                                if (emp is Map && (emp['email']?.toString().toLowerCase() == email.toLowerCase())) {
                                                  emp['state'] = 'approved';
                                                  approvalCycleArray[i] = jsonEncode(decoded);
                                                  updated = true;
                                                  break;
                                                }
                                              }
                                            }
                                          } catch (e) {
                                          }
                                        }
                                        if (updated) break;
                                      }

                                      if (!updated) {
                                        return;
                                      }

                                      final myIndex = widget.service.currentApprovalCycle.indexWhere(
                                              (e) => (e.email ?? '').toLowerCase() == email.toLowerCase()
                                      );
                                      final isLastApprover = (myIndex == widget.service.currentApprovalCycle.length - 1);

                                      Map<String, dynamic> updateData = {
                                        'approveComment': approveController.text,
                                        'timestamps': FieldValue.arrayUnion([DateTime.now().millisecondsSinceEpoch]),
                                      };

                                      // ✅ Update both possible field names
                                      if (docData.containsKey('approvalCycle')) {
                                        updateData['approvalCycle'] = approvalCycleArray;
                                      }
                                      if (docData.containsKey('Approval_Cycle')) {
                                        updateData['Approval_Cycle'] = approvalCycleArray;
                                      }

                                      if (isLastApprover) {
                                        updateData['state'] = FieldValue.arrayUnion(['approved']);
                                      }

                                      await docRef.update(updateData);

                                      // Send notifications
                                      if (requesterEmail != null && requesterEmail.isNotEmpty) {
                                        await _sendNotificationToRequester(
                                          action: 'approved',
                                          requesterEmail: requesterEmail,
                                          serviceName: displayServiceName,
                                          approverEmail: email,
                                        );
                                      }

                                      if (isLastApprover) {
                                        final providerEmail = _extractProviderEmail(docData);
                                        if (providerEmail != null && providerEmail.isNotEmpty) {
                                          await _sendNotificationToProvider(
                                            action: 'approved',
                                            providerEmail: providerEmail,
                                            serviceName: displayServiceName,
                                            requesterName: displayRequesterName,
                                          );
                                        }
                                      }

                                      if (!isLastApprover && myIndex + 1 < widget.service.currentApprovalCycle.length) {
                                        final nextApprover = widget.service.currentApprovalCycle[myIndex + 1];
                                        final nextApproverEmail = nextApprover.email ?? '';

                                        if (nextApproverEmail.isNotEmpty) {
                                          await _sendNotificationToNextApprover(
                                            nextApproverEmail: nextApproverEmail,
                                            serviceName: displayServiceName,
                                            requesterName: displayRequesterName,
                                          );
                                        }
                                      }

                                      cubit.getAllServices();
                                      cubit.getMyRequestServices();
                                      cubit.loadProviderPerDocument();
                                      cubit.getMyApprovalServices(email);
                                      widget.onRefresh();
                                      setState(() {});
                                    } catch (e, st) {
                                    }
                                  },
                                  onSuccessDismissed: () {
                                    final cubit = ServicesManagerCubit.get(context);
                                    cubit.getAllServices();
                                    cubit.getMyRequestServices();
                                    cubit.loadProviderPerDocument();
                                    cubit.getMyApprovalServices(employeeEntity.email);
                                    widget.onRefresh();
                                    setState(() {});
                                  },
                                  successLottie: 'assets/lottie/approved.json',
                                  successTitle: S.of(context).Successful,
                                  successSubtitle: S.of(context).YouSuccessfullyApprovedThisRequest,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: light ? AppColors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(color: AppColors.lightGreen),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/state/approved.svg",
                                      width: 24.sp,
                                      height: 24.sp,
                                      fit: BoxFit.scaleDown,
                                    ),
                                    SizedBox(width: 8.w),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 3.sp),
                                      child: Text(
                                        S.of(context).Approve,
                                        style: AppTextStyles.font16BlackMediumCairo.copyWith(
                                          color: AppColors.lightGreen,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],

                if (!canAct) ...[
                  Center(
                    child: _stateBadge(
                      label: myActionLabel,
                      state: myAction,
                      color: myActionClr,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    rejectController.dispose();
    approveController.dispose();
    super.dispose();
  }
}
