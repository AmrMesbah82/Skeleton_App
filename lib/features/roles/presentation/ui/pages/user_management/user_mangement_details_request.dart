import 'package:demo_app/core/widgets/shared_action_widgets.dart';
import 'package:demo_app/features/knowledge_hub_module/core/custom_dialog_manager.dart';
import 'package:demo_app/core/widgets/side_frame_master.dart';
import 'package:demo_app/features/knowledge_hub_module/knowledge_hub/presentation/ui/widgets/customed_text_field.dart';
import 'package:demo_app/core/theme/new_theme.dart';
import 'package:demo_app/features/services_mangment_module/core/custom_textformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/core/widgets/custom_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/format_helper.dart';
import 'package:demo_app/features/employee/data/models/emplyees_model/mobile_phone_model.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/services_mangment_module/core/new_theme.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../../generated/l10n.dart';
// REMOVED_MODULE: import '../../../../../../external/inventory_module/core/custom_button_widget.dart';
// REMOVED_MODULE: import '../../../../../../external/inventory_module/core/text_field.dart';
// REMOVED_MODULE: import '../../../../../../external/knowledge_hub_module/core/custom_dialog_manager.dart';
// REMOVED_MODULE: import '../../../../../../external/knowledge_hub_module/knowledge_hub/presentation/ui/widgets/customed_text_field.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../employee/data/models/emplyees_model/new_employee_model.dart';
import '../../../../../employee/presentation/controller/main_core_employee_controller.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/Category/presentation/ui/service_department_manager/mobile/dashBoard_master_mobile/widget/dialog.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/Category/presentation/ui/services_admin/Widget/W3_Frame_Screen_tablet.dart';


class UserManagementDetailsRequestSettings extends StatefulWidget {
  final Map<String, dynamic> requestData;
  final String? requestId;

  const UserManagementDetailsRequestSettings({
    super.key,
    required this.requestData,
    this.requestId,
  });

  @override
  State<UserManagementDetailsRequestSettings> createState() =>
      _UserManagementDetailsRequestSettingsState();
}

class _UserManagementDetailsRequestSettingsState
    extends State<UserManagementDetailsRequestSettings> {
  late TextEditingController requestNoteController;
  bool submitted = false;
  bool isProcessing = false;
  bool isLoading = true;

  String status = 'pending';
  int requestTime = 0;
  String createdByID = '';
  String createdByEmail = '';
  String section = '';

  List<Map<String, String>> changes = [];
  Map<String, dynamic>? completeRequestData;

  @override
  void initState() {
    super.initState();
    requestNoteController = TextEditingController();
    _fetchCompleteRequestData();
  }

  Future<void> _fetchCompleteRequestData() async {
    try {
      if (widget.requestId == null || widget.requestId!.isEmpty) {
        setState(() => isLoading = false);
        return;
      }

      final String basePath = getBaseUrl('Modules');
      final docSnapshot = await FirebaseFirestore.instance
          .doc('$basePath/roles')
          .collection('Employees_Request')
          .doc(widget.requestId)
          .get();

      if (!docSnapshot.exists) {
        setState(() => isLoading = false);
        return;
      }

      completeRequestData = docSnapshot.data();
      _initializeWithCompleteData();
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _initializeWithCompleteData() {
    if (completeRequestData == null) {
      setState(() => isLoading = false);
      return;
    }

    createdByEmail = completeRequestData!['employeeEmail'] ?? '';
    createdByID = completeRequestData!['employeeId'] ?? '';
    status = completeRequestData!['status'] ?? 'pending';
    section = completeRequestData!['section'] ?? 'Personal Information';

    final requestDate = completeRequestData!['requestDate'];
    if (requestDate != null) {
      if (requestDate is int) {
        requestTime = requestDate;
      } else if (requestDate is Timestamp) {
        requestTime = requestDate.millisecondsSinceEpoch;
      }
    }

    requestNoteController.text = FormatHelper.capitalize(
        completeRequestData!['requestNote']?.toString() ?? '');

    _parseChanges();
    setState(() => isLoading = false);
  }

  void _parseChanges() {
    try {
      final changesData = completeRequestData!['changes'];

      if (changesData is List && changesData.isNotEmpty) {
        changes = changesData.map((change) {
          if (change is Map) {
            return {
              'fieldName': change['fieldName']?.toString() ?? '',
              'oldValue': change['oldValue']?.toString() ?? '',
              'newValue': change['newValue']?.toString() ?? '',
            };
          }
          return <String, String>{};
        }).where((c) => c['fieldName']?.isNotEmpty == true).toList();
      } else {
        final whatChanged =
            completeRequestData!['whatChanged']?.toString().trim() ?? '';
        final oldValue = completeRequestData!['oldValue']?.toString() ?? '';
        final newValue = completeRequestData!['newValue']?.toString() ?? '';

        if (whatChanged.isNotEmpty) {
          changes = [
            {'fieldName': whatChanged, 'oldValue': oldValue, 'newValue': newValue}
          ];
        } else {
          changes = [];
        }
      }
    } catch (e) {
      changes = [];
    }
  }

  @override
  void dispose() {
    requestNoteController.dispose();
    super.dispose();
  }

  String _mapFieldName(String requestFieldName) {
    final fieldMappings = {
      'first_name': 'firstName',
      'middle_name': 'middleName',
      'last_name': 'lastName',
      'first_name_arabic': 'firstNameInArabic',
      'middle_name_arabic': 'middleNameInArabic',
      'last_name_arabic': 'lastNameInArabic',
      'email': 'email',
      'gender': 'gender',
      'date_of_birth': 'birthDay',
      'marital_status': 'maritalStatus',
      'street': 'street',
      'city': 'city',
      'province': 'province',
      'country': 'country',
      'postalCode': 'postalCode',
      'postal_code': 'postalCode',
      'phone': 'mobilePhone.phones',
      'Phone': 'mobilePhone.phones',
      'country_code': 'mobilePhone.countryCode',
      'Country_Code': 'mobilePhone.countryCode',
      'country_app': 'mobilePhone.countryApp',
      'Country_App': 'mobilePhone.countryApp',
      'insuranceName': 'insuranceName',
      'insurance_name': 'insuranceName',
      'Insurance_Name': 'insuranceName',
      'insurancePolicyNumber': 'insurancePolicyNumber',
      'insurance_policy_number': 'insurancePolicyNumber',
      'Insurance_Policy_Number': 'insurancePolicyNumber',
      'firstContactFirstName': 'firstContactFirstName',
      'firstContactLastName': 'firstContactLastName',
      'firstContactRelationship': 'firstContactRelationship',
      'firstContactEmail': 'firstContactEmail',
      'firstContactPhone': 'firstContactPhone',
      'secondContactFirstName': 'secondContactFirstName',
      'secondContactLastName': 'secondContactLastName',
      'secondContactRelationship': 'secondContactRelationship',
      'secondContactEmail': 'secondContactEmail',
      'secondContact_email': 'secondContactEmail',
      'secondContactPhone': 'secondContactPhone',
    };
    return fieldMappings[requestFieldName] ?? requestFieldName;
  }

  Future<void> _updateEmployeeData() async {
    final employeeController = Get.find<MainCoreEmployeeController>();
    final employeeEntity = employeeController.getLocaleEmployee(createdByEmail);

    if (employeeEntity == null) throw Exception('Employee not found');

    final employeeId = employeeEntity.id;
    if (employeeId == null || employeeId.isEmpty)
      throw Exception('Employee ID not found');

    final String basePath = getBaseUrl('Employees_Info');
    final employeeDoc =
    await FirebaseFirestore.instance.doc('$basePath/$employeeId').get();

    if (!employeeDoc.exists) throw Exception('Employee document not found');

    var employeeHistory =
    NewEmployeeModelHistory.fromMap(employeeDoc.data());

    for (var change in changes) {
      final fieldName = change['fieldName']!;
      final newValue = change['newValue']!;
      final modelFieldName = _mapFieldName(fieldName);

      if (modelFieldName.startsWith('mobilePhone.')) {
        await _updateMobilePhoneField(
          employeeId: employeeId,
          basePath: basePath,
          employeeHistory: employeeHistory,
          modelFieldName: modelFieldName,
          newValue: newValue,
        );
      } else {
        employeeHistory =
            employeeHistory.updateFieldSynchronized(modelFieldName, newValue);
      }
    }

    if (!changes
        .any((c) => _mapFieldName(c['fieldName']!).startsWith('mobilePhone.'))) {
      await FirebaseFirestore.instance
          .doc('$basePath/$employeeId')
          .update(employeeHistory.toMap());
    }
  }

  Future<void> _updateMobilePhoneField({
    required String employeeId,
    required String basePath,
    required NewEmployeeModelHistory employeeHistory,
    required String modelFieldName,
    required String newValue,
  }) async {
    final phoneFieldName = modelFieldName.split('.').last;
    MobilePhone? currentPhone;

    if (employeeHistory.mobilePhone != null &&
        employeeHistory.mobilePhone!.isNotEmpty) {
      currentPhone = employeeHistory.mobilePhone!.last;
    }
    currentPhone ??= MobilePhone();

    final now = Timestamp.now();
    List<String> updatedPhones = List.from(currentPhone.phones ?? []);
    List<String> updatedCountryCodes =
    List.from(currentPhone.countryCode ?? []);
    List<String> updatedCountryApps = List.from(currentPhone.countryApp ?? []);
    List<Timestamp> updatedTimestamps =
    List.from(currentPhone.timestamps ?? []);

    switch (phoneFieldName) {
      case 'phones':
        updatedPhones.add(newValue);
        break;
      case 'countryCode':
        updatedCountryCodes.add(newValue);
        break;
      case 'countryApp':
        updatedCountryApps.add(newValue);
        break;
    }
    updatedTimestamps.add(now);

    final updatedPhone = MobilePhone(
      phones: updatedPhones,
      countryCode: updatedCountryCodes,
      countryApp: updatedCountryApps,
      timestamps: updatedTimestamps,
    );

    await FirebaseFirestore.instance
        .doc('$basePath/$employeeId')
        .update({'Mobile_Phone': (updatedPhone.toMap())});
  }

  String _formatValueForDisplay(String value, String fieldName) {
    bool isDateField = fieldName.toLowerCase().contains('date') ||
        fieldName.toLowerCase().contains('birth') ||
        fieldName.toLowerCase().contains('_of_');

    if (!isDateField) return value;

    try {
      DateTime? dateTime;
      if (value.contains('T')) {
        dateTime = DateTime.tryParse(value);
      } else if (value.contains('-') && value.split('-').length == 3) {
        dateTime = DateTime.tryParse(value);
      } else if (value.contains('/')) {
        List<String> parts = value.split('/');
        if (parts.length == 3) {
          int month = int.tryParse(parts[0]) ?? 0;
          int day = int.tryParse(parts[1]) ?? 0;
          int year = int.tryParse(parts[2]) ?? 0;
          if (year < 100) year += (year <= 30) ? 2000 : 1900;
          if (month > 0 && day > 0 && year > 0) {
            dateTime = DateTime(year, month, day);
          }
        }
      } else if (int.tryParse(value) != null) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(value));
      }
      if (dateTime != null) return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (_) {}

    return value;
  }

  // ─── CORE: update status in Firestore ────────────────────────────────────
  Future<void> _updateRequestStatus(String newStatus) async {
    if (widget.requestId == null) return;

    setState(() => isProcessing = true);

    try {
      final String basePath = getBaseUrl('Modules');

      if (newStatus == 'approved') {
        await _updateEmployeeData();
      }

      await FirebaseFirestore.instance
          .doc('$basePath/roles')
          .collection('Employees_Request')
          .doc(widget.requestId)
          .update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        status = newStatus;
        isProcessing = false;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newStatus == 'approved'
                  ? 'Request approved successfully ✓'
                  : 'Request rejected ✗',
            ),
            backgroundColor:
            newStatus == 'approved' ? Color(0xFF34C759) : Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => isProcessing = false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ─── Confirmation dialog via CustomDialogManager ─────────────────────────
  Future<void> _showConfirmDialog({required String action}) async {
    final isApprove = action == 'approved';

    await CustomDialogManager.showDialogFlow(
      context: context,

      // ── Confirm step ──────────────────────────────────────────────────────
      confirmLottie: isApprove
          ? 'assets/lottie/confirm_approve.json'   // ← swap with your actual lottie paths
          : 'assets/lottie/confirm_reject.json',
      confirmTitle: isApprove
          ? 'Approve Request'
          : 'Reject Request',
      confirmSubtitle: isApprove
          ? 'Are you sure you want to approve this request?'
          : 'Are you sure you want to reject this request?',
      confirmYesText: isApprove ? S.of(context).approve : S.of(context).reject,
      confirmNoText: 'Cancel',

      // ── What happens when the user taps YES ───────────────────────────────
      onConfirm: () {
        _updateRequestStatus(action);
      },

      // ── No comment dialog needed ──────────────────────────────────────────
      comment: false,

      // ── Success step ──────────────────────────────────────────────────────
      successLottie: isApprove
          ? 'assets/lottie/success_approve.json'   // ← swap with your actual lottie paths
          : 'assets/lottie/success_reject.json',
      successTitle: isApprove
          ? 'Request Approved'
          : 'Request Rejected',
      successSubtitle: isApprove
          ? 'The request has been approved successfully.'
          : 'The request has been rejected.',
    );
  }

  String _translateSectionTitle(String englishTitle) {
    bool isArabic = Get.locale?.languageCode == 'ar';
    if (!isArabic) return englishTitle;
    switch (englishTitle) {
      case 'Personal Information':
        return 'المعلومات الشخصية';
      case 'Emergency Contact':
        return 'جهة الاتصال في حالات الطوارئ';
      case 'Health Insurance':
        return 'التأمين الصحي';
      default:
        return englishTitle;
    }
  }

  String _formatDate(int timestamp) {
    if (timestamp == 0) return '-';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd MMM yyyy').format(date);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Color(0xFF34C759);
      case 'pending':
        return Color(0xffFF814A);
      case 'rejected':
        return Colors.red[500]!;
      default:
        return AppColors.secondaryText;
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'assets/state_icon/approve_icon.svg';
      case 'pending':
        return 'assets/state_icon/pending_icon.svg';
      case 'rejected':
        return 'assets/state_icon/rejected_icon.svg';
      default:
        return 'assets/state_icon/rejected_icon.svg';
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return S.of(context).Approved;
      case 'pending':
        return S.of(context).Pending;
      case 'rejected':
        return S.of(context).Rejected;
      default:
        return status;
    }
  }

  String _getFieldLabel(String fieldKey) {
    final labelMap = {
      'first_name': S.of(context).firstName,
      'middle_name': S.of(context).middleName,
      'last_name': S.of(context).lastName,
      'street': S.of(context).streetName,
      'city': S.of(context).city,
      'province': S.of(context).stateOrProvince,
      'country': S.of(context).country,
      'email': S.of(context).email,
      'phone': S.of(context).phoneNumber,
      'gender': S.of(context).gender,
      'date_of_birth': S.of(context).birthday,
      'marital_status': S.of(context).maritalStatus,
      'secondContact_email': 'Emergency Contact Email',
      'secondContactEmail': 'Emergency Contact Email',
      'secondContactPhone': 'Emergency Contact Phone',
      'secondContactFirstName': 'Emergency Contact First Name',
      'secondContactLastName': 'Emergency Contact Last Name',
      'secondContactRelationship': 'Emergency Contact Relationship',
      'firstContactEmail': 'Primary Contact Email',
      'firstContactPhone': 'Primary Contact Phone',
      'firstContactFirstName': 'Primary Contact First Name',
      'firstContactLastName': 'Primary Contact Last Name',
      'firstContactRelationship': 'Primary Contact Relationship',
      'insuranceName': 'Insurance Name',
      'insurance_name': 'Insurance Name',
      'Insurance_Name': 'Insurance Name',
      'insurancePolicyNumber': 'Insurance Policy Number',
      'insurance_policy_number': 'Insurance Policy Number',
      'Insurance_Policy_Number': 'Insurance Policy Number',
    };
    return labelMap[fieldKey] ?? _formatFieldName(fieldKey);
  }

  String _formatFieldName(String fieldKey) {
    return fieldKey
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
        ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
        : '')
        .join(' ');
  }

  // ─── Status / action button area ─────────────────────────────────────────
  Widget _buildStatusButton() {
    // Already actioned → show read-only badge
    if (status != 'pending') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: _getStatusColor(status)),
            ),
            width: 200.w,
            height: 36.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSvg(
                  assetPath: _getStatusIcon(status),
                  width: 24.w,
                  height: 24.h,
                  fit: BoxFit.scaleDown,
                ),
                SizedBox(width: 8.w),
                Text(
                  _getStatusLabel(status),
                  style: StyleText.fontSize16Weight500.copyWith(
                    color: _getStatusColor(status),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Saving in progress
    if (isProcessing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 24.w,
            height: 24.h,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      );
    }

    // ── Pending → Approve + Reject buttons ───────────────────────────────────
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Reject
        GestureDetector(
          onTap: () => _showConfirmDialog(action: 'rejected'),
          child: Container(
            width: 150.w,
            height: 38.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.red, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSvg(
                    assetPath: "assets/state/reject.svg",
                    width: 18.w,
                    height: 18.h,
                    fit: BoxFit.scaleDown),
                SizedBox(width: 6.w),
                Text(
                  S.of(context).reject,
                  style: StyleText.fontSize16Weight500
                      .copyWith(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // Approve
        GestureDetector(
          onTap: () => _showConfirmDialog(action: 'approved'),
          child: Container(
            width: 150.w,
            height: 38.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Color(0xFF34C759), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSvg(
                    assetPath: "assets/state/approved.svg",
                    width: 18.w,
                    height: 18.h,
                    fit: BoxFit.scaleDown),
                SizedBox(width: 6.w),
                Text(
                  S.of(context).approve,
                  style: StyleText.fontSize16Weight500
                      .copyWith(color: Color(0xFF34C759)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
      bool lightMode,
      bool isMobile,
      bool isArabic,
      String creatorName,
      String creatorTitle,
      String creatorDepartment,
      String creatorPhone,
      String creatorEmail,
      String creatorPhoto,
      bool isNetworkPhoto,
      ) {
    if (isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(50.sp),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (changes.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(50.sp),
          child: Text(
            'No changes found in this request',
            style: StyleText.fontSize16Weight500.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(lightMode),
        SizedBox(height: 8.h),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.card,
              ),
              child: Padding(
                padding: EdgeInsets.all(15.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 65.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: ClipOval(
                        child: !isNetworkPhoto
                            ? Image.network(
                          creatorPhoto,
                          width: 80.w,
                          height: 80.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return CustomSvg(
                              assetPath: "assets/images/male.svg",
                              width: 80.w,
                              height: 80.h,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                            : CustomSvg(
                          assetPath: creatorPhoto,
                          width: 80.w,
                          height: 80.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 14.sp),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            FormatHelper.capitalize(creatorName),
                            style: StyleText.fontSize16Weight500.copyWith(
                              color: AppColors.text,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 16.sp),
                          isMobile
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(
                                  lightMode,
                                  "assets/images/case.svg",
                                  S.of(context).title,
                                  creatorTitle),
                              SizedBox(height: 12.h),
                              _buildDetailRow(
                                  lightMode,
                                  "assets/images/department.svg",
                                  S.of(context).department,
                                  creatorDepartment),
                              SizedBox(height: 12.h),
                              _buildDetailRow(
                                  lightMode,
                                  "assets/images/phone_number.svg",
                                  S.of(context).phoneNumber,
                                  creatorPhone),
                              SizedBox(height: 12.h),
                              _buildDetailRow(
                                  lightMode,
                                  "assets/images/email.svg",
                                  S.of(context).email,
                                  creatorEmail),
                            ],
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailRow(
                                        lightMode,
                                        "assets/svg/job_title_new.svg",
                                        S.of(context).title,
                                        creatorTitle),
                                    SizedBox(height: 18.h),
                                    _buildDetailRow(
                                        lightMode,
                                        "assets/images/department.svg",
                                        S.of(context).department,
                                        creatorDepartment),
                                  ],
                                ),
                              ),
                              SizedBox(width: 24.sp),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailRow(
                                        lightMode,
                                        "assets/images/phone_number.svg",
                                        S.of(context).phoneNumber,
                                        creatorPhone),
                                    SizedBox(height: 18.h),
                                    _buildDetailRow(
                                        lightMode,
                                        "assets/images/email.svg",
                                        S.of(context).email,
                                        creatorEmail),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10.sp,
              left: isArabic ? 10.sp : null,
              right: isArabic ? null : 10.sp,
              child: customButtonWithImage(
                title: isMobile ? "" : "Chat".tr,
                function: () {},
                color: AppColors.primary,
                width: isMobile ? 38.w : 150.w,
                height: 38.h,
                radius: 4.r,
                space: 8.sp,
                heightImage: 25.sp,
                colorBorder: Colors.transparent,
                widthImage: 25.sp,
                image: 'assets/roles_icons/Messages.svg',
                textStyle: StyleText.fontSize14Weight400
                    .copyWith(color: AppColors.textButton),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        ...changes
            .map((change) => _buildSection(
          lightMode: lightMode,
          sectionTitle: _translateSectionTitle(section),
          isMobile: isMobile,
          fieldName: change['fieldName']!,
          oldValue: change['oldValue']!,
          newValue: change['newValue']!,
        ))
            .toList(),
        _buildRequestNoteSection(lightMode),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildDetailRow(
      bool lightMode, String iconPath, String label, String value) {
    return Row(
      children: [
        CustomSvg(
            assetPath: iconPath, width: 15.w, height: 15.h, fit: BoxFit.fill),
        SizedBox(width: 8.sp),
        Text(
          "$label: ",
          style: StyleText.fontSize14Weight500
              .copyWith(color: AppColors.secondaryText),
        ),
        Expanded(
          child: Text(
            FormatHelper.capitalize(value),
            style:
            StyleText.fontSize14Weight500.copyWith(color: AppColors.text),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool lightMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          S.of(context).requestDetails,
          style: StyleText.fontSize16Weight600.copyWith(
            color: lightMode
                ? AppColors.blackButton
                : AppColors.white,
          ),
        ),
        Spacer(),
        Text(
          "${S.of(context).requestedDate}: ",
          style: StyleText.fontSize12Weight400.copyWith(
            color: lightMode
                ? AppColors.secondaryText
                : AppColors.grey,
          ),
        ),
        Text(
          _formatDate(requestTime),
          style: StyleText.fontSize12Weight400.copyWith(
            color: lightMode
                ? AppColors.blackButton
                : AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required bool lightMode,
    required String sectionTitle,
    required bool isMobile,
    required String fieldName,
    required String oldValue,
    required String newValue,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: AppColors.card,
          ),
          child: Padding(
            padding: EdgeInsets.only(
                right: 15.sp, left: 15.sp, top: 5.sp, bottom: 15.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15.h),
                _buildSectionHeader(lightMode, sectionTitle),
                SizedBox(height: 20.h),
                isMobile
                    ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDataColumn(
                      lightMode: lightMode,
                      title: S.of(context).current_details,
                      titleColor: AppColors.text,
                      value: oldValue,
                      fieldName: fieldName,
                    ),
                    SizedBox(height: 12.h),
                    _buildDataColumn(
                      lightMode: lightMode,
                      title: S.of(context).new_details,
                      titleColor: Colors.green,
                      value: newValue,
                      fieldName: fieldName,
                    ),
                  ],
                )
                    : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildDataColumn(
                        lightMode: lightMode,
                        title: S.of(context).current_details,
                        titleColor: lightMode
                            ? AppColors.blackButton
                            : AppColors.white,
                        value: oldValue,
                        fieldName: fieldName,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildDataColumn(
                        lightMode: lightMode,
                        title: S.of(context).new_details,
                        titleColor: Colors.green,
                        value: newValue,
                        fieldName: fieldName,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildSectionHeader(bool lightMode, String sectionTitle) {
    bool isInsuranceSection =
        sectionTitle.contains('Insurance') || sectionTitle.contains('التأمين');

    return Row(
      children: [
        Container(
          width: 30.w,
          height: 30.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: AppColors.primary.withOpacity(.15),
          ),
          child: Center(
            child: CustomSvg(
              assetPath: isInsuranceSection
                  ? "assets/Insurance Details.svg"
                  : "assets/Emergency Contact.svg",
              width: 16.w,
              height: 16.h,
              fit: BoxFit.fill,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          FormatHelper.capitalize(sectionTitle),
          style: StyleText.fontSize18Weight500.copyWith(
            color: lightMode
                ? AppColors.blackButton
                : AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDataColumn({
    required bool lightMode,
    required String title,
    required Color titleColor,
    required String value,
    required String fieldName,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          FormatHelper.capitalize(title),
          style: StyleText.fontSize16Weight600.copyWith(color: titleColor),
        ),
        SizedBox(height: 15.h),
        CustomValidatedTextFieldMaster(
          label: FormatHelper.capitalize(_getFieldLabel(fieldName)),
          hint: _getFieldLabel(fieldName),
          controller:
          TextEditingController(text: value.isEmpty ? '-' : value),
          enabled: false,
          submitted: submitted,
          fillColor: title.contains('current') || title.contains('الحالية')
              ? (lightMode ? AppColors.background : AppColors.background)
              : null,
        ),
      ],
    );
  }

  Widget _buildRequestNoteSection(bool lightMode) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r), color: AppColors.card),
      child: Padding(
        padding: EdgeInsets.all(15.sp),
        child: Column(
          children: [
            CustomValidatedTextField(
              hint: S.of(context).requestNote,
              controller: requestNoteController,
              enabled: false,
              label: S.of(context).requestNote,
              submitted: submitted,
              maxLines: 3,
              height: 72,
              textDirection:
              isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
              showCharCount: true,
            ),
            SizedBox(height: 20.h),

            // ── Shows Approve+Reject when pending, badge otherwise ────────
            _buildStatusButton(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;
    var lightMode = Theme.of(context).brightness == Brightness.light;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final employeeController = Get.find<MainCoreEmployeeController>();
    final creatorEmployee =
    employeeController.getLocaleEmployee(createdByEmail);

    final String creatorName = creatorEmployee != null
        ? employeeController.getEmployeeName(createdByEmail)
        : 'Unknown User';

    final String creatorTitle = creatorEmployee != null
        ? employeeController.getEmployeeJobTitle(createdByEmail)
        : '-';

    final String creatorDepartment = creatorEmployee != null
        ? employeeController.getEmployeeDepartmentName(createdByEmail)
        : '-';

    final String creatorPhone = () {
      if (creatorEmployee?.mobilePhone == null) return '-';
      final phone = isArabic
          ? "${creatorEmployee?.mobilePhone?.phone} ${creatorEmployee?.mobilePhone?.countryCode}"
          : "${creatorEmployee?.mobilePhone?.countryCode} ${creatorEmployee?.mobilePhone?.phone}";
      if (phone.trim().isEmpty || phone == ' ') return '-';
      return phone.replaceAll(RegExp(r'[\[\]]'), '');
    }();

    final String creatorEmail = creatorEmployee?.email ?? createdByEmail;

    final String creatorPhoto = creatorEmployee != null
        ? employeeController.getEmployeePhoto(createdByEmail)
        : "assets/images/male.svg";

    final bool isNetworkPhoto = creatorPhoto.startsWith('http');

    final contentWidget = _buildContent(
      lightMode,
      isMobile,
      isArabic,
      creatorName,
      creatorTitle,
      creatorDepartment,
      creatorPhone,
      creatorEmail,
      creatorPhoto,
      isNetworkPhoto,
    );

    if (isMobile) {
      return Scaffold(
        body: SideFrameMaster(
          titleText: S.of(context).userManagement,
          onFirstTap: () => Navigator.of(context).pop(),
          secondTitle: S.of(context).requests,
          onSecondTap: () => Navigator.pop(context),
          thirdTitle: S.of(context).requestDetails,
          child: SingleChildScrollView(child: contentWidget),
        ),
      );
    }

    return SideFrameMasterServices(
      titleText: S.of(context).userManagement,
      onFirstTap: () => Navigator.of(context).pop(),
      secondTitle: S.of(context).requests,
      onSecondTap: () => Navigator.pop(context),
      thirdTitle: S.of(context).requestDetails,
      child: SingleChildScrollView(child: contentWidget),
    );
  }
}