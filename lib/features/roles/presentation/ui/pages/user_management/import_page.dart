/// ******************* FILE INFO *******************
/// File Name: upload_file.dart
/// Description: can make bulk upload of file by drag and drop here
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'dart:io';

import 'package:demo_app/core/widgets/custom_button_widget.dart';
import 'package:demo_app/core/widgets/navigation.dart';
import 'package:demo_app/core/widgets/side_frame_master.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/new_theme.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide Border, BorderStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/inventory_module/core/navigate.dart';
import 'package:demo_app/features/roles/presentation/ui/pages/user_management/uoload_file_details.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:desktop_drop/desktop_drop.dart'; // Add this dependency


import '../../../../../../../../../generated/l10n.dart';

// REMOVED_MODULE: import '../../../../../../external/inventory_module/core/custom_button_widget.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/Category/presentation/ui/service_department_manager/tablet/s1_create_service/data_upload/upload_file_details_toggle.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/Category/presentation/ui/services_admin/Widget/W3_Frame_Screen_tablet.dart' show SideFrameMasterServices;
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/core/new_theme.dart';


class UploadFileTabletRoles extends StatefulWidget {
  const UploadFileTabletRoles({super.key});
  ////
  @override
  State<UploadFileTabletRoles> createState() => _UploadFileTabletRolesState();
}

class _UploadFileTabletRolesState extends State<UploadFileTabletRoles> {
  // Add drag and drop state variables
  bool _isDragging = false;
  bool _isHovering = false;

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

  final List<String> expectedHeaders = [
    'Employee ID',
    'Current Role Type',
    'Desired Role Type',
    'Access Granted',
    'Access Revoked',
    'Status',
  ];

  String? selectedFileName;

  bool validateHeaders(List<String> headers) {
    if (headers.length != expectedHeaders.length) return false;
    for (int i = 0; i < headers.length; i++) {
      if (headers[i].trim() != expectedHeaders[i].trim()) return false;
    }
    return true;
  }

  String? validateCell(String key, String? value, {Map<String, TextEditingController>? rowData}) {
    // Handle conditional fields that can be empty based on other field values
    if (key == 'Access Granted') {
      final statusCtrl = rowData?['Status'];
      final status = statusCtrl?.text.trim().toLowerCase() ?? '';
      if (status == 'revoke') {
        // When status is "revoke", Access Granted can be empty - no validation
        return null;
      }
    }

    if (key == 'Access Revoked') {
      final statusCtrl = rowData?['Status'];
      final status = statusCtrl?.text.trim().toLowerCase() ?? '';
      if (status == 'grant') {
        // When status is "grant", Access Revoked can be empty - no validation
        return null;
      }
    }

    if (value == null || value.trim().isEmpty) return 'Required';
    value = value.trim();

    if (value.toLowerCase() == 'null') return 'Warning Wrong Entry';

    bool hasMultipleWords(String val) => val.trim().contains(' ');
    bool hasExtraSpaces(String val) => RegExp(r'\s{2,}').hasMatch(val);
    bool isArabic(String text) => RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(text);
    bool isEnglish(String text) => RegExp(r'^[a-zA-Z\s]+$').hasMatch(text);
    bool hasSpecialChars(String text) => RegExp(r'[!@#<>?":_~;\[\]\\|=+)(*&^%$]').hasMatch(text);
    bool hasNumbers(String text) => RegExp(r'\d').hasMatch(text);
    bool containsArabic(String text) => RegExp(r'[\u0600-\u06FF]').hasMatch(text);
    bool containsEnglish(String text) => RegExp(r'[a-zA-Z]').hasMatch(text);

    // ✅ Detect duplicate for Employee ID only
    if (['Employee ID'].contains(key)) {
      final currentValue = value.toLowerCase().trim();
      int count = 0;

      for (var row in formData) {
        final otherValue = row[key]?.text.toLowerCase().trim();
        if (otherValue == currentValue) count++;
      }

      if (count > 1) return 'Duplicate value – must be unique';
    }

    switch (key.trim()) {
      case 'Employee ID':
      // Employee ID should be alphanumeric, no special chars, no spaces
        if (value.contains(' ')) return 'Warning Format Issue';
        if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%$]').hasMatch(value)) {
          return 'Warning Format Issue';
        }
        if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
          return 'Warning Format Issue';
        }
        if (value.length < 2) return 'Warning Format Issue';
        break;

      case 'Current Role Type':
      // Should be English text only, no numbers, no Arabic, allow spaces
        if (containsArabic(value)) return 'Warning Language Check';
        if (hasNumbers(value)) return 'Warning Format Issue';
        if (hasSpecialChars(value)) return 'Warning Format Issue';
        if (!isEnglish(value)) return 'Warning Language Check';
        if (hasExtraSpaces(value)) return 'Warning Format Issue';
        if (value.length < 2) return 'Warning Format Issue';
        break;

      case 'Desired Role Type':
      // Should be English text only, no numbers, no Arabic, allow spaces
        if (containsArabic(value)) return 'Warning Language Check';
        if (hasNumbers(value)) return 'Warning Format Issue';
        if (hasSpecialChars(value)) return 'Warning Format Issue';
        if (!isEnglish(value)) return 'Warning Language Check';
        if (hasExtraSpaces(value)) return 'Warning Format Issue';
        if (value.length < 2) return 'Warning Format Issue';
        break;

      case 'Access Granted':
        final statusCtrl = rowData?['Status'];
        final status = statusCtrl?.text.trim().toLowerCase() ?? '';

        // Only validate if Status is "grant"
        if (status == 'grant') {
          // Validate comma-separated permissions
          if (value.startsWith(',') || value.endsWith(',')) {
            return 'Warning Misplaced Comma';
          }

          if (value.contains(',,')) {
            return 'Warning Misplaced Comma';
          }

          // Check for spaces around commas
          if (RegExp(r'\s*,\s*').hasMatch(value) && value.contains(' ')) {
            return 'Warning Format Issue';
          }

          // Check for invalid characters (only allow letters, numbers, and commas)
          if (RegExp(r'[!@#<>?":_~;\[\]\\|=+)(*&^%$\s]').hasMatch(value)) {
            return 'Warning Format Issue';
          }

          final permissions = value.split(',').map((e) => e.trim()).toList();

          for (final perm in permissions) {
            if (perm.isEmpty) {
              return 'Warning Misplaced Comma';
            }

            if (perm.length < 2) {
              return 'Warning Format Issue';
            }

            // Each permission should be alphanumeric
            if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(perm)) {
              return 'Warning Format Issue';
            }
          }
        }
        break;

      case 'Access Revoked':
        final statusCtrl = rowData?['Status'];
        final status = statusCtrl?.text.trim().toLowerCase() ?? '';

        // Only validate if Status is "revoke"
        if (status == 'revoke') {
          // Validate comma-separated permissions
          if (value.startsWith(',') || value.endsWith(',')) {
            return 'Warning Misplaced Comma';
          }

          if (value.contains(',,')) {
            return 'Warning Misplaced Comma';
          }

          // Check for spaces around commas
          if (RegExp(r'\s*,\s*').hasMatch(value) && value.contains(' ')) {
            return 'Warning Format Issue';
          }

          // Check for invalid characters (only allow letters, numbers, and commas)
          if (RegExp(r'[!@#<>?":_~;\[\]\\|=+)(*&^%$\s]').hasMatch(value)) {
            return 'Warning Format Issue';
          }

          final permissions = value.split(',').map((e) => e.trim()).toList();

          for (final perm in permissions) {
            if (perm.isEmpty) {
              return 'Warning Misplaced Comma';
            }

            if (perm.length < 2) {
              return 'Warning Format Issue';
            }

            // Each permission should be alphanumeric
            if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(perm)) {
              return 'Warning Format Issue';
            }
          }
        }
        break;

      case 'Status':
        final normalized = value.toLowerCase();
        if (!['grant', 'revoke'].contains(normalized)) {
          return 'Warning Wrong Entry';
        }
        break;
    }

    return null;
  }

  // Enhanced method to handle both file picker and drag-drop
  Future<void> processFile(List<int> bytes, String fileName) async {
    selectedFileName = fileName;

    // Show loading with a key to track it
    final dialogKey = GlobalKey();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        key: dialogKey,
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Processing file..."),
          ],
        ),
      ),
    );

    try {
      var excel = Excel.decodeBytes(bytes);

      if (excel.tables.isEmpty) {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading
        await Future.delayed(Duration(milliseconds: 100));
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
          debugPrint('⚠️ Sheet "$tableName" has less than 2 rows, skipping...');
          continue;
        }

        List<String> actualHeaders = [];
        if (rows.isNotEmpty && rows[0].isNotEmpty) {
          actualHeaders = rows[0]
              .map((cell) => cell?.value?.toString()?.trim() ?? '')
              .where((header) => header.isNotEmpty)
              .toList();
        }

        if (actualHeaders.isEmpty) {
          debugPrint('⚠️ Sheet "$tableName" has no valid headers, skipping...');
          continue;
        }

        List<String> missingHeaders = expectedHeaders
            .where((h) => !actualHeaders.contains(h))
            .toList();
        List<String> unknownHeaders = actualHeaders
            .where((h) => !expectedHeaders.contains(h))
            .toList();

        debugPrint('👉 Sheet: $tableName');
        debugPrint('👉 Actual headers: $actualHeaders');
        debugPrint('👉 Expected headers: $expectedHeaders');
        debugPrint('👉 Missing headers (${missingHeaders.length}): $missingHeaders');
        debugPrint('👉 Unknown headers (${unknownHeaders.length}): $unknownHeaders');

        if (missingHeaders.length >= 3) {
          Navigator.of(context, rootNavigator: true).pop(); // Close loading
          await Future.delayed(Duration(milliseconds: 100));
          _showHeaderErrorDialog(missingHeaders);
          return;
        }

        if (missingHeaders.isNotEmpty && missingHeaders.length < 3) {
          _showMissingHeadersWarning(missingHeaders);
        }

        if (unknownHeaders.isNotEmpty) {
          _showAdditionalColumnsWarning(unknownHeaders);
        }

        for (int i = 1; i < rows.length; i++) {
          if (rows[i].isEmpty) continue;

          Map<String, TextEditingController> rowControllers = {};
          Map<String, String> rowErrors = {};

          for (final header in expectedHeaders) {
            String cellValue = '';

            if (actualHeaders.contains(header)) {
              int colIndex = actualHeaders.indexOf(header);
              if (colIndex < rows[i].length && rows[i][colIndex] != null) {
                var cellData = rows[i][colIndex]!.value;
                cellValue = cellData?.toString().trim() ?? '';
              }
            }

            rowControllers[header] = TextEditingController(text: cellValue);

            String? error = validateCell(header, cellValue.isEmpty ? null : cellValue, rowData: rowControllers);
            if (error != null) {
              rowErrors[header] = error;
            }

            if (!actualHeaders.contains(header)) {
              rowErrors[header] = 'Warning Invalid Column Title';
            }
          }

          parsedFormData.add(rowControllers);
          parsedValidationErrors.add(rowErrors);
        }

        fileProcessed = true;
        break;
      }

      // Close loading dialog FIRST
      Navigator.of(context, rootNavigator: true).pop();
      await Future.delayed(Duration(milliseconds: 300));

      if (!fileProcessed) {
        _showErrorDialog('No valid data found in the Excel file.');
        return;
      }

      if (parsedFormData.isEmpty) {
        _showErrorDialog('No data rows found in the Excel file.');
        return;
      }

      if (!mounted) return;

      // Set formData for future reference
      setState(() {
        formData = parsedFormData;
        validationErrors = parsedValidationErrors;
      });

      debugPrint('🎯 Processed ${parsedFormData.length} rows with ${parsedValidationErrors.length} validation entries');

      // Navigate to details page
      navigateTo(
        context,
        UploadFileDetailsTabletRoles(
          formData: parsedFormData,
          validationErrors: parsedValidationErrors,
          selectedFileName: selectedFileName,
        ),
      );

    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop(); // Close loading
      await Future.delayed(Duration(milliseconds: 100));
      debugPrint('❌ Excel processing error: $e');
      _showErrorDialog('Failed to process Excel file: ${e.toString()}');
    }
  }

  // File picker method (your existing method but simplified)
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
      debugPrint('❌ File picker error: $e');
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

  // Your existing helper methods
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (BuildContext dialogContext) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Processing file...",style: StyleText.fontSize18Weight500.copyWith(

                color: AppColors.text
              ),),
            ],
          ),
        ),
      ),
    );
  }

  void _hideLoadingDialog() {
    try {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    } catch (e) {
      debugPrint('❌ Error hiding dialog: $e');
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
              style: StyleText.fontSize20Weight500.copyWith(
                  color: AppColors.text
              ),
            ),
            SizedBox(height: 16.sp),
            Text(
              message,
              style: StyleText.fontSize12Weight500.copyWith(
                  color: AppColors.secondaryText
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
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
              "Warning Invalid Column Title",
              style: StyleText.fontSize20Weight500.copyWith(
                  color: AppColors.text
              ),
            ),
            SizedBox(height: 16.sp),
            Text(
              "Some required columns are missing: ${missingHeaders.join(', ')}",
              style: StyleText.fontSize12Weight500.copyWith(
                  color: AppColors.secondaryText
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showMissingHeadersWarning(List<String> missingHeaders) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Warning Invalid Column Title: ${missingHeaders.join(', ')}'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showAdditionalColumnsWarning(List<String> additionalHeaders) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Warning Additional Column: ${additionalHeaders.join(', ')}'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.orange,
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
      debugPrint('❌ Permission error: $e');
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;

    return SideFrameMaster(
      titleText: S.of(context).service,
      onFirstTap: (){
        Navigator.pop(context);
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
                              : (AppColors.card),
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
                                style: StyleText.fontSize20Weight500.copyWith(
                                  color: _isDragging
                                      ? AppColors.primary
                                      : (AppColors.text),
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
                customButton(
                  title: S.of(context).discard,
                  function: () {
                    setState(() {
                      selectedFileName = null;
                      formData.clear();
                      validationErrors.clear();
                    });
                  },
                  textStyle: StyleText.fontSize16Weight600.copyWith(
                    color: AppColors.text,
                  ),
                  width: 150.sp,
                  height: 38.sp,
                  radius: 8.r,
                  color: AppColors.secondaryText,
                ),

                Spacer(),

                customButton(
                  title: S.of(context).browseFiles,
                  function: pickAndParseExcel,
                  textStyle: StyleText.fontSize16Weight600.copyWith(
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
                        style: StyleText.fontSize14Weight500.copyWith(
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