/// ******************* FILE INFO *******************
/// File Name: upload_file_details.dart
/// Description: upload and edit data which come from bulk upload (Master variant).
///   uploadToFirebase now returns Map<String, String> (serviceName → docId)
///   so Step 2 can use the real Firestore document IDs for Parent_Service_Id.
/// Created by: Amr Mesbah
///
/// CHANGE LOG:
/// - uploadToFirebase() changed return type from Future<void> to Future<Map<String,String>>
/// - Returns serviceName → firestoreDocId map after uploading.
/// - onActivated callback signature updated to match new return type.

import 'dart:convert';
import 'dart:io';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/2-custom_textfield.dart';
import 'package:demo_app/core/custom/5-custom_button.dart' hide customButton;
import 'package:demo_app/core/custom/6_custom_button_with_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/ui/pages/data_upload_upload_file_details_toggle.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/custom/5-custom_button.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_helper_function.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/ui/pages/upload_file_toggle.dart';

class CustomCheckBox extends StatelessWidget {
  CustomCheckBox(
      {this.size, required this.isSelected, this.borderColor, super.key});
  bool isSelected = false;
  Color? borderColor;
  double? size;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 20.sp,
      height: size ?? 20.sp,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondaryPrimary : Colors.transparent,
        borderRadius: BorderRadius.circular(6.r),
        border: isSelected
            ? null
            : Border.all(color: borderColor ?? AppColors.grey, width: 1.5.sp),
      ),
      child: Center(
        child: Icon(Icons.check,
            size: (size ?? 20.sp) - 4.sp,
            color: isSelected ? AppColors.white : Colors.transparent),
      ),
    );
  }
}

class UploadFileDetailsTabletMaster extends StatefulWidget {
  const UploadFileDetailsTabletMaster({
    super.key,
    required this.formData,
    required this.validationErrors,
    this.selectedFileName,
    this.onActivated,
  });

  final List<Map<String, TextEditingController>> formData;
  final List<Map<String, String>> validationErrors;
  final String? selectedFileName;

  /// Called after the user confirms activation.
  /// In master flow: receives uploadToFirebase fn — MasterUploadScreen stores it,
  /// defers execution until Step 2 confirms.
  /// The fn now returns Map<String, String> (serviceName → firestoreDocId).
  final Future<void> Function(Future<Map<String, String>> Function() uploadFn)? onActivated;

  @override
  State<UploadFileDetailsTabletMaster> createState() =>
      _UploadFileDetailsTabletMasterState();
}

class _UploadFileDetailsTabletMasterState extends State<UploadFileDetailsTabletMaster> {
  List<Map<String, GlobalKey>> fieldKeys = [];
  final MainCoreEmployeeController employeeController = Get.find();

  final _formKey = GlobalKey<FormState>();
  List<Map<String, TextEditingController>> formData = [];
  List<Map<String, TextEditingController>> filteredData = [];
  List<Map<String, String>> validationErrors = [];
  Set<int> selectedRows = {};
  String primaryKey = 'Approvers';
  String searchQuery = '';
  String? selectedFileName;

  final List<String> expectedHeaders = [
    'Service Name',
    'اسم الخدمة',
    'Service Description',
    'وصف الخدمة',
    'Duration of Service',
    'Time Unit',
    'Service Provider',
    'Limit Service Availability',
    'Departments',
    'Requires Approvals',
    'Approvers',
  ];

  void ensureDisabledFieldsAreCleared() {
    for (int i = 0; i < formData.length; i++) {
      final requireApproval = formData[i]['Requires Approvals']?.text.trim().toLowerCase() ?? '';
      if (requireApproval == 'no') {
        formData[i]['Approvers']?.clear();
        validationErrors[i].remove('Approvers');
      }

      final limitAvailability = formData[i]['Limit Service Availability']?.text.trim().toLowerCase() ?? '';
      if (limitAvailability == 'no') {
        formData[i]['Departments']?.clear();
        validationErrors[i].remove('Departments');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    formData = widget.formData;
    validationErrors = widget.validationErrors;
    filteredData = List.from(widget.formData);
    selectedFileName = widget.selectedFileName;

    focusNodes = List.generate(formData.length, (i) {
      final map = <String, FocusNode>{};
      for (final key in formData[i].keys) {
        map[key] = FocusNode();
      }
      return map;
    });

    fieldKeys = List.generate(formData.length, (i) {
      final map = <String, GlobalKey>{};
      for (final key in formData[i].keys) {
        map[key] = GlobalKey();
      }
      return map;
    });

    ensureDisabledFieldsAreCleared();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateErrorLocations();
    });
  }

  int currentPage = 0;

  bool isValidEmail(String email) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
  bool isArabic(String text) => RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(text);
  bool isEnglish(String text) => RegExp(r'^[a-zA-Z\s]+$').hasMatch(text);
  bool hasSpecialChars(String text) =>
      RegExp(r'[!@#<>?":_~;[\]\\|=+)(*&^%0-9]').hasMatch(text);
  bool hasNumbers(String text) => RegExp(r'\d').hasMatch(text);
  bool hasNoSpaceBetweenWords(String text) => !text.trim().contains(' ');
  bool containsArabic(String text) => RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  bool containsEnglish(String text) => RegExp(r'[a-zA-Z]').hasMatch(text);

  bool validateHeaders(List<String> headers) {
    if (headers.length != expectedHeaders.length) return false;
    for (int i = 0; i < headers.length; i++) {
      if (headers[i].trim() != expectedHeaders[i].trim()) return false;
    }
    return true;
  }

  double getColumnWidth(int rowIndex, String header) {
    return validationErrors.length > rowIndex &&
        validationErrors[rowIndex].containsKey(header)
        ? 230
        : 250;
  }

  String? validateCell(
      BuildContext context,
      String key,
      String? value, {
        Map<String, TextEditingController>? rowData,
      }) {
    if (key == 'Approvers') {
      final requireApprovalCtrl = rowData?['Requires Approvals'];
      final requireApproval =
          requireApprovalCtrl?.text.trim().toLowerCase() ?? '';
      if (requireApproval == 'no') return null;
    }

    if (key == 'Departments') {
      final limitCtrl = rowData?['Limit Service Availability'];
      final limit = limitCtrl?.text.trim().toLowerCase() ?? '';
      if (limit == 'no') return null;
    }

    if (value == null || value.trim().isEmpty) {
      return S.of(context).required;
    }

    value = value.trim();

    if (value.toLowerCase() == 'null') {
      return S.of(context).cannotBeNull;
    }

    bool hasExtraSpaces(String val) => RegExp(r'\s{2,}').hasMatch(val);
    bool isArabic(String text) =>
        RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(text);
    bool isEnglish(String text) => RegExp(r'^[a-zA-Z\s]+$').hasMatch(text);
    bool hasSpecialChars(String text) =>
        RegExp(r'[!@#<>?":_~;\[\]\\|=+)(*&^%$0-9]').hasMatch(text);
    bool hasNumbers(String text) => RegExp(r'\d').hasMatch(text);
    bool containsArabic(String text) =>
        RegExp(r'[\u0600-\u06FF]').hasMatch(text);
    bool containsEnglish(String text) => RegExp(r'[a-zA-Z]').hasMatch(text);

    bool hasForbiddenCharsInDescription(String text) =>
        RegExp(r'[!<>?":_~;\[\]\\|=+)(*&^%]').hasMatch(text);

    if (['Service Name', 'اسم الخدمة', 'Service Description', 'وصف الخدمة']
        .contains(key)) {
      final currentValue = value.toLowerCase();
      int count = 0;
      for (var row in formData) {
        final otherValue = row[key]?.text.toLowerCase().trim();
        if (otherValue == currentValue) count++;
      }
      if (count > 1) {
        return S.of(context).duplicateValue;
      }
    }

    switch (key.trim()) {
      case 'Service Name':
        if (!isEnglish(value)) return S.of(context).englishOnly;
        if (containsArabic(value)) return S.of(context).arabicNotAllowed;
        if (hasSpecialChars(value)) return S.of(context).specialCharsNotAllowed;
        if (hasExtraSpaces(value)) return S.of(context).extraSpaces;
        break;

      case 'اسم الخدمة':
        if (!isArabic(value)) return S.of(context).arabicOnly;
        if (containsEnglish(value)) return S.of(context).englishNotAllowed;
        if (hasSpecialChars(value)) return S.of(context).specialCharsNotAllowed;
        if (hasExtraSpaces(value)) return S.of(context).extraSpaces;
        break;

      case 'Service Description':
        if (containsArabic(value)) return S.of(context).arabicNotAllowed;
        if (hasForbiddenCharsInDescription(value)) {
          return S.of(context).descriptionSpecialChars;
        }
        if (hasExtraSpaces(value)) return S.of(context).extraSpaces;
        break;

      case 'وصف الخدمة':
        if (containsEnglish(value)) return S.of(context).englishNotAllowed;
        if (hasForbiddenCharsInDescription(value)) {
          return S.of(context).descriptionSpecialChars;
        }
        if (hasExtraSpaces(value)) return S.of(context).extraSpaces;
        break;

      case 'Duration of Service':
        final parsed = int.tryParse(value);
        if (parsed == null) return S.of(context).mustBeNumber;
        if (parsed <= 0) return S.of(context).mustBeGreaterThanZero;
        if (parsed > 1000) return S.of(context).mustBeLessThanOrEqual;
        break;

      case 'Time Unit':
        if (hasNumbers(value)) return S.of(context).numbersNotAllowed;
        if (containsArabic(value)) return S.of(context).arabicNotAllowed;
        const allowed = ['Hours', 'Days', 'Seconds', 'Minutes'];
        if (!allowed.map((e) => e.toLowerCase()).contains(value.toLowerCase())) {
          return S.of(context).invalidTimeUnit;
        }
        break;

      case 'Service Provider':
        if (value.contains(':') ||
            value.contains(';') ||
            value.contains("'") ||
            value.contains('"') ||
            value.contains(' ')) {
          return S.of(context).emailsCommaSeparated;
        }
        if (value.startsWith(',') || value.endsWith(','))
          return S.of(context).commaAtStartOrEnd;
        if (value.contains(',,')) return S.of(context).doubleCommas;

        final emails = value.split(',').map((e) => e.trim()).toList();
        if (emails.toSet().length != emails.length) {
          return S.of(context).duplicateEmails;
        }
        for (final email in emails) {
          if (email.isEmpty) return S.of(context).emptyEmail;
          if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
            return S.of(context).invalidEmailFormat;
          }
          if (!employeeController.mapOfEmployeesWithEmailKey.containsKey(email)) {
            return S.of(context).emailDoesNotExist;
          }
        }
        break;

      case 'Approvers':
        final requireApprovalCtrl = rowData?['Requires Approvals'];
        final requireApproval =
            requireApprovalCtrl?.text.trim().toLowerCase() ?? '';
        if (requireApproval == 'no') return null;

        if (value.contains(':') ||
            value.contains(';') ||
            value.contains("'") ||
            value.contains('"') ||
            value.contains(' ')) {
          return S.of(context).emailsCommaSeparated;
        }
        if (value.startsWith(',') || value.endsWith(','))
          return S.of(context).commaAtStartOrEnd;
        if (value.contains(',,')) return S.of(context).doubleCommas;

        final apEmails = value.split(',').map((e) => e.trim()).toList();
        if (apEmails.toSet().length != apEmails.length) {
          return S.of(context).duplicateEmails;
        }
        for (final email in apEmails) {
          if (email.isEmpty) return S.of(context).emptyEmail;
          if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
            return S.of(context).invalidEmailFormat;
          }
          if (!employeeController.mapOfEmployeesWithEmailKey.containsKey(email)) {
            return S.of(context).emailDoesNotExist;
          }
        }
        break;

      case 'Limit Service Availability':
      case 'Requires Approvals':
        if (!['yes', 'no'].contains(value.toLowerCase())) {
          return S.of(context).invalidYesNo;
        }
        break;

      case 'Departments':
        final limitCtrl = rowData?['Limit Service Availability'];
        final limit = limitCtrl?.text.trim().toLowerCase() ?? '';

        if (limit == 'yes') {
          if (value.isEmpty) return S.of(context).departmentRequired;
          if (value.startsWith(',') || value.endsWith(','))
            return S.of(context).commaAtStartOrEnd;
          if (value.contains(',,')) return S.of(context).doubleCommas;
          if (RegExp(r'[!@#<>?":_~;\[\]\\|=+)(*&^%$]').hasMatch(value)) {
            return S.of(context).invalidDepartmentChars;
          }

          final departments = value.split(',').map((e) => e.trim()).toList();
          final controller = Get.find<MainCoreDepartmentController>();

          for (final dept in departments) {
            if (dept.isEmpty) return S.of(context).emptyDepartment;
            if (dept.length < 2) return S.of(context).departmentMinLength;
            if (controller.getDepartmentIdFromDepartmentName(
                departmentName: dept) == null) {
              return S.of(context).departmentDoesNotExist;
            }
          }
        }
        break;
    }

    return null;
  }

  bool isDepartmentDisabled(int rowIndex) {
    final limitCtrl = formData[rowIndex]['Limit Service Availability'];
    final limit = limitCtrl?.text.trim().toLowerCase() ?? '';
    return limit == 'no';
  }

  bool isApproversDisabled(int rowIndex) {
    final requireApprovalCtrl = formData[rowIndex]['Requires Approvals'];
    final requireApproval =
        requireApprovalCtrl?.text.trim().toLowerCase() ?? '';
    return requireApproval == 'no';
  }

  Future<void> pickAndParseExcel() async {
    await requestStoragePermission();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      selectedFileName = file.path.split('/').last;
      setState(() {});
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      List<Map<String, TextEditingController>> parsedFormData = [];
      List<Map<String, String>> parsedValidationErrors = [];

      for (var table in excel.tables.keys) {
        var rows = excel.tables[table]!.rows;
        if (rows.length < 2) continue;

        List<String> actualHeaders =
        rows[0].map((e) => e?.value.toString().trim() ?? '').toList();
        List<String> missingHeaders =
        expectedHeaders.where((h) => !actualHeaders.contains(h)).toList();
        List<String> unknownHeaders =
        actualHeaders.where((h) => !expectedHeaders.contains(h)).toList();

        if (missingHeaders.length >= 5) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(S.of(context).headerMismatch),
              content: Text(
                "${S.of(context).excelNotAccepted}\n\n${S.of(context).missingColumns}: ${missingHeaders.join(', ')}\n${S.of(context).unknownColumns}: ${unknownHeaders.join(', ')}",
              ),
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
          return;
        }

        for (int i = 1; i < rows.length; i++) {
          Map<String, TextEditingController> rowControllers = {};
          Map<String, String> rowErrors = {};

          for (final header in expectedHeaders) {
            if (actualHeaders.contains(header)) {
              int colIndex = actualHeaders.indexOf(header);
              String value = rows[i][colIndex]?.value.toString() ?? '';
              rowControllers[header] = TextEditingController(text: value);
              String? error =
              validateCell(context, header, value, rowData: rowControllers);
              if (error != null) rowErrors[header] = error;
            } else {
              rowControllers[header] = TextEditingController(text: '');
              rowErrors[header] = S.of(context).missingColumns;
            }
          }

          parsedFormData.add(rowControllers);
          parsedValidationErrors.add(rowErrors);
        }
      }

      navigateTo(
        context,
        ToggleUploadFileDetails(
          formData: parsedFormData,
          validationErrors: parsedValidationErrors,
          selectedFileName: selectedFileName,
        ),
      );
    }
  }

  final ScrollController _scrollController = ScrollController();

  // ─── Enrich a comma-separated email string into full employee objects ────────
  // Extracted as a STATE method (not a local function) so it always uses
  // the class-level employeeController that is populated during initState.
  List<Map<String, dynamic>> _enrichEmailListStep1(String emails) {
    if (emails.trim().isEmpty) return [];

    final deptController = Get.find<MainCoreDepartmentController>();

    return emails
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((email) {
      // Always use the class-level employeeController — same instance
      // used by validation which confirms these emails exist.
      final emp = employeeController.mapOfEmployeesWithEmailKey[email];

      return {
        'email': emp?.email ?? email,
        'firstName': emp?.firstName ?? '',
        'lastName': emp?.lastName ?? '',
        'firstNameInArabic': emp?.firstNameInArabic ?? '',
        'lastNameInArabic': emp?.lastNameInArabic ?? '',
        'middleName': emp?.middleName ?? '',
        'middleNameInArabic': emp?.middleNameInArabic ?? '',
        'title': emp?.title ?? '',
        'titleInArabic': emp?.titleInArabic ?? '',
        'departmentId': emp?.departmentId ?? '',
        'departmentNameEnglish': emp?.departmentId != null && emp!.departmentId!.isNotEmpty
            ? (deptController.getEnglishDepartmentNameFromDepartmentId(
            departmentId: emp.departmentId!) ??
            '')
            : '',
        'departmentNameArabic': emp?.departmentId != null && emp!.departmentId!.isNotEmpty
            ? (deptController.getArabicDepartmentNameFromDepartmentId(
            departmentId: emp.departmentId!) ??
            '')
            : '',
        'photo': emp?.photo ?? '',
        'gender': emp?.gender ?? '',
        'role': emp?.role ?? '',
        'state': 'pending',
        'id': emp?.id ?? '',
        'mobilePhone': {
          'phone': emp?.mobilePhone?.phone ?? '',
          'countryCode': emp?.mobilePhone?.countryCode ?? '',
          'countryApp': emp?.mobilePhone?.countryApp ?? '',
        },
      };
    }).toList();
  }

  //
  // ─── Upload to Firebase ──────────────────────────────────────────────────
  // Returns Map<String, String> (serviceName → firestoreDocId)
  // so Step 2 can set Parent_Service_Id and id to the real Firestore doc ID.
  // FIX: enrichEmailList moved OUT of the for-loop as _enrichEmailListStep1()
  //      so it always uses the class-level employeeController instance.
  Future<Map<String, String>> uploadToFirebase() async {
    // Ensure employee data is loaded before enriching
    if (employeeController.mapOfEmployeesWithEmailKey.isEmpty) {
      await employeeController.getAllNewEmployees();
    }

    // getBaseUrl already resolves the correct Demo/{companyId}/CreateServices path
    final createServicesCollection = FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.createServices));

    final Map<String, String> serviceNameToDocId = {};
    int success = 0, updated = 0, failed = 0, deleted = 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    // ── Load existing docs to detect updates vs creates ──────────────────────
    var existingDocs = await createServicesCollection
        .where("Email_Requester", arrayContains: employeeFunctionHelper.email)
        .get();

    Map<String, String> firebaseItems = {};
    for (var doc in existingDocs.docs) {
      final data = doc.data();
      String key = '';
      if (data['Service_Name_English'] is List) {
        final list = data['Service_Name_English'] as List;
        if (list.isNotEmpty) key = list.last.toString();
      } else if (data['Service_Name_English'] is String) {
        key = data['Service_Name_English'].toString();
      }
      if (key.isNotEmpty) firebaseItems[key] = doc.id;
    }

    Set<String> localKeys = formData
        .map((row) => row['Service Name']?.text.trim() ?? '')
        .where((key) => key.isNotEmpty)
        .toSet();

    for (var row in formData) {
      String serviceNameEnglish = '';
      String serviceNameArabic = '';
      String serviceDescriptionEnglish = '';
      String serviceDescriptionArabic = '';
      String durationOfServices = '';
      String selectedDurationUnit = '';
      List<Map<String, dynamic>> providerServicesList = [];
      String assignedProviderEmail = '';
      List<Map<String, dynamic>> approvalCycleList = [];
      bool limitAvailability = false;
      bool requireApproval = false;
      List<String> selectDepartment = [];

      row.forEach((key, controller) {
        final value = controller.text.trim();
        switch (key) {
          case 'Service Name':
            serviceNameEnglish = value;
            break;
          case 'اسم الخدمة':
            serviceNameArabic = value;
            break;
          case 'Service Description':
            serviceDescriptionEnglish = value;
            break;
          case 'وصف الخدمة':
            serviceDescriptionArabic = value;
            break;
          case 'Duration of Service':
            durationOfServices = value;
            break;
          case 'Time Unit':
            selectedDurationUnit = value;
            break;
          case 'Service Provider':
          // assignedProviderEmail will be overwritten by __enriched_providers__.
            if (assignedProviderEmail.isEmpty) {
              assignedProviderEmail = value.split(',').first.trim();
            }
            break;
          case 'Approvers':
          // Enrichment comes from __enriched_approvers__ set at parse time.
            break;
          case 'Requires Approvals':
            requireApproval = value.toLowerCase() == 'yes';
            break;
          case 'Limit Service Availability':
            limitAvailability = value.toLowerCase() == 'yes';
            break;
          case 'Departments':
            selectDepartment = value
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
            break;
        // Pre-enriched JSON stored by MasterUploadScreen at parse time.
        // Guaranteed full employee data because enrichment runs while
        // mapOfEmployeesWithEmailKey is populated on the master screen.
          case '__enriched_providers__':
            if (value.isNotEmpty && value != '[]') {
              try {
                final decoded = jsonDecode(value) as List<dynamic>;
                final cached = decoded.cast<Map<String, dynamic>>();

                // Check if enrichment actually worked (firstName not empty)
                if (cached.isNotEmpty && cached[0]['firstName'].toString().isNotEmpty) {
                  providerServicesList = cached;
                } else {
                  // Fallback: re-enrich at upload time when map is populated
                  final rawEmail = row['Service Provider']?.text.trim() ?? '';
                  providerServicesList = _enrichEmailListStep1(rawEmail);
                }

                if (providerServicesList.isNotEmpty) {
                  assignedProviderEmail = providerServicesList[0]['email']?.toString() ?? '';
                }
              } catch (e) {
              }
            }
            break;

          case '__enriched_approvers__':
            if (value.isNotEmpty && value != '[]') {
              try {
                final decoded = jsonDecode(value) as List<dynamic>;
                final cached = decoded.cast<Map<String, dynamic>>();

                // Check if enrichment actually worked
                if (cached.isNotEmpty && cached[0]['firstName'].toString().isNotEmpty) {
                  approvalCycleList = cached;
                } else {
                  // Fallback: re-enrich at upload time
                  final rawEmail = row['Approvers']?.text.trim() ?? '';
                  approvalCycleList = _enrichEmailListStep1(rawEmail);
                }
              } catch (e) {
              }
            }
            break;
        }
      });

      final keyValue = serviceNameEnglish;
      if (keyValue.isEmpty) {
        failed++;
        continue;
      }

      try {
        String docId;

        if (firebaseItems.containsKey(keyValue)) {
          // ── UPDATE: reuse existing doc ID ───────────────────────────────────
          docId = firebaseItems[keyValue]!;
          await createServicesCollection.doc(docId).update(_buildServiceData(
            docId: docId,
            now: now,
            serviceNameEnglish: serviceNameEnglish,
            serviceNameArabic: serviceNameArabic,
            serviceDescriptionEnglish: serviceDescriptionEnglish,
            serviceDescriptionArabic: serviceDescriptionArabic,
            durationOfServices: durationOfServices,
            selectedDurationUnit: selectedDurationUnit,
            assignedProviderEmail: assignedProviderEmail,
            providerServicesList: providerServicesList,
            approvalCycleList: approvalCycleList,
            limitAvailability: limitAvailability,
            requireApproval: requireApproval,
            selectDepartment: selectDepartment,
          ));
          serviceNameToDocId[keyValue] = docId;
          updated++;
        } else {
          // ── CREATE: pre-generate docRef so id = docId ───────────────────────
          final docRef = createServicesCollection.doc();
          docId = docRef.id;
          await docRef.set(_buildServiceData(
            docId: docId,
            now: now,
            serviceNameEnglish: serviceNameEnglish,
            serviceNameArabic: serviceNameArabic,
            serviceDescriptionEnglish: serviceDescriptionEnglish,
            serviceDescriptionArabic: serviceDescriptionArabic,
            durationOfServices: durationOfServices,
            selectedDurationUnit: selectedDurationUnit,
            assignedProviderEmail: assignedProviderEmail,
            providerServicesList: providerServicesList,
            approvalCycleList: approvalCycleList,
            limitAvailability: limitAvailability,
            requireApproval: requireApproval,
            selectDepartment: selectDepartment,
          ));
          serviceNameToDocId[keyValue] = docId;
          success++;
        }
      } catch (e) {
        failed++;
      }
    }

    // ── Delete services removed from local data ───────────────────────────────
    for (var entry in firebaseItems.entries) {
      if (!localKeys.contains(entry.key)) {
        try {
          await createServicesCollection.doc(entry.value).delete();
          deleted++;
        } catch (e) {
        }
      }
    }

    return serviceNameToDocId;
  }

  // ─── Helper: build service document data ────────────────────────────────
  // docId is pre-generated before writing so 'id' and 'Parent_Service_Id'
  // always contain the real Firestore document ID.
  Map<String, dynamic> _buildServiceData({
    required String docId,
    required int now,
    required String serviceNameEnglish,
    required String serviceNameArabic,
    required String serviceDescriptionEnglish,
    required String serviceDescriptionArabic,
    required String durationOfServices,
    required String selectedDurationUnit,
    required String assignedProviderEmail,
    required List<Map<String, dynamic>> providerServicesList,
    required List<Map<String, dynamic>> approvalCycleList,
    required bool limitAvailability,
    required bool requireApproval,
    required List<String> selectDepartment,
  }) {
    return {
      'timestamps': [now],
      'id': [docId],                // ← real Firestore doc ID
      'state': ['active'],
      'status': ['active'],
      'Parent_Service_Id': [docId], // ← real Firestore doc ID

      'First_Name_Requester': [employeeFunctionHelper.firstName],
      'Last_Name_Requester': [employeeFunctionHelper.lastName],
      'Department_Requester': [employeeFunctionHelper.departmentId ?? ''],
      'Job_Title_Requester': [employeeFunctionHelper.title ?? ''],
      'Email_Requester': [employeeFunctionHelper.email],
      'Phone_Requester': [employeeFunctionHelper.mobilePhone?.phone ?? ''],
      'Gender_Requester': [employeeFunctionHelper.gender ?? ''],
      'Assigned_Provider_Email': [assignedProviderEmail],

      'First_Name_Requester_Arabic': [employeeFunctionHelper.firstNameInArabic ?? ''],
      'Last_Name_Requester_Arabic': [employeeFunctionHelper.lastNameInArabic ?? ''],
      'Job_Title_Requester_Arabic': [employeeFunctionHelper.titleInArabic ?? ''],
      'Department_Requester_Arabic': [''],

      'Service_Name_English': [serviceNameEnglish],
      'Service_Name_Arabic': [serviceNameArabic],
      'Service_Description_English': [serviceDescriptionEnglish],
      'Service_Description_Arabic': [serviceDescriptionArabic],
      'Duration_Of_Services': [durationOfServices],
      'Selected_Duration_Unit': [selectedDurationUnit],
      'Duration_Of_Services_Timestamp': [Timestamp.now()],
      'Image_Url': [''],

      'Provider_Services': [jsonEncode(providerServicesList)],
      'Limit_Availability': [limitAvailability],
      'Require_Approval': [requireApproval],
      'Select_Department': [jsonEncode(selectDepartment)],
      'Approval_Cycle': [jsonEncode(approvalCycleList)],

      'Sla_One_Controller_English': [''],
      'Sla_Two_Controller_English': [''],
      'Notify_Requester_Checked': [false],
      'Notify_Provider_Checked': [false],
      'Notify_Manager_Checked': [false],
      'Notify_Requester_Switch0': [false],
      'Notify_Manager_Switch1': [false],
    };
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) return true;
      final status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    } else {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  void filterData(String query) {
    setState(() {
      searchQuery = query;
      filteredData = query.isEmpty
          ? List.from(formData)
          : formData.where((row) {
        return row.entries.any((entry) =>
            entry.value.text.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    });
  }

  void saveLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> simpleData = formData.map((row) {
      return row.map((key, controller) => MapEntry(key, controller.text));
    }).toList();
    prefs.setString('saved_excel_data', jsonEncode(simpleData));
  }

  void loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('saved_excel_data');
    if (data != null) {
      List decoded = jsonDecode(data);
      List<Map<String, TextEditingController>> loaded = decoded.map((row) {
        return Map<String, TextEditingController>.fromEntries(
          (row as Map).entries.map(
                  (e) => MapEntry(e.key, TextEditingController(text: e.value))),
        );
      }).toList();
      setState(() {
        formData = loaded;
        filteredData = List.from(formData);
      });
    }
  }

  void addEmptyRow() {
    Map<String, TextEditingController> newRow = {};
    for (var header in expectedHeaders) {
      newRow[header] = TextEditingController();
    }
    setState(() {
      formData.add(newRow);
      filteredData = List.from(formData);
    });
  }

  void deleteRow(int index) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).confirmDeletion),
        content: Text(S.of(context).areYouSureDeleteRow),
        actions: [
          customButton(
            title: S.of(context).cancel,
            function: () => Navigator.pop(context, false),
            width: 90.sp,
            height: 36.sp,
            color: AppColors.card,
            textColor: AppColors.text,
          ),
          customButton(
            title: S.of(context).delete,
            function: () => Navigator.pop(context, true),
            width: 90.sp,
            height: 36.sp,
            color: AppColors.primary,
            textColor: AppColors.textButton,
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() {
        formData.removeAt(index);
        validationErrors.removeAt(index);
        filteredData = List.from(formData);
      });
    }
  }

  int getTotalErrorCount() {
    int totalErrors = 0;
    for (final row in validationErrors) {
      totalErrors += row.length;
    }
    return totalErrors;
  }

  List<Map<String, FocusNode>> focusNodes = [];
  List<MapEntry<int, String>> errorLocations = [];
  int currentErrorIndex = -1;

  void updateErrorLocations() {
    errorLocations.clear();
    for (int row = 0; row < validationErrors.length; row++) {
      validationErrors[row].forEach((header, error) {
        errorLocations.add(MapEntry(row, header));
      });
    }

    if (errorLocations.isEmpty) {
      currentErrorIndex = -1;
    } else if (currentErrorIndex >= errorLocations.length ||
        currentErrorIndex < 0) {
      currentErrorIndex = 0;
    }
  }

  void focusErrorField(bool forward) {
    if (errorLocations.isEmpty) return;

    setState(() {
      if (forward) {
        currentErrorIndex = (currentErrorIndex + 1) % errorLocations.length;
      } else {
        currentErrorIndex = (currentErrorIndex - 1 + errorLocations.length) %
            errorLocations.length;
      }
    });

    final entry = errorLocations[currentErrorIndex];
    final rowIndex = entry.key;
    final header = entry.value;

    final controller = formData[rowIndex][header];
    final node = focusNodes[rowIndex][header];
    final key = fieldKeys[rowIndex][header];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        final contextToScroll = key?.currentContext;
        if (contextToScroll != null) {
          Scrollable.ensureVisible(
            contextToScroll,
            duration: const Duration(milliseconds: 500),
            alignment: 0.3,
            curve: Curves.easeInOut,
          ).then((_) {
            if (controller != null && node != null) {
              controller.selection = TextSelection(
                  baseOffset: 0, extentOffset: controller.text.length);
              FocusScope.of(context).requestFocus(node);
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return SideFrameMasterServices(
      titleText: S.of(context).service,
      onFirstTap: () {
        navigateTo(context, ToggleUploadFile());
      },
      secondTitle: S.of(context).bulkUpload,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    selectedFileName ?? S.of(context).noFileSelected,
                    style: AppTextStyles.font23BlackRegularCairo
                        .copyWith(color: AppColors.text),
                  ),
                ],
              ),
              SizedBox(height: 23.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 30.sp,
                    width: 138.sp,
                    decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(4.r)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (errorLocations.isEmpty) updateErrorLocations();
                            if (errorLocations.isNotEmpty) {
                              focusErrorField(false);
                              setState(() {});
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.sp),
                            child: SvgPicture.asset(
                              isArabic
                                  ? "assets/arrow_right.svg"
                                  : "assets/arrowleft.svg",
                              width: 15.sp,
                              height: 15.sp,
                              color: errorLocations.isEmpty
                                  ? AppColors.grey
                                  : (lightMode
                                  ? AppColors.blackButton
                                  : AppColors.whiteShadow),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 9.sp),
                        Text(
                          "${S.of(context).error}: ",
                          style: AppTextStyles.font16BlackMediumCairo.copyWith(
                            color: lightMode
                                ? AppColors.blackButton
                                : AppColors.white,
                          ),
                        ),
                        Text(
                          getTotalErrorCount() > 0
                              ? "${currentErrorIndex + 1}/${getTotalErrorCount()}"
                              : "${getTotalErrorCount()}",
                          style: AppTextStyles.font16BlackMediumCairo.copyWith(
                            color: AppColors.red,
                          ),
                        ),
                        SizedBox(width: 9.sp),
                        GestureDetector(
                          onTap: () {
                            if (errorLocations.isEmpty) updateErrorLocations();
                            if (errorLocations.isNotEmpty) {
                              focusErrorField(true);
                              setState(() {});
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.sp),
                            child: SvgPicture.asset(
                              isArabic
                                  ? "assets/arrowleft.svg"
                                  : "assets/arrow_right.svg",
                              width: 15.sp,
                              height: 15.sp,
                              color: errorLocations.isEmpty
                                  ? AppColors.grey
                                  : (lightMode
                                  ? AppColors.blackButton
                                  : AppColors.whiteShadow),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  customButtonWithSvg(
                      title: S.of(context).removeSelection,
                      function: () {
                        if (selectedRows.isEmpty) return;
                        setState(() {
                          final sortedRows = selectedRows.toList()
                            ..sort((a, b) => b.compareTo(a));
                          for (final index in sortedRows) {
                            formData.removeAt(index);
                            validationErrors.removeAt(index);
                            focusNodes.removeAt(index);
                            fieldKeys.removeAt(index);
                          }
                          selectedRows.clear();
                          filteredData = List.from(formData);
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => updateErrorLocations());
                        });
                      },
                      textStyle: AppTextStyles.font16BlackMediumCairo
                          .copyWith(color: AppColors.white),
                      width: 166.sp,
                      height: 30.sp,
                      space: 8.sp,
                      radius: 4.r,
                      color: AppColors.black,
                      image: "assets/minus.svg",
                      svgColor: AppColors.white,
                      widthImage: 12.sp,
                      heightImage: 1.5.sp,
                      colorBorder: Colors.transparent),
                  SizedBox(width: 10.sp),
                  customButton(
                      title: S.of(context).duplication,
                      function: () {
                        if (selectedRows.length != 1) return;

                        final indexToDuplicate = selectedRows.first;
                        final original = formData[indexToDuplicate];

                        final newRow = <String, TextEditingController>{};
                        for (final entry in original.entries) {
                          newRow[entry.key] =
                              TextEditingController(text: entry.value.text);
                        }

                        final newFocusMap = <String, FocusNode>{};
                        final newKeyMap = <String, GlobalKey>{};
                        for (final key in expectedHeaders) {
                          newFocusMap[key] = FocusNode();
                          newKeyMap[key] = GlobalKey();
                        }

                        setState(() {
                          formData.add(newRow);
                          focusNodes.add(newFocusMap);
                          fieldKeys.add(newKeyMap);
                          validationErrors.add({});
                          filteredData = List.from(formData);

                          int newIndex = formData.length - 1;

                          final requireApproval = formData[newIndex]
                          ['Requires Approvals']
                              ?.text
                              .trim()
                              .toLowerCase() ??
                              '';
                          if (requireApproval == 'no') {
                            formData[newIndex]['Approvers']?.clear();
                          }

                          final limitAvailability = formData[newIndex]
                          ['Limit Service Availability']
                              ?.text
                              .trim()
                              .toLowerCase() ??
                              '';
                          if (limitAvailability == 'no') {
                            formData[newIndex]['Departments']?.clear();
                          }

                          final newRowData = formData[newIndex];
                          final newErrorMap = <String, String>{};
                          for (final header in expectedHeaders) {
                            final value = newRowData[header]?.text ?? '';
                            final error = validateCell(context, header, value,
                                rowData: newRowData);
                            if (error != null) newErrorMap[header] = error;
                          }
                          validationErrors[newIndex] = newErrorMap;

                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => updateErrorLocations());
                        });
                      },
                      textStyle: AppTextStyles.font16BlackMediumCairo
                          .copyWith(color: AppColors.white),
                      width: 103.sp,
                      height: 30.sp,
                      radius: 4.r,
                      color: AppColors.black),
                  SizedBox(width: 10.sp),
                  customButtonWithSvg(
                      title: S.of(context).row,
                      function: () {
                        Map<String, TextEditingController> newRow = {};
                        Map<String, FocusNode> newFocusMap = {};
                        Map<String, GlobalKey> newKeyMap = {};

                        for (var header in expectedHeaders) {
                          newRow[header] = TextEditingController();
                          newFocusMap[header] = FocusNode();
                          newKeyMap[header] = GlobalKey();
                        }

                        setState(() {
                          formData.add(newRow);
                          validationErrors.add({});
                          focusNodes.add(newFocusMap);
                          fieldKeys.add(newKeyMap);
                          filteredData = List.from(formData);
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => updateErrorLocations());
                        });
                      },
                      textStyle: AppTextStyles.font16BlackMediumCairo
                          .copyWith(color: AppColors.white),
                      width: 82.sp,
                      height: 30.sp,
                      space: 8.sp,
                      radius: 4.r,
                      color: AppColors.black,
                      image: "assets/plus.svg",
                      svgColor: AppColors.white,
                      widthImage: 12.sp,
                      heightImage: 12.sp,
                      colorBorder: Colors.transparent),
                ],
              ),
              SizedBox(height: 10.sp),
              if (formData.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: (expectedHeaders.length * 265) + 90,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10.sp, top: 10.sp, right: 10),
                              child: Container(
                                width: 124.sp,
                                height: 25.sp,
                                decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(4.r)),
                                child: Center(
                                  child: Text(
                                    "${S.of(context).totalServices}: ${formData.length}",
                                    style: AppTextStyles.font14BlackCairoMedium
                                        .copyWith(color: AppColors.text),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.sp),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                height: 400.sp,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: formData.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 33.sp),
                                        child: Row(
                                          children: [
                                            ...expectedHeaders.map((header) {
                                              final isMixedLang =
                                                  RegExp(r'[a-zA-Z]')
                                                      .hasMatch(header) &&
                                                      RegExp(r'[\u0600-\u06FF]')
                                                          .hasMatch(header);
                                              final isArabicHeader =
                                              RegExp(r'[\u0600-\u06FF]')
                                                  .hasMatch(header);

                                              String arabicPart = '';
                                              String englishPart = '';

                                              if (isMixedLang) {
                                                arabicPart = header
                                                    .replaceAll(
                                                    RegExp(r'[a-zA-Z0-9]'),
                                                    '')
                                                    .trim();
                                                englishPart = header
                                                    .replaceAll(
                                                    RegExp(r'[^\x00-\x7F]'),
                                                    '')
                                                    .trim();
                                              }

                                              return Container(
                                                width: 250,
                                                margin: const EdgeInsets.only(
                                                    right: 12),
                                                alignment: isArabicHeader
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                                child: isMixedLang
                                                    ? Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Text(arabicPart,
                                                        textAlign: TextAlign.right,
                                                        style: AppTextStyles.font16BlackMediumCairo.copyWith(color: AppColors.text)),
                                                    const SizedBox(width: 6),
                                                    Text(englishPart,
                                                        textAlign: TextAlign.left,
                                                        style: AppTextStyles.font16BlackMediumCairo.copyWith(color: AppColors.text)),
                                                  ],
                                                )
                                                    : Text(
                                                  header,
                                                  textAlign: isArabicHeader
                                                      ? TextAlign.right
                                                      : TextAlign.left,
                                                  style: AppTextStyles.font16BlackMediumCairo
                                                      .copyWith(color: AppColors.text),
                                                ),
                                              );
                                            }).toList(),
                                          ],
                                        ),
                                      );
                                    }

                                    final rowIndex = index - 1;
                                    final row = formData[rowIndex];
                                    final isSelected =
                                    selectedRows.contains(rowIndex);

                                    return Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.sp,
                                          bottom: 10.sp,
                                          right: 12.sp,
                                          left: 0.sp),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (isSelected) {
                                                  selectedRows.remove(rowIndex);
                                                } else {
                                                  selectedRows.add(rowIndex);
                                                }
                                              });
                                            },
                                            child: CustomCheckBox(
                                              isSelected: isSelected,
                                              size: 24.sp,
                                              borderColor: lightMode
                                                  ? AppColors.grey
                                                  : AppColors.grey,
                                            ),
                                          ),
                                          SizedBox(width: 10.sp),
                                          ...expectedHeaders.map((header) {
                                            bool isDisabled = false;
                                            if (header == 'Departments') {
                                              isDisabled =
                                                  isDepartmentDisabled(rowIndex);
                                            } else if (header == 'Approvers') {
                                              isDisabled =
                                                  isApproversDisabled(rowIndex);
                                            }

                                            return Padding(
                                                padding: const EdgeInsets.only(right: 12),
                                                child: KeyedSubtree(
                                                  key: fieldKeys[rowIndex][header],
                                                  child: CustomExcelTextField(
                                                    controller: row[header]!,
                                                    focusNode: focusNodes[rowIndex][header],
                                                    placeholder: isDisabled
                                                        ? S.of(context).disabled
                                                        : header,
                                                    width: 250,
                                                    height: 36,
                                                    showHeader: false,
                                                    headerLabel: '',
                                                    errorText: validationErrors.length > rowIndex
                                                        ? validationErrors[rowIndex][header]
                                                        : null,
                                                    rowIndex: rowIndex,
                                                    isDisabled: isDisabled,
                                                    validator: (key, index) {
                                                      if (key == 'Requires Approvals') {
                                                        final value = formData[index][key]?.text ?? '';
                                                        if (value.trim().toLowerCase() == 'no') {
                                                          formData[index]['Approvers']?.clear();
                                                          validationErrors[index].remove('Approvers');
                                                        } else {
                                                          final approverValue = formData[index]['Approvers']?.text ?? '';
                                                          final approverError = validateCell(context, 'Approvers', approverValue, rowData: formData[index]);
                                                          if (approverError != null) {
                                                            validationErrors[index]['Approvers'] = approverError;
                                                          } else {
                                                            validationErrors[index].remove('Approvers');
                                                          }
                                                        }
                                                        final error = validateCell(context, key, value, rowData: formData[index]);
                                                        if (error != null) {
                                                          validationErrors[index][key] = error;
                                                        } else {
                                                          validationErrors[index].remove(key);
                                                        }
                                                      } else if (key == 'Limit Service Availability') {
                                                        final value = formData[index][key]?.text ?? '';
                                                        if (value.trim().toLowerCase() == 'no') {
                                                          formData[index]['Departments']?.clear();
                                                          validationErrors[index].remove('Departments');
                                                        } else {
                                                          final deptValue = formData[index]['Departments']?.text ?? '';
                                                          final deptError = validateCell(context, 'Departments', deptValue, rowData: formData[index]);
                                                          if (deptError != null) {
                                                            validationErrors[index]['Departments'] = deptError;
                                                          } else {
                                                            validationErrors[index].remove('Departments');
                                                          }
                                                        }
                                                        final error = validateCell(context, key, value, rowData: formData[index]);
                                                        if (error != null) {
                                                          validationErrors[index][key] = error;
                                                        } else {
                                                          validationErrors[index].remove(key);
                                                        }
                                                      } else {
                                                        final value = formData[index][key]?.text ?? '';
                                                        final error = validateCell(context, key, value, rowData: formData[index]);
                                                        if (error != null) {
                                                          validationErrors[index][key] = error;
                                                        } else {
                                                          validationErrors[index].remove(key);
                                                        }
                                                      }

                                                      setState(() {
                                                        WidgetsBinding.instance.addPostFrameCallback((_) => updateErrorLocations());
                                                      });
                                                    },
                                                  ),
                                                ));
                                          }).toList(),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 20.sp),
              Row(
                children: [
                  customButton(
                      title: S.of(context).discard,
                      function: () {},
                      textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                          color: lightMode ? AppColors.black : AppColors.white),
                      width: 150.sp,
                      height: 38.sp,
                      radius: 8.r,
                      color: lightMode ? AppColors.grey : AppColors.mediumGrey),
                  Spacer(),
                  customButton(
                    title: S.of(context).activate,
                    function: () {
                      final parentContext = context;

                      if (getTotalErrorCount() > 0) {
                        showDialog(
                          context: parentContext,
                          barrierDismissible: true,
                          builder: (errorDialogContext) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r)),
                            contentPadding: EdgeInsets.all(20.sp),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Lottie.asset('assets/lottie/rejected.json',
                                    width: 90.sp, height: 90.sp, fit: BoxFit.contain),
                                SizedBox(height: 20.sp),
                                Text(
                                  S.of(errorDialogContext).mustCorrectErrors,
                                  style: AppTextStyles.font18BlackMediumCairo
                                      .copyWith(color: AppColors.secondaryText),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                        return;
                      }

                      showDialog(
                        context: parentContext,
                        barrierDismissible: true,
                        builder: (confirmDialogContext) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r)),
                          contentPadding: EdgeInsets.all(20.sp),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Lottie.asset('assets/lottie/createServices.json',
                                  width: 90.sp, height: 90.sp, fit: BoxFit.contain),
                              SizedBox(height: 15.sp),
                              Text(
                                S.of(confirmDialogContext).activatingService,
                                style: AppTextStyles.font20BlackCairoMedium
                                    .copyWith(color: AppColors.secondaryText),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 18.sp),
                              Text(
                                S.of(confirmDialogContext).areYouSureActivate,
                                style: AppTextStyles.font18BlackMediumCairo
                                    .copyWith(color: AppColors.secondaryText),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 15.sp),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  customButton(
                                      title: S.of(confirmDialogContext).no,
                                      function: () => Navigator.pop(confirmDialogContext),
                                      textStyle: AppTextStyles.font18BlackMediumCairo.copyWith(
                                          color: lightMode ? AppColors.black : AppColors.white),
                                      width: 135.sp,
                                      height: 38.sp,
                                      radius: 4.r,
                                      color: lightMode ? AppColors.grey : AppColors.mediumGrey),
                                  SizedBox(width: 28.sp),
                                  customButton(
                                      title: S.of(confirmDialogContext).yes,
                                      function: () async {
                                        Navigator.pop(confirmDialogContext);
                                        if (!mounted) return;

                                        try {
                                          if (widget.onActivated != null) {
                                            // ── Master flow: pass uploadToFirebase fn to parent.
                                            // Parent (MasterUploadScreen) stores it and calls it
                                            // together with Step 2 when user confirms Step 2.
                                            await widget.onActivated!(uploadToFirebase);
                                          } else {
                                            // ── Standalone flow: upload directly (ignore return).
                                            await uploadToFirebase();
                                          }
                                        } catch (e) {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(parentContext).showSnackBar(
                                            SnackBar(content: Text('Upload failed: $e')),
                                          );
                                          return;
                                        }

                                        if (!mounted) return;

                                        // Only refresh + show success in standalone mode.
                                        // In master mode the parent handles the success dialog
                                        // after Step 2 finishes.
                                        if (widget.onActivated == null) {
                                          try {
                                            final cubit = ServicesManagerCubit.get(parentContext);
                                            await cubit.getAllServices();
                                            await cubit.getAllRequestServices();
                                          } catch (e) {
                                          }

                                          showDialog(
                                            context: parentContext,
                                            barrierDismissible: false,
                                            builder: (successDialogContext) {
                                              Future.delayed(Duration(seconds: 2), () {
                                                if (Navigator.canPop(successDialogContext)) {
                                                  Navigator.pop(successDialogContext);
                                                  if (Navigator.canPop(parentContext)) {
                                                    Navigator.pop(parentContext);
                                                    Future.delayed(Duration(milliseconds: 100), () {
                                                      if (Navigator.canPop(parentContext)) {
                                                        Navigator.pop(parentContext);
                                                      }
                                                    });
                                                  }
                                                }
                                              });

                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12.r)),
                                                contentPadding: EdgeInsets.all(20.sp),
                                                content: Container(
                                                  width: 400.sp,
                                                  height: 180.sp,
                                                  child: Column(
                                                    children: [
                                                      Lottie.asset('assets/lottie/approved.json',
                                                          width: 90.sp, height: 90.sp, fit: BoxFit.contain),
                                                      SizedBox(height: 15.sp),
                                                      Text(S.of(successDialogContext).activated,
                                                          style: AppTextStyles.font20BlackCairoMedium
                                                              .copyWith(color: AppColors.secondaryText),
                                                          textAlign: TextAlign.center),
                                                      SizedBox(height: 18.sp),
                                                      Text(S.of(successDialogContext).successfullyActivated,
                                                          style: AppTextStyles.font18BlackMediumCairo
                                                              .copyWith(color: AppColors.secondaryText),
                                                          textAlign: TextAlign.center),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          // Master flow: go back to MasterUploadScreen
                                          if (Navigator.canPop(parentContext)) {
                                            Navigator.pop(parentContext);
                                          }
                                        }
                                      },
                                      textStyle: AppTextStyles.font18BlackMediumCairo
                                          .copyWith(color: AppColors.textButton),
                                      width: 135.sp,
                                      height: 38.sp,
                                      radius: 4.r,
                                      color: AppColors.primary),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                      color: getTotalErrorCount() > 0
                          ? lightMode ? AppColors.black : AppColors.white
                          : AppColors.textButton,
                    ),
                    width: 150.sp,
                    height: 38.sp,
                    radius: 8.r,
                    color: getTotalErrorCount() > 0
                        ? lightMode ? AppColors.grey : AppColors.mediumGrey
                        : AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── CustomExcelTextField (unchanged) ────────────────────────────────────────
class CustomExcelTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final double width;
  final double height;
  final bool showHeader;
  final FocusNode? focusNode;
  final String headerLabel;
  final String placeholder;
  final Function(String value)? onChanged;
  final int? rowIndex;
  final Function(String key, int index)? validator;
  final bool isDisabled;

  const CustomExcelTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.errorText,
    this.width = 200,
    this.height = 36,
    this.showHeader = false,
    this.headerLabel = '',
    this.onChanged,
    this.focusNode,
    this.rowIndex,
    this.validator,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEmail = placeholder.toLowerCase().contains('email');
    final isPhone = placeholder.toLowerCase().contains('phone');
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Align(
                alignment:
                headerLabel.trim().contains(RegExp(r'[\u0600-\u06FF]'))
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  headerLabel,
                  style:  TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.black.withOpacity(0.87)),
                ),
              ),
            ),
          SizedBox(
            width: width,
            child: Directionality(
              textDirection:
              placeholder.trim().contains(RegExp(r'[\u0600-\u06FF]'))
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: height,
                      child: CustomTextField(
                        controller: controller,
                        focusNode: focusNode,
                        enabled: !isDisabled,
                        hint: placeholder,
                        // Error shown via the external error icon next to the
                        // cell (below); no inline errorText to avoid overflowing
                        // the fixed-height table cell.
                        fillColor: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        keyboardType:
                            isPhone ? TextInputType.phone : TextInputType.text,
                        inputFormatters: isEmail
                            ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))]
                            : null,
                        valueStyle: AppTextStyles.font12BlackMediumCairo.copyWith(
                          color: isDisabled ? AppColors.grey : AppColors.text,
                        ),
                        hintStyle: TextStyle(
                            fontSize: 13,
                            color: isDisabled
                                ? AppColors.secondaryText.withOpacity(.5)
                                : AppColors.mediumGrey),
                        onChanged: (value) {
                          if (validator != null && rowIndex != null && !isDisabled) {
                            validator!(placeholder, rowIndex!);
                          }
                          if (onChanged != null) onChanged!(value);
                        },
                      ),
                    ),
                  ),
                  if (errorText != null) SizedBox(width: 8.sp),
                  GestureDetector(
                    onTap: () {
                      if (errorText != null) {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 24.sp, horizontal: 16.sp),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                            content: Container(
                              width: 410.sp,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Lottie.asset('assets/lottie/rejected.json',
                                      width: 70.sp, height: 70.sp),
                                  SizedBox(height: 16.sp),
                                  Text(
                                    '${S.of(dialogContext).warning} $placeholder',
                                    style: AppTextStyles.font20BlackSemiBoldCairo.copyWith(
                                        color: AppColors.text, height: 1.7),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16.sp),
                                  Text(
                                    errorText == S.of(dialogContext).emailDoesNotExist ||
                                        errorText == S.of(dialogContext).departmentDoesNotExist
                                        ? S.of(dialogContext).specifiedDoesNotExist(placeholder)
                                        : S.of(dialogContext).specifiedError(placeholder, errorText ?? ''),
                                    style: AppTextStyles.font14BlackCairoRegular.copyWith(
                                        color: AppColors.mediumGrey, height: 1.7),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: errorText != null
                        ? Container(
                      width: 20.sp,
                      height: height,
                      alignment: Alignment.center,
                      child: SvgPicture.asset('assets/error.svg',
                          width: 20.sp, height: 20.sp, fit: BoxFit.cover),
                    )
                        : SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
