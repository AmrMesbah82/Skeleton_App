/// ******************* FILE INFO *******************
/// File Name: employee_services_details.dart
/// Description: View all request details with action capabilities (approve/progress/done)
/// Created by: Amr Mesbah
/// Last Update: 27/01/2026 - Added notification system integration

import 'dart:io';
import 'package:demo_app/core/custom/36-custom_comment_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:demo_app/core/custom/36-custom_comment_widget.dart';
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
import 'package:demo_app/features/services_management_module/data/helper/services_helper_function.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/pages/select_services_provider_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/approvals.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/provider_details.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/responsive_text.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/show_request_details_shimmer.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/pages/request_services_toggle.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/services_management_module/presentation/s10_employee_action/ui/pages/employee_services_toggle.dart';

class EmployeeDetailsServicesScreenTablet extends StatefulWidget {
  const EmployeeDetailsServicesScreenTablet({
    required this.approvalModel,
    required this.index,
    super.key,
  });

  final ServicesHistoryModel approvalModel;
  final int index;

  @override
  State<EmployeeDetailsServicesScreenTablet> createState() => _EmployeeDetailsServicesScreenTabletState();
}

class _EmployeeDetailsServicesScreenTabletState extends State<EmployeeDetailsServicesScreenTablet> {
  final TextEditingController _controller = TextEditingController();
  bool isVisible = true;
  String? currentState;
  String? selectedState;
  Future<Map<String, dynamic>?>? _providerFuture;
  final NotificationTemplateService _templateService = NotificationTemplateService();

  // Requester data from SharedPreferences
  String? globalEmailRequester;
  String? globalFirstNameRequester;
  String? globalLastNameRequester;
  String? globalGenderRequester;
  String? globalPhoneRequester;
  String? globalJobTitleRequester;
  String? globalDepartmentRequester;
// ✅ ADD THIS METHOD at the top of the class with other helper methods
  late final MainCoreDepartmentController departmentController;
  late final MainCoreEmployeeController employeeController;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize controllers
    departmentController = Get.find<MainCoreDepartmentController>();
    employeeController = Get.find<MainCoreEmployeeController>();

    _initializeState();
    _loadRequesterData();
    _ensureApprovalCycleExists();
  }

// ✅ ADD THIS HELPER METHOD
  String _getDepartmentNameFromId(String departmentId) {
    if (departmentId.isEmpty || departmentId == '-') {
      return '-';
    }

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final departmentName = isArabic
        ? departmentController.getArabicDepartmentNameFromDepartmentId(departmentId: departmentId)
        : departmentController.getEnglishDepartmentNameFromDepartmentId(departmentId: departmentId);

    return departmentName ?? departmentId; // Fallback to ID if name not found
  }

  // ==================== INITIALIZATION ====================

  void _initializeState() {
    currentState = widget.approvalModel.currentState;

    final approvalCycle = widget.approvalModel.currentApprovalCycle;

    // Auto-approve if no approval cycle exists
    if (approvalCycle.isEmpty && _isEmptyOrPending(currentState)) {
      currentState = 'approved';
    }

    // Check if all approvers have approved
    if (approvalCycle.isNotEmpty) {
      final allApproved = approvalCycle.every((e) => e.state?.toLowerCase() == 'approved');
      if (allApproved && _isEmptyOrPending(currentState)) {
        currentState = 'approved';
      }
    }

  }

  bool _isEmptyOrPending(String? state) {
    return state == null || state == '' || state == 'pending';
  }

  // Helper method to get requester's language preference from Firestore
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

  // ✅ UPDATED: Enhanced notification method with Firestore integration
// ✅ UPDATED: Enhanced notification method with dynamic templates
// ✅ UPDATED: Enhanced notification method with dynamic templates
  // ✅ UPDATED: Enhanced notification method with dynamic templates
// ✅ UPDATED: Enhanced notification method with dynamic templates
  Future<void> _sendStatusChangeNotification({
    required String newState,
    required String requesterEmail,
    required String serviceName,
  }) async {
    if (requesterEmail.isEmpty) {
      return;
    }

    try {

      final employeeEntity = Get.find<MainCoreEmployeeController>().employeeEntity!;
      final isArabic = await _getRequesterLanguagePreference(requesterEmail);

      // ✅ Determine event type based on state
      String eventType;
      if (newState.toLowerCase() == 'inprogress') {
        eventType = 'request_in_progress';
      } else if (newState.toLowerCase() == 'done') {
        eventType = 'request_done';
      } else {
        // No notification for other status changes
        return;
      }

      // ✅ Fetch template from Firestore (NEW WAY - no notificationType parameter)
      final template = await _templateService.getTemplate(
        module: 'services',
        eventType: eventType,
      );

      // ✅ Check if notification is enabled AND push is selected
      if (template == null || !template.isEnabled || !template.hasPush) {
        return;
      }

      String notificationTitle = isArabic ? template.subjectArabic : template.subjectEnglish;
      String notificationBody = isArabic ? template.bodyArabic : template.bodyEnglish;

      // ✅ Replace placeholders
      final variables = {
        'serviceName': serviceName,
      };
      notificationTitle = _templateService.processTemplate(notificationTitle, variables);
      notificationBody = _templateService.processTemplate(notificationBody, variables);

      // ✅ Create notification model for Firestore
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

      // ✅ Upload to Firestore using the notification service
      final notificationService = FirestoreNotificationService();
      final docId = await notificationService.uploadNotification(notificationModel);

      // ✅ Send push notification
      await NotificationServiceApp.sendNotification(
        notificationTitle,
        notificationBody,
        requesterEmail,
      );

    } catch (notificationError) {
      // Don't stop the flow if notification fails
    }
  }

  Future<void> _loadRequesterData() async {
    final prefs = await SharedPreferences.getInstance();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    setState(() {
      globalEmailRequester = prefs.getString("emailRequester") ?? '';
      globalGenderRequester = prefs.getString("genderRequester") ?? '';
      globalPhoneRequester = prefs.getString("phoneRequester") ?? '';
      globalDepartmentRequester = prefs.getString("departmentRequester") ?? '';

      globalFirstNameRequester = isArabic
          ? prefs.getString("firstNameRequesterArabic") ?? ''
          : prefs.getString("firstNameRequester") ?? '';

      globalLastNameRequester = isArabic
          ? prefs.getString("lastNameRequesterArabic") ?? ''
          : prefs.getString("lastNameRequester") ?? '';

      globalJobTitleRequester = isArabic
          ? prefs.getString("jobTitleRequesterArabic") ?? ''
          : prefs.getString("jobTitleRequester") ?? '';
    });
  }

  Future<void> _ensureApprovalCycleExists() async {
    final service = widget.approvalModel;
    final hasApprovalCycle = service.currentApprovalCycle.isNotEmpty;

    if (!hasApprovalCycle && _isApprovedOrEmpty(service.currentState)) {

      final syntheticApproval = EmployeeEntityModell(
        id: 'auto-approved',
        email: 'system@auto.approved',
        firstName: 'System',
        lastName: 'Auto Approval',
        title: 'System Process',
        state: 'approved',
        gender: 'system',
      );

      try {
        final requesterEmail = service.currentEmailRequester.isNotEmpty
            ? service.currentEmailRequester
            : globalEmailRequester ?? employeeFunctionHelper.email;

        // Query to find the document
        final querySnapshot = await FirebaseFirestore.instance
            .collection(getBaseUrl(FirestoreCollections.requestServices))
            .where("Email_Requester", arrayContains: requesterEmail)
            .get();

        final doc = querySnapshot.docs.firstWhere(
              (doc) => doc.id == service.currentId,
          orElse: () => throw Exception("Document not found"),
        );

        await doc.reference.update({
          'approvalCycle': [syntheticApproval.toJson()],
          'state': ['approved'],
          'timestamps': [DateTime.now().millisecondsSinceEpoch],
        });

        currentState = 'approved';
        setState(() {});
      } catch (e) {
      }
    }
  }

  bool _isApprovedOrEmpty(String state) {
    final lower = state.toLowerCase();
    return lower == 'approved' || lower == '' || lower == 'pending';
  }

  // ==================== STATE MANAGEMENT ====================

  String _getOverallStatus() {
    final approvalCycle = widget.approvalModel.currentApprovalCycle;
    final docState = currentState?.toLowerCase();

    if (docState == 'inprogress' || docState == 'breached sla') {
      return docState!;
    }

    // Check for rejections/cancellations
    for (final approver in approvalCycle) {
      final state = approver.state?.toLowerCase();
      if (state == 'rejected' || state == 'cancel') return state!;
    }

    // Check for pending
    for (final approver in approvalCycle) {
      if (approver.state?.toLowerCase() == 'pending') return 'pending';
    }

    // All approved
    if (approvalCycle.every((e) => e.state?.toLowerCase() == 'approved')) {
      return 'approved';
    }

    return 'pending';
  }

  List<EmployeeEntityModell> _adjustCycleStates(List<EmployeeEntityModell> list) {
    final adjusted = List<EmployeeEntityModell>.from(list);
    bool foundPending = false;

    for (int i = 0; i < adjusted.length; i++) {
      final originalState = adjusted[i].state?.toLowerCase();

      if (originalState == 'approved' || originalState == 'rejected' || originalState == 'cancel') {
        continue;
      }

      if (!foundPending) {
        adjusted[i] = adjusted[i].copyWith(state: 'pending');
        foundPending = true;
      } else {
        adjusted[i] = adjusted[i].copyWith(state: 'normal');
      }
    }

    return adjusted;
  }

  Future<void> _fetchLatestStateFromFirestore() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .where("Email_Requester", arrayContains: employeeFunctionHelper.email)
          .get();

      final docSnapshot = querySnapshot.docs.firstWhere(
            (doc) => doc.id == widget.approvalModel.currentId,
        orElse: () => throw Exception("Document not found"),
      );

      final data = docSnapshot.data();
      final stateField = data['state'];

      if (stateField is List && stateField.isNotEmpty) {
        currentState = stateField.last.toString().toLowerCase();
      } else if (stateField is String) {
        currentState = stateField.toLowerCase();
      }

    } catch (e) {
    }
  }

  // ==================== UI HELPERS ====================

  String _getLabel(String state) {
    switch (state.toLowerCase()) {
      case 'approve':
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'cancel':
        return 'Canceled';
      case 'pending':
        return 'Pending';
      case 'inprogress':
        return 'Inprogress';
      case 'breached sla':
        return 'Breached SLA';
      default:
        return FormatHelper.capitalize(state);
    }
  }

  Color _getBorderColor(String state) {
    switch (state.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF814A);
      case 'approve':
      case 'approved':
        return const Color(0xFF4BB609);
      case 'rejected':
      case 'cancel':
        return const Color(0xFFDF0C0C);
      case 'inprogress':
        return const Color(0xFFFFCC00);
      case 'breached sla':
        return const Color(0xFFB00020);
      default:
        return AppColors.lightGrey!;
    }
  }

  String _getIconAsset(String state) {
    switch (state.toLowerCase()) {
      case 'approve':
      case 'approved':
        return 'assets/state/approved.svg';
      case 'rejected':
      case 'cancel':
        return 'assets/state/reject.svg';
      case 'pending':
        return 'assets/state/pending.svg';
      case 'inprogress':
        return 'assets/state/inprogress_icon.svg';
      case 'breached sla':
        return 'assets/state/breached SLA.svg';
      default:
        return 'assets/state/pending.svg';
    }
  }

  Color _getStateColor(String state) {
    switch (state.toLowerCase()) {
      case 'approve':
      case 'approved':
        return AppColors.lightGreen;
      case 'inprogress':
        return Color(0xFFFF814A);
      case 'done':
        return Color(0xFF4BB609);
      default:
        return AppColors.black;
    }
  }

  Color _getArrowColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF814A);
      case 'approved':
        return const Color(0xFF4BB609);
      case 'rejected':
        return const Color(0xFFDF0C0C);
      case 'inprogress':
        return const Color(0xFFFFCC00);
      default:
        return Theme.of(context).brightness == Brightness.light
            ? AppColors.blackButton
            : AppColors.whiteShadow;
    }
  }

  Map<String, String> _getLocalizedLabels(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return {
      'approved': isArabic ? 'تمت الموافقة' : 'Approved',
      'inprogress': isArabic ? 'قيد التنفيذ' : 'Inprogress',
      'done': isArabic ? 'تم الإنجاز' : 'Done',
    };
  }

  bool _isTabletLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return size.width >= 600 && isLandscape;
  }

  // ==================== DROPDOWN LOGIC ====================

  bool _shouldShowDropdown() {
    final state = currentState?.toLowerCase();

    if (state == 'cancel') {
      return false;
    }

    final approvalCycle = widget.approvalModel.currentApprovalCycle;

    if (approvalCycle.isEmpty) {
      final canProgress = state == 'approved' || state == 'inprogress' || state == 'done' || state == null || state == '';
      return canProgress;
    }

    final allApproved = approvalCycle.isNotEmpty && approvalCycle.every((e) => e.state?.toLowerCase() == 'approved');

    final shouldShow = state == 'approved' ||
        state == 'inprogress' ||
        state == 'done' ||
        allApproved ||
        (state == null && allApproved) ||
        (state == '' && allApproved) ||
        (state == 'pending' && allApproved);

    return shouldShow;
  }

  String get _effectiveState => (selectedState ?? currentState ?? '').toLowerCase();

  List<String> _getAvailableStates(String? _) {
    final c = _effectiveState;

    if (c == 'done') {
      return ['done'];
    }

    if (c == 'inprogress') {
      return ['done'];
    }

    if (c == 'approved') {
      return ['inprogress'];
    }

    final approvalCycle = widget.approvalModel.currentApprovalCycle;
    if (approvalCycle.isNotEmpty) {
      final allApproved = approvalCycle.every((e) => e.state?.toLowerCase() == 'approved');
      if (allApproved) {
        return ['inprogress'];
      }
    }

    if (approvalCycle.isEmpty) {
      return ['inprogress'];
    }

    return ['inprogress'];
  }

  // ==================== FIREBASE UPDATE ====================

  Future<void> _updateStateInFirestore(String newState) async {
    final requesterEmail = widget.approvalModel.currentEmailRequester.isNotEmpty
        ? widget.approvalModel.currentEmailRequester
        : globalEmailRequester ?? employeeFunctionHelper.email;

    try {

      // Query to find the document
      final querySnapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .where("Email_Requester", arrayContains: requesterEmail)
          .get();

      final docSnapshot = querySnapshot.docs.firstWhere(
            (doc) => doc.id == widget.approvalModel.currentId,
        orElse: () => throw Exception("Document not found"),
      );

      final data = docSnapshot.data();
      final stateField = data['state'];

      Map<String, dynamic> updateData;

      // Check if it's already using the list format
      if (stateField is List) {
        final currentStates = List<String>.from(stateField);
        final currentTimestamps = List<int>.from(data['timestamps'] ?? []);

        currentStates.add(newState.toLowerCase());
        currentTimestamps.add(DateTime.now().millisecondsSinceEpoch);

        updateData = {
          "state": currentStates,
          "timestamps": currentTimestamps,
        };

      } else {
        // Convert to list format
        updateData = {
          "state": [newState.toLowerCase()],
          "timestamps": [DateTime.now().millisecondsSinceEpoch],
        };

      }

      await docSnapshot.reference.update(updateData);

      // ✅ Send notification to requester about status change
      if (requesterEmail != null && requesterEmail.isNotEmpty) {
        final isArabic = Localizations.localeOf(context).languageCode == 'ar';
        final serviceName = isArabic
            ? (widget.approvalModel.currentServiceNameArabic ?? widget.approvalModel.currentServiceNameEnglish)
            : widget.approvalModel.currentServiceNameEnglish;

        await _sendStatusChangeNotification(
          newState: newState.toLowerCase(),
          requesterEmail: requesterEmail,
          serviceName: serviceName,
        );
      }

      await _fetchLatestStateFromFirestore();

      setState(() {
        selectedState = currentState;
      });
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  // ==================== PROVIDER COMPUTATION ====================

  Future<Map<String, dynamic>?> _computeProvider() {
    final candidates = widget.approvalModel.currentProviderServices
        .map((e) => {
      'email': e.email,
      'firstName': e.firstName,
      'lastName': e.lastName,
      'firstNameInArabic': e.firstNameInArabic,
      'lastNameInArabic': e.lastNameInArabic,
      'title': e.title,
      'titleInArabic': e.titleInArabic,
      'mobilePhone': (e.mobilePhone == null)
          ? null
          : {
        'countryApp': e.mobilePhone?.countryApp,
        'countryCode': e.mobilePhone?.countryCode,
        'phone': e.mobilePhone?.phone,
      },
    })
        .where((m) => (m['email'] ?? '').toString().isNotEmpty)
        .toList();

    return selectServiceProviderLite(
      candidates: candidates,
      windowDays: 7,
      perDayCap: 2,
    );
  }

  // ==================== DIALOGS ====================

  Future<bool> _showConfirmationDialog() async {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final res = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: lightMode ? AppColors.white : AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: SizedBox(
            width: 411.sp,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lottie/Edit Document.json',
                  width: 70.sp,
                  height: 70.sp,
                  fit: BoxFit.scaleDown,
                  repeat: true,
                  animate: true,
                ),
                SizedBox(height: 20.sp),
                Text(
                  S.of(context).changingStatus,
                  style: AppTextStyles.font20BlackCairoMedium.copyWith(
                    color: lightMode ? AppColors.blackButton : AppColors.white,
                  ),
                ),
                SizedBox(height: 18.sp),
                Text(
                  S.of(context).Areyousureyouwanttochangethisstatus,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font14BlackCairoMedium.copyWith(
                    color: lightMode ? AppColors.secondaryText : AppColors.grey,
                  ),
                ),
                SizedBox(height: 20.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customButtonAnimation(
                      title: FormatHelper.capitalize(S.of(context).no),
                      function: () => Navigator.pop(context, false),
                      textStyle: AppTextStyles.font15BlackCairoRegular.copyWith(color: AppColors.black),
                      width: 118.sp,
                      height: 38.sp,
                      radius: 4.r,
                      color: AppColors.secondaryButton,
                    ),
                    SizedBox(width: 15.sp),
                    customButtonAnimation(
                      title: FormatHelper.capitalize(S.of(context).yes),
                      function: () => Navigator.pop(context, true),
                      textStyle: AppTextStyles.font15BlackCairoRegular.copyWith(
                        color: AppColors.textButton,
                      ),
                      width: 118.sp,
                      height: 38.sp,
                      radius: 4.r,
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
    return res == true;
  }

  Future<void> _showSuccessDialog() async {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: lightMode ? AppColors.white : AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: SizedBox(
            width: 405.sp,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lottie/approved.json',
                  width: 70.sp,
                  height: 70.sp,
                  fit: BoxFit.scaleDown,
                ),
                SizedBox(height: 20.sp),
                Text(
                  S.of(context).changingStatus,
                  style: AppTextStyles.font20BlackCairoMedium.copyWith(
                    color: lightMode ? AppColors.blackButton : AppColors.white,
                  ),
                ),
                SizedBox(height: 18.sp),
                Text(
                  S.of(context).YouSuccessfullyCompletedThisRequest,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font14BlackCairoMedium.copyWith(
                    color: lightMode ? AppColors.secondaryText : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  bool _isCommentExpanded = false;
  // ==================== BUILD METHOD ====================

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isPhone;
    final isTablet = context.isTablet;
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final approvalCycle = widget.approvalModel.currentApprovalCycle;
    final displayCycle = _adjustCycleStates(approvalCycle);

    final docState = _getOverallStatus();
    String stateLabel = _getLabel(docState);
    Color borderColor = _getBorderColor(docState);
    String iconAsset = _getIconAsset(docState);

    bool hasRejection = displayCycle.any(
          (e) => e.state != null && (e.state!.toLowerCase() == 'rejected' || e.state!.toLowerCase() == 'cancel'),
    );

    if (hasRejection) {
      final rejected = displayCycle.firstWhere(
            (e) => e.state!.toLowerCase() == 'rejected' || e.state!.toLowerCase() == 'cancel',
      );
      final s = rejected.state!.toLowerCase();
      stateLabel = _getLabel(s);
      borderColor = _getBorderColor(s);
      iconAsset = _getIconAsset(s);
    } else if (docState != 'inprogress' && displayCycle.every((e) => e.state?.toLowerCase() == 'approved')) {
      stateLabel = 'Approved';
      borderColor = AppColors.lightGreen;
      iconAsset = "assets/state/approved.svg";
    }

    final localizedLabels = _getLocalizedLabels(context);
    final dropdownStates = _getAvailableStates(currentState);

    return Scaffold(
      body: SafeArea(
        child: SideFrameMasterServices(
          titleText: S.of(context).serviceRequests,
          onFirstTap: () {
            Navigator.pop(context);
          },
          secondTitle: S.of(context).requestedServices,
          onSecondTap: () {
            Navigator.pop(context);
          },
          thirdTitle: FormatHelper.capitalize(
            isArabic ? widget.approvalModel.currentServiceNameArabic : widget.approvalModel.currentServiceNameEnglish,
          ),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                // ✅ Hide all content when comments are expanded
                if (!_isCommentExpanded) ...[
                  _buildHeader(lightMode, dropdownStates, localizedLabels, isArabic),
                  SizedBox(height: 10.sp),
                  _buildMainContent(isMobile, lightMode, isArabic, displayCycle),
                  SizedBox(height: 20.sp),
                ],

                UniversalCommentSection(
                  collectionPath: 'Demo/75440689/Comments',
                  filterFields: {
                    'Request_Id': widget.approvalModel.currentId,
                  },
                  currentUserId: Get.find<MainCoreEmployeeController>()
                      .employeeEntity!
                      .email!,
                  isExpandable: true,
                  fixedHeight: _isCommentExpanded
                      ? MediaQuery.of(context).size.height * 0.85
                      : MediaQuery.of(context).size.height,
                  onExpandChanged: (expanded) {
                    setState(() {
                      _isCommentExpanded = expanded;
                    });
                  },
                  style: CommentSectionStyle(
                    hintStyle: AppTextStyles.font16BlackRegularCairo.copyWith(
                        color: AppColors.secondaryText.withOpacity(.5)),
                    commentTextStyle: AppTextStyles.font18BlackMediumCairo
                        .copyWith(color: AppColors.text),
                    fileChipDecoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    fileIconColor: AppColors.text,
                    fileNameStyle: AppTextStyles.font12BlackCairoRegular
                        .copyWith(color: AppColors.text),
                    avatarColor: AppColors.background,
                    inputFillColor: AppColors.card,
                    containerDecoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    commentItemDecoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r)),
                    userNameStyle: AppTextStyles.font16BlackRegularCairo.copyWith(
                      color: AppColors.text,
                    ),
                    sendButtonDecoration: BoxDecoration(
                      color: AppColors.secondaryPrimary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    sendIconColor: AppColors.secondaryPrimaryText,
                  ),
                ),

                if (!_isCommentExpanded) SizedBox(height: 20.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool lightMode, List<String> dropdownStates, Map<String, String> localizedLabels, bool isArabic) {
    return SizedBox(
      height: 50.sp,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            S.of(context).serviceDetails,
            style: AppTextStyles.font18BlackMediumCairo.copyWith(
              color: lightMode ? AppColors.blackButton : AppColors.white,
            ),
          ),
          Spacer(),
          if (_shouldShowDropdown()) ...[
            _buildStatusDropdown(lightMode, dropdownStates, localizedLabels, isArabic),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(bool lightMode, List<String> dropdownStates, Map<String, String> localizedLabels, bool isArabic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SvgPicture.asset(
          "assets/status.svg",
          width: 12.sp,
          height: 12.sp,
          color: lightMode ? AppColors.blackButton : AppColors.white,
          fit: BoxFit.fill,
        ),
        SizedBox(width: 5.sp),
        Text(
          "${S.of(context).status}: ",
          style: AppTextStyles.font14BlackCairoMedium.copyWith(
            color: lightMode ? AppColors.blackButton : AppColors.white,
          ),
        ),
        SizedBox(width: 4.sp),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            width: 135.sp,
            height: 30.sp,
            decoration: BoxDecoration(
              color: lightMode ? AppColors.white : AppColors.chatBackground,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: FormField<String>(
              initialValue: selectedState,
              builder: (FormFieldState<String> field) {
                final safeSelected = dropdownStates.contains(selectedState) ? selectedState : null;
                final uniqueDropdownStates = dropdownStates.toSet().toList();
                final effective = (safeSelected ?? currentState ?? '').toLowerCase();
                final isReadOnlyDone = effective == 'done';

                if (isReadOnlyDone) {
                  return IgnorePointer(
                    ignoring: true,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 12.sp),
                      child: Text(
                        (localizedLabels['done'] ?? 'Done'),
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font12BlackCairoRegular.copyWith(
                          color: _getStateColor('done'),
                        ),
                      ),
                    ),
                  );
                }

                return DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    value: safeSelected,
                    isExpanded: true,
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        color: lightMode ? AppColors.white : AppColors.chatBackground,
                      ),
                      elevation: 2,
                      offset: const Offset(0, 0),
                    ),
                    items: uniqueDropdownStates.map((e) {
                      return DropdownMenuItem<String>(
                        value: e,
                        child: Text(
                          localizedLabels[e] ?? e,
                          style: AppTextStyles.font12BlackCairoRegular.copyWith(
                            color: _getStateColor(e),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) async {
                      if (value == null) return;
                      if (!await _showConfirmationDialog()) return;

                      setState(() {
                        selectedState = value;
                        if (value.toLowerCase() == 'done') {
                          currentState = 'done';
                        }
                      });

                      try {
                        await _updateStateInFirestore(value);
                        await _showSuccessDialog();
                        navigateTo(context, EmployeeLayoutScreenServices());
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Failed to update status: $e"),
                            backgroundColor: AppColors.red,
                          ),
                        );
                      }
                    },
                    hint: Padding(
                      padding: isArabic ? EdgeInsets.only(top: 4) : EdgeInsets.zero,
                      child: Text(
                            () {
                          final rawState = safeSelected ?? currentState ?? '';
                          final currentDisplayState = rawState.isEmpty ? 'approve' : rawState;
                          final lowerState = currentDisplayState.toLowerCase();

                          switch (lowerState) {
                            case 'approve':
                            case 'approved':
                              return isArabic ? 'تمت الموافقة' : 'Approved';
                            case 'inprogress':
                              return isArabic ? 'قيد التنفيذ' : 'Inprogress';
                            case 'done':
                              return isArabic ? 'تم الإنجاز' : 'Done';
                            default:
                              return localizedLabels[lowerState] ?? 'Approved';
                          }
                        }(),
                        style: AppTextStyles.font10BlackCairoRegular.copyWith(
                          color: currentState == "inprogress"
                              ? Color(0xFFFF814A)
                              : currentState == "done"
                              ? AppColors.green
                              : AppColors.green,
                        ),
                      ),
                    ),
                    iconStyleData: IconStyleData(
                      icon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.sp),
                        child: SvgPicture.asset(
                          'assets/arrowdown.svg',
                          width: 20.sp,
                          height: 20.sp,
                          fit: BoxFit.fill,
                          color: lightMode ? AppColors.secondaryText : AppColors.whiteShadow,
                        ),
                      ),
                    ),
                    style: AppTextStyles.font12BlackCairoRegular.copyWith(
                      color: lightMode ? AppColors.blackButton : AppColors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(bool isMobile, bool lightMode, bool isArabic, List<EmployeeEntityModell> displayCycle) {
    return Container(
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: lightMode ? AppColors.white : AppColors.chatBackground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildServiceHeader(isMobile, lightMode, isArabic),
          SizedBox(height: 20.h),
          if (isMobile) ...[
            _buildDescriptionWidget(isMobile, lightMode, isArabic),
            SizedBox(height: 20.sp),
          ],
          _buildProviderSection(lightMode),
          SizedBox(height: 29.sp),
          _buildRequesterDetails(lightMode, isArabic),
          SizedBox(height: 20.h),
          if (widget.approvalModel.currentApprovalCycle.isNotEmpty) ...[
            _buildApprovalCycleHeader(lightMode),
            SizedBox(height: 15.h),
            _buildApprovalCycleContent(isMobile, displayCycle),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceHeader(bool isMobile, bool lightMode, bool isArabic) {
    return Row(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Container(
          width: isMobile ? 40.sp : !_isTabletLandscape(context) ? 80.sp : 100.sp,
          height: isMobile ? 40.sp : !_isTabletLandscape(context) ? 80.sp : 100.sp,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: lightMode ? AppColors.background : AppColors.background,
          ),
          child: Center(
            child: SvgPicture.asset(
              color: lightMode ? AppColors.secondaryText : AppColors.grey,
              "assets/images/headPhone.svg",
              width: isMobile ? 20.sp : !_isTabletLandscape(context) ? 40.sp : 48.sp,
              height: isMobile ? 20.sp : !_isTabletLandscape(context) ? 40.sp : 48.sp,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isMobile
                  ? Text(
                isArabic
                    ? widget.approvalModel.currentServiceNameArabic
                    : widget.approvalModel.currentServiceNameEnglish,
                style: AppTextStyles.font14BlackCairoRegular.copyWith(
                  color: lightMode ? AppColors.blackButton : AppColors.white,
                ),
              )
                  : _buildDescriptionWidget(isMobile, lightMode, isArabic),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionWidget(bool isMobile, bool lightMode, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              "assets/des.svg",
              width: isMobile ? 16.w : 14.sp,
              height: isMobile ? 16.h : 14.sp,
              color: AppColors.secondaryText,
              fit: isMobile ? BoxFit.scaleDown : BoxFit.fill,
            ),
            SizedBox(width: 3.sp),
            Text(
              "${S.of(context).serviceDescription}${isMobile ? ' : ' : ''}",
              style: isMobile
                  ? AppTextStyles.font12BlackCairoRegular.copyWith(
                color: AppColors.secondaryText,
              )
                  : AppTextStyles.font14BlackCairoRegular.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Text(
          FormatHelper.capitalize(
            isArabic
                ? widget.approvalModel.currentServiceDescriptionArabic
                : widget.approvalModel.currentServiceDescriptionEnglish,
          ),
          style: isMobile
              ? AppTextStyles.font10BlackCairoRegular.copyWith(
            wordSpacing: -1.sp,
            color: lightMode ? AppColors.blackButton : AppColors.white,
          )
              : AppTextStyles.font13SecondaryBlackCairo.copyWith(
            color: lightMode ? AppColors.blackButton : AppColors.white,
          ),
          textAlign: TextAlign.start,
          softWrap: true,
          overflow: isMobile ? TextOverflow.visible : TextOverflow.clip,
        ),
      ],
    );
  }

  Widget _buildProviderSection(bool lightMode) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _providerFuture ??= _computeProvider(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerPlaceholder(context, width: 200, height: 20),
                  SizedBox(height: 10.h),
                  shimmerPlaceholder(context, width: 150, height: 20),
                  SizedBox(height: 10.h),
                  shimmerPlaceholder(context, width: 180, height: 20),
                ],
              ),
              if (!context.isPhone)
                SizedBox(
                  width: !_isTabletLandscape(context)
                      ? MediaQuery.sizeOf(context).width * .05
                      : MediaQuery.sizeOf(context).width * .1,
                ),
              if (!context.isPhone)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerPlaceholder(context, width: 160, height: 20),
                    SizedBox(height: 10.h),
                    shimmerPlaceholder(context, width: 140, height: 20),
                    SizedBox(height: 10.h),
                    shimmerPlaceholder(context, width: 180, height: 20),
                  ],
                ),
            ],
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          final provider = snapshot.data!;
          return buildProviderDetailsSectionMaster(
            onTap: () {
              navigateTo(
                context,
                ServicesProviderLayout(
                  editingModel: widget.approvalModel,
                  docId: widget.approvalModel.currentId,
                  editProvider: widget.approvalModel,
                ),
              );
            },
            table: true,
            context: context,
            duration: widget.approvalModel.currentDurationOfServices,
            durationUnit: widget.approvalModel.currentSelectedDurationUnit,
            durationTimeStamp: widget.approvalModel.currentDurationOfServicesTimestamp,
            approvalCycle: widget.approvalModel.currentApprovalCycle,
            model: widget.approvalModel.currentProviderServices.first,
            state: currentState ?? 'pending', // 👈 Add this
          );
        } else {
          return Center(
            child: Text(S.of(context).Noproviderdatafound),
          );
        }
      },
    );
  }

  Widget _buildRequesterDetails(bool lightMode, bool isArabic) {
    final isMobile = context.isPhone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).RequesterDetails,
          style: AppTextStyles.font16BlackMediumCairo.copyWith(
            color: lightMode ? AppColors.blackButton : AppColors.white,
          ),
        ),
        SizedBox(height: 20.h),

        if (isMobile) ...[
          // ✅ Mobile: all fields stacked vertically
          CustomRowDetailsMaster(
            data: "${FormatHelper.capitalize(globalFirstNameRequester ?? '-')} ${FormatHelper.capitalize(globalLastNameRequester ?? '-')}",
            image: "assets/images/details/User Plus.svg",
            title: "${S.of(context).Requestedby}: ",
          ),
          SizedBox(height: 10.sp),
          CustomRowDetailsMaster(
            data: _getDepartmentNameFromId(
              widget.approvalModel.currentDepartmentRequester,
            ),
            image: "assets/images/details/Case.svg",
            title: "${S.of(context).Department}: ",
          ),
          SizedBox(height: 10.sp),
          CustomRowDetailsMaster(
            data: FormatHelper.capitalize(globalJobTitleRequester ?? '-'),
            image: "assets/images/details/Case.svg",
            title: "${S.of(context).jobTitle}: ",
          ),
        ] else ...[
          // ✅ Tablet/Desktop: original row layout
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomRowDetailsMaster(
                    data: "${FormatHelper.capitalize(globalFirstNameRequester ?? '-')} ${FormatHelper.capitalize(globalLastNameRequester ?? '-')}",
                    image: "assets/images/details/User Plus.svg",
                    title: "${S.of(context).Requestedby}: ",
                  ),
                  SizedBox(height: 5.sp),
                  CustomRowDetailsMaster(
                    data: _getDepartmentNameFromId(
                      widget.approvalModel.currentDepartmentRequester,
                    ),
                    image: "assets/images/details/Case.svg",
                    title: "${S.of(context).Department}: ",
                  ),
                ],
              ),
              SizedBox(
                width: !_isTabletLandscape(context)
                    ? MediaQuery.sizeOf(context).width * .14
                    : MediaQuery.sizeOf(context).width * .27,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomRowDetailsMaster(
                    data: FormatHelper.capitalize(globalJobTitleRequester ?? '-'),
                    image: "assets/images/details/Case.svg",
                    title: "${S.of(context).jobTitle}: ",
                  ),
                  SizedBox(height: 27.sp),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildApprovalCycleHeader(bool lightMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "${S.of(context).approvalCycle}: ",
          style: AppTextStyles.font14BlackCairoRegular.copyWith(
            color: lightMode ? AppColors.blackButton : AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildApprovalCycleContent(bool isMobile, List<EmployeeEntityModell> displayCycle) {
    return isMobile
        ? buildApprovalCycleMyRequest(
      context,
      false,
      [],
      displayCycle,
    )
        : approvalCycleViewLogic(context, displayCycle);
  }
}

// Extension for copyWith on EmployeeEntityModel
extension EmployeeEntityModelExtension on EmployeeEntityModell {
  EmployeeEntityModell copyWith({String? state}) {
    return EmployeeEntityModell(
      id: id,
      email: email,
      title: title,
      gender: gender,
      lastName: lastName,
      firstName: firstName,
      state: state ?? this.state,
    );
  }
}
