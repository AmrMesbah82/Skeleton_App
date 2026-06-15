import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/core/widgets/dialogs/custom_dialog_box.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/dummy_data/mode_changer.dart';
import 'package:demo_app/core/widgets/grc/svg_custom.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/widgets/custom_check_box.dart';

import 'package:demo_app/core/custom/33-custom_haptic.dart';

import '../../theme/app_colors.dart';
import '../../custom/button.dart';
import 'custom_textformfield.dart';

class CommentsAndFeedbackScreen extends StatefulWidget {
  const CommentsAndFeedbackScreen({super.key});

  @override
  _CommentsAndFeedbackScreenState createState() => _CommentsAndFeedbackScreenState();
}

class _CommentsAndFeedbackScreenState extends State<CommentsAndFeedbackScreen> {
  Languages? selectedLanguage = Languages.english;
  final textControllerReport = TextEditingController();
  final textControllerComments = TextEditingController();
  final textControllerRequest = TextEditingController();

  // Checkbox states
  bool isReportBugsSelected = false;
  bool isCommentsSelected = false;
  bool isRequestFeatureSelected = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to rebuild when text changes
    textControllerReport.addListener(() => setState(() {}));
    textControllerComments.addListener(() => setState(() {}));
    textControllerRequest.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    textControllerReport.dispose();
    textControllerComments.dispose();
    textControllerRequest.dispose();
    super.dispose();
  }

  // Check if any checkbox is selected AND has data
  bool get hasAnyData {
    bool reportHasData = isReportBugsSelected && textControllerReport.text.trim().isNotEmpty;
    bool commentsHasData = isCommentsSelected && textControllerComments.text.trim().isNotEmpty;
    bool requestHasData = isRequestFeatureSelected && textControllerRequest.text.trim().isNotEmpty;

    return reportHasData || commentsHasData || requestHasData;
  }

  // Get button color based on data
  Color get buttonColor => hasAnyData ? AppColors.text : const Color(0xFFD9D9D9);

  // Build checkbox with label
  Widget buildCheckboxRow(String title, bool isSelected, Function(bool) onChanged) {
    var lightMode = Theme.of(context).brightness == Brightness.light;

    return InkWell(
      onTap: () => onChanged(!isSelected),
      child: Row(
        children: [
          CustomCheckBox(
            isSelected: isSelected,
            size: 20.sp,
          ),
          SizedBox(width: 10.w),
          Text(
            title.tr,
            style: AppTextStyles.font16BlackMediumCairo.copyWith(
              color: lightMode ? AppColors.blackButton : AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    final orientation = MediaQuery.of(context).orientation;
    final bool isArabic = Get.locale.toString().contains('ar');

    return MediaQuery.of(context).size.shortestSide > 600
        ? Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Fixed Title Header
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15.h,
                      right: 15.w,
                      left: 15.w,
                    ),
                    child: Row(
                      children: [
                        Center(
                          child: CustomSvg(
                            assetPath: "assets/settings/Comments and Feedbacks.svg",
                            width: 25.w,
                            height: 25.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(width: 10.sp),
                        Text(
                          'Comments And Feedbacks'.tr,
                          style: AppTextStyles.font20BlackSemiBoldCairo.copyWith(
                            color: lightMode ? AppColors.blackButton : AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.shortestSide > 600
                        ? (orientation == Orientation.portrait ? 0.02.h : 0.04.h)
                        : 0,
                  ),

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        right: 15.w,
                        left: 15.w,
                        bottom: 15.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Report Bugs Checkbox
                          buildCheckboxRow(
                            'Report Bugs'.tr,
                            isReportBugsSelected,
                                (value) {
                              setState(() {
                                isReportBugsSelected = value;
                                if (!value) {
                                  textControllerReport.clear();
                                }
                              });
                            },
                          ),

                          // Report Bugs TextField (show only if selected)
                          if (isReportBugsSelected) ...[
                            SizedBox(height: 10.h),
                            CustomValidatedTextFieldMaster(
                              label: 'Report Bugs'.tr,
                              hint: S.of(context).textHere,
                              controller: textControllerReport,
                              height: 72,
                              maxLines: 3,
                              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                              showCharCount: true,
                              onChanged: (value) => setState(() {}),
                            ),
                          ],

                          SizedBox(height: 15.h),

                          // Comments And Feedback Checkbox
                          buildCheckboxRow(
                            'Comments And Feedback'.tr,
                            isCommentsSelected,
                                (value) {
                              setState(() {
                                isCommentsSelected = value;
                                if (!value) {
                                  textControllerComments.clear();
                                }
                              });
                            },
                          ),

                          // Comments TextField (show only if selected)
                          if (isCommentsSelected) ...[
                            SizedBox(height: 10.h),
                            CustomValidatedTextFieldMaster(
                              label: 'Comments And Feedback'.tr,
                              hint: S.of(context).textHere,
                              controller: textControllerComments,
                              height: 72,
                              maxLines: 3,
                              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                              showCharCount: true,
                              onChanged: (value) => setState(() {}),
                            ),
                          ],

                          SizedBox(height: 15.h),

                          // Request New Feature Checkbox
                          buildCheckboxRow(
                            'Request New Feature'.tr,
                            isRequestFeatureSelected,
                                (value) {
                              setState(() {
                                isRequestFeatureSelected = value;
                                if (!value) {
                                  textControllerRequest.clear();
                                }
                              });
                            },
                          ),

                          // Request Feature TextField (show only if selected)
                          if (isRequestFeatureSelected) ...[
                            SizedBox(height: 10.h),
                            CustomValidatedTextFieldMaster(
                              label: 'Request New Feature'.tr,
                              hint: S.of(context).textHere,
                              controller: textControllerRequest,
                              height: 72,
                              maxLines: 3,
                              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                              showCharCount: true,
                              onChanged: (value) => setState(() {}),
                            ),
                          ],

                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // space
          SizedBox(height: 15.sp),

          // submit button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customButton(
                title: 'Confirm'.tr,
                function: hasAnyData
                    ? () {
                  hapticController.triggerHapticFeedback(
                    vibration: VibrateType.heavyImpact,
                    hapticFeedback: HapticFeedback.heavyImpact,
                  );
                }
                    : () {}, // Empty function instead of null
                textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                  color: hasAnyData ? AppColors.textButton : Colors.black,
                ),
                color: hasAnyData ? AppColors.primary : Colors.black,
                width: 300.w,
                radius: 4.r,
                height: 36.h,
              ),
            ],
          ),

          // space
          SizedBox(height: 15.sp),
        ],
      ),
    )
        : Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            CustomAppBarMobile(
              showIcon: true,
              showMoreIcon: false,
              title: "Comments And Feedbacks".tr,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.05.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h),

                      // Report Bugs Checkbox
                      buildCheckboxRow(
                        'Report Bugs',
                        isReportBugsSelected,
                            (value) {
                          setState(() {
                            isReportBugsSelected = value;
                            if (!value) {
                              textControllerReport.clear();
                            }
                          });
                        },
                      ),

                      // Report Bugs TextField
                      if (isReportBugsSelected) ...[
                        SizedBox(height: 10.h),
                        CustomValidatedTextFieldMaster(
                          label: 'Report Bugs'.tr,
                          hint: 'Enter bug details...'.tr,
                          controller: textControllerReport,
                          height: 72,
                          maxLines: 3,
                          showCharCount: true,
                          onChanged: (value) => setState(() {}),
                        ),
                      ],

                      SizedBox(height: 15.h),

                      // Comments And Feedback Checkbox
                      buildCheckboxRow(
                        'Comments And Feedback'.tr,
                        isCommentsSelected,
                            (value) {
                          setState(() {
                            isCommentsSelected = value;
                            if (!value) {
                              textControllerComments.clear();
                            }
                          });
                        },
                      ),

                      // Comments TextField
                      if (isCommentsSelected) ...[
                        SizedBox(height: 10.h),
                        CustomValidatedTextFieldMaster(
                          label: 'Comments And Feedback'.tr,
                          hint: 'Enter your comments...'.tr,
                          controller: textControllerComments,
                          height: 72,
                          maxLines: 3,
                          showCharCount: true,
                          onChanged: (value) => setState(() {}),
                        ),
                      ],

                      SizedBox(height: 15.h),

                      // Request New Feature Checkbox
                      buildCheckboxRow(
                        'Request New Feature',
                        isRequestFeatureSelected,
                            (value) {
                          setState(() {
                            isRequestFeatureSelected = value;
                            if (!value) {
                              textControllerRequest.clear();
                            }
                          });
                        },
                      ),

                      // Request Feature TextField
                      if (isRequestFeatureSelected) ...[
                        SizedBox(height: 10.h),
                        CustomValidatedTextFieldMaster(
                          label: 'Request New Feature'.tr,
                          hint: 'Describe the feature...'.tr,
                          controller: textControllerRequest,
                          height: 72,
                          maxLines: 3,
                          showCharCount: true,
                          onChanged: (value) => setState(() {}),
                        ),
                      ],

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 32,
                horizontal: 16,
              ),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: hasAnyData
                    ? () async {
                  hapticController.triggerHapticFeedback(
                    vibration: VibrateType.heavyImpact,
                    hapticFeedback: HapticFeedback.heavyImpact,
                  );

                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialogBox(
                        title: 'Thanks for sharing your feedback'.tr,
                        subtitle: 'We value our customers and strive to exceed their expectations'.tr,
                        imagePath: 'assets/images/Thanks.png',
                        backgroundColor: AppColors.text,
                        showButtons: false,
                      );
                    },
                  );

                  setState(() {
                    Get.back();
                  });
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(0.9.w, 50),
                  backgroundColor: buttonColor,
                  disabledBackgroundColor: const Color(0xFFD9D9D9),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
                child: Text(
                  'Confirm'.tr,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: FontConstants.fontSize025.h,
                    color: hasAnyData ? AppColors.text : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
