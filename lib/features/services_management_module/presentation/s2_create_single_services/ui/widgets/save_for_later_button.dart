import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/5-custom_button.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/controller/provider_selection_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/controller/provider_selection_state.dart';

class SaveForLaterButton extends StatelessWidget {
  const SaveForLaterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderSelectionCubit, ProviderSelectionState>(
      builder: (context, state) {
        if (state is! ProviderSelectionLoaded) return const SizedBox.shrink();

        final data = state.data;

        final isEditingSubmittedService =
            data.editingModel != null && data.editingModel!.state != "submitted";

        final isDraft = data.editingModel != null &&
            (data.editingModel!.currentState == "draft" ||
                data.editingModel!.currentDurationOfServices == "-" ||
                data.editingModel!.currentDurationOfServices.isEmpty);

        final shouldShow = !isEditingSubmittedService || isDraft;

        if (!shouldShow) return const SizedBox.shrink();

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            customButtonAnimation(
              title: isEditingSubmittedService && isDraft
                  ? S.of(context).saveForLater
                  : isEditingSubmittedService
                  ? S.of(context).discardChange
                  : S.of(context).saveForLater,
              function: () => _handleSaveForLater(context, isEditingSubmittedService, isDraft),
              textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(color: const Color(0xff2D2D2D)),
              width: 150.sp,
              height: 38.sp,
              radius: 8.r,
              color: const Color(0xffCCCCCCCC).withOpacity(.8),
            ),
          ],
        );
      },
    );
  }

  void _handleSaveForLater(BuildContext context, bool isEditingSubmittedService, bool isDraft) {
    final cubit = context.read<ProviderSelectionCubit>();

    if (isEditingSubmittedService && !isDraft) {
      // Navigate to details without saving
      return;
    }

    // Show confirmation and save to FIREBASE (not local)
    _showDraftConfirmation(context, cubit, isDraft);
  }

  void _showDraftConfirmation(BuildContext context, ProviderSelectionCubit cubit, bool isDraft) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        title: Row(
          children: [
             Icon(Icons.save, color: AppColors.blue),
            SizedBox(width: 8.w),
            Text(S.of(context).saveForLater),
          ],
        ),
        content: Text(S.of(context).areYouSureYouWantToSaveAsDraft),
        actions: [
          customButton(
            title: S.of(context).no,
            function: () => Navigator.pop(context),
            width: 80.sp,
            height: 36.sp,
            color: AppColors.card,
            textColor: AppColors.text,
          ),
          customButton(
            title: S.of(context).yes,
            function: () async {
              Navigator.pop(context);
              await cubit.handleSaveForLaterToFirebase(); // 🔥 NEW METHOD
            },
            width: 80.sp,
            height: 36.sp,
            color: AppColors.primary,
            textColor: AppColors.textButton,
          ),
        ],
      ),
    );
  }
}
