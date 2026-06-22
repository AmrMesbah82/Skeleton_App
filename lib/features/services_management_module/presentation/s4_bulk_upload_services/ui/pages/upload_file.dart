/// ******************* FILE INFO *******************
/// File Name: upload_file.dart
/// Description: can make bulk upload of file by drag and drop here
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide Border, BorderStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services_toggle.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:desktop_drop/desktop_drop.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/5-custom_button.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/ui/pages/data_upload_upload_file_details_toggle.dart';

class UploadFileTablet extends StatefulWidget {
  const UploadFileTablet({super.key});

  @override
  State<UploadFileTablet> createState() => _UploadFileTabletState();
}

class _UploadFileTabletState extends State<UploadFileTablet> {
  // Add drag and drop state variables
  bool _isDragging = false;
  bool _isHovering = false;
  final MainCoreEmployeeController employeeController = Get.find();

  bool isValidEmail(String email) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());

  bool isArabic(String text) => RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(text);

  bool isEnglish(String text) => RegExp(r'^[a-zA-Z\s]+$').hasMatch(text);

  bool hasSpecialChars(String text) =>
      RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9]').hasMatch(text);

  bool hasNumbers(String text) => RegExp(r'\d').hasMatch(text);

  bool hasNoSpaceBetweenWords(String text) => !text.trim().contains(' ');

  bool containsArabic(String text) => RegExp(r'[\u0600-\u06FF]').hasMatch(text);

  bool containsEnglish(String text) => RegExp(r'[a-zA-Z]').hasMatch(text);

  List<Map<String, TextEditingController>> formData = [];
  List<Map<String, TextEditingController>> filteredData = [];
  List<Map<String, String>> validationErrors = [];
  int currentPage = 0;

  // ✅ UPDATED: Removed 'Service Availability' from expected headers
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

  String? selectedFileName;

  bool validateHeaders(List<String> headers) {
    if (headers.length != expectedHeaders.length) return false;
    for (int i = 0; i < headers.length; i++) {
      if (headers[i].trim() != expectedHeaders[i].trim()) return false;
    }
    return true;
  }

  String? validateCell(
      BuildContext context,
      String key,
      String? value, {
        Map<String, TextEditingController>? rowData,
      })
  {
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
        if (hasSpecialChars(value))
          return S.of(context).specialCharsNotAllowed;
        if (hasExtraSpaces(value))
          return S.of(context).extraSpaces;
        break;

      case 'اسم الخدمة':
        if (!isArabic(value)) return S.of(context).arabicOnly;
        if (containsEnglish(value)) return S.of(context).englishNotAllowed;
        if (hasSpecialChars(value))
          return S.of(context).specialCharsNotAllowed;
        if (hasExtraSpaces(value))
          return S.of(context).extraSpaces;
        break;

      case 'Service Description':
        if (containsArabic(value)) return S.of(context).arabicNotAllowed;
        if (hasForbiddenCharsInDescription(value)) {
          return S.of(context).descriptionSpecialChars;
        }
        if (hasExtraSpaces(value))
          return S.of(context).extraSpaces;
        break;

      case 'وصف الخدمة':
        if (containsEnglish(value)) return S.of(context).englishNotAllowed;
        if (hasForbiddenCharsInDescription(value)) {
          return S.of(context).descriptionSpecialChars;
        }
        if (hasExtraSpaces(value))
          return S.of(context).extraSpaces;
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
          if (!employeeController.mapOfEmployeesWithEmailKey
              .containsKey(email)) {
            return S.of(context).emailDoesNotExist;
          }
        }
        break;

      case 'Approvers':
      // Check if approval is required first
        final requireApprovalCtrl = rowData?['Requires Approvals'];
        final requireApproval =
            requireApprovalCtrl?.text.trim().toLowerCase() ?? '';

        // If approval not required, skip validation
        if (requireApproval == 'no') return null;

        // Check for invalid characters (same as Service Provider)
        if (value.contains(':') ||
            value.contains(';') ||
            value.contains("'") ||
            value.contains('"') ||
            value.contains(' ')) {
          return S.of(context).emailsCommaSeparated;
        }

        // Check for comma at start or end
        if (value.startsWith(',') || value.endsWith(','))
          return S.of(context).commaAtStartOrEnd;

        // Check for double commas
        if (value.contains(',,')) return S.of(context).doubleCommas;

        // Split and validate emails
        final emails = value.split(',').map((e) => e.trim()).toList();

        // Check for duplicate emails in the same field
        if (emails.toSet().length != emails.length) {
          return S.of(context).duplicateEmails;
        }

        // Validate each email
        for (final email in emails) {
          if (email.isEmpty) return S.of(context).emptyEmail;

          // Check email format
          if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
            return S.of(context).invalidEmailFormat;
          }

          // Check if email exists in company (same validation as Service Provider)
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
            if (dept.length < 2)
              return S.of(context).departmentMinLength;
            if (controller.getDepartmentIdFromDepartmentName(
                departmentName: dept) ==
                null) {
              return S.of(context).departmentDoesNotExist;
            }
          }
        }
        break;
    }

    return null;
  }

  Future<void> processFile(List<int> bytes, String fileName) async {
    // ✅ Set the filename immediately
    setState(() {
      selectedFileName = fileName;
    });

    Excel? excel;

    try {
      // ✅ FIXED: Wrap Excel decoding in try-catch
      try {
        excel = Excel.decodeBytes(bytes);
      } catch (parseError, parseStack) {
        _hideLoadingDialog();
        _showErrorDialog(
            'Failed to parse Excel file. The file may be corrupted or contain invalid data.\n\nPlease ensure:\n• The file is a valid Excel format (.xlsx or .xls)\n• All cells contain valid data\n• There are no merged cells in the header row'
        );
        return;
      }

      if (excel == null || excel.tables.isEmpty) {
        _hideLoadingDialog();
        _showErrorDialog('No worksheets found in the Excel file.');
        return;
      }

      List<Map<String, TextEditingController>> parsedFormData = [];
      List<Map<String, String>> parsedValidationErrors = [];

      bool fileProcessed = false;

      for (var tableName in excel.tables.keys) {
        var sheet = excel.tables[tableName];
        if (sheet == null || sheet.rows.isEmpty) continue;

        var rows = sheet.rows;
        if (rows.length < 2) {
          continue;
        }

        // ✅ FIXED: Safe header extraction with additional null checks
        List<String> actualHeaders = [];
        try {
          if (rows.isNotEmpty && rows[0] != null) {
            actualHeaders = rows[0]
                .map((cell) {
              try {
                if (cell == null || cell.value == null) return '';
                return cell.value.toString().trim();
              } catch (e) {
                return '';
              }
            })
                .where((header) => header.isNotEmpty)
                .toList();
          }
        } catch (e) {
          continue;
        }

        if (actualHeaders.isEmpty) {
          continue;
        }

        List<String> missingHeaders = expectedHeaders
            .where((h) => !actualHeaders.contains(h))
            .toList();
        List<String> unknownHeaders = actualHeaders
            .where((h) => !expectedHeaders.contains(h))
            .toList();

        if (missingHeaders.length >= 3) {
          _hideLoadingDialog();
          _showHeaderErrorDialog(missingHeaders);
          return;
        }

        if (missingHeaders.isNotEmpty && missingHeaders.length < 3) {
          _showMissingHeadersWarning(missingHeaders);
        }

        // ✅ FIXED: Safe data row processing with try-catch per row
        for (int i = 1; i < rows.length; i++) {
          try {
            if (rows[i] == null || rows[i].isEmpty) continue;

            Map<String, TextEditingController> rowControllers = {};
            Map<String, String> rowErrors = {};

            for (final header in expectedHeaders) {
              String cellValue = '';

              if (actualHeaders.contains(header)) {
                int colIndex = actualHeaders.indexOf(header);

                // ✅ FIXED: Safe cell value extraction with try-catch
                try {
                  if (colIndex < rows[i].length) {
                    var cell = rows[i][colIndex];
                    if (cell != null && cell.value != null) {
                      cellValue = cell.value.toString().trim();
                    }
                  }
                } catch (cellError) {
                  cellValue = '';
                }
              }

              rowControllers[header] = TextEditingController(text: cellValue);

              String? error = validateCell(
                  context,
                  header,
                  cellValue.isEmpty ? null : cellValue,
                  rowData: rowControllers
              );

              if (error != null) {
                rowErrors[header] = error;
              }

              if (!actualHeaders.contains(header)) {
                rowErrors[header] = S.of(context).missingColumns;
              }
            }

            parsedFormData.add(rowControllers);
            parsedValidationErrors.add(rowErrors);

          } catch (rowError) {
            // Skip this row and continue with next
            continue;
          }
        }

        fileProcessed = true;
        break;
      }

      _hideLoadingDialog();

      if (!fileProcessed) {
        _showErrorDialog('No valid data found in the Excel file.');
        return;
      }

      if (parsedFormData.isEmpty) {
        _showErrorDialog('No data rows found in the Excel file.');
        return;
      }

      // Set formData for future reference
      setState(() {
        formData = parsedFormData;
        validationErrors = parsedValidationErrors;
      });

      // ✅ Navigate with filename
      navigateTo(
        context,
        ToggleUploadFileDetails(
          formData: parsedFormData,
          validationErrors: parsedValidationErrors,
          selectedFileName: fileName,
        ),
      );

    } catch (e, stackTrace) {
      _hideLoadingDialog();
      _showErrorDialog('Failed to process Excel file: ${e.toString()}');
    }
  }

  // File picker method
  Future<void> pickAndParseExcel() async {
    try {
      bool hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        _showErrorDialog('Storage permission denied. Please grant permission to access files.');
        return;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      PlatformFile file = result.files.single;

      List<int> bytes;
      if (file.path != null) {
        File actualFile = File(file.path!);
        if (!await actualFile.exists()) {
          _showErrorDialog('Selected file does not exist.');
          return;
        }
        bytes = await actualFile.readAsBytes();
      } else if (file.bytes != null) {
        bytes = file.bytes!;
      } else {
        _showErrorDialog('Unable to read the selected file.');
        return;
      }

      await processFile(bytes, file.name);

    } catch (e) {
      _showErrorDialog('Failed to pick file: ${e.toString()}');
    }
  }

  // Drag and drop handlers
  void _onDragEntered() {
    setState(() {
      _isDragging = true;
    });
  }

  void _onDragExited() {
    setState(() {
      _isDragging = false;
    });
  }

  void _onDragUpdate(DropEventDetails details) {
    setState(() {
      _isHovering = true;
    });
  }

  Future<void> _onDragDone(DropDoneDetails details) async {
    setState(() {
      _isDragging = false;
      _isHovering = false;
    });

    if (details.files.isEmpty) {
      _showErrorDialog('No files were dropped.');
      return;
    }

    final file = details.files.first;
    final fileName = file.name.toLowerCase();

    // Check file extension
    if (!fileName.endsWith('.xlsx') && !fileName.endsWith('.xls')) {
      _showErrorDialog('Please drop only Excel files (.xlsx or .xls)');
      return;
    }

    try {
      final bytes = await file.readAsBytes();
      await processFile(bytes, file.name);
    } catch (e) {
      _showErrorDialog('Failed to read dropped file: ${e.toString()}');
    }
  }

  // Helper methods
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text(S.of(context).processingFile),
          ],
        ),
      ),
    );
  }

  void _hideLoadingDialog() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/lottie/rejected.json',
              width: 90.sp,
              height: 90.sp,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16.sp),
            Text(
              "Error",
              style: AppTextStyles.font20BlackCairoMedium.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.blackButton
                      : AppColors.white
              ),
            ),
            SizedBox(height: 16.sp),
            Text(
              message,
              style: AppTextStyles.font12BlackMediumCairo.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.secondaryText
                      : AppColors.grey
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          customButton(
            title: "OK",
            function: () => Navigator.pop(context),
            width: 80.sp,
            height: 36.sp,
            color: AppColors.primary,
            textColor: AppColors.textButton,
          ),
        ],
      ),
    );
  }

  void _showHeaderErrorDialog(List<String> missingHeaders) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/lottie/rejected.json',
              width: 90.sp,
              height: 90.sp,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16.sp),
            Text(
              "Warning Missing Column",
              style: AppTextStyles.font20BlackCairoMedium.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.blackButton
                      : AppColors.white
              ),
            ),
            SizedBox(height: 16.sp),
            Text(
              "Some required columns are missing: ${missingHeaders.join(', ')}",
              style: AppTextStyles.font12BlackMediumCairo.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.secondaryText
                      : AppColors.grey
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          customButton(
            title: "OK",
            function: () => Navigator.pop(context),
            width: 80.sp,
            height: 36.sp,
            color: AppColors.primary,
            textColor: AppColors.textButton,
          ),
        ],
      ),
    );
  }

  void _showMissingHeadersWarning(List<String> missingHeaders) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Missing columns: ${missingHeaders.join(', ')}'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<bool> requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (status.isGranted) {
          return true;
        }

        if (status.isDenied) {
          status = await Permission.storage.request();
          if (status.isGranted) {
            return true;
          }
        }

        if (status.isPermanentlyDenied) {
          var manageStatus = await Permission.manageExternalStorage.status;
          if (manageStatus.isDenied) {
            manageStatus = await Permission.manageExternalStorage.request();
          }
          return manageStatus.isGranted;
        }

        return status.isGranted;
      } else if (Platform.isIOS) {
        return true;
      }
      return true;
    } catch (e) {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;

    return SideFrameMasterServices(
      titleText: S.of(context).service,
      onFirstTap: (){
        navigateTo(context, LayoutScreenServices());
      },
      secondTitle: S.of(context).bulkUpload,
      child: Padding(
        padding: EdgeInsets.only(right: 7.sp),
        child: Column(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Enhanced Upload box with drag and drop
                  DropTarget(
                    onDragEntered: (_) => _onDragEntered(),
                    onDragExited: (_) => _onDragExited(),
                    onDragUpdated: _onDragUpdate,
                    onDragDone: _onDragDone,
                    child: GestureDetector(
                      onTap: pickAndParseExcel,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _isDragging
                              ? (lightMode
                              ? AppColors.primary.withOpacity(0.1)
                              : AppColors.primary.withOpacity(0.2))
                              : (lightMode
                              ? AppColors.white
                              : AppColors.chatBackground),
                          borderRadius: BorderRadius.circular(8.r),

                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 60.sp),

                            // Animated icon based on drag state
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: _isDragging
                                  ? Icon(
                                Icons.cloud_upload_outlined,
                                key: ValueKey('dragging'),
                                size: 100.sp,
                                color: AppColors.primary,
                              )
                                  : SvgPicture.asset(
                                "assets/uploadfile.svg",
                                key: ValueKey('normal'),
                                width: 100.sp,
                                height: 100.sp,
                                fit: BoxFit.scaleDown,
                                semanticsLabel: 'Upload Icon',
                              ),
                            ),

                            SizedBox(height: 27.sp),

                            // Dynamic text based on drag state
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              child: Text(
                                _isDragging
                                    ?  "Drop your Excel file here"
                                    : S.of(context).dragDropFilesHere,
                                key: ValueKey(_isDragging ? 'drop' : 'drag'),
                                style: AppTextStyles.font20BlackCairoMedium.copyWith(
                                  color: _isDragging
                                      ? AppColors.primary
                                      : (lightMode
                                      ? AppColors.blackButton
                                      : AppColors.white),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(height: 25.sp),

                            SizedBox(height: 60.sp),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 26.sp),

            // Discard And Browse buttons
            Row(
              children: [
                customButtonAnimation(
                  title: S.of(context).discard,
                  function: () {
                    setState(() {
                      selectedFileName = null;
                      formData.clear();
                      validationErrors.clear();
                    });
                  },
                  textStyle: AppTextStyles.font16BlackSemiBoldCairo.copyWith(
                    color: AppColors.blackButton,
                  ),
                  width: 150.sp,
                  height: 38.sp,
                  radius: 8.r,
                  color: AppColors.secondaryButton.withOpacity(.8),
                ),

                Spacer(),

                customButtonAnimation(
                  title: S.of(context).browseFiles,
                  function: pickAndParseExcel,
                  textStyle: AppTextStyles.font16BlackSemiBoldCairo.copyWith(
                    color: AppColors.textButton,
                  ),
                  width: 150.sp,
                  height: 38.sp,
                  radius: 8.r,
                  color: AppColors.primary,
                ),
              ],
            ),

            // Show selected file name if any
            if (selectedFileName != null) ...[
              SizedBox(height: 16.sp),
              Container(
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.description,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.sp),
                    Expanded(
                      child: Text(
                        selectedFileName!,
                        style: AppTextStyles.font14BlackCairoMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedFileName = null;
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        color: AppColors.primary,
                        size: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
