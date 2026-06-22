/// ******************* FILE INFO *******************
/// File Name: master_upload_screen.dart
/// Description: Master Upload screen with two steps:
///   Step 1: Bulk Upload Services Data
///   Step 2: Bulk Upload Service Requests (enabled only after Step 1 done)
/// Created by: Amr Mesbah
///
/// CHANGE LOG:
/// - UI completely redesigned to match Figma specifications
/// - Linear step indicator with proper styling
/// - Single unified content card design
/// - Proper button styling and layout
/// - Enhanced upload area with drag & drop states

import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide BorderStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/presentation/s3_create_master_services/ui/pages/master_upload_upload_file_details_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s3_create_master_services/ui/pages/upload_request_details_toggle.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:desktop_drop/desktop_drop.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/core/custom/6_custom_button_with_svg.dart';
import 'package:demo_app/core/custom/5-custom_button.dart';
import 'package:demo_app/core/custom/12-custom_delete_icon.dart';
import 'package:demo_app/core/custom/13-custom_edit_icon.dart';
import 'package:demo_app/core/custom/32-custom_svg.dart';

import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/ui/pages/upload_file_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/ui/pages/data_upload_upload_file_details_toggle.dart';

class MasterUploadScreen extends StatefulWidget {
  const MasterUploadScreen({super.key});

  @override
  State<MasterUploadScreen> createState() => _MasterUploadScreenState();
}

class _MasterUploadScreenState extends State<MasterUploadScreen> {
  final MainCoreEmployeeController employeeController = Get.find();

  // ─── Step 1 state ───────────────────────────────────────────
  bool _step1Completed = false;
  String? _step1FileName;
  int _step1TotalServices = 0;
  int _step1TotalDepartments = 0;
  List<Map<String, TextEditingController>> _step1FormData = [];
  List<Map<String, String>> _step1ValidationErrors = [];

  /// Holds Step 1's uploadToFirebase function.
  /// Returns Map<String, String> (serviceName → firestoreDocId).
  /// Set when the user confirms Step 1 — upload does NOT run yet.
  /// Will be called together with Step 2 upload when Step 2 is confirmed.
  Future<Map<String, String>> Function()? _step1UploadFunction;

  // ─── Step 2 state ───────────────────────────────────────────
  bool _step2IsDragging = false;
  String? _step2FileName;
  int _step2UniqueServices = 0;
  int _step2UniqueDepartments = 0;

  // ─── Step 1 Excel expected headers ─────────────────────────
  final List<String> _step1ExpectedHeaders = [
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

  // ─── Step 2 Excel expected headers ─────────────────────────
  final List<String> _step2ExpectedHeaders = [
    'Service Name',
    'Email Requester',
    'Service Provider',
    'Approvers',
    'State',
    'Requested Date',
  ];

  // ─── Validation helpers ─────────────────────────────────────
  bool isValidEmail(String email) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());

  bool containsArabic(String text) =>
      RegExp(r'[\u0600-\u06FF]').hasMatch(text);

  // ─── Step 1: pick & parse ───────────────────────────────────
  Future<void> _pickStep1File() async {
    await _requestStoragePermission();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    List<int> bytes;
    if (file.path != null) {
      bytes = await File(file.path!).readAsBytes();
    } else if (file.bytes != null) {
      bytes = file.bytes!;
    } else {
      _showErrorDialog('Unable to read the selected file.');
      return;
    }
    await _processStep1File(bytes, file.name);
  }

  Future<void> _processStep1File(List<int> bytes, String fileName) async {
    try {
      final excel = Excel.decodeBytes(bytes);
      List<Map<String, TextEditingController>> parsedFormData = [];
      List<Map<String, String>> parsedErrors = [];

      for (var tableName in excel.tables.keys) {
        final sheet = excel.tables[tableName];
        if (sheet == null || sheet.rows.length < 2) continue;

        final rows = sheet.rows;
        final actualHeaders = rows[0]
            .map((c) => c?.value.toString().trim() ?? '')
            .where((h) => h.isNotEmpty)
            .toList();

        final missingHeaders = _step1ExpectedHeaders
            .where((h) => !actualHeaders.contains(h))
            .toList();

        if (missingHeaders.length >= 3) {
          _showErrorDialog(
              'Missing required columns: ${missingHeaders.join(', ')}');
          return;
        }

        for (int i = 1; i < rows.length; i++) {
          Map<String, TextEditingController> rowCtrl = {};
          Map<String, String> rowErr = {};

          for (final header in _step1ExpectedHeaders) {
            String val = '';
            if (actualHeaders.contains(header)) {
              int col = actualHeaders.indexOf(header);
              if (col < rows[i].length && rows[i][col] != null) {
                try {
                  val = rows[i][col]?.value?.toString().trim() ?? '';
                } catch (e) {
                  val = '';
                }
              }
            }
            rowCtrl[header] = TextEditingController(text: val);
          }
          parsedFormData.add(rowCtrl);
          parsedErrors.add(rowErr);
        }
        break;
      }

      // Count departments
      final Set<String> deptSet = {};
      for (final row in parsedFormData) {
        final depts = row['Departments']?.text ?? '';
        if (depts.isNotEmpty) {
          depts
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .forEach(deptSet.add);
        }
      }

      setState(() {
        _step1FileName = fileName;
        _step1FormData = parsedFormData;
        _step1ValidationErrors = parsedErrors;
        _step1TotalServices = parsedFormData.length;
        _step1TotalDepartments = deptSet.length;
      });

      // ── Enrich emails NOW while map is guaranteed populated ──────────────────
      for (final row in parsedFormData) {
        final providerRaw = row['Service Provider']?.text.trim() ?? '';
        final approverRaw = row['Approvers']?.text.trim() ?? '';
        row['__enriched_providers__'] = TextEditingController(
            text: _enrichEmailsToJson(providerRaw));
        row['__enriched_approvers__'] = TextEditingController(
            text: _enrichEmailsToJson(approverRaw));
      }

      navigateTo(
        context,
        ToggleUploadFileDetailsMaster(
          formData: parsedFormData,
          validationErrors: parsedErrors,
          selectedFileName: fileName,
          onActivated: (Future<Map<String, String>> Function() uploadFn) async {
            setState(() {
              _step1Completed = true;
              _step1UploadFunction = uploadFn;
            });
          },
        ),
      );
    } catch (e) {
      _showErrorDialog('Failed to process file: $e');
    }
  }

  // ─── Step 2: pick & parse ───────────────────────────────────
  Future<void> _pickStep2File() async {
    if (!_step1Completed) return;

    await _requestStoragePermission();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    List<int> bytes;
    if (file.path != null) {
      bytes = await File(file.path!).readAsBytes();
    } else if (file.bytes != null) {
      bytes = file.bytes!;
    } else {
      _showErrorDialog('Unable to read the selected file.');
      return;
    }
    await _processStep2File(bytes, file.name);
  }

  Future<void> _processStep2File(List<int> bytes, String fileName) async {
    try {

      Excel excel;
      try {
        excel = Excel.decodeBytes(bytes);
      } catch (decodeError) {
        _showErrorDialog(
            'Cannot read this Excel file. Please re-save it as .xlsx and try again.\n\nDetails: $decodeError');
        return;
      }

      List<Map<String, TextEditingController>> parsedFormData = [];
      List<Map<String, String>> parsedErrors = [];

      for (var tableName in excel.tables.keys) {
        final sheet = excel.tables[tableName];
        if (sheet == null || sheet.rows.length < 2) continue;

        final rows = sheet.rows;

        final actualHeaders = <String>[];
        for (int hi = 0; hi < rows[0].length; hi++) {
          try {
            final cell = rows[0][hi];
            String val = '';
            if (cell != null && cell.value != null) {
              val = cell.value.toString().trim();
            }
            actualHeaders.add(val);
          } catch (e) {
            actualHeaders.add('');
          }
        }

        final missingHeaders = _step2ExpectedHeaders
            .where((h) => !actualHeaders.contains(h))
            .toList();

        if (missingHeaders.length >= 3) {
          _showErrorDialog(
              'Missing required columns: ${missingHeaders.join(', ')}');
          return;
        }

        for (int i = 1; i < rows.length; i++) {
          bool allEmpty = true;
          for (int ci = 0; ci < rows[i].length; ci++) {
            try {
              final v = rows[i][ci]?.value?.toString().trim() ?? '';
              if (v.isNotEmpty) {
                allEmpty = false;
                break;
              }
            } catch (e) {/* skip */}
          }
          if (allEmpty) continue;

          Map<String, TextEditingController> rowCtrl = {};
          Map<String, String> rowErr = {};

          for (final header in _step2ExpectedHeaders) {
            String val = '';
            if (actualHeaders.contains(header)) {
              int col = actualHeaders.indexOf(header);
              if (col < rows[i].length) {
                try {
                  final cell = rows[i][col];
                  if (cell != null && cell.value != null) {
                    val = cell.value.toString().trim();
                  }
                } catch (e) {
                  val = '';
                }
              }
            }
            rowCtrl[header] = TextEditingController(text: val);

            if (header != 'Approvers' && header != 'Service Name') {
              final error = _validateStep2Cell(context, header, val, rowCtrl);
              if (error != null) rowErr[header] = error;
            }
          }

          parsedFormData.add(rowCtrl);
          parsedErrors.add(rowErr);
        }
        break;
      }

      if (parsedFormData.isEmpty) {
        _showErrorDialog('No data rows found in the file.');
        return;
      }

      // Calculate unique services and departments
      final Set<String> uniqueServices = {};
      final Set<String> uniqueDepts = {};

      for (final row in parsedFormData) {
        final serviceName = row['Service Name']?.text.trim() ?? '';
        if (serviceName.isNotEmpty) uniqueServices.add(serviceName);

        final requester = row['Email Requester']?.text.trim() ?? '';
        if (requester.isNotEmpty && employeeController.mapOfEmployeesWithEmailKey.containsKey(requester)) {
          final emp = employeeController.mapOfEmployeesWithEmailKey[requester];
          if (emp?.departmentId != null && emp!.departmentId!.isNotEmpty) {
            uniqueDepts.add(emp.departmentId!);
          }
        }
      }

      setState(() {
        _step2FileName = fileName;
        _step2UniqueServices = uniqueServices.length;
        _step2UniqueDepartments = uniqueDepts.length;
      });

      navigateTo(
        context,
        UploadRequestsDetailsToggle(
          formData: parsedFormData,
          validationErrors: parsedErrors,
          selectedFileName: fileName,
          uploadedServicesFormData: _step1FormData,
          step1UploadFunction: _step1UploadFunction,
        ),
      );
    } catch (e, stack) {
      _showErrorDialog('Failed to process file: $e');
    }
  }

  String? _validateStep2Cell(
      BuildContext context,
      String key,
      String? value,
      Map<String, TextEditingController> rowData,
      ) {
    if (key == 'Approvers') {
      if (value == null || value.trim().isEmpty) return null;
    }

    if (value == null || value.trim().isEmpty) {
      return S.of(context).required;
    }

    value = value.trim();

    switch (key) {
      case 'Service Name':
        break;

      case 'Email Requester':
        if (!isValidEmail(value)) return S.of(context).invalidEmailFormat;
        if (!employeeController.mapOfEmployeesWithEmailKey.containsKey(value)) {
          return S.of(context).emailDoesNotExist;
        }
        break;

      case 'Service Provider':
        if (value.contains(' ')) return S.of(context).emailsCommaSeparated;
        if (value.startsWith(',') || value.endsWith(',')) {
          return S.of(context).commaAtStartOrEnd;
        }
        final emails = value.split(',').map((e) => e.trim()).toList();
        for (final email in emails) {
          if (email.isEmpty) return S.of(context).emptyEmail;
          if (!isValidEmail(email)) return S.of(context).invalidEmailFormat;
          if (!employeeController.mapOfEmployeesWithEmailKey.containsKey(email)) {
            return S.of(context).emailDoesNotExist;
          }
        }
        break;

      case 'Approvers':
        if (value.contains(' ')) return S.of(context).emailsCommaSeparated;
        if (value.startsWith(',') || value.endsWith(',')) {
          return S.of(context).commaAtStartOrEnd;
        }
        final apEmails = value.split(',').map((e) => e.trim()).toList();
        for (final email in apEmails) {
          if (email.isEmpty) return S.of(context).emptyEmail;
          if (!isValidEmail(email)) return S.of(context).invalidEmailFormat;
          if (!employeeController.mapOfEmployeesWithEmailKey.containsKey(email)) {
            return S.of(context).emailDoesNotExist;
          }
        }
        break;

      case 'State':
        const allowed = ['pending', 'approved', 'done'];
        if (!allowed.contains(value.toLowerCase())) {
          return 'State must be: pending, approved, or done';
        }
        break;

      case 'Requested Date':
        final dateRegex = RegExp(r'^\d{1,2}\s+[A-Za-z]{3}\s+\d{4}$');
        if (!dateRegex.hasMatch(value)) {
          return 'Date format must be: 12 Feb 2023';
        }
        break;
    }

    return null;
  }

  // ─── Drag & Drop Step 2 ─────────────────────────────────────
  Future<void> _onStep2DragDone(DropDoneDetails details) async {
    if (!_step1Completed) return;
    setState(() => _step2IsDragging = false);
    if (details.files.isEmpty) return;

    final file = details.files.first;
    final name = file.name.toLowerCase();
    if (!name.endsWith('.xlsx') && !name.endsWith('.xls')) {
      _showErrorDialog('Please drop only Excel files (.xlsx or .xls)');
      return;
    }
    final bytes = await file.readAsBytes();
    await _processStep2File(bytes, file.name);
  }

  // ─── Helpers ─────────────────────────────────────────────────
  Future<void> _requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        await Permission.manageExternalStorage.request();
      } else if (Platform.isIOS) {
        await Permission.storage.request();
      }
    } catch (e) {
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/lottie/rejected.json',
                width: 90.sp, height: 90.sp),
            SizedBox(height: 16.sp),
            Text(S.of(context).error,
                style:
                AppTextStyles.font20BlackCairoMedium.copyWith(color: AppColors.text)),
            SizedBox(height: 8.sp),
            Text(message,
                style: AppTextStyles.font12BlackMediumCairo
                    .copyWith(color: AppColors.secondaryText),
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          customButton(
            title: 'OK',
            function: () => Navigator.pop(context),
            width: 80.sp,
            height: 36.sp,
            color: AppColors.primary,
            textColor: AppColors.textButton,
          )
        ],
      ),
    );
  }

  // ─── Build ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;

    return SideFrameMasterServices(
      titleText: S.of(context).service,
      onFirstTap: () => Navigator.pop(context),
      secondTitle: 'Master Upload',
      child: SingleChildScrollView(
       // padding: EdgeInsets.all(24.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with steps indicator
            _buildStepsHeader(lightMode),
            SizedBox(height: 24.sp),

            // Main content card
            _buildMainContentCard(lightMode),

            SizedBox(height: 24.sp),

            // Bottom buttons
            _buildBottomButtons(lightMode),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsHeader(bool lightMode) {
    return Container(
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Step 1
          _buildStepIndicator(
            stepNumber: '1',
            title: 'Services Data',
            isActive: true,
            isCompleted: _step1Completed,
            lightMode: lightMode,
          ),

          // Connector line
          Expanded(
            child: Container(
              height: 2.5,
              margin: EdgeInsets.symmetric(horizontal: 20.sp),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _step1Completed
                      ? [AppColors.primary, AppColors.primary]
                      : [
                    AppColors.primary.withOpacity(0.3),
                    AppColors.grey.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ),

          // Step 2
          _buildStepIndicator(
            stepNumber: '2',
            title: 'Service Requests',
            isActive: _step1Completed,
            isCompleted: false,
            lightMode: lightMode,
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator({
    required String stepNumber,
    required String title,
    required bool isActive,
    required bool isCompleted,
    required bool lightMode,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: isCompleted
              ? Icon(Icons.check, color: AppColors.white, size: 20.sp)
              : Text(
            "$stepNumber:",
            style: TextStyle(
              color: isActive ? AppColors.text : AppColors.text ,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 10.sp),
        Text(
          title,
          style: TextStyle(
            color: isActive ? AppColors.text : AppColors.secondaryText,
            fontSize: 15.sp,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
  bool _showStep2Upload = false; // ADD THIS

  Widget _buildMainContentCard(bool lightMode) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(15.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step 1 section
          if (_step1Completed && _step1FileName != null)
            _buildUploadedFileDisplay(lightMode, isStep2: false)
          else
            _buildUploadArea(lightMode, isStep2: false),

          // Step 2 section — only visible after Next is clicked
          if (_showStep2Upload) ...[
            SizedBox(height: 24.sp),
            Divider(color: AppColors.secondaryText.withOpacity(0.3)),
            SizedBox(height: 16.sp),
            Text(S.of(context).step2ServiceRequests,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                )),
            SizedBox(height: 12.sp),
            if (_step2FileName != null)
              _buildUploadedFileDisplay(lightMode, isStep2: true)
            else
              _buildUploadArea(lightMode, isStep2: true),
          ],
        ],
      ),
    );
  }

  Widget _buildUploadedFileDisplay(bool lightMode, {required bool isStep2}) {
    // Determine which step to show based on completion
    final showStep2 = isStep2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // File info with actions
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container (
              width: 280.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.secondaryText.withOpacity(.5)
                )
              ),
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Row(
                  children: [
                    // Excel icon
                    Container(
                      width: 50.sp,
                      height: 50.sp,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D6F42).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: CustomSvg( assetPath: 'assets/exel.svg.svg',width: 43.w,height: 43.h,fit: BoxFit.fill,)
                      ),
                    ),
                    SizedBox(width: 14.sp),
                    // File name and size
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            showStep2 ? (_step2FileName ?? 'Resume 1.pdf') : (_step1FileName ?? 'Resume 1.pdf'),
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4.sp),
                          Text(
                            '62 KB',
                            style: TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),

            Spacer(),

            // Edit button
            // Edit button
            CustomEditIcon(
              color: AppColors.primary,
              borderColor: Colors.transparent,
              svgColor: AppColors.textButton,
              title: S.of(context).edit,
              textStyle: TextStyle(
                color: AppColors.textButton,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              onTap: () {
                if (showStep2) {
                  // Navigate to Step 2 edit
                } else {
                  navigateTo(
                    context,
                    ToggleUploadFileDetailsMaster(
                      formData: _step1FormData,
                      validationErrors: _step1ValidationErrors,
                      selectedFileName: _step1FileName,
                      onActivated: (Future<Map<String, String>> Function() uploadFn) async {
                        setState(() {
                          _step1Completed = true;
                          _step1UploadFunction = uploadFn;
                        });
                      },
                    ),
                  );
                }
              },
            ),
            SizedBox(width: 10.sp),

// Delete button
            CustomDeleteIcon(
              color: AppColors.red,
              borderColor: Colors.transparent,
              svgColor: AppColors.white,
              title: S.of(context).delete,
              textStyle: TextStyle(
                color: AppColors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              onTap: () {
                if (showStep2) {
                  setState(() {
                    _step2FileName = null;
                    _step2UniqueServices = 0;
                    _step2UniqueDepartments = 0;
                  });
                } else {
                  setState(() {
                    _step1Completed = false;
                    _step1FileName = null;
                    _step1FormData = [];
                    _step1ValidationErrors = [];
                    _step1TotalServices = 0;
                    _step1TotalDepartments = 0;
                    _step1UploadFunction = null;
                    _showStep2Upload = false; // ADD THIS
                  });
                }
              },
            ),
          ],
        ),

        SizedBox(height: 28.sp),

        // Stats row
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildStatItem(
              icon: 'assets/vectors/totoal services.svg',
              label: showStep2 ? 'Unique Services' : 'Total Services',
              value: showStep2 ? _step2UniqueServices.toString() : _step1TotalServices.toString(),
              lightMode: lightMode,
            ),
            SizedBox(height: 28.sp),
            _buildStatItem(
              icon: 'assets/vectors/totoal_department.svg',
              label: showStep2 ? 'Unique Department Requesters' : 'Total Owning Departments',
              value: showStep2 ? _step2UniqueDepartments.toString() : _step1TotalDepartments.toString(),
              lightMode: lightMode,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String label,
    required String value,
    required bool lightMode,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          icon,
          width: 22.sp,
          height: 22.sp,
          color: AppColors.primary
        ),
        SizedBox(width: 10.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "${label}: ",
              style: TextStyle(
                color: AppColors.text,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadArea(bool lightMode, {required bool isStep2}) {
    final isDisabled = isStep2 && !_step1Completed;

    return DropTarget(
      onDragEntered: (_) {
        if (!isDisabled && isStep2) {
          setState(() => _step2IsDragging = true);
        }
      },
      onDragExited: (_) {
        if (isStep2) {
          setState(() => _step2IsDragging = false);
        }
      },
      onDragDone: isStep2 ? _onStep2DragDone : null,
      child: GestureDetector(
        onTap: isDisabled ? null : (isStep2 ? _pickStep2File : _pickStep1File),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 68.sp),
          decoration: BoxDecoration(
            color: _step2IsDragging
                ? AppColors.primary.withOpacity(0.06)
                : AppColors.card,
            borderRadius: BorderRadius.circular(12.r),
            // border: Border.all(
            //   color: _step2IsDragging
            //       ? AppColors.primary
            //       : AppColors.grey.withOpacity(0.25),
            //   width: 2,
            // ),
          ),
          child: isDisabled
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 52.sp,
                color: AppColors.grey,
              ),
              SizedBox(height: 18.sp),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.sp),
                child: Text(
                  'Complete The First Upload To Enable This Step',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _step2IsDragging
                    ? Icon(
                  Icons.cloud_upload_outlined,
                  key: const ValueKey('dragging'),
                  size: 68.sp,
                  color: AppColors.primary,
                )
                    : SvgPicture.asset(
                  'assets/uploadfile.svg',
                  key: const ValueKey('normal'),
                  width: 68.sp,
                  height: 68.sp,
                  fit: BoxFit.scaleDown,
                ),
              ),
              SizedBox(height: 22.sp),
              Text(
                _step2IsDragging
                    ? 'Drop your Excel file here'
                    : S.of(context).dragDropFilesHere,
                style: TextStyle(
                  color: _step2IsDragging
                      ? AppColors.primary
                      : AppColors.secondaryText,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 18.sp),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 26.sp, vertical: 11.sp),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  S.of(context).browseFiles,
                  style: AppTextStyles.font14BlackCairoRegular.copyWith(
                    color: AppColors.textButton
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(bool lightMode) {
    final showNext = _step1Completed && _step2FileName == null;
    final showActivate = _step2FileName != null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

      customButton(title: S.of(context).discard, function: (){

        Navigator.pop(context);
      },width: 150.w,height: 38.h,radius: 8.r,color: lightMode ? AppColors.grey : AppColors.mediumGrey),

    if (showNext || showActivate) ...[
        customButton(title: S.of(context).next, function: () {
          if (showNext) {
            setState(() {
              _showStep2Upload = true; // This reveals Step 2 upload area
            });
          }

    else if (showActivate) {
    // Handle activation logic
    }
    },width: 150.w,height: 38.h,radius: 8.r,color: AppColors.primary, textStyle: AppTextStyles.font16BlackRegularCairo.copyWith(
          color: AppColors.textButton
        )),

        // // Discard button
        // Expanded(
        //   child: GestureDetector(
        //     onTap: () => Navigator.pop(context),
        //     child: Container(
        //       height: 46.sp,
        //       decoration: BoxDecoration(
        //         color: lightMode
        //             ? const Color(0xFFF5F5F5)
        //             : AppColors.background,
        //         borderRadius: BorderRadius.circular(8.r),
        //         // border: Border.all(
        //         //   color: AppColors.grey.withOpacity(0.3),
        //         //   width: 1,
        //         // ),
        //       ),
        //       child: Center(
        //         child: Text(
        //           'Discard',
        //           style: TextStyle(
        //             color: AppColors.text,
        //             fontSize: 16.sp,
        //             fontWeight: FontWeight.w600,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        // if (showNext || showActivate) ...[
        //   SizedBox(width: 14.sp),
        //   // Next/Activate button
        //   Expanded(
        //     child: GestureDetector(
        //       onTap: () {
        //         if (showNext) {
        //           // Show Step 2 upload area
        //           setState(() {
        //             // The UI will automatically show Step 2 area when Step 1 is completed
        //           });
        //         } else if (showActivate) {
        //           // Handle activation logic
        //         }
        //       },
        //       child: Container(
        //         height: 46.sp,
        //         decoration: BoxDecoration(
        //           color: const Color(0xFFFFC107),
        //           borderRadius: BorderRadius.circular(8.r),
        //         ),
        //         child: Center(
        //           child: Text(
        //             showActivate ? 'Activate' : 'Next',
        //             style: TextStyle(
        //               color: AppColors.black,
        //               fontSize: 16.sp,
        //               fontWeight: FontWeight.w700,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        ],
      ],
    );
  }

  // ─── Enrich emails at parse time ───────────────────────────────────────────
  String _enrichEmailsToJson(String emails) {
    if (emails.trim().isEmpty) return '[]';
    final deptController = Get.find<MainCoreDepartmentController>();
    final enriched = emails
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((email) {
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
            departmentId: emp.departmentId!) ?? '')
            : '',
        'departmentNameArabic': emp?.departmentId != null && emp!.departmentId!.isNotEmpty
            ? (deptController.getArabicDepartmentNameFromDepartmentId(
            departmentId: emp.departmentId!) ?? '')
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
    return jsonEncode(enriched);
  }
}
