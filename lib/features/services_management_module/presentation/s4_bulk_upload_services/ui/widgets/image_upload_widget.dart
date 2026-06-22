import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/controller/create_service_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/controller/create_service_state.dart';


class ImageUploadWidget extends StatelessWidget {
  const ImageUploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final lightMode = Theme.of(context).brightness == Brightness.light;

    return BlocBuilder<CreateServiceCubit, CreateServiceState>(
      buildWhen: (previous, current) =>
      current is CreateServiceLoaded || current is CreateServiceImageUploaded,
      builder: (context, state) {
        if (state is! CreateServiceLoaded) return const SizedBox.shrink();

        final imageUrl = state.formData.imageUrl;
        final hasImage = imageUrl != null || state.webImage != null || state.selectedImage != null;

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: state.isUploadingImage
                  ? null
                  : () => context.read<CreateServiceCubit>().pickImage(),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: AppColors.background,
                    backgroundImage: _getImageProvider(state),
                    child: _getImageChild(state, lightMode),
                  ),
                  if (!hasImage && !state.isUploadingImage)
                    _buildCameraIcon(isArabic),
                  if (state.isUploadingImage)
                    _buildLoadingIndicator(isArabic),
                  if (hasImage && !state.isUploadingImage)
                    _buildDeleteButton(context, isArabic),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  ImageProvider? _getImageProvider(CreateServiceLoaded state) {
    if (state.formData.imageUrl != null) {
      return NetworkImage(state.formData.imageUrl!);
    } else if (kIsWeb && state.webImage != null) {
      return MemoryImage(state.webImage!);
    } else if (!kIsWeb && state.selectedImage != null) {
      return FileImage(state.selectedImage!);
    }
    return null;
  }

  Widget? _getImageChild(CreateServiceLoaded state, bool lightMode) {
    final hasImage = state.formData.imageUrl != null ||
        state.webImage != null ||
        state.selectedImage != null;
    if (hasImage) return null;

    return Container(
      width: 30.sp,
      height: 30.sp,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Center(
        child: SvgPicture.asset(
          "assets/images/img.svg",
          width: 40.sp,
          height: 40.sp,
          fit: BoxFit.fill,
          color: AppColors.text,
        ),
      ),
    );
  }

  Widget _buildCameraIcon(bool isArabic) {
    return Positioned(
      right: isArabic ? 30.sp : 0,
      bottom: 0,
      child: Container(
        width: 20.sp,
        height: 20.sp,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          "assets/images/Camera.svg",
          width: 1.sp,
          height: 111.sp,
          color: AppColors.textButton,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(bool isArabic) {
    return Positioned(
      right: isArabic ? 30.sp : 0,
      bottom: 0,
      child: Container(
        width: 20.sp,
        height: 20.sp,
        decoration:  BoxDecoration(
          color: AppColors.grey,
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          width: 12.sp,
          height: 12.sp,
          child:  CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, bool isArabic) {
    return Align(
      alignment: isArabic ? Alignment.bottomLeft : Alignment.bottomRight,
      child: GestureDetector(
        onTap: () => _showDeleteConfirmation(context),
        child: Container(
          width: 15.sp,
          height: 15.sp,
          decoration:  BoxDecoration(
            color: AppColors.red,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.close,
            color: AppColors.white,
            size: 12.sp,
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        content: DeleteImageDialogContent(),
      ),
    );

    if (confirmed == true) {
      context.read<CreateServiceCubit>().removeImage();
    }
  }
}

class DeleteImageDialogContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 137.sp,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie.asset(
          //   'assets/lottie/rejected.json',
          //   width: 70.sp,
          //   height: 70.sp,
          //   fit: BoxFit.scaleDown,
          // ),
          SizedBox(height: 12.sp),
          Text(
            'Are you sure to delete image?', // Use S.of(context).areYouSureToDeleteImage
            textAlign: TextAlign.center,
            style: AppTextStyles.font14BlackCairoRegular.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          SizedBox(height: 10.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Container(
                  width: 100.sp,
                  height: 36.sp,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.sp),
                    color: AppColors.primary,
                  ),
                  child: Center(
                    child: Text(
                      'Delete', // Use S.of(context).delete
                      style: AppTextStyles.font15BlackCairoRegular.copyWith(
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
    );
  }
}
