import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/custom/2-custom_textfield.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/widgets/services_management/custom_textformfield.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/widgets/home_services_dialog.dart';

class ExportDialog extends StatefulWidget {
  final List<dynamic> filteredModel;
  final Map selectedProviders;
  final String Function(dynamic date) formatStartDate;

  const ExportDialog({
    Key? key,
    required this.filteredModel,
    required this.selectedProviders,
    required this.formatStartDate,
  }) : super(key: key);

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  final TextEditingController controller = TextEditingController();
  OverlayEntry? _overlayEntry;
  bool _isExporting = false;

  Future<void> _showLoadingIndicator(BuildContext context) async {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          ModalBarrier(
            dismissible: true,
            color: AppColors.black.withOpacity(0.3),
          ),
          Center(
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(0.87),
                borderRadius: BorderRadius.circular(12),
              ),
              child:  CircularProgressIndicator(color: AppColors.white),
            ),
          ),
        ],
      ),
    );

    final overlay = Overlay.of(context);
    if (overlay != null) {
      overlay.insert(_overlayEntry!);
    }
  }

  void _hideLoadingIndicator() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  String _escapeCsvValue(String value) {
    if (value.isEmpty) return '';

    if (value.contains(',') || value.contains('"') || value.contains('\n') || value.contains('\r')) {
      String escaped = value.replaceAll('"', '""');
      return '"$escaped"';
    }

    return value;
  }

  /// 🔥 NEW: Format date ALWAYS in English (EN)
  String _formatDateEnglish(dynamic date) {
    try {
      if (date == null) return '-';

      DateTime dateTime;

      if (date is Timestamp) {
        dateTime = date.toDate();
      } else if (date is int) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(date);
      } else if (date is DateTime) {
        dateTime = date;
      } else {
        return '-';
      }

      // ALWAYS use English format: MMM dd, yyyy
      final formatter = DateFormat('MMM dd, yyyy', 'en_US');
      return formatter.format(dateTime);
    } catch (e) {
      return '-';
    }
  }

  /// 🔥 NEW: Extract department names
  String _extractDepartments(dynamic item) {
    try {
      if (item.currentSelectDepartment == null) return '-';

      final departments = item.currentSelectDepartment;

      if (departments is! List || departments.isEmpty) return '-';

      // Extract department names
      List<String> departmentNames = [];

      for (var dept in departments) {
        String deptName = '';

        if (dept is Map) {
          // Try different possible keys
          deptName = dept['departmentName']?.toString() ??
              dept['name']?.toString() ??
              dept['department']?.toString() ??
              '';
        } else if (dept is String) {
          deptName = dept;
        }

        if (deptName.isNotEmpty) {
          departmentNames.add(deptName.trim());
        }
      }

      if (departmentNames.isEmpty) return '-';

      // Join with semicolon for CSV compatibility
      return departmentNames.join('; ');
    } catch (e) {
      return '-';
    }
  }

  Future<void> _exportToCSVSimple(BuildContext context) async {
    if (_isExporting) return;

    final fileName = controller.text.trim();
    if (fileName.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a file name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.orange,
        colorText: AppColors.white,
      );
      return;
    }

    setState(() {
      _isExporting = true;
    });

    try {
      await _showLoadingIndicator(context);

      if (widget.filteredModel.isEmpty) {
        _hideLoadingIndicator();
        setState(() {
          _isExporting = false;
        });
        Get.snackbar(
          'No Data',
          'No services to export',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.orange,
          colorText: AppColors.white,
        );
        return;
      }

      // Print full provider map structure
      widget.selectedProviders.forEach((key, value) {
      });

      final directory = await getApplicationDocumentsDirectory();
      String finalFileName = fileName.toLowerCase().endsWith('.csv')
          ? fileName
          : '$fileName.csv';

      final filePath = '${directory.path}/$finalFileName';
      final file = File(filePath);

      StringBuffer csvContent = StringBuffer();

      // 🔥 UPDATED HEADER: Added Department column
      csvContent.write('No,');
      csvContent.write('Service Name (EN),');
      csvContent.write('Service Name (AR),');
      csvContent.write('Description (EN),');
      csvContent.write('Description (AR),');
      csvContent.write('Status,');
      csvContent.write('Duration,');
      csvContent.write('Time Unit,');
      csvContent.write('Department,');  // 🔥 NEW COLUMN
      csvContent.write('Limit Availability,');
      csvContent.write('Requires Approval,');
      csvContent.write('Start Date,');
      csvContent.writeln('Service Provider');

      for (int i = 0; i < widget.filteredModel.length; i++) {
        try {
          final item = widget.filteredModel[i];

          // Get service ID
          String serviceId = item.currentId ?? '';

          // Get provider name
          String providerName = 'No Provider';

          if (serviceId.isEmpty) {
          } else if (!widget.selectedProviders.containsKey(serviceId)) {
            widget.selectedProviders.keys.take(5).forEach((key) {
            });
          } else {
            final provider = widget.selectedProviders[serviceId];

            if (provider != null) {

              if (provider is Map) {

                // Try multiple possible key names
                final possibleFirstNames = ['firstName', 'first_name', 'FirstName', 'firstname', 'FIRSTNAME'];
                final possibleLastNames = ['lastName', 'last_name', 'LastName', 'lastname', 'LASTNAME'];

                String firstName = '';
                String lastName = '';

                for (var key in possibleFirstNames) {
                  if (provider.containsKey(key)) {
                    firstName = provider[key]?.toString() ?? '';
                    break;
                  }
                }

                for (var key in possibleLastNames) {
                  if (provider.containsKey(key)) {
                    lastName = provider[key]?.toString() ?? '';
                    break;
                  }
                }

                if (firstName.isEmpty && lastName.isEmpty) {

                  // Try to get email as fallback
                  if (provider.containsKey('email')) {
                    final email = provider['email']?.toString() ?? '';
                    providerName = email.isNotEmpty ? email : 'No Provider';
                  }
                } else {
                  providerName = '$firstName $lastName'.trim();
                }

              }
            }
          }

          // 🔥 UPDATED: Get start date ALWAYS in English
          String startDate = '-';
          try {
            String state = item.currentState?.toLowerCase()?.trim() ?? '';

            if (state != 'draft') {
              // Try timestamps array first
              if (item.timestamps != null && item.timestamps is List && (item.timestamps as List).isNotEmpty) {
                final timestampValue = (item.timestamps as List)[0];
                if (timestampValue is int) {
                  final timestamp = Timestamp.fromMillisecondsSinceEpoch(timestampValue);
                  startDate = _formatDateEnglish(timestamp);  // 🔥 ALWAYS ENGLISH
                } else if (timestampValue is Timestamp) {
                  startDate = _formatDateEnglish(timestampValue);  // 🔥 ALWAYS ENGLISH
                }
              }
              // Fallback to durationOfServicesTimestamp
              else if (item.durationOfServicesTimestamp != null) {
                startDate = _formatDateEnglish(item.durationOfServicesTimestamp);  // 🔥 ALWAYS ENGLISH
              }
            }
          } catch (e) {
          }

          // Helper to safely get string
          String safeGet(dynamic value) {
            if (value == null) return '';
            return value.toString().trim();
          }

          // Extract fields
          String serviceNameEn = safeGet(item.currentServiceNameEnglish);
          String serviceNameAr = safeGet(item.currentServiceNameArabic);
          String descEn = safeGet(item.currentServiceDescriptionEnglish);
          String descAr = safeGet(item.currentServiceDescriptionArabic);
          String status = safeGet(item.currentState ?? 'Active');
          String duration = safeGet(item.currentDurationOfServices);
          String timeUnit = safeGet(item.currentSelectedDurationUnit);

          // 🔥 NEW: Extract departments
          String departments = _extractDepartments(item);

          // Check limit availability
          String limitAvailability = 'No';
          try {
            if (item.currentSelectDepartment != null &&
                item.currentSelectDepartment is List &&
                (item.currentSelectDepartment as List).isNotEmpty) {
              limitAvailability = 'Yes';
            }
          } catch (e) {}

          // Check requires approval
          String requiresApproval = 'No';
          try {
            if (item.currentApprovalCycle != null &&
                item.currentApprovalCycle is List &&
                (item.currentApprovalCycle as List).isNotEmpty) {
              requiresApproval = 'Yes';
            }
          } catch (e) {}

          // 🔥 UPDATED: Build CSV row with Department column
          csvContent.write('${i + 1},');
          csvContent.write('${_escapeCsvValue(serviceNameEn)},');
          csvContent.write('${_escapeCsvValue(serviceNameAr)},');
          csvContent.write('${_escapeCsvValue(descEn)},');
          csvContent.write('${_escapeCsvValue(descAr)},');
          csvContent.write('${_escapeCsvValue(status)},');
          csvContent.write('${_escapeCsvValue(duration)},');
          csvContent.write('${_escapeCsvValue(timeUnit)},');
          csvContent.write('${_escapeCsvValue(departments)},');  // 🔥 NEW COLUMN
          csvContent.write('$limitAvailability,');
          csvContent.write('$requiresApproval,');
          csvContent.write('${_escapeCsvValue(startDate)},');
          csvContent.writeln(_escapeCsvValue(providerName));

        } catch (e) {
          continue;
        }
      }

      await file.writeAsString(csvContent.toString());

      _hideLoadingIndicator();
      setState(() {
        _isExporting = false;
      });

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      try {
        await showSuccessDialogMaster(
          lottiePath: "assets/lottie/approved.json",
          title: S.of(context).exported,
          subtitle: "File saved successfully",
          context: context,
        );
      } catch (e) {
        Get.snackbar(
          '✅ Export Successful',
          'File saved to: ${directory.path}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.green,
          colorText: AppColors.white,
          duration: Duration(seconds: 5),
        );
      }

    } catch (e) {
      _hideLoadingIndicator();
      setState(() {
        _isExporting = false;
      });

      Get.snackbar(
        '❌ Export Failed',
        'Error: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        duration: Duration(seconds: 5),
      );
    }
  }

  @override
  void dispose() {
    _hideLoadingIndicator();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    var isMobile = context.isPhone;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            color: lightMode ? AppColors.white : AppColors.chatBackground,
            borderRadius: BorderRadius.circular(8.r),
          ),
          constraints: BoxConstraints(
            maxWidth: 411.sp,
            minWidth: isMobile ? 280.sp : 350.sp,
          ),
          child: Padding(
            padding: EdgeInsets.all(20.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30.sp,
                      height: 30.sp,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/export.svg",
                          width: 16.sp,
                          height: 16.sp,
                          color: AppColors.textButton,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.sp),
                    Text(
                      S.of(context).export,
                      style: AppTextStyles.font16BlackMediumCairo.copyWith(
                        color: lightMode ? AppColors.blackButton : AppColors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.sp),
                CustomTextField(
                  controller: controller,
                  height: 36,
                  label: S.of(context).fileName,
                  hint: S.of(context).Texthere,
                  restrictByDirection: true,
                  autoCapitalize: true,
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: 20.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customButtonAnimation(
                      width: isMobile ? 120.w : 135.w,
                      title: S.of(context).discard,
                      color: _isExporting ? AppColors.grey : const Color(0xffcccccccc),
                      height: 38.sp,
                      textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                        color: _isExporting ? AppColors.mediumGrey : const Color(0xff2D2D2D),
                      ),
                      radius: 8.r,
                      function: () {
                        if (!_isExporting) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    SizedBox(width: 15.sp),
                    customButtonAnimation(
                      width: isMobile ? 120.w : 135.w,
                      title: _isExporting ? "${S.of(context).export}..." : S.of(context).download,
                      color: _isExporting ? AppColors.grey : AppColors.primary,
                      height: 38.sp,
                      textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                        color: AppColors.textButton,
                      ),
                      radius: 8.r,
                      function: () {
                        if (!_isExporting) {
                          _exportToCSVSimple(context);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
