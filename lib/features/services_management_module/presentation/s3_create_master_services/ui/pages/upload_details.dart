/// ******************* FILE INFO *******************
/// File Name: upload_details.dart (upload_requests_details_screen)
/// Description: Preview and edit service requests data from bulk upload,
///   then upload BOTH Step 1 and Step 2 to Firebase together.
/// Created by: Amr Mesbah
///
/// CHANGE LOG:
/// - step1UploadFunction now returns Future<Map<String,String>> (serviceName → docId).
/// - uploadToFirebase() calls step1UploadFunction first, gets the docId map,
///   then uses real Firestore docIds for Parent_Service_Id and id fields.
/// - RequestServices Firestore path: /Demo/{companyId}/RequestServices/
/// - Fields match real Firestore structure exactly.

import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/custom/5-custom_button.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/2-custom_textfield.dart';
import 'package:demo_app/core/custom/6_custom_button_with_svg.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';

// ─── Reusable inline-editable cell ───────────────────────────────────────────
class _RequestEditableCell extends StatelessWidget {
  const _RequestEditableCell({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.placeholder,
    required this.errorText,
    required this.onChanged,
    this.width = 220,
    this.height = 36,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String placeholder;
  final String? errorText;
  final VoidCallback onChanged;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isEmailField = placeholder.toLowerCase().contains('email') ||
        placeholder.toLowerCase().contains('provider') ||
        placeholder.toLowerCase().contains('approver');

    return SizedBox(
      width: errorText != null ? width + 40 : width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: width,
            height: height,
            child: CustomTextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: (_) => onChanged(),
              hint: placeholder,
              // Error is signalled by the external error icon next to the cell
              // (kept below); no inline errorText here to avoid overflowing the
              // fixed-height table cell.
              fillColor: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              valueStyle: AppTextStyles.font12BlackMediumCairo
                  .copyWith(color: AppColors.text),
              hintStyle: TextStyle(fontSize: 13, color: AppColors.mediumGrey),
              inputFormatters: isEmailField
                  ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))]
                  : null,
            ),
          ),
          if (errorText != null) SizedBox(width: 8.sp),
          if (errorText != null)
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (dialogCtx) => AlertDialog(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 24.sp, horizontal: 16.sp),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                    content: SizedBox(
                      width: 410.sp,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset('assets/lottie/rejected.json',
                              width: 70.sp, height: 70.sp),
                          SizedBox(height: 16.sp),
                          Text(
                            '${S.of(dialogCtx).warning} $placeholder',
                            style: AppTextStyles.font20BlackSemiBoldCairo.copyWith(
                                color: AppColors.text, height: 1.7),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.sp),
                          Text(
                            errorText!,
                            style: AppTextStyles.font14BlackCairoRegular.copyWith(
                                color: AppColors.mediumGrey, height: 1.7),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                width: 20.sp,
                height: height,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/error.svg',
                  width: 20.sp,
                  height: 20.sp,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class UploadRequestsDetailsScreen extends StatefulWidget {
  const UploadRequestsDetailsScreen({
    super.key,
    required this.formData,
    required this.validationErrors,
    this.selectedFileName,
    required this.uploadedServicesFormData,
    this.step1UploadFunction,
  });

  final List<Map<String, TextEditingController>> formData;
  final List<Map<String, String>> validationErrors;
  final String? selectedFileName;

  /// Services uploaded in Step 1 — used to validate Service Name.
  final List<Map<String, TextEditingController>> uploadedServicesFormData;

  /// Step 1's deferred uploadToFirebase function.
  /// Returns Map<String, String> (serviceName → firestoreDocId).
  /// Called BEFORE Step 2 uploads so Parent_Service_Id uses real doc IDs.
  final Future<Map<String, String>> Function()? step1UploadFunction;

  @override
  State<UploadRequestsDetailsScreen> createState() =>
      _UploadRequestsDetailsScreenState();
}

class _UploadRequestsDetailsScreenState
    extends State<UploadRequestsDetailsScreen> {
  final MainCoreEmployeeController employeeController = Get.find();
  final MainCoreDepartmentController departmentController = Get.find();

  List<Map<String, TextEditingController>> formData = [];
  List<Map<String, String>> validationErrors = [];
  Set<int> selectedRows = {};
  String? selectedFileName;

  Set<String> _validServiceNames = {};

  final List<String> expectedHeaders = [
    'Service Name',
    'Email Requester',
    'Service Provider',
    'Approvers',
    'State',
    'Requested Date',
  ];

  List<Map<String, GlobalKey>> fieldKeys = [];
  List<Map<String, FocusNode>> focusNodes = [];
  List<MapEntry<int, String>> errorLocations = [];
  int currentErrorIndex = -1;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    formData = widget.formData;
    validationErrors = widget.validationErrors;
    selectedFileName = widget.selectedFileName;

    _validServiceNames = widget.uploadedServicesFormData
        .map((row) => row['Service Name']?.text.trim().toLowerCase() ?? '')
        .where((n) => n.isNotEmpty)
        .toSet();

    focusNodes = List.generate(formData.length, (i) {
      final map = <String, FocusNode>{};
      for (final key in expectedHeaders) {
        map[key] = FocusNode();
      }
      return map;
    });

    fieldKeys = List.generate(formData.length, (i) {
      final map = <String, GlobalKey>{};
      for (final key in expectedHeaders) {
        map[key] = GlobalKey();
      }
      return map;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _revalidateAll();
      updateErrorLocations();
    });
  }

  @override
  void dispose() {
    for (final row in focusNodes) {
      for (final node in row.values) {
        node.dispose();
      }
    }
    _scrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  // ─── Validation ──────────────────────────────────────────────
  String? validateCell(String key, String? value, {int? rowIndex}) {
    if (key == 'Approvers') {
      if (value == null || value.trim().isEmpty) return null;
    }

    if (value == null || value.trim().isEmpty) {
      return S.of(context).required;
    }
    value = value.trim();

    bool isValidEmail(String e) =>
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(e);

    switch (key) {
      case 'Service Name':
        if (!_validServiceNames.contains(value.toLowerCase())) {
          return 'Service not found in uploaded services list';
        }
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
        final spEmails = value.split(',').map((e) => e.trim()).toList();
        if (spEmails.toSet().length != spEmails.length) {
          return S.of(context).duplicateEmails;
        }
        for (final email in spEmails) {
          if (email.isEmpty) return S.of(context).emptyEmail;
          if (!isValidEmail(email)) return S.of(context).invalidEmailFormat;
          if (!employeeController.mapOfEmployeesWithEmailKey.containsKey(email)) {
            return S.of(context).emailDoesNotExist;
          }
        }
        break;

      case 'Approvers':
        if (value.isEmpty) return null;
        if (value.contains(' ')) return S.of(context).emailsCommaSeparated;
        if (value.startsWith(',') || value.endsWith(',')) {
          return S.of(context).commaAtStartOrEnd;
        }
        final apEmails = value.split(',').map((e) => e.trim()).toList();
        if (apEmails.toSet().length != apEmails.length) {
          return S.of(context).duplicateEmails;
        }
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

  void _revalidateAll() {
    for (int i = 0; i < formData.length; i++) {
      final rowErr = <String, String>{};
      for (final header in expectedHeaders) {
        final val = formData[i][header]?.text ?? '';
        final error = validateCell(header, val, rowIndex: i);
        if (error != null) rowErr[header] = error;
      }
      if (i < validationErrors.length) {
        validationErrors[i] = rowErr;
      } else {
        validationErrors.add(rowErr);
      }
    }
  }

  int getTotalErrorCount() {
    int total = 0;
    for (final row in validationErrors) {
      total += row.length;
    }
    return total;
  }

  void updateErrorLocations() {
    errorLocations.clear();
    for (int row = 0; row < validationErrors.length; row++) {
      validationErrors[row].forEach((header, _) {
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
        currentErrorIndex =
            (currentErrorIndex - 1 + errorLocations.length) %
                errorLocations.length;
      }
    });

    final entry = errorLocations[currentErrorIndex];
    final rowIndex = entry.key;
    final header = entry.value;
    final key = fieldKeys[rowIndex][header];
    final node = focusNodes[rowIndex][header];
    final controller = formData[rowIndex][header];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        final ctx = key?.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(ctx,
              duration: const Duration(milliseconds: 500),
              alignment: 0.3,
              curve: Curves.easeInOut)
              .then((_) {
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

  // ─── Firebase upload ─────────────────────────────────────────
  Future<void> uploadToFirebase() async {
    // ════════════════════════════════════════════════════════════
    // STEP 1: Upload services first and get serviceName → docId map.
    // This ensures every service exists in Firebase before we link
    // requests to them via Parent_Service_Id.
    // ════════════════════════════════════════════════════════════
    Map<String, String> serviceNameToDocId = {};

    if (widget.step1UploadFunction != null) {
      serviceNameToDocId = await widget.step1UploadFunction!();
    }

    // ════════════════════════════════════════════════════════════
    // STEP 2: Upload requests to /Demo/{companyId}/RequestServices/
    // Each request links to its service via Parent_Service_Id = docId.
    // ════════════════════════════════════════════════════════════
    // getBaseUrl already resolves the correct Demo/{companyId}/RequestServices path
    final requestsCollection = FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices));

    int success = 0, failed = 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final formatted = DateFormat("MMMdd_yyyy").format(DateTime.now());

    for (int rowIdx = 0; rowIdx < formData.length; rowIdx++) {
      final row = formData[rowIdx];

      try {
        final serviceName = row['Service Name']?.text.trim() ?? '';
        final emailRequester = row['Email Requester']?.text.trim() ?? '';
        final serviceProviderRaw = row['Service Provider']?.text.trim() ?? '';
        final approversRaw = row['Approvers']?.text.trim() ?? '';
        final state = row['State']?.text.trim().toLowerCase() ?? 'pending';
        final requestedDate = row['Requested Date']?.text.trim() ?? '';

        if (serviceName.isEmpty || emailRequester.isEmpty) {
          failed++;
          continue;
        }

        // ── Resolve the real Firestore doc ID for this service.
        // If Step 1 ran, use the returned map; otherwise fall back to name.
        final serviceDocId = serviceNameToDocId[serviceName] ?? serviceName;

        final providerList = _enrichEmailList(serviceProviderRaw);
        final approverList = _enrichEmailList(approversRaw);
        final assignedProviderEmail = providerList.isNotEmpty
            ? (providerList[0]['email']?.toString() ?? '')
            : '';

        final random = Random().nextInt(100000);
        final docId = 'Request$random$formatted';

        // ── Build the request document matching exact Firestore structure.
        final Map<String, dynamic> data = {
          'timestamps': [now],
          'id': [serviceDocId],             // real Firestore service doc ID
          'state': [state],
          'status': ['active'],
          'Parent_Service_Id': [serviceDocId], // real Firestore service doc ID
          'Email_Requester': [emailRequester],
          'Assigned_Provider_Email': [assignedProviderEmail],
          'Provider_Services': [jsonEncode(providerList)],
          'Approval_Cycle': [jsonEncode(approverList)],
          'approveComment': '',
          'requestedDate': [requestedDate],
        };

        await requestsCollection.doc(docId).set(data);
        success++;
      } catch (e, stack) {
        failed++;
      }
    }

  }

  // ─── Enrich email list ───────────────────────────────────────
  List<Map<String, dynamic>> _enrichEmailList(String emails) {
    if (emails.trim().isEmpty) return [];

    final deptController = Get.find<MainCoreDepartmentController>();

    return emails
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
  }

  // ─── Build ───────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return SideFrameMasterServices(
      titleText: S.of(context).service,
      onFirstTap: () => Navigator.pop(context),
      secondTitle: 'Bulk Upload Preview',
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  selectedFileName ?? S.of(context).noFileSelected,
                  style:
                  AppTextStyles.font23BlackRegularCairo.copyWith(color: AppColors.text),
                ),
              ],
            ),
            SizedBox(height: 23.sp),

            // ── Toolbar ──────────────────────────────────────────
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
                                ? 'assets/arrow_right.svg'
                                : 'assets/arrowleft.svg',
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
                        '${S.of(context).error}: ',
                        style: AppTextStyles.font16BlackMediumCairo.copyWith(
                          color: lightMode
                              ? AppColors.blackButton
                              : AppColors.white,
                        ),
                      ),
                      Text(
                        getTotalErrorCount() > 0
                            ? '${currentErrorIndex + 1}/${getTotalErrorCount()}'
                            : '${getTotalErrorCount()}',
                        style: AppTextStyles.font16BlackMediumCairo
                            .copyWith(color: AppColors.red),
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
                                ? 'assets/arrowleft.svg'
                                : 'assets/arrow_right.svg',
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
                const Spacer(),
                customButtonWithSvg(
                  title: S.of(context).removeSelection,
                  function: () {
                    if (selectedRows.isEmpty) return;
                    setState(() {
                      final sorted = selectedRows.toList()
                        ..sort((a, b) => b.compareTo(a));
                      for (final i in sorted) {
                        formData.removeAt(i);
                        validationErrors.removeAt(i);
                        focusNodes.removeAt(i);
                        fieldKeys.removeAt(i);
                      }
                      selectedRows.clear();
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => updateErrorLocations());
                    });
                  },
                  textStyle:
                  AppTextStyles.font16BlackMediumCairo.copyWith(color: AppColors.white),
                  width: 166.sp,
                  height: 30.sp,
                  space: 8.sp,
                  radius: 4.r,
                  color: AppColors.black,
                  image: 'assets/minus.svg',
                  svgColor: AppColors.white,
                  widthImage: 12.sp,
                  heightImage: 1.5.sp,
                  colorBorder: Colors.transparent,
                ),
                SizedBox(width: 10.sp),
                customButtonWithSvg(
                  title: S.of(context).row,
                  function: () {
                    final newRow = <String, TextEditingController>{};
                    final newFocus = <String, FocusNode>{};
                    final newKeys = <String, GlobalKey>{};
                    for (final h in expectedHeaders) {
                      newRow[h] = TextEditingController();
                      newFocus[h] = FocusNode();
                      newKeys[h] = GlobalKey();
                    }
                    setState(() {
                      formData.add(newRow);
                      validationErrors.add({});
                      focusNodes.add(newFocus);
                      fieldKeys.add(newKeys);
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => updateErrorLocations());
                    });
                  },
                  textStyle:
                  AppTextStyles.font16BlackMediumCairo.copyWith(color: AppColors.white),
                  width: 82.sp,
                  height: 30.sp,
                  space: 8.sp,
                  radius: 4.r,
                  color: AppColors.black,
                  image: 'assets/plus.svg',
                  svgColor: AppColors.white,
                  widthImage: 12.sp,
                  heightImage: 12.sp,
                  colorBorder: Colors.transparent,
                ),
              ],
            ),
            SizedBox(height: 10.sp),

            // ── Preview Table ─────────────────────────────────────
            if (formData.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(8.r)),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _horizontalScrollController,
                    child: SizedBox(
                      width: 1400.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                            EdgeInsets.only(left: 10.sp, top: 10.sp, right: 10),
                            child: Container(
                              width: 160.sp,
                              height: 25.sp,
                              decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(4.r)),
                              child: Center(
                                child: Text(
                                  'Total Requests: ${formData.length}',
                                  style: AppTextStyles.font14BlackCairoMedium
                                      .copyWith(color: AppColors.text),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.sp),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SizedBox(
                              height: 400.sp,
                              child: ListView.builder(
                                controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: formData.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: 34.sp, top: 8.sp, bottom: 8.sp),
                                      child: Row(
                                        children: expectedHeaders.map((header) {
                                          return SizedBox(
                                            width: 220 + 40 + 12,
                                            child: Text(
                                              header,
                                              style: AppTextStyles.font16BlackMediumCairo
                                                  .copyWith(color: AppColors.text),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  }

                                  final rowIndex = index - 1;
                                  return _buildDataRow(context, rowIndex, lightMode);
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

            // ── Bottom buttons ───────────────────────────────────
            Row(
              children: [
                customButton(
                  title: S.of(context).discard,
                  function: () => Navigator.pop(context),
                  textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                      color: lightMode ? AppColors.black : AppColors.white),
                  width: 150.sp,
                  height: 38.sp,
                  radius: 8.r,
                  color: lightMode ? AppColors.grey : AppColors.mediumGrey,
                ),
                const Spacer(),
                customButton(
                  title: 'Review',
                  function: () {
                    if (getTotalErrorCount() > 0) {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r)),
                          contentPadding: EdgeInsets.all(20.sp),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Lottie.asset('assets/lottie/rejected.json',
                                  width: 90.sp,
                                  height: 90.sp,
                                  fit: BoxFit.contain),
                              SizedBox(height: 20.sp),
                              Text(
                                S.of(context).mustCorrectErrors,
                                style: AppTextStyles.font18BlackMediumCairo.copyWith(
                                    color: AppColors.secondaryText),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                      return;
                    }

                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (confirmCtx) => AlertDialog(
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
                              'Activating Requests',
                              style: AppTextStyles.font20BlackCairoMedium.copyWith(
                                  color: AppColors.secondaryText),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 18.sp),
                            Text(
                              'Are you sure you want to activate these requests?',
                              style: AppTextStyles.font18BlackMediumCairo.copyWith(
                                  color: AppColors.secondaryText),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 15.sp),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                customButton(
                                  title: S.of(confirmCtx).no,
                                  function: () => Navigator.pop(confirmCtx),
                                  textStyle: AppTextStyles.font18BlackMediumCairo.copyWith(
                                      color: lightMode ? AppColors.black : AppColors.white),
                                  width: 135.sp,
                                  height: 38.sp,
                                  radius: 4.r,
                                  color: lightMode ? AppColors.grey : AppColors.mediumGrey,
                                ),
                                SizedBox(width: 28.sp),
                                customButton(
                                  title: S.of(confirmCtx).yes,
                                  function: () async {
                                    Navigator.pop(confirmCtx);
                                    if (!mounted) return;

                                    try {
                                      // uploadToFirebase calls Step 1 first,
                                      // gets docId map, then uploads requests
                                      // using the real Firestore service doc IDs.
                                      await uploadToFirebase();
                                    } catch (e) {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Upload failed: $e')));
                                      return;
                                    }

                                    if (!mounted) return;

                                    try {
                                      final cubit = ServicesManagerCubit.get(context);
                                      await cubit.getAllServices();
                                      await cubit.getAllRequestServices();
                                    } catch (e) {
                                    }

                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (successCtx) {
                                        Future.delayed(const Duration(seconds: 2), () {
                                          if (Navigator.canPop(successCtx)) {
                                            Navigator.pop(successCtx);
                                          }
                                          if (mounted && Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                          }
                                        });
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12.r)),
                                          contentPadding: EdgeInsets.all(20.sp),
                                          content: SizedBox(
                                            width: 400.sp,
                                            height: 180.sp,
                                            child: Column(
                                              children: [
                                                Lottie.asset(
                                                    'assets/lottie/approved.json',
                                                    width: 90.sp,
                                                    height: 90.sp,
                                                    fit: BoxFit.contain),
                                                SizedBox(height: 15.sp),
                                                Text(S.of(context).activated,
                                                    style: AppTextStyles.font20BlackCairoMedium
                                                        .copyWith(color: AppColors.secondaryText),
                                                    textAlign: TextAlign.center),
                                                SizedBox(height: 18.sp),
                                                Text(
                                                    'Services & Requests Activated Successfully',
                                                    style: AppTextStyles.font18BlackMediumCairo
                                                        .copyWith(color: AppColors.secondaryText),
                                                    textAlign: TextAlign.center),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  textStyle: AppTextStyles.font18BlackMediumCairo
                                      .copyWith(color: AppColors.textButton),
                                  width: 135.sp,
                                  height: 38.sp,
                                  radius: 4.r,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
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
    );
  }

  // ─── Data row ────────────────────────────────────────────────
  Widget _buildDataRow(BuildContext context, int rowIndex, bool lightMode) {
    final row = formData[rowIndex];
    final isSelected = selectedRows.contains(rowIndex);

    return Padding(
      padding: EdgeInsets.only(
          top: 10.sp, bottom: 10.sp, right: 12.sp, left: 0.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
            child: Container(
              width: 24.sp,
              height: 24.sp,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.secondaryPrimary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6.r),
                border: isSelected
                    ? null
                    : Border.all(
                    color: lightMode ? AppColors.grey : AppColors.grey,
                    width: 1.5.sp),
              ),
              child: Center(
                child: Icon(Icons.check,
                    size: 16.sp,
                    color: isSelected ? AppColors.white : Colors.transparent),
              ),
            ),
          ),
          SizedBox(width: 10.sp),
          ...expectedHeaders.map((header) {
            final hasError = (validationErrors.length > rowIndex) &&
                validationErrors[rowIndex].containsKey(header);
            final errorText = hasError ? validationErrors[rowIndex][header] : null;

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: KeyedSubtree(
                key: fieldKeys[rowIndex][header],
                child: _RequestEditableCell(
                  controller: row[header]!,
                  focusNode: focusNodes[rowIndex][header]!,
                  placeholder: header,
                  errorText: errorText,
                  width: 220,
                  height: 36,
                  onChanged: () {
                    final val = row[header]?.text ?? '';
                    final error = validateCell(header, val, rowIndex: rowIndex);
                    setState(() {
                      if (error != null) {
                        validationErrors[rowIndex][header] = error;
                      } else {
                        validationErrors[rowIndex].remove(header);
                      }
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => updateErrorLocations());
                    });
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
