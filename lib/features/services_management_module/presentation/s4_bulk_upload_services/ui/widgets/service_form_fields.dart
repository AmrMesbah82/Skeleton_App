import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/custom/2-custom_textfield.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_dropdown.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/widgets/services_management/custom_reasponsive_filed.dart';
import 'package:demo_app/core/widgets/services_management/custom_textformfield.dart';
import 'package:demo_app/core/widgets/services_management/dropdown_no_lable.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/controller/create_service_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/controller/create_service_state.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/ui/widgets/image_upload_widget.dart';

class ServiceFormFields extends StatefulWidget {
  const ServiceFormFields({super.key});

  @override
  State<ServiceFormFields> createState() => _ServiceFormFieldsState();
}

class _ServiceFormFieldsState extends State<ServiceFormFields> {
  // Create controllers once
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;
  late final TextEditingController _descEnController;
  late final TextEditingController _descArController;
  late final TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    _nameEnController = TextEditingController();
    _nameArController = TextEditingController();
    _descEnController = TextEditingController();
    _descArController = TextEditingController();
    _durationController = TextEditingController();
  }

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameArController.dispose();
    _descEnController.dispose();
    _descArController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocConsumer<CreateServiceCubit, CreateServiceState>(
      listenWhen: (previous, current) {
        // Listen when form data changes from external sources
        if (previous is CreateServiceLoaded && current is CreateServiceLoaded) {
          return previous.formData != current.formData;
        }
        return false;
      },
      listener: (context, state) {
        if (state is CreateServiceLoaded) {
          // Update controllers only if values are different
          _syncControllers(state.formData);
        }
      },
      buildWhen: (previous, current) => current is CreateServiceLoaded,
      builder: (context, state) {
        if (state is! CreateServiceLoaded) return const SizedBox.shrink();

        final cubit = context.read<CreateServiceCubit>();
        final formData = state.formData;

        // Initialize controllers with current values (only once)
        _initializeControllers(formData);

        return Form(
          child: Container(
            padding: EdgeInsets.only(top: 15.sp, right: 15.sp, left: 15.sp),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: [
                const ImageUploadWidget(),
                SizedBox(height: 24.sp),

                // Service Names
                isArabic
                    ? buildResponsiveFields(
                  left: _buildNameArField(cubit, state.submitted),
                  right: _buildNameEnField(cubit, state.submitted),
                  context: context,
                )
                    : buildResponsiveFields(
                  left: _buildNameEnField(cubit, state.submitted),
                  right: _buildNameArField(cubit, state.submitted),
                  context: context,
                ),

                SizedBox(height: 15.h),

                // Descriptions
                _buildDescriptionFields(context, cubit, state.submitted),

                SizedBox(height: 15.h),

                // Duration
                _buildDurationRow(context, cubit, formData, state.submitted),

                SizedBox(height: 15.h),
              ],
            ),
          ),
        );
      },
    );
  }

  void _initializeControllers(dynamic formData) {
    // Only set text if controller is empty and formData has value
    if (_nameEnController.text.isEmpty && formData.serviceNameEn.isNotEmpty) {
      _nameEnController.text = formData.serviceNameEn;
    }
    if (_nameArController.text.isEmpty && formData.serviceNameAr.isNotEmpty) {
      _nameArController.text = formData.serviceNameAr;
    }
    if (_descEnController.text.isEmpty && formData.descriptionEn.isNotEmpty) {
      _descEnController.text = formData.descriptionEn;
    }
    if (_descArController.text.isEmpty && formData.descriptionAr.isNotEmpty) {
      _descArController.text = formData.descriptionAr;
    }
    if (_durationController.text.isEmpty && formData.durationValue.isNotEmpty) {
      _durationController.text = formData.durationValue;
    }
  }

  void _syncControllers(dynamic formData) {
    // Only update if text is different to avoid cursor jumping
    if (_nameEnController.text != formData.serviceNameEn) {
      _nameEnController.text = formData.serviceNameEn;
    }
    if (_nameArController.text != formData.serviceNameAr) {
      _nameArController.text = formData.serviceNameAr;
    }
    if (_descEnController.text != formData.descriptionEn) {
      _descEnController.text = formData.descriptionEn;
    }
    if (_descArController.text != formData.descriptionAr) {
      _descArController.text = formData.descriptionAr;
    }
    if (_durationController.text != formData.durationValue) {
      _durationController.text = formData.durationValue;
    }
  }

  Widget _buildNameEnField(
      CreateServiceCubit cubit,
      bool submitted, {
        String? errorMessage,
      }) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: CustomTextField(
        controller: _nameEnController,
        height: 36,
        maxLines: 1,
        restrictByDirection: true,
        autoCapitalize: true,
        label: "Services Name",
        submitted: submitted,
        hint: 'Text Here',
        onChanged: (value) {
          cubit.updateServiceNameEn(value);
        },
      ),
    );
  }

  Widget _buildNameArField(
      CreateServiceCubit cubit,
      bool submitted, {
        String? errorMessage,
      }) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: CustomTextField(
        controller: _nameArController,
        height: 36,
        maxLines: 1,
        restrictByDirection: true,
        autoCapitalize: true,
        label: 'اسم الخدمة',
        hint: 'اكتب هنا',
        textDirection: ui.TextDirection.rtl,
        submitted: submitted,
        onChanged: (value) {
          cubit.updateServiceNameAr(value);
        },
      ),
    );
  }

  Widget _buildDescriptionFields(
      BuildContext context,
      CreateServiceCubit cubit,
      bool submitted,
      ) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (isArabic) {
      return Column(
        children: [
          Directionality(
            textDirection: ui.TextDirection.rtl,
            child: CustomTextField(
              controller: _descArController,
              height: 72,
              label: 'وصف الخدمة',
              submitted: submitted,
              onChanged: (value) {
                cubit.updateDescriptionAr(value);
              },
              hint: 'اكتب هنا',
              maxLines: 3,
              restrictByDirection: true,
              autoCapitalize: true,
              textDirection: ui.TextDirection.rtl,
              showCharCount: true,
            ),
          ),
          SizedBox(height: 15.sp),
          Directionality(
            textDirection: ui.TextDirection.ltr,
            child: CustomTextField(
              controller: _descEnController,
              height: 72,
              label: 'Service Description',
              hint: 'Text here',
              submitted: submitted,
              maxLines: 3,
              restrictByDirection: true,
              autoCapitalize: true,
              showCharCount: true,
              textDirection: ui.TextDirection.ltr,
              onChanged: (value) {
                cubit.updateDescriptionEn(value);
              },
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Directionality(
            textDirection: ui.TextDirection.ltr,
            child: CustomTextField(
              controller: _descEnController,
              height: 72,
              label: 'Service Description',
              hint: 'Text here',
              maxLines: 3,
              restrictByDirection: true,
              autoCapitalize: true,
              submitted: submitted,
              showCharCount: true,
              textDirection: ui.TextDirection.ltr,
              onChanged: (value) {
                cubit.updateDescriptionEn(value);
              },
            ),
          ),
          SizedBox(height: 15.sp),
          Directionality(
            textDirection: ui.TextDirection.rtl,
            child: CustomTextField(
              controller: _descArController,
              height: 72,
              label: 'وصف الخدمة',
              onChanged: (value) {
                cubit.updateDescriptionAr(value);
              },
              hint: 'اكتب هنا',
              maxLines: 3,
              restrictByDirection: true,
              autoCapitalize: true,
              submitted: submitted,
              textDirection: ui.TextDirection.rtl,
              showCharCount: true,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildDurationRow(
      BuildContext context,
      CreateServiceCubit cubit,
      dynamic formData,
      bool submitted,
      ) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final durationUnits = [
      {"key": "minutes", "value": S.of(context).minutes},
      {"key": "hours", "value": S.of(context).hours},
      {"key": "days", "value": S.of(context).days},
      {"key": "weeks", "value": S.of(context).week},
    ];

    return Row(
      children: [
        SizedBox(
          width: context.isPhone
              ? 200.sp
              : (context.isTablet && !context.isLandscape ? 250.sp : 350.sp),
          child: Directionality(
            textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
            child: CustomTextField(
              controller: _durationController,
              height: 36,
              label: S.of(context).durationOfService,
              hint: S.of(context).Texthere,
              onlyDigits: true,
              submitted: submitted,
              textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
              onChanged: (value) {
                cubit.updateDurationValue(value);
              },
            ),
          ),
        ),
        SizedBox(width: 12.sp),
        Directionality(
          textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
          child: CustomDropdownFormFieldInvMaster(
            selectedValue: formData.durationUnit,
            height: 36,
            label: "",
            borderRadius: 4.r,
            spaceHeight: 6.sp,
            hint: Text(isArabic ? "اختر الوحدة" : "chooseUnit"),
            items: durationUnits,
            width: context.isPhone
                ? 100.sp
                : (context.isTablet && !context.isLandscape ? 120.sp : 120.sp),
            dropdownColor: AppColors.background,
            widthIcon: 12.w,
            heightIcon: 6.h,
            iconPath: "assets/arrowdown.svg",
            onChanged: (value) => cubit.updateDurationUnit(value!),
          ),
        ),
      ],
    );
  }
}
