import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/features/home/presentation/ui/pages/dashboard_view_data/chart_settings_dialog.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/controller/create_service_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/controller/create_service_state.dart';


class ActionButtonsRow extends StatelessWidget {
  final VoidCallback onDiscard;

  const ActionButtonsRow({required this.onDiscard, super.key});

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;

    return BlocBuilder<CreateServiceCubit, CreateServiceState>(
      buildWhen: (previous, current) => current is CreateServiceLoaded,
      builder: (context, state) {
        final isValid = state is CreateServiceLoaded && state.formData.isFormValid;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Discard Button
            customButton(
              title: S.of(context).discard,
              function: onDiscard,
              textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                color: lightMode ? AppColors.black : AppColors.white,
              ),
              width: 150.sp,
              height: 38.sp,
              radius: 8.r,
              color: lightMode ? AppColors.grey : AppColors.mediumGrey,
            ),

            // Next Button
            customButton(
              title: S.of(context).next,
              function: () => context.read<CreateServiceCubit>().submitForm(),
              textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                color: isValid ? AppColors.textButton : (lightMode ? AppColors.black : AppColors.white),
              ),
              width: 150.sp,
              height: 38.sp,
              radius: 8.r,
              color: isValid ? AppColors.primary : (lightMode ? AppColors.grey : AppColors.mediumGrey),
            ),
          ],
        );
      },
    );
  }
}
