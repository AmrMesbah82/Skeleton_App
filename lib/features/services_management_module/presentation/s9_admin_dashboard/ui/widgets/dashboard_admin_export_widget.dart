/// ******************* FILE INFO *******************
/// File Name: export_file_dialog.dart
/// Description: Reusable export file name dialog
/// Created by: Refactored from dashBoard_admin.dart
/// Last Update: [Current Date]

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/widgets/services_management/custom_textformfield.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';

class ExportFileDialog extends StatefulWidget {
  const ExportFileDialog({Key? key}) : super(key: key);

  @override
  State<ExportFileDialog> createState() => _ExportFileDialogState();

  /// Static method to show the dialog and return the file name
  static Future<String?> show(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (context) => const ExportFileDialog(),
    );
  }
}

class _ExportFileDialogState extends State<ExportFileDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isTabletLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return size.width >= 1000 && isLandscape;
  }

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: lightMode ? AppColors.white : AppColors.chatBackground,
          borderRadius: BorderRadius.circular(8.r),
        ),
        width: 411.sp,
       // height: isTabletLandscape(context) ? 203.h : 170.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 15.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(lightMode),
              SizedBox(height: 10.sp),

              // File name label
              Text(
                S.of(context).fileName,
                style: AppTextStyles.font14BlackCairoMedium.copyWith(
                  color: lightMode ? AppColors.blackButton : AppColors.white,
                ),
              ),
              SizedBox(height: 8.sp),

              // Text field
              CustomValidatedTextFieldMaster(
                hint: S.of(context).Texthere,
                controller: controller,
              ),

              // Action buttons
              _buildActionButtons(lightMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool lightMode) {
    return Row(
      children: [
        // Icon
        Container(
          width: 30.sp,
          height: 30.sp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
          child: Center(
            child: SvgPicture.asset(
              "assets/lottie/export.svg",
              width: 12.sp,
              height: 12.sp,
              fit: BoxFit.scaleDown,
              color: lightMode ? AppColors.textButton : AppColors.textButton,
              semanticsLabel: 'Export Icon',
            ),
          ),
        ),
        SizedBox(width: 8.sp),
        // Export text
        Text(
          S.of(context).export,
          style: AppTextStyles.font16BlackMediumCairo.copyWith(
            color: lightMode ? AppColors.blackButton : AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool lightMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Discard button
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 130.sp,
            height: 38.sp,
            decoration: BoxDecoration(
              color: Color(0xffCCCCCCCC),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: Text(
                S.of(context).discard,
                style: AppTextStyles.font14BlackSemiBoldCairo.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.sp),

        // Download button
        GestureDetector(
          onTap: () {
            final name = controller.text.trim();
            if (name.isNotEmpty) {
              Navigator.pop(context, name);
            }
          },
          child: Container(
            width: 130.sp,
            height: 38.sp,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: Text(
                S.of(context).download,
                style: AppTextStyles.font14BlackSemiBoldCairo.copyWith(
                  color: AppColors.textButton,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
