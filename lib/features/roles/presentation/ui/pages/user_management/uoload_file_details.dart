/// ******************* FILE INFO *******************
/// File Name: upload_file_details.dart
/// Description: upload and edit data which come from bulk upload
/// Created by: Amr Mesbah

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/core/helper/helper_function.dart';
import 'package:demo_app/core/widgets/custom_button_widget.dart';
import 'package:demo_app/core/widgets/navigation.dart';
import 'package:demo_app/core/widgets/shared_action_widgets.dart';
import 'package:demo_app/core/widgets/side_frame_master.dart';
import 'package:demo_app/core/theme/new_theme.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:demo_app/features/data_grc_module/grc_module/grc_owner/presentation/widgets/add_champion/upload_file_details_toggle.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

// REMOVED: company_contact_info not available
import '../../../../../../../../../generated/l10n.dart';
// REMOVED: employee_personal_info not available
// REMOVED_MODULE: import '../../../../../../external/inventory_module/core/custom_button_widget.dart';
// REMOVED_MODULE: import '../../../../../../external/inventory_module/core/navigate.dart';
// REMOVED_MODULE: import '../../../../../../external/inventory_module/core/sheard.dart';

import 'package:demo_app/core/network/get_base_url.dart';
import '../../../../../../core/theme/app_colors.dart' show AppColors;
import '../../../../../employee/data/models/emplyees_model/new_employee_model.dart';
import '../../../../../employee/presentation/controller/main_core_employee_controller.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/Category/presentation/ui/services_admin/Widget/W3_Frame_Screen_tablet.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/core/constant/constant.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/core/new_theme.dart';




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
            : Border.all(
            color: borderColor ?? AppColors.grey, width: 1.5.sp),
      ),
      child: Center(
        child: Icon(Icons.check,
            size: (size ?? 20.sp) - 4.sp,
            color: isSelected ? Colors.white : Colors.transparent),
      ),
    );
  }
}

class UploadFileDetailsTabletRoles extends StatefulWidget {
  const UploadFileDetailsTabletRoles({super.key, required this.formData, required this.validationErrors,this.selectedFileName});

  final List<Map<String, TextEditingController>> formData;
  final List<Map<String, String>> validationErrors;
  final String? selectedFileName;

  @override
  State<UploadFileDetailsTabletRoles> createState() => _UploadFileDetailsTabletRolesState();
}

class _UploadFileDetailsTabletRolesState extends State<UploadFileDetailsTabletRoles> {

  List<Map<String, GlobalKey>> fieldKeys = [];

  final _formKey = GlobalKey<FormState>();
  List<Map<String, TextEditingController>> formData = [];
  List<Map<String, TextEditingController>> filteredData = [];
  List<Map<String, String>> validationErrors = [];
  Set<int> selectedRows = {};
  String primaryKey = 'Employee ID';
  String searchQuery = '';
  final List<String> expectedHeaders = [
    'Employee ID',
    'Current Role Type',
    'Desired Role Type',
    'Access Granted',
    'Access Revoked',
    'Status',
  ];

  @override
  void initState() {
    super.initState();

    formData = widget.formData;
    validationErrors = widget.validationErrors;
    filteredData = List.from(widget.formData);

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

    // Initialize error locations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateErrorLocations();
    });
  }

  int currentPage = 0;

  bool isValidEmail(String email) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
  bool isArabic(String text) => RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(text);
  bool isEnglish(String text) => RegExp(r'^[a-zA-Z\s]+$').hasMatch(text);
  bool hasSpecialChars(String text) => RegExp(r'[!@#<>?":_~;[\]\\|=+)(*&^%0-9]').hasMatch(text);
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

  String? validateCell(String key, String? value, {Map<String, TextEditingController>? rowData}) {
    // No conditional validation - Access Granted and Access Revoked are always independent

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
      // Always validate - independent of Status
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
        break;

      case 'Access Revoked':
      // Always validate - independent of Status
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
        break;

      case 'Status':
      // Status must be one of: Active, Inactive, Scheduled, Expiring Soon (case insensitive)
        final normalized = value.toLowerCase();
        const allowedStatuses = ['active', 'inactive', 'scheduled', 'expiring soon'];
        if (!allowedStatuses.contains(normalized)) {
          return 'Warning Wrong Entry';
        }
        break;
    }

    return null;
  }

  String? selectedFileName;
  Future<void> pickAndParseExcel() async {
    await requestStoragePermission();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      selectedFileName = file.path.split('/').last; // Extract just the file name
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
        List<String> missingHeaders = expectedHeaders
            .where((h) => !actualHeaders.contains(h))
            .toList();
        List<String> unknownHeaders = actualHeaders
            .where((h) => !expectedHeaders.contains(h))
            .toList();

        // 🔍 Always print this BEFORE any return
        debugPrint('👉 Actual headers: $actualHeaders');
        debugPrint('👉 Expected headers: $expectedHeaders');
        debugPrint('👉 Missing headers (${missingHeaders.length}): $missingHeaders');
        debugPrint('👉 Unknown headers (${unknownHeaders.length}): $unknownHeaders');

        // ❌ Reject file if 3+ expected headers are missing
        if (missingHeaders.length >= 3) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Warning Invalid Column Title"),
              content: Text(
                "The Excel file is not accepted.\n\nMissing columns: ${missingHeaders.join(', ')}\nUnknown columns: ${unknownHeaders.join(', ')}",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
          );
          return;
        }

        // ✅ Allow preview if 1–2 columns missing
        if (missingHeaders.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Warning Invalid Column Title: ${missingHeaders.join(', ')}'),
              backgroundColor: Colors.orange,
            ),
          );
        }

        if (unknownHeaders.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Warning Additional Column: ${unknownHeaders.join(', ')}'),
              backgroundColor: Colors.orange,
            ),
          );
        }

        // 📦 Parse rows
        for (int i = 1; i < rows.length; i++) {
          Map<String, TextEditingController> rowControllers = {};
          Map<String, String> rowErrors = {};

          for (final header in expectedHeaders) {
            if (actualHeaders.contains(header)) {
              int colIndex = actualHeaders.indexOf(header);
              String value = rows[i][colIndex]?.value.toString() ?? '';
              rowControllers[header] = TextEditingController(text: value);
              String? error = validateCell(header, value, rowData: rowControllers);
              if (error != null) rowErrors[header] = error;
            } else {
              rowControllers[header] = TextEditingController(text: '');
              rowErrors[header] = 'Warning Invalid Column Title';
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
          selectedFileName: selectedFileName, // ✅ Pass the file name
        ),
      );
    }
  }

  final ScrollController _scrollController = ScrollController();

  final Map<String, String> columnToFirestoreField = {
    'Employee ID': 'employeeId',
    'Current Role Type': 'currentRoleType',
    'Desired Role Type': 'Role',
    'Access Granted': 'From_Date',
    'Access Revoked': 'To_Date',
    'Status': 'status',
  };

  Future<void> uploadToFirebase() async {
    final firestore = FirebaseFirestore.instance;
    final accessCollection = firestore.collection(getBaseUrl(FirestoreCollections.accessEmployee));
    final employeesCollection = firestore.collection(getBaseUrl(FirestoreCollections.employeeInfo)); // Assuming this is the correct collection name

    int success = 0, updated = 0, failed = 0;

    for (var row in formData) {
      String employeeId = row[primaryKey]?.text.trim() ?? '';
      if (employeeId.isEmpty) {
        failed++;
        continue;
      }

      try {
        final now = DateTime.now().millisecondsSinceEpoch;

        // ✅ Step 1: Update/Create document in accessEmployee collection
        final accessDocRef = accessCollection.doc(employeeId);
        final accessDocSnapshot = await accessDocRef.get();

        if (accessDocSnapshot.exists) {
          // ✅ APPEND to existing arrays (not replace)
          Map<String, dynamic> updateData = {};

          // Add timestamp to timestamps array
          updateData['timestamps'] = FieldValue.arrayUnion([now]);

          row.forEach((key, controller) {
            String value = controller.text.trim();
            final firestoreField = columnToFirestoreField[key] ?? key;

            // Append to arrays (preserving existing data)
            updateData[firestoreField] = FieldValue.arrayUnion([value]);
          });

          await accessDocRef.update(updateData);
          updated++;
        } else {
          // ✅ CREATE new document with arrays
          Map<String, dynamic> data = {};

          data['timestamps'] = [now];

          row.forEach((key, controller) {
            String value = controller.text.trim();
            final firestoreField = columnToFirestoreField[key] ?? key;
            data[firestoreField] = [value];
          });

          await accessDocRef.set(data);
          success++;
        }

        // ✅ Step 2: Update Employee's Role in Employees_Info collection
        String desiredRole = row['Desired Role Type']?.text.trim() ?? '';

        if (desiredRole.isNotEmpty) {
          final employeeDocRef = employeesCollection.doc(employeeId);
          final employeeDocSnapshot = await employeeDocRef.get();

          if (employeeDocSnapshot.exists) {
            // Get existing employee data using NewEmployeeModelHistory
            final employeeData = NewEmployeeModelHistory.fromMap(employeeDocSnapshot.data());

            // Check if role already exists in the list
            bool roleExists = false;
            if (employeeData.role.isNotEmpty) {
              // Check the last role entry
              String lastRole = employeeData.role.last;
              roleExists = lastRole == desiredRole;
            }

            if (!roleExists) {
              // Add new role using the synchronized update method
              final updatedEmployee = employeeData.copyWithUpdateSynchronized(
                role: desiredRole,
                addTimestamp: now,
              );

              // Update Firestore
              await employeeDocRef.update(updatedEmployee.toMap());
              debugPrint('✅ Updated role for employee $employeeId: $desiredRole');
            } else {
              debugPrint('ℹ️ Role $desiredRole already exists for employee $employeeId');
            }
          } else {
            debugPrint('⚠️ Employee document not found for ID: $employeeId');
          }
        }

      } catch (e) {
        failed++;
        debugPrint('❌ Error uploading $employeeId: $e');
      }
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Upload complete: $success added, $updated updated, $failed failed.'),
      ),
    );
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
      filteredData = query.isEmpty ? List.from(formData) : formData.where((row) {
        return row.entries.any((entry) => entry.value.text.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    });
  }

  void saveLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> simpleData = formData.map((row) {
      return row.map((key, controller) => MapEntry(key, controller.text));
    }).toList();
    prefs.setString('saved_excel_data', jsonEncode(simpleData));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data saved locally.")));
  }

  void loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('saved_excel_data');
    if (data != null) {
      List decoded = jsonDecode(data);
      List<Map<String, TextEditingController>> loaded = decoded.map((row) {
        return Map<String, TextEditingController>.fromEntries(
          (row as Map).entries.map((e) => MapEntry(e.key, TextEditingController(text: e.value))),
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
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this row?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
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

  //////////////////////////////////////////////////////////////////////////////////

  List<Map<String, FocusNode>> focusNodes = [];
  List<MapEntry<int, String>> errorLocations = [];
  int currentErrorIndex = -1; // Start with -1 to indicate no selection

  // ✅ UPDATE ERROR LOCATION LIST
  void updateErrorLocations() {
    errorLocations.clear();
    for (int row = 0; row < validationErrors.length; row++) {
      validationErrors[row].forEach((header, error) {
        errorLocations.add(MapEntry(row, header));
      });
    }

    // Reset current index if no errors or index is out of bounds
    if (errorLocations.isEmpty) {
      currentErrorIndex = -1;
    } else if (currentErrorIndex >= errorLocations.length || currentErrorIndex < 0) {
      currentErrorIndex = 0;
    }

    debugPrint('🔍 Updated error locations: ${errorLocations.length} errors found, currentIndex: $currentErrorIndex');
  }

  void focusErrorField(bool forward) {
    if (errorLocations.isEmpty) {
      debugPrint('⚠️ No errors to navigate');
      return;
    }

    setState(() {
      if (forward) {
        currentErrorIndex = (currentErrorIndex + 1) % errorLocations.length;
      } else {
        currentErrorIndex = (currentErrorIndex - 1 + errorLocations.length) % errorLocations.length;
      }
    });

    final entry = errorLocations[currentErrorIndex];
    final rowIndex = entry.key;
    final header = entry.value;

    debugPrint('🎯 Navigating to error $currentErrorIndex: Row $rowIndex, Column $header');

    final controller = formData[rowIndex][header];
    final node = focusNodes[rowIndex][header];
    final key = fieldKeys[rowIndex][header];

    // Scroll to the field first, then focus
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
            // Focus after scrolling is complete
            if (controller != null && node != null) {
              controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
              FocusScope.of(context).requestFocus(node);
              debugPrint('✅ Focused on field: $header');
            }
          });
        } else {
          debugPrint('❌ Could not find context for field: $header');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return SideFrameMaster(
      titleText: S.of(context).service,
      onFirstTap: (){

      },
      secondTitle: S.of(context).bulkUpload,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // File Name
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${widget.selectedFileName}',
                    style: StyleText.fontSize24Weight600.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
              //space
              SizedBox(height: 23.sp),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Error Counter with WORKING navigation
                  Container(
                    height: 30.sp,
                    width: 138.sp,
                    decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(4.r)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ⬅️ Previous Error
                        GestureDetector(
                          onTap: () {
                            if (errorLocations.isEmpty) {
                              updateErrorLocations();
                            }
                            if (errorLocations.isNotEmpty) {
                              focusErrorField(false); // Navigate to previous error
                              setState(() {}); // Trigger rebuild to update counter
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.sp),
                            child: Transform.rotate(
                              angle: Localizations.localeOf(context).languageCode == 'ar' ? 3.14159 : 0, // 180 degrees in radians for RTL
                              child: SvgPicture.asset(
                                "assets/arrowleft.svg",
                                width: 15.sp,
                                height: 15.sp,
                                color: errorLocations.isEmpty
                                    ? Colors.grey.shade400
                                    : (AppColors.text),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 9.sp),
                        Text(
                          "${S.of(context).error}: ",
                          style: StyleText.fontSize16Weight500.copyWith(
                            color: AppColors.text,
                          ),
                        ),
                        Text(
                          getTotalErrorCount() > 0
                              ? "${currentErrorIndex + 1}/${getTotalErrorCount()}"
                              : "${getTotalErrorCount()}",
                          style: StyleText.fontSize16Weight500.copyWith(
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(width: 9.sp),
                        // ➡️ Next Error
                        GestureDetector(
                          onTap: () {
                            if (errorLocations.isEmpty) {
                              updateErrorLocations();
                            }
                            if (errorLocations.isNotEmpty) {
                              focusErrorField(true); // Navigate to next error
                              setState(() {}); // Trigger rebuild to update counter
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.sp),
                            child: Transform.rotate(
                              angle: Localizations.localeOf(context).languageCode == 'ar' ? 3.14159 : 0, // 180 degrees in radians for RTL
                              child: SvgPicture.asset(
                                "assets/arrow_right.svg",
                                width: 15.sp,
                                height: 15.sp,
                                color: errorLocations.isEmpty
                                    ? Colors.grey.shade400
                                    : (AppColors.text),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ),

                  Spacer(),

                  customButtonWithImage(
                      title: S.of(context).removeSelection,
                      function: () {
                        if (selectedRows.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please select at least one row to remove.")),
                          );
                          return;
                        }

                        setState(() {
                          // Sort descending to avoid index shifting
                          final sortedRows = selectedRows.toList()..sort((a, b) => b.compareTo(a));
                          for (final index in sortedRows) {
                            formData.removeAt(index);
                            validationErrors.removeAt(index);
                            focusNodes.removeAt(index);
                            fieldKeys.removeAt(index);
                          }
                          selectedRows.clear();
                          filteredData = List.from(formData);
                          // Update error locations after removing rows
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            updateErrorLocations();
                          });
                        });
                      },
                      textStyle: StyleText.fontSize16Weight500.copyWith(
                          color: ColorAppLight.whiteColor
                      ),
                      width: 166.sp,
                      height: 30.sp,
                      space: 8.sp,
                      radius: 4.r,
                      color: Colors.black,
                      image: "assets/minus.svg",
                      svgColor: ColorAppLight.whiteColor,
                      widthImage: 12.sp,
                      heightImage: 1.5.sp,
                      colorBorder: Colors.transparent
                  ),
                  SizedBox(width: 10.sp,),
                  customButton(
                    title: S.of(context).duplication,
                    function: () {
                      if (selectedRows.length != 1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please select exactly one row to duplicate.")),
                        );
                        return;
                      }

                      final indexToDuplicate = selectedRows.first;
                      final original = formData[indexToDuplicate];
                      final originalErrors = validationErrors[indexToDuplicate];

                      // 🔁 Deep copy controllers
                      final newRow = <String, TextEditingController>{};
                      for (final entry in original.entries) {
                        newRow[entry.key] = TextEditingController(text: entry.value.text);
                      }

                      // 🔁 Deep copy errors
                      final newErrors = Map<String, String>.from(originalErrors);

                      // ✅ Create matching focus nodes for the new row
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

                        // 🔁 Run validation after duplication
                        int newIndex = formData.length - 1;
                        final newRowData = formData[newIndex];
                        final newErrorMap = <String, String>{};
                        for (final header in expectedHeaders) {
                          final value = newRowData[header]?.text ?? '';
                          final error = validateCell(header, value, rowData: newRowData);
                          if (error != null) newErrorMap[header] = error;
                        }
                        validationErrors[newIndex] = newErrorMap;

                        // Update error locations after duplication
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          updateErrorLocations();
                        });
                      });
                    },
                    textStyle: StyleText.fontSize16Weight500.copyWith(
                        color: ColorAppLight.whiteColor
                    ),
                    width: 103.sp,
                    height: 30.sp,
                    radius: 4.r,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10.sp,),
                  customButtonWithImage(
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

                          // Update error locations after adding row
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            updateErrorLocations();
                          });
                        });
                      },

                      textStyle: StyleText.fontSize16Weight500.copyWith(
                          color: ColorAppLight.whiteColor
                      ),
                      width: 82.sp,
                      height: 30.sp,
                      space: 8.sp,
                      radius: 4.r,
                      color: Colors.black,
                      image: "assets/plus.svg",
                      svgColor: ColorAppLight.whiteColor,
                      widthImage: 12.sp,
                      heightImage: 12.sp,
                      colorBorder: Colors.transparent
                  ),

                ],
              ),

              SizedBox(height: 10.sp),
              if (formData.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                      color: lightMode ? ColorAppLight.whiteColor : ColorAppDark.chatBackground,
                      borderRadius: BorderRadius.circular(8.r)
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: (expectedHeaders.length * 265) + 90, // Extra for checkbox column
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Total Services Text
                            Padding(
                              padding: EdgeInsets.only(left: 10.sp, top: 10.sp,right: 10),
                              child: Container(
                                width: 124.sp,
                                height: 25.sp,
                                decoration: BoxDecoration(
                                    color: lightMode
                                        ? ColorAppLight.whiteOp
                                        : ColorAppDark.background,
                                    borderRadius: BorderRadius.circular(4.r)
                                ),
                                child: Center(
                                  child: Text(
                                    "${S.of(context).totalRoles}: ${formData.length}",
                                    style: StyleText.fontSize14Weight500.copyWith(
                                      color: lightMode
                                          ? ColorAppLight.blackButton
                                          : ColorAppDark.titleValue,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 10.sp),

                            // Table
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
                                        padding: EdgeInsets.symmetric(horizontal: 33.sp),
                                        child: Row(

                                          children: [
                                            ...expectedHeaders.map((header) {
                                              final isMixedLang = RegExp(r'[a-zA-Z]').hasMatch(header) && RegExp(r'[\u0600-\u06FF]').hasMatch(header);
                                              final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(header);
                                              final isEnglish = RegExp(r'[a-zA-Z]').hasMatch(header);

                                              // Split Arabic and English words if mixed
                                              String arabicPart = '';
                                              String englishPart = '';

                                              if (isMixedLang) {
                                                arabicPart = header.replaceAll(RegExp(r'[a-zA-Z0-9]'), '').trim();
                                                englishPart = header.replaceAll(RegExp(r'[^\x00-\x7F]'), '').trim();
                                              }

                                              return Container(
                                                width: 250,
                                                margin: const EdgeInsets.only(right: 12),
                                                alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                                                child: isMixedLang
                                                    ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      arabicPart,
                                                      textAlign: TextAlign.right,
                                                      style: StyleText.fontSize16Weight500.copyWith(
                                                        color: lightMode ? ColorAppLight.blackButton : ColorAppDark.titleValue,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6), // spacing between Arabic and English
                                                    Text(
                                                      englishPart,
                                                      textAlign: TextAlign.left,
                                                      style: StyleText.fontSize16Weight500.copyWith(
                                                        color: lightMode ? ColorAppLight.blackButton : ColorAppDark.titleValue,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                                    : Text(
                                                  header,
                                                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                                  style: StyleText.fontSize16Weight500.copyWith(
                                                    color: lightMode ? ColorAppLight.blackButton : ColorAppDark.titleValue,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ],
                                        ),
                                      );
                                    }

                                    final rowIndex = index - 1;
                                    final row = formData[rowIndex];
                                    final isSelected = selectedRows.contains(rowIndex);

                                    return Padding(
                                      padding:  EdgeInsets.only(top: 10.h,bottom: 10.h,right: 10.w) ,
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
                                                  : Colors.grey.shade400,
                                            ),
                                          ),
                                          SizedBox(width: 10.sp),
                                          ...expectedHeaders.map((header) {
                                            return Padding(
                                                padding: const EdgeInsets.only(right: 12),
                                                child: KeyedSubtree(
                                                  key: fieldKeys[rowIndex][header],
                                                  child: CustomExcelTextField(
                                                    controller: row[header]!,
                                                    focusNode: focusNodes[rowIndex][header],
                                                    placeholder: header,
                                                    width: 250,
                                                    height: 36,
                                                    showHeader: false,
                                                    headerLabel: '',
                                                    errorText: validationErrors.length > rowIndex ? validationErrors[rowIndex][header] : null,
                                                    rowIndex: rowIndex,
                                                    validator: (key, index) {
                                                      final value = formData[index][key]?.text ?? '';
                                                      final error = validateCell(key, value, rowData: formData[index]);
                                                      if (error != null) {
                                                        validationErrors[index][key] = error;
                                                      } else {
                                                        validationErrors[index].remove(key);
                                                      }

                                                      // No conditional re-validation needed since Status is independent

                                                      // Update error locations after validation changes
                                                      setState(() {
                                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                                          updateErrorLocations();
                                                        });
                                                      });
                                                    },
                                                  ),
                                                )

                                            );
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
                    function: (){},
                    textStyle: StyleText.fontSize16Weight500.copyWith(
                        color: Colors.black
                    ),
                    width: 150.sp,
                    height: 38.sp,
                    radius: 8.r,
                    color: ColorAppLight.grayHead,
                  ),

                  Spacer(),

                  customButton(
                    title: S.of(context).activate,
                    function: () {
                      if (getTotalErrorCount() > 0) {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                            contentPadding: EdgeInsets.all(20.sp),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Lottie.asset(
                                  'assets/lottie/rejected.json',
                                  width: 90.sp,
                                  height: 90.sp,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: 20.sp),
                                Text(
                                  "You must correct all errors before uploading",
                                  style: StyleText.fontSize18Weight500.copyWith(
                                    color: lightMode ? ColorAppLight.grayTextSla : ColorAppDark.titleKey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                        return;
                      }
                      else
                      {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                            contentPadding: EdgeInsets.all(20.sp),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Lottie.asset(
                                  'assets/lottie/createServices.json',
                                  width: 90.sp,
                                  height: 90.sp,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: 15.sp),
                                Text(
                                  S.of(context).activatingRoles,
                                  style: StyleText.fontSize20Weight500.copyWith(
                                    color: lightMode ? ColorAppLight.grayTextSla : ColorAppDark.titleKey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 18.sp),
                                Text(
                                  S.of(context).confirmActivateRoles,
                                  style: StyleText.fontSize18Weight500.copyWith(
                                    color: lightMode ? ColorAppLight.grayTextSla : ColorAppDark.titleKey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 15.sp),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    customButton(
                                        title: S.of(context).no,
                                        function: (){
                                          Navigator.pop(context);
                                        },
                                        textStyle: StyleText.fontSize18Weight500.copyWith(
                                          color: Colors.black
                                        ),
                                        width: 135.sp,
                                        height: 38.sp,
                                        radius: 4.r,
                                        color: ColorAppLight.grayTextSla
                                    ),

                                    SizedBox(width: 28.sp),

                                    customButton(
                                        title: S.of(context).yes,
                                        function: () async {
                                          // ✅ Store the current context BEFORE async operations
                                          final scaffoldContext = context;

                                          // Close the confirmation dialog
                                          Navigator.pop(scaffoldContext);

                                          // Perform the upload
                                          await uploadToFirebase();

                                          // ✅ Check if widget is still mounted before showing success dialog
                                          if (!mounted) return;

                                          // Show success dialog
                                          customButton(
                                            title: "Activate ",
                                            function: () {
                                              // ✅ Capture the widget's context HERE (outside all dialogs)
                                              final widgetContext = context;

                                              if (getTotalErrorCount() > 0) {
                                                showDialog(
                                                  context: widgetContext,
                                                  barrierDismissible: true,
                                                  builder: (context) => AlertDialog(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                                                    contentPadding: EdgeInsets.all(20.sp),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Lottie.asset(
                                                          'assets/lottie/rejected.json',
                                                          width: 90.sp,
                                                          height: 90.sp,
                                                          fit: BoxFit.contain,
                                                        ),
                                                        SizedBox(height: 20.sp),
                                                        Text(
                                                          "You must correct all errors before uploading",
                                                          style: StyleText.fontSize18Weight500.copyWith(
                                                            color: lightMode ? ColorAppLight.grayTextSla : ColorAppDark.titleKey,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }
                                              else
                                              {
                                                showDialog(
                                                  context: widgetContext,
                                                  barrierDismissible: true,
                                                  builder: (dialogContext) => AlertDialog(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                                                    contentPadding: EdgeInsets.all(20.sp),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Lottie.asset(
                                                          'assets/lottie/createServices.json',
                                                          width: 90.sp,
                                                          height: 90.sp,
                                                          fit: BoxFit.contain,
                                                        ),
                                                        SizedBox(height: 15.sp),
                                                        Text(
                                                          "Activating Roles",
                                                          style: StyleText.fontSize20Weight500.copyWith(
                                                            color: lightMode ? ColorAppLight.grayTextSla : ColorAppDark.titleKey,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        SizedBox(height: 18.sp),
                                                        Text(
                                                          "Are You Sure You Want To Activate These Roles ?",
                                                          style: StyleText.fontSize18Weight500.copyWith(
                                                            color: lightMode ? ColorAppLight.grayTextSla : ColorAppDark.titleKey,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        SizedBox(height: 15.sp),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            customButton(
                                                                title: S.of(dialogContext).no,
                                                                function: (){
                                                                  Navigator.pop(dialogContext);
                                                                },
                                                                textStyle: StyleText.fontSize18Weight500.copyWith(
                                                                    color: Colors.black
                                                                ),
                                                                width: 135.sp,
                                                                height: 38.sp,
                                                                radius: 4.r,
                                                                color: ColorAppLight.grayTextSla
                                                            ),

                                                            SizedBox(width: 28.sp),

                                                            customButton(
                                                                title: S.of(dialogContext).yes,
                                                                function: () async {
                                                                  // Close the confirmation dialog
                                                                  Navigator.pop(dialogContext);

                                                                  // Perform the upload
                                                                  await uploadToFirebase();

                                                                  // ✅ Check if widget is still mounted
                                                                  if (!mounted) return;

                                                                  // ✅ Use widgetContext (not dialogContext or scaffoldContext)
                                                                  showDialog(
                                                                      context: widgetContext,
                                                                      barrierDismissible: true,
                                                                      builder: (context) => AlertDialog(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(12.r)
                                                                        ),
                                                                        contentPadding: EdgeInsets.all(20.sp),
                                                                        content: Container(
                                                                          width: 400.sp,
                                                                          height: 180.sp,
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              Lottie.asset(
                                                                                'assets/lottie/approved.json',
                                                                                width: 90.sp,
                                                                                height: 90.sp,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                              SizedBox(height: 15.sp),
                                                                              Text(
                                                                                "Activated",
                                                                                style: StyleText.fontSize20Weight500.copyWith(
                                                                                  color: lightMode
                                                                                      ? ColorAppLight.grayTextSla
                                                                                      : ColorAppDark.titleKey,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                              SizedBox(height: 18.sp),
                                                                              Text(
                                                                                "You Successfully Activated These Roles",
                                                                                style: StyleText.fontSize18Weight500.copyWith(
                                                                                  color: lightMode
                                                                                      ? ColorAppLight.grayTextSla
                                                                                      : ColorAppDark.titleKey,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                  );
                                                                },
                                                                textStyle: StyleText.fontSize18Weight500.copyWith(
                                                                    color: AppColors.textButton
                                                                ),
                                                                width: 135.sp,
                                                                height: 38.sp,
                                                                radius: 4.r,
                                                                color: AppColors.primary
                                                            ),
                                                          ],
                                                        )

                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }

                                            },
                                            textStyle: StyleText.fontSize16Weight500.copyWith(
                                              color: getTotalErrorCount() > 0 ? Colors.black  : AppColors.textButton ,
                                            ),
                                            width: 150.sp,
                                            height: 38.sp,
                                            radius: 8.r,
                                            color: getTotalErrorCount() > 0
                                                ? ColorAppLight.grayTextSla
                                                : AppColors.primary,
                                          );
                                        },
                                        textStyle: StyleText.fontSize18Weight500.copyWith(
                                            color: AppColors.textButton
                                        ),
                                        width: 135.sp,
                                        height: 38.sp,
                                        radius: 4.r,
                                        color: AppColors.primary
                                    ),
                                  ],
                                )

                              ],
                            ),
                          ),
                        );
                      }

                    },
                    textStyle: StyleText.fontSize16Weight500.copyWith(
                      color: getTotalErrorCount() > 0 ? Colors.black  : AppColors.textButton ,
                    ),
                    width: 150.sp,
                    height: 38.sp,
                    radius: 8.r,
                    color: getTotalErrorCount() > 0
                        ? ColorAppLight.grayTextSla
                        : AppColors.primary,
                  ),

                ],
              ),
              SizedBox(height: 20.sp),
            ],
          ),
        ),
      ),
    );
  }

  void showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Container(
          height: 100,
          width: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                child: Lottie.asset('assets/lottie/rejected.json'),
              ),
              SizedBox(height: 20),
              Text(
                "You must solve these errors",
                style: StyleText.fontSize20Weight600.copyWith(
                  color: ColorAppLight.redColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          customButton(
            title: "Ok ",
            function: () {
              Navigator.pop(context);
            },
            textStyle: StyleText.fontSize16Weight500.copyWith(
                color: ColorAppLight.blackButton
            ),
            width: 150.sp,
            height: 38.sp,
            radius: 8.r,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

}

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
  });

  @override
  Widget build(BuildContext context) {
    final isEmail = placeholder.toLowerCase().contains('email');
    final isPhone = placeholder.toLowerCase().contains('phone');

    return Container(
      width: width, // Example: 250
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader)
            Padding(
              padding: const EdgeInsets.only(bottom: 8,),
              child: Align(
                alignment: headerLabel.trim().contains(RegExp(r'[\u0600-\u06FF]'))
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  headerLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

          SizedBox(
            width: width,
            child: Directionality(
              textDirection: placeholder.trim().contains(RegExp(r'[\u0600-\u06FF]')) ? TextDirection.rtl : TextDirection.ltr,
              child: Row(
                children: [
                  // ❗ Always reserve icon space (clickable if errorText exists)
                  GestureDetector(
                    onTap: () {
                      if (errorText != null) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            contentPadding: EdgeInsets.symmetric(vertical: 24.sp, horizontal: 16.sp),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                            content: Container(
                              width: 410.sp,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Lottie.asset('assets/lottie/rejected.json', width: 70.sp, height: 70.sp),
                                  SizedBox(height: 16.sp),
                                  Text(
                                    'Warning $placeholder',
                                    style: StyleText.fontSize20Weight600.copyWith(
                                      color: Theme.of(context).brightness == Brightness.light
                                          ? ColorAppLight.blackButton
                                          : ColorAppDark.titleValue,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16.sp),
                                  Text(
                                    'The specified $placeholder $errorText! .Please verify the entry',
                                    style: StyleText.fontSize14Weight400.copyWith(color: Colors.grey.shade600),
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
                      child: SvgPicture.asset(
                        "assets/error.svg",
                        width: 20.sp,
                        height: 20.sp,
                        fit: BoxFit.cover,
                      ),
                    )
                        : SizedBox(),
                  ),

                  errorText != null? SizedBox(width: 8.sp) : SizedBox(),

                  // 📦 TextField
                  Expanded(
                    child: SizedBox(
                      height: height,
                      child: TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        onChanged: (value) {
                          if (validator != null && rowIndex != null) {
                            validator!(placeholder, rowIndex!);
                          }
                          if (onChanged != null) onChanged!(value);
                        },
                        style: StyleText.fontSize14Weight500.copyWith(
                            color: Theme.of(context).brightness == Brightness.light ? ColorAppLight.blackButton : ColorAppDark.titleValue
                        ),
                        inputFormatters: isEmail
                            ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))]
                            : null,
                        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
                        decoration: InputDecoration(
                          hintText: placeholder,
                          hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          filled: true,
                          fillColor: Theme.of(context).brightness == Brightness.light
                              ? ColorAppLight.whiteOp
                              : ColorAppDark.background,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: errorText != null ? Colors.red : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: errorText != null ? Colors.red : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red, width: 1.5),
                          ),
                          errorText: null, // No default error text
                        ),
                      ),
                    ),
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