import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/controller/create_service_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/controller/create_service_state.dart';


class StatusToggleWidget extends StatelessWidget {
  const StatusToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateServiceCubit, CreateServiceState>(
      buildWhen: (previous, current) =>
      current is CreateServiceLoaded || current is CreateServiceStatusChanged,
      builder: (context, state) {
        if (state is! CreateServiceLoaded) return const SizedBox.shrink();

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset(
              'assets/lottie/status.svg',
              width: 16.sp,
              height: 16.sp,
              fit: BoxFit.cover,
              color: AppColors.text,
            ),
            SizedBox(width: 6.sp),
            Text(
              "${S.of(context).Status}: ",
              style: AppTextStyles.font14BlackCairoRegular,
            ),
            SizedBox(width: 8.sp),
            FlutterSwitch(
              height: 22.0.sp,
              width: 38.0.sp,
              toggleSize: 17.sp,
              value: state.formData.isActive,
              borderRadius: 20.0,
              padding: 2.0,
              activeColor: AppColors.secondaryPrimary,
              onToggle: (val) async {
                final shouldChange = await _showConfirmDialog(context, val);
                if (shouldChange) {
                  context.read<CreateServiceCubit>().toggleStatus(val);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showConfirmDialog(BuildContext context, bool newValue) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatusChangeDialog(newValue: newValue),
    );
    return result ?? false;
  }
}

class StatusChangeDialog extends StatelessWidget {
  final bool newValue;

  const StatusChangeDialog({required this.newValue, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Container(
        width: 411.sp,
        padding: EdgeInsets.all(20.sp),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/lottie/Edit Document.json',
              width: 70.w,
              height: 70.h,
              fit: BoxFit.scaleDown,
              repeat: true,
              animate: true,
            ),
            SizedBox(height: 20.sp),
            Text(
              S.of(context).changingStatus,
              style: AppTextStyles.font20BlackCairoMedium.copyWith(
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 18.sp),
            Text(
              S.of(context).areYouSureToDisableService,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14BlackCairoMedium.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            SizedBox(height: 15.sp),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                      height: 38.sp,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryText,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        S.of(context).no,
                        style: AppTextStyles.font16BlackMediumCairo.copyWith(color: AppColors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 28.sp),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(true),
                    child: Container(
                      height: 38.sp,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        S.of(context).yes,
                        style: AppTextStyles.font16BlackMediumCairo.copyWith(
                          color: AppColors.textButton,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
