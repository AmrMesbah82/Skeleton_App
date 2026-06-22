/// ******************* FILE INFO *******************
/// File Name: my_request_details.dart
/// Description: can see all request details which you make request
/// Created by: Amr Mesbah
/// Last Update: 14/10/2025 - Updated for ServicesHistoryModel

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/theme/new_theme.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/approvals.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/chat.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/modules_enum.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/request_service_permission.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/services_permissions_sections.dart';
import 'package:shimmer/shimmer.dart';

import 'package:demo_app/core/custom/36-custom_comment_widget.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/features/notification/data/models/notification_data_model.dart';
import 'package:demo_app/features/notification/data/repository/notification_services.dart';
import 'package:demo_app/features/notification/notification_page_confg.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';
import 'package:demo_app/core/widgets/services_management/custom_button_with_image.dart';
import 'package:demo_app/core/widgets/services_management/custom_dialog.dart';
import 'package:demo_app/core/helper/services_management/circle_progress.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_helper_function.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';

import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/controller/create_services_helper.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/pages/my_request_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/approval.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/show_request_details_shimmer.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/pages/request_services_toggle.dart';

import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/provider_details.dart';

class MyRequestDetails extends StatefulWidget {
  const MyRequestDetails({
    required this.myRequestDetailsModel,
    super.key,
  });

  final ServicesHistoryModel myRequestDetailsModel;

  @override
  State<MyRequestDetails> createState() => _MyRequestDetailsState();
}

class _MyRequestDetailsState extends State<MyRequestDetails> {
  bool isVisible = false;

  // ✅ Track comment section expansion
  bool _isCommentExpanded = false;

  String _getLabel(String state) {
    switch (state.toLowerCase()) {
      case 'done':
        return 'Done';
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
      case 'done':
        return Color(0xFF4BB609);
      case 'approved':
        return const Color(0xFF4BB609);
      case 'rejected':
      case 'cancel':
        return const Color(0xFFDF0C0C);
      case 'inprogress':
        return AppColors.yellow;
      case 'breached sla':
        return const Color(0xFFB00020);
      default:
        return AppColors.lightGrey!;
    }
  }

  String _getIconAsset(String state) {
    switch (state.toLowerCase()) {
      case 'approved':
        return 'assets/state/approved.svg';
      case 'done':
        return 'assets/state/approved.svg';
      case 'rejected':
        return 'assets/state/reject.svg';
      case 'cancel':
        return 'assets/state/cansel.svg';
      case 'pending':
        return 'assets/state/pending.svg';
      case 'inprogress':
        return 'assets/state/inprogress.svg';
      case 'breached sla':
        return 'assets/state/breached SLA.svg';
      default:
        return 'assets/state/pending.svg';
    }
  }

  String getOverallStatus() {
    final approvalCycle = widget.myRequestDetailsModel.currentApprovalCycle;

    String? docState = currentState?.toLowerCase();

    if (docState != null && docState.contains('timestamps')) {
      docState = widget.myRequestDetailsModel.currentState.toLowerCase();
    }

    if (approvalCycle.isEmpty) {
      if (docState == 'cancel' ||
          docState == 'inprogress' ||
          docState == 'breached sla' ||
          docState == 'done' ||
          docState == 'rejected') {
        return docState!;
      }
      return 'approved';
    }

    if (docState == 'cancel') {
      return 'cancel';
    }

    if (docState == 'inprogress' || docState == 'breached sla' || docState == 'done') {
      return docState!;
    }

    for (final approver in approvalCycle) {
      final state = approver.state?.toLowerCase();
      if (state == 'rejected' || state == 'cancel') {
        return state!;
      }
    }

    for (final approver in approvalCycle) {
      if (approver.state?.toLowerCase() == 'pending') {
        return 'pending';
      }
    }

    if (approvalCycle.isNotEmpty) {
      bool allApproved = true;
      for (final approver in approvalCycle) {
        if (approver.state?.toLowerCase() != 'approved') {
          allApproved = false;
          break;
        }
      }
      if (allApproved) {
        return 'approved';
      }
    }

    return 'pending';
  }

  String _getLocalizedLabel(String state) {
    switch (state.toLowerCase()) {
      case 'done':
        return S.of(context).Done;
      case 'approved':
        return S.of(context).Approved;
      case 'rejected':
        return S.of(context).Reject;
      case 'cancel':
        return S.of(context).Canceled;
      case 'pending':
        return S.of(context).Pending;
      case 'inprogress':
        return S.of(context).Inprogress;
      case 'breached sla':
        return S.of(context).BreachedSLA;
      default:
        return FormatHelper.capitalize(state);
    }
  }

  Future<void> fetchAndPrintStates() async {
    try {
      final docId = widget.myRequestDetailsModel.currentId;
      final serviceName = widget.myRequestDetailsModel.currentServiceNameEnglish;

      if (docId.isEmpty) {
        return;
      }

      var querySnapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .doc(docId)
          .collection("RequestedServices")
          .where('serviceName', isEqualTo: serviceName)
          .get();

      for (var doc in querySnapshot.docs) {
        if (querySnapshot.docs.isNotEmpty) {
          saveIdUser = querySnapshot.docs.first.data()['id'];
        }
      }
    } catch (e) {
    }
  }

  Future<void> updateStateLabel() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .where("Email_Requester", arrayContains: employeeFunctionHelper.email)
        .where("Service_Name_English",
        isEqualTo: widget.myRequestDetailsModel.currentServiceNameEnglish)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.update({
        "state": FieldValue.arrayUnion([stateLabel]),
        "timestamps":
        FieldValue.arrayUnion([DateTime.now().millisecondsSinceEpoch]),
      });
    }
  }

  List<EmployeeEntityModell> _adjustCycleStates(
      List<EmployeeEntityModell> list) {

    final adjusted = <EmployeeEntityModell>[];
    bool foundPending = false;

    for (int i = 0; i < list.length; i++) {
      final originalState = list[i].state?.toLowerCase();

      if (originalState == 'approved' ||
          originalState == 'rejected' ||
          originalState == 'cancel') {
        adjusted.add(list[i]);
        continue;
      }

      if (!foundPending) {
        adjusted.add(list[i].copyWith(state: 'pending'));
        foundPending = true;
      } else {
        adjusted.add(list[i].copyWith(state: 'normal'));
      }
    }

    return adjusted;
  }

  Color getArrowColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF814A);
      case 'approved':
        return const Color(0xFF4BB609);
      case 'rejected':
        return const Color(0xFFDF0C0C);
      case 'inprogress':
        return AppColors.yellow;
      default:
        return Theme.of(context).brightness == Brightness.light
            ? AppColors.blackButton
            : AppColors.whiteShadow;
    }
  }

  String saveIdUser = "";
  String stateLabel = 'Pending';
  String? cancelReason;

  Future<void> _initFunctions() async {
    await fetchAndPrintStates();

    if (saveIdUser.isNotEmpty) {
      await updateStateLabel();
    }
  }

  cancelCommentFunction() async {

    final cancelSnapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .where('Email_Requester', arrayContains: employeeFunctionHelper.email)
        .get();

    final doc = cancelSnapshot.docs.firstWhere(
          (doc) => doc.id == widget.myRequestDetailsModel.currentId,
      orElse: () => throw Exception("Document not found"),
    );

    final data = doc.data();

    cancelReason = data["canselComment"] ?? '';
    setState(() {});

  }

  String? currentState;
  bool isLoadingCommentReson = true;
  String rejectCommentText = '';
  String approveCommentText = '';

  String serviceNameToDisplay = '';
  String serviceDescriptionToDisplay = '';
  String durationToDisplay = '';
  bool isLoadingServiceDetails = true;

  Future<void> _loadServiceDetailsFromCreateServices() async {
    try {
      final emailRequester =
      widget.myRequestDetailsModel.currentEmailRequester.isNotEmpty
          ? widget.myRequestDetailsModel.currentEmailRequester
          : '';

      final parentServiceId =
          widget.myRequestDetailsModel.currentParentServiceId;

      if (parentServiceId.isEmpty || emailRequester.isEmpty) {
        setState(() {
          final isArabic =
              Localizations.localeOf(context).languageCode == 'ar';
          serviceNameToDisplay = isArabic
              ? widget.myRequestDetailsModel.currentServiceNameArabic
              : widget.myRequestDetailsModel.currentServiceNameEnglish;
          serviceDescriptionToDisplay = isArabic
              ? (widget.myRequestDetailsModel
              .currentServiceDescriptionArabic ??
              '')
              : (widget.myRequestDetailsModel
              .currentServiceDescriptionEnglish ??
              '');
          durationToDisplay =
          '${widget.myRequestDetailsModel.currentDurationOfServices} ${widget.myRequestDetailsModel.currentSelectedDurationUnit}';
          isLoadingServiceDetails = false;
        });
        return;
      }

      final result =
      await CreateServicesHelper.getServiceDetailsFromCreateServices(
        parentServiceId: parentServiceId,
        emailRequester: emailRequester,
      );

      if (mounted) {
        final isArabic = Localizations.localeOf(context).languageCode == 'ar';

        setState(() {
          serviceNameToDisplay = isArabic
              ? (result['Service_Name_Arabic'] != '-'
              ? result['Service_Name_Arabic']!
              : widget.myRequestDetailsModel.currentServiceNameArabic)
              : (result['Service_Name_English'] != '-'
              ? result['Service_Name_English']!
              : widget.myRequestDetailsModel.currentServiceNameEnglish);

          serviceDescriptionToDisplay = isArabic
              ? (result['Service_Description_Arabic'] != '-'
              ? result['Service_Description_Arabic']!
              : (widget.myRequestDetailsModel
              .currentServiceDescriptionArabic ??
              ''))
              : (result['Service_Description_English'] != '-'
              ? result['Service_Description_English']!
              : (widget.myRequestDetailsModel
              .currentServiceDescriptionEnglish ??
              ''));

          final duration = result['duration']!;
          final unit = result['unit']!;

          if (duration != '-' && unit != '-') {
            durationToDisplay = '$duration $unit';
          } else {
            durationToDisplay =
            '${widget.myRequestDetailsModel.currentDurationOfServices} ${widget.myRequestDetailsModel.currentSelectedDurationUnit}';
          }

          isLoadingServiceDetails = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          final isArabic =
              Localizations.localeOf(context).languageCode == 'ar';
          serviceNameToDisplay = isArabic
              ? widget.myRequestDetailsModel.currentServiceNameArabic
              : widget.myRequestDetailsModel.currentServiceNameEnglish;
          serviceDescriptionToDisplay = isArabic
              ? (widget.myRequestDetailsModel
              .currentServiceDescriptionArabic ??
              '')
              : (widget.myRequestDetailsModel
              .currentServiceDescriptionEnglish ??
              '');
          durationToDisplay =
          '${widget.myRequestDetailsModel.currentDurationOfServices} ${widget.myRequestDetailsModel.currentSelectedDurationUnit}';
          isLoadingServiceDetails = false;
        });
      }
    }
  }

  void debugModelState() {

    final cycle = widget.myRequestDetailsModel.currentApprovalCycle;
  }

  @override
  void initState() {
    super.initState();
    debugModelState();
    _initialize();
    _loadServiceDetailsFromCreateServices();
  }

  Future<void> _initialize() async {

    rejectCommentText = await checkRejectComment();

    approveCommentText = await checkApproveComment();

    await cancelCommentFunction();

    final snapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .doc(widget.myRequestDetailsModel.currentId)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data();
      final stateData = data?["state"];

      if (stateData is List && stateData.isNotEmpty) {
        currentState = stateData.last?.toString().toLowerCase();
      } else if (stateData is String) {
        currentState = stateData.toLowerCase();
      } else {
        currentState = stateData?.toString().toLowerCase();
      }

    }

    await _initFunctions();

    setState(() {
      isLoadingCommentReson = false;
    });
  }

  Future<String> checkRejectComment() async {

    final querySnapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .where("Email_Requester", arrayContains: employeeFunctionHelper.email)
        .get();

    final doc = querySnapshot.docs.firstWhere(
          (doc) => doc.id == widget.myRequestDetailsModel.currentId,
      orElse: () => throw Exception("Document not found"),
    );

    final data = doc.data();

    final comment = data['rejectComment'];

    if (comment != null && comment.toString().isNotEmpty) {
      return comment.toString();
    } else {
      return '';
    }
  }

  Future<String> checkApproveComment() async {

    final querySnapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .where("Email_Requester", arrayContains: employeeFunctionHelper.email)
        .get();

    final doc = querySnapshot.docs.firstWhere(
          (doc) => doc.id == widget.myRequestDetailsModel.currentId,
      orElse: () => throw Exception("Document not found"),
    );

    final data = doc.data();

    final comment = data['approveComment'];

    if (comment != null && comment.toString().isNotEmpty) {
      return comment.toString();
    } else {
      return '';
    }
  }

  Future<void> fetchLatestStateFromFirestore() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .where("Email_Requester", arrayContains: employeeFunctionHelper.email)
          .get();

      final doc = querySnapshot.docs.firstWhere(
            (doc) => doc.id == widget.myRequestDetailsModel.currentId,
        orElse: () => throw Exception("Document not found"),
      );

      final data = doc.data();
      final stateData = data['state'];

      if (stateData is List && stateData.isNotEmpty) {
        currentState = stateData.last?.toString().toLowerCase();
      } else if (stateData is String) {
        currentState = stateData.toLowerCase();
      } else {
        currentState = stateData?.toString().toLowerCase();
      }

    } catch (e) {
    }
  }

  bool isTabletLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return size.width >= 600 && isLandscape;
  }

  final TextEditingController _cancelController = TextEditingController();

  @override
  void dispose() {
    _cancelController.dispose();
    super.dispose();
  }

  int totalServices = 0;
  int pendingCount = 0;
  int approvedCount = 0;
  int cancelCount = 0;
  int rejectedCount = 0;
  int inProgressCount = 0;
  int branchSlaCount = 0;
  int doneCount = 0;

  List<String> _extractStatesFromValueList(List<dynamic>? valueList) {
    List<String> states = [];

    if (valueList != null && valueList.isNotEmpty) {
      for (var item in valueList) {
        final state = (item['state'] ?? '').toString().toLowerCase();
        states.add(state);
      }
    }

    return states;
  }

  Future<void> fetchServiceStateCounts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .where("Email_Requester", isEqualTo: employeeFunctionHelper.email)
        .get();

    totalServices = snapshot.docs.length;
    pendingCount = 0;
    approvedCount = 0;
    cancelCount = 0;
    doneCount = 0;
    rejectedCount = 0;
    inProgressCount = 0;
    branchSlaCount = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();

      final model = ServicesHistoryModel.fromJson(data, doc.id);
      final stateField = model.currentState.toLowerCase().trim();

      String finalState = '';

      if (stateField.isNotEmpty) {
        finalState = stateField;
      }

      if (finalState.isEmpty) {
        final approvalCycle = model.currentApprovalCycle;

        if (approvalCycle.isNotEmpty) {
          final states =
          approvalCycle.map((a) => a.state?.toLowerCase() ?? '').toList();

          if (states.contains('cancel')) {
            finalState = 'cancel';
          } else if (states.contains('rejected')) {
            finalState = 'rejected';
          } else if (states.every((s) => s == 'approved')) {
            finalState = 'approved';
          } else if (states.contains('pending')) {
            finalState = 'pending';
          }
        }
      }

      switch (finalState) {
        case 'pending':
          pendingCount++;
          break;
        case 'approved':
          approvedCount++;
          break;
        case 'cancel':
          cancelCount++;
          break;
        case 'rejected':
          rejectedCount++;
          break;
        case 'inprogress':
          inProgressCount++;
          break;
        case 'branchsla':
        case 'breached sla':
          branchSlaCount++;
          break;
        case 'done':
          doneCount++;
          break;
      }
    }

    setState(() {});
  }

  bool _hasRejectionInApprovalCycle(
      List<EmployeeEntityModell> approvalCycle) {
    for (var approver in approvalCycle) {
      final state = approver.state?.toLowerCase();
      if (state == 'rejected' || state == 'cancel') {
        return true;
      }
    }
    return false;
  }

  bool _hasSpecificStateInApprovalCycle(
      List<EmployeeEntityModell> approvalCycle, String targetState) {
    for (var approver in approvalCycle) {
      if (approver.state?.toLowerCase() == targetState.toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  bool _areAllApproversApproved(List<EmployeeEntityModell> approvalCycle) {
    for (var approver in approvalCycle) {
      if (approver.state?.toLowerCase() != 'approved') {
        return false;
      }
    }
    return approvalCycle.isNotEmpty;
  }

  Future<Map<String, dynamic>?> _getRequestSpecificProvider() async {
    try {
      final docId = widget.myRequestDetailsModel.currentId;

      final providerServices =
          widget.myRequestDetailsModel.currentProviderServices;
      for (int i = 0; i < providerServices.length; i++) {
        final provider = providerServices[i];
      }

      if (docId.isEmpty) {
        return null;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .where("Email_Requester", arrayContains: employeeFunctionHelper.email)
          .get();

      final requestDoc = querySnapshot.docs.firstWhere(
            (doc) => doc.id == docId,
        orElse: () => throw Exception("Document not found"),
      );

      final data = requestDoc.data();

      final assignedEmail =
          widget.myRequestDetailsModel.currentAssignedProviderEmail;

      if (assignedEmail.isNotEmpty) {

        final providerServices =
            widget.myRequestDetailsModel.currentProviderServices;

        if (providerServices.isNotEmpty) {
          try {
            final assignedProvider = providerServices.firstWhere(
                  (p) =>
              (p.email ?? '').toLowerCase() == assignedEmail.toLowerCase(),
            );

            final providerMap = _convertEmployeeToMap(assignedProvider);

            return providerMap;
          } catch (e) {
          }
        }
      }

      if (data.containsKey('Provider_Services') &&
          data['Provider_Services'] is Map) {
        final providerData = data['Provider_Services'] as Map<String, dynamic>;
        return providerData;
      }

      final providerServicesForSelection =
          widget.myRequestDetailsModel.currentProviderServices;

      if (providerServicesForSelection.isNotEmpty) {

        final selectedProvider = await _selectFairProviderFromModel(
          providers: providerServicesForSelection,
          requestDate: widget.myRequestDetailsModel.timestamps.isNotEmpty
              ? DateTime.fromMillisecondsSinceEpoch(
              widget.myRequestDetailsModel.timestamps.first)
              : DateTime.now(),
        );

        if (selectedProvider != null) {

          final assignedEmail =
          selectedProvider['email'].toString().toLowerCase();

          await requestDoc.reference.update({
            'Provider_Services': selectedProvider,
            'Assigned_Provider_Email': FieldValue.arrayUnion([assignedEmail]),
            'timestamps':
            FieldValue.arrayUnion([DateTime.now().millisecondsSinceEpoch]),
          });

          return selectedProvider;
        }
      }

      final providerServicesFromModel =
          widget.myRequestDetailsModel.currentProviderServices;

      if (providerServicesFromModel.isNotEmpty) {
        final firstProvider = providerServicesFromModel.first;

        final providerMap = _convertEmployeeToMap(firstProvider);
        final assignedEmail = (firstProvider.email ?? '').toLowerCase();

        await requestDoc.reference.update({
          'Provider_Services': providerMap,
          'Assigned_Provider_Email': FieldValue.arrayUnion([assignedEmail]),
          'timestamps':
          FieldValue.arrayUnion([DateTime.now().millisecondsSinceEpoch]),
        });

        return providerMap;
      }

      return null;
    } catch (e, stackTrace) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> _selectFairProviderFromModel({
    required List<EmployeeEntityModell> providers,
    required DateTime requestDate,
  }) async {
    try {
      if (providers.isEmpty) return null;

      final providersList =
      providers.map((p) => _convertEmployeeToMap(p)).toList();

      return await _selectFairProviderFromMaps(
        providers: providersList,
        requestDate: requestDate,
      );
    } catch (e) {
      return providers.isNotEmpty
          ? _convertEmployeeToMap(providers.first)
          : null;
    }
  }

  Map<String, dynamic> _convertEmployeeToMap(EmployeeEntityModell employee) {

    if (employee.mobilePhone != null) {

      try {
        final jsonTest = employee.mobilePhone!.toJson();
      } catch (e) {
      }
    }

    final map = {
      'id': employee.id ?? '',
      'email': employee.email ?? '',
      'firstName': employee.firstName ?? '',
      'lastName': employee.lastName ?? '',
      'firstNameInArabic': employee.firstNameInArabic ?? '',
      'lastNameInArabic': employee.lastNameInArabic ?? '',
      'middleName': employee.middleName ?? '',
      'middleNameInArabic': employee.middleNameInArabic ?? '',
      'departmentId': employee.departmentId ?? '',
      'title': employee.title ?? '',
      'titleInArabic': employee.titleInArabic ?? '',
      'role': employee.role ?? '',
      'gender': employee.gender ?? '',
      'workLocation': employee.workLocation ?? '',
      'status': employee.status ?? 'active',
      'nationalId': employee.nationalId ?? '',
      'nationality': employee.nationality ?? '',
      'birthDay': employee.birthDay ?? '',
      'country': employee.country ?? '',
      'province': employee.province ?? '',
      'city': employee.city ?? '',
      'maritalStatus': employee.maritalStatus ?? '',
      'language': employee.language ?? '',
      'supervisor': employee.supervisor ?? '',
      'mobilePhone': employee.mobilePhone?.toJson(),
      'officePhone': employee.officePhone ?? '',
      'homePhone': employee.homePhone ?? '',
      'extension': employee.extension ?? '',
    };

    if (map['mobilePhone'] != null && map['mobilePhone'] is Map) {
      final phoneMap = map['mobilePhone'] as Map;
    }

    return map;
  }

  Future<Map<String, dynamic>?> _selectFairProviderFromMaps({
    required List<Map<String, dynamic>> providers,
    required DateTime requestDate,
  }) async {
    try {
      if (providers.isEmpty) return null;

      final sevenDaysAgo = requestDate.subtract(Duration(days: 7));

      final recentRequestsQuery = await FirebaseFirestore.instance
          .collectionGroup('user')
          .where('createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo))
          .where('createdAt',
          isLessThanOrEqualTo: Timestamp.fromDate(requestDate))
          .get();

      Map<String, int> providerWorkload = {};
      for (var provider in providers) {
        final email = provider['email']?.toString() ?? '';
        if (email.isNotEmpty) {
          providerWorkload[email] = 0;
        }
      }

      for (var doc in recentRequestsQuery.docs) {
        final data = doc.data();
        if (data['provider'] is Map) {
          final providerEmail = data['provider']['email']?.toString();
          if (providerEmail != null &&
              providerWorkload.containsKey(providerEmail)) {
            providerWorkload[providerEmail] =
                (providerWorkload[providerEmail] ?? 0) + 1;
          }
        }
      }

      String? selectedProviderEmail;
      int minWorkload = double.maxFinite.toInt();

      for (var entry in providerWorkload.entries) {
        if (entry.value < minWorkload) {
          minWorkload = entry.value;
          selectedProviderEmail = entry.key;
        }
      }

      if (selectedProviderEmail != null) {
        return providers.firstWhere(
              (p) => p['email'] == selectedProviderEmail,
          orElse: () => providers.first,
        );
      }

      return providers.first;
    } catch (e) {
      return providers.isNotEmpty ? providers.first : null;
    }
  }

  EmployeeEntityModell _convertMapToEmployeeEntityModel(
      Map<String, dynamic> data) {
    List<String?>? _convertToStringList(dynamic value) {
      if (value == null) return null;
      if (value is List) {
        return value.map((e) => e?.toString()).toList();
      }
      if (value is String) {
        return value.isEmpty ? null : [value];
      }
      return null;
    }

    return EmployeeEntityModell(
      id: data['id']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      firstName: data['firstName']?.toString() ?? '',
      lastName: data['lastName']?.toString() ?? '',
      firstNameInArabic: data['firstNameInArabic']?.toString() ?? '',
      lastNameInArabic: data['lastNameInArabic']?.toString() ?? '',
      middleName: data['middleName']?.toString() ?? '',
      middleNameInArabic: data['middleNameInArabic']?.toString() ?? '',
      nationalId: data['nationalId']?.toString() ?? '',
      nationalIdExpirationDate:
      data['nationalIdExpirationDate']?.toString() ?? '',
      nationality: data['nationality']?.toString() ?? '',
      passport: data['passport']?.toString() ?? '',
      passportExpirationDate:
      data['passportExpirationDate']?.toString() ?? '',
      mobilePhone: data['mobilePhone'] != null && data['mobilePhone'] is Map
          ? ServicesMobilePhoneEntity.fromJson(data['mobilePhone'])
          : null,
      officePhone: data['officePhone']?.toString() ?? '',
      homePhone: data['homePhone']?.toString() ?? '',
      extension: data['extension']?.toString() ?? '',
      birthDay: data['birthDay']?.toString() ?? '',
      gender: data['gender']?.toString() ?? '',
      country: data['country']?.toString() ?? '',
      province: data['province']?.toString() ?? '',
      city: data['city']?.toString() ?? '',
      postalCode: data['postalCode']?.toString() ?? '',
      street: data['street']?.toString() ?? '',
      maritalStatus: data['maritalStatus']?.toString() ?? '',
      language: data['language']?.toString() ?? '',
      departmentId: data['departmentId']?.toString() ?? '',
      supervisor: data['supervisor']?.toString() ?? '',
      role: data['role']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      titleInArabic: data['titleInArabic']?.toString() ?? '',
      workLocation: data['workLocation']?.toString() ?? '',
      drivingLicenseId: data['drivingLicenseId']?.toString() ?? '',
      carPlates: _convertToStringList(data['carPlates']),
      academicHistory:
      data['academicHistory'] != null && data['academicHistory'] is Map
          ? AcademicHistoryEntity.fromJson(data['academicHistory'])
          : null,
      bio: data['bio']?.toString() ?? '',
      photo: data['photo']?.toString() ?? '',
      skills: _convertToStringList(data['skills']),
      hobbies: _convertToStringList(data['hobbies']),
      status: data['status']?.toString() ?? '',
      password: data['password']?.toString() ?? '',
      defaultPassword: data['defaultPassword'],
      firstLogin: data['firstLogin'],
      lastLogin: data['lastLogin']?.toString() ?? '',
      deactivationDate: data['deactivationDate']?.toString() ?? '',
      activationDate: data['activationDate']?.toString() ?? '',
      state: data['state']?.toString() ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    var employeeEntity = Get.find<MainCoreEmployeeController>().employeeEntity!;

    final isDocStateFinalized =
    (currentState?.toLowerCase().trim().isNotEmpty ?? false);
    final hasPendingInApprovalCycle = _hasSpecificStateInApprovalCycle(
        widget.myRequestDetailsModel.currentApprovalCycle, 'pending');

    if (isLoadingCommentReson) {
      return Center(
        child: CircleProgress(),
      );
    }

    final approvalCycle = widget.myRequestDetailsModel.currentApprovalCycle;
    List<EmployeeEntityModell> displayCycle = _adjustCycleStates(approvalCycle);

    final docState = getOverallStatus();

    stateLabel = _getLabel(docState);
    Color borderColor = _getBorderColor(docState);
    String iconAsset = _getIconAsset(docState);

    final bool hasRejection = _hasRejectionInApprovalCycle(displayCycle);

    if (docState == 'cancel') {
      stateLabel = _getLabel('cancel');
      borderColor = _getBorderColor('cancel');
      iconAsset = _getIconAsset('cancel');
    } else if (hasRejection) {
      EmployeeEntityModell? rejected;
      for (var approver in displayCycle) {
        final state = approver.state?.toLowerCase();
        if (state == 'rejected' || state == 'cancel') {
          rejected = approver;
          break;
        }
      }

      if (rejected != null) {
        final s = rejected.state!.toLowerCase();
        stateLabel = _getLabel(s);
        borderColor = _getBorderColor(s);
        iconAsset = _getIconAsset(s);
      }
    } else if (docState != 'inprogress' &&
        docState != 'done' &&
        docState != 'breached sla' &&
        _areAllApproversApproved(displayCycle)) {
      stateLabel = 'Approved';
      borderColor = AppColors.lightGreen;
      iconAsset = "assets/state/approved.svg";
    } else {
      int currentPending = -1;
      for (int i = 0; i < displayCycle.length; i++) {
        if (displayCycle[i].state?.toLowerCase() == 'pending') {
          currentPending = i;
          break;
        }
      }

      if (currentPending != -1) {
        stateLabel = 'Pending';
        borderColor = _getBorderColor('pending');
        iconAsset = _getIconAsset('pending');
      }
    }

    String getLocalizedDurationUnit(String? unit, bool isArabic) {
      if (unit == null) return '';

      final lowerUnit = unit.toLowerCase().trim();

      final map = {
        'days': isArabic ? 'أيام' : 'days',
        'day': isArabic ? 'يوم' : 'day',
        'weeks': isArabic ? 'أسابيع' : 'weeks',
        'week': isArabic ? 'أسبوع' : 'week',
        'hours': isArabic ? 'ساعات' : 'hours',
        'hour': isArabic ? 'ساعة' : 'hour',
        'minutes': isArabic ? 'دقائق' : 'minutes',
        'minute': isArabic ? 'دقيقة' : 'minute',
      };

      return map[lowerUnit] ?? (isArabic ? 'وحدة غير معروفة' : 'Unknown Unit');
    }

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final hasPending = _hasSpecificStateInApprovalCycle(
        widget.myRequestDetailsModel.currentApprovalCycle, 'pending');

    final isCanceled = (currentState?.toLowerCase() ?? '') == 'cancel';

    final shouldShowReminder = hasPending && !hasRejection && !isCanceled;
    var isMobile = context.isPhone;
    var isTablet = context.isTablet;

    Future<bool> _getProviderLanguagePreference(String providerEmail) async {
      try {

        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(providerEmail.toLowerCase())
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

    Future<void> _sendCancellationNotificationToProvider({
      required String providerEmail,
      required String serviceName,
      required String requesterName,
      required String cancellationReason,
    }) async {
      if (providerEmail.isEmpty) {
        return;
      }

      try {

        final isArabic = await _getProviderLanguagePreference(providerEmail);

        String notificationTitle;
        String notificationBody;

        notificationTitle =
        isArabic ? "تم إلغاء طلب خدمة" : "Service Request Cancelled";

        notificationBody = isArabic
            ? "تم إلغاء طلب الخدمة '$serviceName' من قبل $requesterName.\nسبب الإلغاء: $cancellationReason"
            : "Service request '$serviceName' from $requesterName has been cancelled.\nReason: $cancellationReason";

        final notificationModel = NotificationModelSystem(
          title: notificationTitle,
          body: notificationBody,
          nameOfModule: 'services',
          senderEmail: employeeFunctionHelper.email ?? '',
          receiverEmail: providerEmail,
          nameOfPage: 'ServiceProviderDashboard',
          isPinned: false,
          isRead: false,
          isClean: false,
        );

        final notificationService = FirestoreNotificationService();
        final docId =
        await notificationService.uploadNotification(notificationModel);

        await NotificationServiceApp.sendNotification(
          notificationTitle,
          notificationBody,
          providerEmail,
        );

      } catch (notificationError) {
      }
    }

    var disappearHome = Get.find<MainCoreEmployeeController>().isHasPermission(
      module: Modules.services,
      section: ServicePermissionsSections.servicesPermissions,
      permission: null,
    );

    return Scaffold(
      body: SafeArea(
        child: SideFrameMasterServices(
          titleText: FormatHelper.capitalize(S.of(context).services),
          onFirstTap: () {
            navigateTo(context, LayoutScreenServices());
          },
          secondTitle: disappearHome
              ? FormatHelper.capitalize(S.of(context).serviceRequests)
              : FormatHelper.capitalize(S.of(context).myRequests),
          onSecondTap: () {
            disappearHome
                ? navigateTo(context, RequestServicesToggle())
                : navigateTo(context, MyRequestServicesToggle());
          },
          thirdTitle: disappearHome
              ? FormatHelper.capitalize(S.of(context).myRequests)
              : isLoadingServiceDetails
              ? '...'
              : FormatHelper.capitalize(serviceNameToDisplay),
          onThirdTap: () {
            Navigator.pop(context);
          },
          fourthTitle: disappearHome
              ? (isLoadingServiceDetails
              ? '...'
              : FormatHelper.capitalize(serviceNameToDisplay))
              : null,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                // ✅ Hide everything above comments when expanded
                if (!_isCommentExpanded) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        S.of(context).requestDetails,
                        style: AppTextStyles.font16BlackSemiBoldCairo.copyWith(
                          color:
                          Theme.of(context).brightness == Brightness.light
                              ? AppColors.blackButton
                              : AppColors.white,
                        ),
                      ),
                      Spacer(),
                      if (Get.find<MainCoreEmployeeController>().isHasPermission(
                          module: Modules.services,
                          permission: RequestServicePermission.cancelService,
                          section: ServicePermissionsSections
                              .requestServicePermissions))
                        (cancelReason?.isEmpty ?? true) &&
                            !_hasRejectionInApprovalCycle(widget
                                .myRequestDetailsModel.currentApprovalCycle) &&
                            (currentState?.toLowerCase() != 'cancel' &&
                                currentState?.toLowerCase() != 'done')
                            ? GestureDetector(
                          onTap: () {
                            CustomDialogManager.showDialogFlow(
                              context: context,
                              customReasonTitle:
                              S.of(context).reasonsOfCancellation,
                              confirmLottie:
                              'assets/lottie/rejected.json',
                              confirmTitle: S.of(context).cancelRequest,
                              confirmSubtitle: S
                                  .of(context)
                                  .AreYousureYouWanttoCancelThisRequest,
                              confirmYesText: S.of(context).yes,
                              confirmNoText: S.of(context).no,
                              onConfirm: () {
                              },
                              comment: true,
                              commentRequired: true,
                              commentController: _cancelController,
                              commentSubmitText: S.of(context).submit,
                              commentDiscardText: S.of(context).discard,
                              onCommentSubmit: () async {
                                try {

                                  await updateRequestState(
                                      widget.myRequestDetailsModel
                                          .currentId,
                                      'cancel');

                                  final querySnapshot =
                                  await FirebaseFirestore.instance
                                      .collection(getBaseUrl(
                                      FirestoreCollections
                                          .requestServices))
                                      .where('Email_Requester',
                                      arrayContains:
                                      employeeEntity.email)
                                      .get();

                                  final doc =
                                  querySnapshot.docs.firstWhere(
                                        (doc) =>
                                    doc.id ==
                                        widget.myRequestDetailsModel
                                            .currentId,
                                    orElse: () => throw Exception(
                                        "Document not found"),
                                  );

                                  await doc.reference.update({
                                    "state": FieldValue.arrayUnion(
                                        ['cancel']),
                                    "timestamps":
                                    FieldValue.arrayUnion([
                                      DateTime.now()
                                          .millisecondsSinceEpoch
                                    ]),
                                    "canselComment":
                                    _cancelController.text,
                                  });

                                  if (mounted) {
                                    setState(() {
                                      currentState = 'cancel';
                                      cancelReason =
                                          _cancelController.text;
                                    });
                                  }

                                  try {
                                    final providerData =
                                    await _getRequestSpecificProvider();

                                    if (providerData != null) {
                                      final providerEmail =
                                          providerData['email']
                                              ?.toString() ??
                                              '';

                                      if (providerEmail.isNotEmpty) {
                                        final isArabic =
                                            Localizations.localeOf(
                                                context)
                                                .languageCode ==
                                                'ar';
                                        final serviceName = isArabic
                                            ? (widget
                                            .myRequestDetailsModel
                                            .currentServiceNameArabic ??
                                            widget
                                                .myRequestDetailsModel
                                                .currentServiceNameEnglish ??
                                            '')
                                            : (widget
                                            .myRequestDetailsModel
                                            .currentServiceNameEnglish ??
                                            '');

                                        final requesterName = isArabic
                                            ? "${widget.myRequestDetailsModel.currentFirstNameRequesterArabic ?? ""} ${widget.myRequestDetailsModel.currentLastNameRequesterArabic ?? ""}"
                                            : "${widget.myRequestDetailsModel.currentFirstNameRequester ?? ""} ${widget.myRequestDetailsModel.currentLastNameRequester ?? ""}";

                                        await _sendCancellationNotificationToProvider(
                                          providerEmail: providerEmail,
                                          serviceName: serviceName,
                                          requesterName:
                                          requesterName.trim(),
                                          cancellationReason:
                                          _cancelController.text,
                                        );
                                      }
                                    }
                                  } catch (notificationError) {
                                  }

                                  await ServicesManagerCubit.get(context)
                                      .getMyRequestServices();
                                  await ServicesManagerCubit.get(context)
                                      .getRequestedServices(
                                      employeeEntity.email!);
                                  await fetchServiceStateCounts();

                                } catch (e, stackTrace) {

                                  if (mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Error cancelling request: $e'),
                                        backgroundColor: AppColors.red,
                                      ),
                                    );
                                  }
                                  rethrow;
                                }
                              },
                              successLottie:
                              'assets/lottie/approved.json',
                              successTitle: S.of(context).CancelRequest,
                              successSubtitle:
                              S.of(context).cancelSuccessMessage,
                              onSuccessComplete: () {

                                Future.delayed(
                                    const Duration(milliseconds: 500),
                                        () {
                                      if (mounted) {
                                        navigateTo(context,
                                            MyRequestServicesToggle());
                                      }
                                    });
                              },
                            );
                          },
                          child: Container(
                            width: isMobile ? 135.sp : 150.sp,
                            height: 30.sp,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: AppColors.red,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/x.svg",
                                  height: 20.sp,
                                  width: 20.sp,
                                  fit: BoxFit.scaleDown,
                                  semanticsLabel: 'Dart Logo',
                                ),
                                SizedBox(width: 8.sp),
                                Text(
                                  S.of(context).Cancel,
                                  style: AppTextStyles.font16BlackMediumCairo
                                      .copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            : SizedBox()
                    ],
                  ),
                  SizedBox(height: 8.sp),
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Theme.of(context).brightness == Brightness.light
                              ? AppColors.white
                              : AppColors.chatBackground,
                          border: widget.myRequestDetailsModel.currentApprovalCycle
                              .length >
                              3 &&
                              widget.myRequestDetailsModel
                                  .currentApprovalCycle[3].state ==
                                  "Breached SLA"
                              ? Border.all(color: AppColors.red)
                              : Border.all(color: Colors.transparent),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: isMobile
                                  ? CrossAxisAlignment.center
                                  : CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: isMobile
                                          ? 40.sp
                                          : !isTabletLandscape(context)
                                          ? 80.sp
                                          : 100.sp,
                                      height: isMobile
                                          ? 40.sp
                                          : !isTabletLandscape(context)
                                          ? 80.sp
                                          : 100.sp,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(8.r),
                                        color: lightMode
                                            ? AppColors.background
                                            : AppColors.background,
                                      ),
                                      child: widget.myRequestDetailsModel
                                          .currentImageUrl.isNotEmpty
                                          ? ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(4.r),
                                        child: CachedNetworkImage(
                                          imageUrl: widget
                                              .myRequestDetailsModel
                                              .currentImageUrl,
                                          width: 40.sp,
                                          height: 40.sp,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                                baseColor: AppColors.secondaryText.withOpacity(.3),
                                                highlightColor: lightMode
                                                    ? AppColors.background
                                                    : AppColors.background
                                                    .withOpacity(0.5),
                                                child: Container(
                                                  width: 40.sp,
                                                  height: 40.sp,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.secondaryText.withOpacity(0.5),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        4.r),
                                                  ),
                                                ),
                                              ),
                                          errorWidget:
                                              (context, url, error) {
                                            return SvgPicture.asset(
                                              'assets/svgItemCard.svg',
                                              width: 20.sp,
                                              height: 20.sp,
                                              color:
                                              AppColors.secondaryText,
                                              fit: BoxFit.scaleDown,
                                            );
                                          },
                                        ),
                                      )
                                          : Center(
                                        child: SvgPicture.asset(
                                          "assets/services_module/new_head_phone.svg",
                                          width: isMobile ? 24.sp : 50.sp,
                                          height:
                                          isMobile ? 24.sp : 50.sp,
                                          color: AppColors.secondaryText,
                                          fit: BoxFit.contain,
                                          semanticsLabel: 'Headphone Icon',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10.w),
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      isMobile
                                          ? isLoadingServiceDetails
                                          ? Shimmer.fromColors(
                                        baseColor: AppColors
                                            .secondaryText
                                            .withOpacity(.3),
                                        highlightColor: AppColors
                                            .background
                                            .withOpacity(.5),
                                        child: Container(
                                          height: 14.sp,
                                          width: 150.sp,
                                          decoration: BoxDecoration(
                                            color: AppColors
                                                .secondaryText
                                                .withOpacity(.5),
                                            borderRadius:
                                            BorderRadius.circular(
                                                4.r),
                                          ),
                                        ),
                                      )
                                          : Text(
                                        FormatHelper.capitalize(
                                            serviceNameToDisplay),
                                        style: StyleText
                                            .fontSize14Weight400
                                            .copyWith(
                                            color: AppColors.text),
                                      )
                                          : Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/des.svg",
                                                    width: 14.sp,
                                                    height: 14.sp,
                                                    color: AppColors.text,
                                                    fit: BoxFit.fill,
                                                    semanticsLabel:
                                                    'Dart Logo',
                                                  ),
                                                  SizedBox(width: 3.sp),
                                                  Text(
                                                    "${S.of(context).serviceDescription}",
                                                    style: StyleText
                                                        .fontSize14Weight400
                                                        .copyWith(
                                                      color: AppColors.text
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                          isLoadingServiceDetails
                                              ? Shimmer.fromColors(
                                            baseColor: AppColors
                                                .secondaryText
                                                .withOpacity(.3),
                                            highlightColor: AppColors
                                                .background
                                                .withOpacity(.5),
                                            child: Container(
                                              height: 40.sp,
                                              decoration:
                                              BoxDecoration(
                                                color: AppColors
                                                    .secondaryText
                                                    .withOpacity(
                                                    .5),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    4.r),
                                              ),
                                            ),
                                          )
                                              : Text(
                                            FormatHelper.capitalize(
                                                serviceDescriptionToDisplay),
                                            style: StyleText
                                                .fontSize13Weight400
                                                .copyWith(
                                              height: 1.5,
                                              color: AppColors.text
                                            ),
                                            textAlign:
                                            TextAlign.start,
                                            softWrap: true,
                                            overflow:
                                            TextOverflow.clip,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20.h),

                            isMobile ? descriptionWidget() : SizedBox(),
                            isMobile ? SizedBox(height: 20.sp) : SizedBox(),

                            FutureBuilder<Map<String, dynamic>?>(
                              future: _getRequestSpecificProvider(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          shimmerPlaceholder(context,
                                              width: 200, height: 20),
                                          SizedBox(height: 10.h),
                                          shimmerPlaceholder(context,
                                              width: 150, height: 20),
                                          SizedBox(height: 10.h),
                                          shimmerPlaceholder(context,
                                              width: 180, height: 20),
                                        ],
                                      ),
                                      isMobile
                                          ? SizedBox()
                                          : SizedBox(
                                        width: !isTabletLandscape(context)
                                            ? MediaQuery.sizeOf(context)
                                            .width *
                                            .05
                                            : MediaQuery.sizeOf(context)
                                            .width *
                                            .1,
                                      ),
                                      isMobile
                                          ? SizedBox()
                                          : Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          shimmerPlaceholder(context,
                                              width: 160, height: 20),
                                          SizedBox(height: 10.h),
                                          shimmerPlaceholder(context,
                                              width: 140, height: 20),
                                          SizedBox(height: 10.h),
                                          shimmerPlaceholder(context,
                                              width: 180, height: 20),
                                        ],
                                      ),
                                    ],
                                  );
                                } else if (snapshot.hasData &&
                                    snapshot.data != null) {
                                  final providerData = snapshot.data!;

                                  final providerModel =
                                  _convertMapToEmployeeEntityModel(
                                      providerData);

                                  final durationTimestamp = widget
                                      .myRequestDetailsModel
                                      .currentDurationOfServicesTimestamp;

                                  return buildProviderDetailsSectionMaster(
                                    context: context,
                                    duration: isLoadingServiceDetails
                                        ? widget.myRequestDetailsModel
                                        .currentDurationOfServices
                                        : durationToDisplay
                                        .split(' ')
                                        .first,
                                    durationUnit: isLoadingServiceDetails
                                        ? widget.myRequestDetailsModel
                                        .currentSelectedDurationUnit
                                        : durationToDisplay.split(' ').length >
                                        1
                                        ? durationToDisplay
                                        .split(' ')
                                        .sublist(1)
                                        .join(' ')
                                        : widget.myRequestDetailsModel
                                        .currentSelectedDurationUnit,
                                    durationTimeStamp: durationTimestamp,
                                    approvalCycle: widget.myRequestDetailsModel
                                        .currentApprovalCycle,
                                    model: providerModel,
                                    state: widget.myRequestDetailsModel.currentState.isNotEmpty
                                        ? widget.myRequestDetailsModel.currentState
                                        : 'pending',
                                  );
                                } else {
                                  return Center(
                                      child:
                                      Text(S.of(context).Noproviderdatafound));
                                }
                              },
                            ),

                            SizedBox(height: 20.h),

                            widget.myRequestDetailsModel.currentApprovalCycle
                                .isEmpty
                                ? SizedBox()
                                : Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).approvalCycle,
                                      style: StyleText
                                          .fontSize14Weight400
                                          .copyWith(
                                        color: Theme.of(context)
                                            .brightness ==
                                            Brightness.light
                                            ? AppColors.secondaryText
                                            : AppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                isMobile
                                    ? SizedBox()
                                    : SizedBox(height: 15.h),
                                isMobile
                                    ? buildApprovalCycleMyRequest(
                                  context,
                                  false,
                                  [],
                                  _adjustCycleStates(widget
                                      .myRequestDetailsModel
                                      .currentApprovalCycle),
                                )
                                    : approvalCycleViewLogic(
                                    context,
                                    _adjustCycleStates(widget
                                        .myRequestDetailsModel
                                        .currentApprovalCycle)),
                              ],
                            ),

                            if (cancelReason != null && cancelReason!.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 12.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 5.sp),
                                      child: SvgPicture.asset(
                                        "assets/status.svg",
                                        width: 16.sp,
                                        height: 16.sp,
                                        fit: BoxFit.cover,
                                        color: AppColors.red,
                                      ),
                                    ),
                                    SizedBox(width: 6.sp),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: AppTextStyles.font14BlackCairoMedium
                                              .copyWith(
                                            color: Theme.of(context)
                                                .brightness ==
                                                Brightness.light
                                                ? AppColors.red
                                                : AppColors.whiteShadow,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                              "${S.of(context).ReasonOfCancelation}: ",
                                              style: StyleText
                                                  .fontSize14Weight500
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                AppColors.red,
                                              ),
                                            ),
                                            TextSpan(
                                              text: FormatHelper.capitalize(
                                                  cancelReason!),
                                              style: StyleText
                                                  .fontSize14Weight500
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
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
                                  ],
                                ),
                              ),

                            if (rejectCommentText.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 12.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/status.svg",
                                      width: isMobile ? 12.sp : 16.sp,
                                      height: isMobile ? 12.sp : 16.sp,
                                      color: AppColors.red,
                                    ),
                                    SizedBox(width: 6.sp),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: AppTextStyles.font14BlackCairoMedium
                                              .copyWith(
                                            color:
                                            AppColors.red,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                              "${S.of(context).ReasonOfRejection}: ",
                                              style: isMobile
                                                  ? StyleText
                                                  .fontSize12Weight500
                                                  .copyWith(
                                                fontWeight:
                                                FontWeight.bold,
                                                color: AppColors.red
                                              )
                                                  : StyleText
                                                  .fontSize14Weight500
                                                  .copyWith(
                                                fontWeight:
                                                FontWeight.bold,
                                                color: AppColors.red
                                              ),
                                            ),
                                            TextSpan(
                                              text: FormatHelper.capitalize(
                                                  rejectCommentText),
                                              style: isMobile
                                                  ? StyleText
                                                  .fontSize12Weight500
                                                  .copyWith(
                                                fontWeight:
                                                FontWeight.bold,
                                                color: AppColors.text
                                              )
                                                  : StyleText
                                                  .fontSize14Weight500
                                                  .copyWith(
                                                fontWeight:
                                                FontWeight.bold,
                                                color: AppColors.text
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if (approveCommentText.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 12.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/status.svg",
                                      width: isMobile ? 12.sp : 16.sp,
                                      height: isMobile ? 12.sp : 16.sp,
                                      color: AppColors.lightGreen,
                                    ),
                                    SizedBox(width: 6.sp),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: AppTextStyles.font14BlackCairoMedium
                                              .copyWith(
                                            color: AppColors.lightGreen,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                              "${S.of(context).ReasonOfApprove}: ",
                                              style: isMobile
                                                  ? StyleText
                                                  .fontSize12Weight500
                                                  .copyWith(
                                                fontWeight:
                                                FontWeight.bold,
                                                color: AppColors.green
                                              )
                                                  : StyleText
                                                  .fontSize14Weight500
                                                  .copyWith(
                                                fontWeight:
                                                FontWeight.bold,
                                                color: AppColors.green
                                              ),
                                            ),
                                            TextSpan(
                                              text: FormatHelper.capitalize(
                                                  approveCommentText),
                                              style: isMobile
                                                  ? StyleText
                                                  .fontSize12Weight500
                                                  .copyWith(
                                                fontWeight:
                                                FontWeight.bold,
                                                color: AppColors.text
                                              )
                                                  : StyleText
                                                  .fontSize14Weight500
                                                  .copyWith(
                                                fontWeight:
                                                FontWeight.bold,
                                                color: AppColors.text
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            SizedBox(height: 20.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                widget.myRequestDetailsModel.currentApprovalCycle
                                    .isNotEmpty &&
                                    shouldShowReminder
                                    ? customButtonWithImage(
                                  title: isMobile
                                      ? S.of(context).reminder
                                      : S.of(context).SendReminder,
                                  function: () async {
                                    String? currentApproverEmail;

                                    List<EmployeeEntityModell>
                                    displayCycle = _adjustCycleStates(
                                        widget.myRequestDetailsModel
                                            .currentApprovalCycle);

                                    for (int i = 0;
                                    i < displayCycle.length;
                                    i++) {
                                      if (displayCycle[i]
                                          .state
                                          ?.toLowerCase() ==
                                          'pending') {
                                        currentApproverEmail =
                                            displayCycle[i].email;
                                        break;
                                      }
                                    }

                                    if (currentApproverEmail != null &&
                                        currentApproverEmail.isNotEmpty) {
                                      final isArabic =
                                          Localizations.localeOf(context)
                                              .languageCode ==
                                              'ar';
                                      final serviceName = isArabic
                                          ? widget.myRequestDetailsModel
                                          .currentServiceNameArabic
                                          : widget.myRequestDetailsModel
                                          .currentServiceNameEnglish;

                                      await NotificationServiceApp
                                          .sendNotification(
                                        serviceName,
                                        "Please Confirm Your Approval Request",
                                        currentApproverEmail,
                                      );

                                    }
                                  },
                                  textStyle: StyleText
                                      .fontSize16Weight500
                                      .copyWith(
                                    color: AppColors.textButton,
                                  ),
                                  width: isMobile ? 125.sp : 185.sp,
                                  height: 36.sp,
                                  space: 8.sp,
                                  radius: 8.r,
                                  color: AppColors.primary,
                                  image: "assets/notification.svg",
                                  widthImage: 21.sp,
                                  heightImage: 21.sp,
                                  colorBorder: Colors.transparent,
                                )
                                    : SizedBox(),
                                if (shouldShowReminder) Spacer(),
                                Container(
                                  width: isMobile
                                      ? (shouldShowReminder ? 150.sp : double.infinity)
                                      : 200.sp,
                                  height: 36.sp,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                        Brightness.light
                                        ? AppColors.white
                                        : AppColors.chatBackground,
                                    borderRadius:
                                    BorderRadius.circular(8.r),
                                    border:
                                    Border.all(color: borderColor),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      widget.myRequestDetailsModel
                                          .currentState ==
                                          "cancel" ||
                                          (widget
                                              .myRequestDetailsModel
                                              .currentApprovalCycle
                                              .isNotEmpty &&
                                              _hasRejectionInApprovalCycle(
                                                  widget.myRequestDetailsModel
                                                      .currentApprovalCycle))
                                          ? Container(
                                        width: 22.sp,
                                        height: 22.sp,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.red,
                                        ),
                                        child: Icon(
                                          Icons.block_flipped,
                                          color: AppColors.chatBackground,
                                          size: 18,
                                        ),
                                      )
                                          : SvgPicture.asset(
                                        iconAsset,
                                        width: 24.sp,
                                        height: 24.sp,
                                        fit: BoxFit.scaleDown,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        _getLocalizedLabel(docState),
                                        style: StyleText
                                            .fontSize16Weight500
                                            .copyWith(color: borderColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.sp),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${S.of(context).requestedDate}: ",
                              style: isMobile
                                  ? AppTextStyles.font10BlackCairoRegular.copyWith(
                                color: lightMode
                                    ? AppColors.secondaryText
                                    : AppColors.grey,
                              )
                                  : AppTextStyles.font12BlackCairoRegular.copyWith(
                                color: lightMode
                                    ? AppColors.secondaryText
                                    : AppColors.grey,
                              ),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy').format(
                                widget.myRequestDetailsModel?.currentTimestamp !=
                                    null
                                    ? DateTime.fromMillisecondsSinceEpoch(widget
                                    .myRequestDetailsModel!.currentTimestamp!)
                                    : DateTime.now(),
                              ),
                              style: isMobile
                                  ? AppTextStyles.font10BlackCairoRegular.copyWith(
                                color: lightMode
                                    ? AppColors.blackButton
                                    : AppColors.white,
                              )
                                  : AppTextStyles.font12BlackCairoRegular.copyWith(
                                color: lightMode
                                    ? AppColors.blackButton
                                    : AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.myRequestDetailsModel.currentApprovalCycle
                          .length >
                          3 &&
                          widget.myRequestDetailsModel.currentApprovalCycle[3]
                              .state ==
                              "Breached SLA")
                        Positioned(
                          top: 12.h,
                          left: -40.w,
                          child: Transform.rotate(
                            angle: -0.785398,
                            child: Container(
                              width: 160.w,
                              color: AppColors.red,
                              child: Row(
                                children: [
                                  SizedBox(width: 30.w),
                                  Text(
                                    'Breached SLA',
                                    style: AppTextStyles.font10BlackCairoRegular
                                        .copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 19.sp),
                ], // ✅ end of if (!_isCommentExpanded)

                // ✅ Comment section — always visible, controls expansion
                UniversalCommentSection(
                  collectionPath: 'Demo/75440689/Comments',
                  filterFields: {
                    'Request_Id': widget.myRequestDetailsModel.currentId,
                  },
                  currentUserId: Get.find<MainCoreEmployeeController>()
                      .employeeEntity!
                      .email!,
                  isExpandable: true,
                  fixedHeight: MediaQuery.of(context).size.height,
                  // ✅ Called by UniversalCommentSection when expand/collapse tapped
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

                if (!_isCommentExpanded) SizedBox(height: 19.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget descriptionWidget() {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    var isMobile = context.isPhone;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              child: SvgPicture.asset(
                "assets/des.svg",
                width: 16.w,
                height: 16.h,
                color: AppColors.secondaryText.withOpacity(.5),
                fit: BoxFit.scaleDown,
                semanticsLabel: 'Dart Logo',
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              S.of(context).serviceDescription,
              style: isMobile
                  ? AppTextStyles.font14BlackCairoRegular
                  .copyWith(color: AppColors.secondaryText)
                  : AppTextStyles.font14BlackCairoRegular
                  .copyWith(color: AppColors.secondaryText),
            ),
          ],
        ),
        SizedBox(height: 5.sp),
        isLoadingServiceDetails
            ? Shimmer.fromColors(
          baseColor: AppColors.secondaryText.withOpacity(.3),
          highlightColor: AppColors.background.withOpacity(.5),
          child: Container(
            height: 40.sp,
            decoration: BoxDecoration(
              color: AppColors.secondaryText.withOpacity(.5),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        )
            : Text(
          FormatHelper.capitalize(serviceDescriptionToDisplay),
          style: isMobile
              ? AppTextStyles.font10BlackCairoRegular.copyWith(
            wordSpacing: -1.sp,
            color: lightMode
                ? AppColors.blackButton
                : AppColors.white,
          )
              : AppTextStyles.font13SecondaryBlackCairo.copyWith(
            color: lightMode
                ? AppColors.blackButton
                : AppColors.white,
          ),
          textAlign: TextAlign.start,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }
}
