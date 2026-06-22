import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/controller/provider_selection_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/controller/provider_selection_state.dart';

class ActionButtonsRow extends StatelessWidget {
  const ActionButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderSelectionCubit, ProviderSelectionState>(
      builder: (context, state) {
        if (state is! ProviderSelectionLoaded) return const SizedBox.shrink();

        final cubit = context.read<ProviderSelectionCubit>();
        final data = state.data;
        final isEditProvider = data.editProvider != null;

        return Row(
          children: [
            customButtonAnimation(
              // ✅ "Discard" in editProvider mode, "Back" otherwise
              title: isEditProvider
                  ? (Localizations.localeOf(context).languageCode == 'ar'
                  ? 'تجاهل'
                  : 'Discard')
                  : S.of(context).back,
              function: () {
                // ✅ Both Discard and Back just pop — no saving
                Navigator.pop(context);
              },
              textStyle: AppTextStyles.font16BlackMediumCairo
                  .copyWith(color: const Color(0xff2D2D2D)),
              width: 150.sp,
              height: 38.sp,
              radius: 8.r,
              color: const Color(0xffCCCCCCCC).withOpacity(.8),
            ),
            const Spacer(),
            customButtonAnimation(
              title: isEditProvider
                  ? S.of(context).Save
                  : S.of(context).next,
              function: () => cubit.handleNextNavigation(),
              width: 150.sp,
              height: 38.sp,
              color: AppColors.primary,
              textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                color: AppColors.textButton,
              ),
              radius: 8.r,
            ),
          ],
        );
      },
    );
  }
}
