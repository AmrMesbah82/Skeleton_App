// ----------------------------- 📤 Export to CSV -----------------------------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/success_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/2-custom_textfield.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_helper_function.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

String formatStartDate(dynamic timestampOrDateTime) {
  if (timestampOrDateTime == null) return '-';

  DateTime date;

  if (timestampOrDateTime is Timestamp) {
    date = timestampOrDateTime.toDate();
  } else if (timestampOrDateTime is DateTime) {
    date = timestampOrDateTime;
  } else {
    return '-';
  }

  final formatted = DateFormat('dd MMM yyyy').format(date);
  return formatted;
}
Future<void> exportToCSV(
    BuildContext context,
    List<dynamic> filteredModel,
    Map selectedProviders,
    String fileName,
    ) async {
  await showLoadingIndicator(context);

  try {
    // ✅ Request storage permission (Android 11+)
    final status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      hideLoadingIndicator();
      Get.snackbar(
        'Permission Denied',
        'Storage permission is required to export CSV.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.orange,
        colorText: AppColors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // ✅ Build CSV rows
    List<List<dynamic>> rows = [];
    rows.add([
      'No',
      'Service Name (EN)',
      'Service Name (AR)',
      'Description (EN)',
      'Description (AR)',
      'Status',
      'Duration',
      'Time Unit',
      'Limit Availability',
      'Requires Approval',
      'Start Date',
      'Service Provider',
    ]);

    for (int i = 0; i < filteredModel.length; i++) {
      final item = filteredModel[i];
      final provider = selectedProviders[item.id];
      final providerName =
      provider != null
          ? "${provider['firstName'] ?? ''} ${provider['lastName'] ?? ''}"
          : "No Provider";

      rows.add([
        i + 1,
        item.serviceNameEnglish ?? '',
        item.serviceNameArabic ?? '',
        item.serviceDescriptionEnglish ?? '',
        item.serviceDescriptionArabic ?? '',
        "Approved",
        item.durationOfServices ?? '',
        item.selectedDurationUnit ?? '',
        item.selectDepartment!.isEmpty ? "No" : "Yes",
        item.approvalCycle!.isEmpty ? "No" : "Yes",
        formatStartDate(item.durationOfServicesTimestamp),
        providerName,
      ]);
    }

    await CSVHelper().exportToCSV(rows, fileName);
    hideLoadingIndicator();

    await showDownloadSuccessDialog(context);

  } catch (e) {
    hideLoadingIndicator();
    Get.snackbar(
      '❌ Export Failed',
      'Could not export data',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.red,
      colorText: AppColors.white,
      duration: const Duration(seconds: 3),
    );
  }
}

Future<String?> showFileNameDialog(BuildContext context) async {
  var lightMode = Theme.of(context).brightness == Brightness.light;
  final TextEditingController controller = TextEditingController();

  return await showDialog<String>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Container(
          decoration: BoxDecoration(
            color:
            lightMode
                ? AppColors.white
                : AppColors.chatBackground,
            borderRadius: BorderRadius.circular(8.r),
          ),
          width: 411.sp, // 🔵 Set your desired width
          height: 213.sp,
          child: Padding(
            padding: EdgeInsets.all(20.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // image & export
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
                          width: 13.sp,
                          height: 13.sp,
                          color: AppColors.textButton,
                          fit: BoxFit.fill  ,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.sp),
                    Text(
                      S.of(context).export,
                      style: AppTextStyles.font16BlackMediumCairo.copyWith(
                        color:
                        lightMode
                            ? AppColors.blackButton
                            : AppColors.white,
                      ),
                    ),
                  ],
                ),
                // space
                SizedBox(height: 20.sp),

                // File Name title
                Text(
                  S.of(context).fileName,
                  style: AppTextStyles.font14BlackCairoMedium.copyWith(
                    color:
                    lightMode
                        ? AppColors.blackButton
                        : AppColors.white,
                  ),
                ),

                SizedBox(height: 8.sp),

                Container(
                  height: 36.sp,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r)
                  ),
                  child: CustomTextField(
                    controller: controller,
                    hint: S.of(context).Texthere,
                    fillColor: AppColors.background,
                    borderRadius: BorderRadius.circular(4.r),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 9.sp, vertical: 13.sp),
                    valueStyle: AppTextStyles.font14BlackCairoRegular.copyWith(
                      color: lightMode ? AppColors.blackButton : AppColors.white,
                    ),
                    hintStyle: AppTextStyles.font12BlackCairoRegular.copyWith(
                      color: lightMode ? AppColors.secondaryText : AppColors.grey,
                    ),
                  ),
                ),

                // space
                SizedBox(height: 20.sp),
                // Discard and Download
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customButtonAnimation(
                      title: S.of(context).discard,
                      width: 120.w,
                      color: lightMode ? AppColors.grey : AppColors.mediumGrey,
                      height: 38.h,
                      textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                        color: lightMode ? AppColors.black : AppColors.white,
                      ),
                      radius: 8.r,
                      function: () {
                        Navigator.pop(context);
                      },
                    ),

                    customButtonAnimation(
                      title: S.of(context).download,
                      width: 120.w,
                      color: AppColors.primary,
                      height: 38.h,
                      textStyle: AppTextStyles.font18BlackMediumCairo.copyWith(
                        color: AppColors.textButton,
                      ),
                      radius: 8.r,
                      function: () {
                        final name = controller.text.trim();
                        if (name.isNotEmpty) {
                          Navigator.pop(context, name);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
OverlayEntry? _overlayEntry;
Future<void> showLoadingIndicator(BuildContext context) async {
  _overlayEntry = OverlayEntry(
    builder:
        (_) => Stack(
      children: [
        ModalBarrier(
          dismissible: false,
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
  Overlay.of(context).insert(_overlayEntry!);
}

void hideLoadingIndicator() {
  _overlayEntry?.remove();
  _overlayEntry = null;
}
