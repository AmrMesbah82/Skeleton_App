import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import 'package:demo_app/core/custom_knowticed_dropdwon.dart';
import 'package:demo_app/core/theme/new_theme.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/core/extension/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/app_search_text_field.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/data_grc_module/core/extensions/extensions.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/knowledge_hub_module/core/theming/new_theme.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';

import '../../../../../../core/helper/format_helper.dart';
import '../../../../../../core/widgets/app_dropdown.dart';
import '../../../../../../core/widgets/small_drop_down.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../controller/user_management_cubit.dart';

class AccessSearchAndFilter extends StatefulWidget {
  AccessSearchAndFilter({super.key});

  @override
  State<AccessSearchAndFilter> createState() => _AccessSearchAndFilterState();
}

class _AccessSearchAndFilterState extends State<AccessSearchAndFilter> {
  late UserManagementAccessCubit controller;

  @override
  Widget build(BuildContext context) {
    controller = context.read<UserManagementAccessCubit>();
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.sp,
      children: [
        Row(
          spacing: 10.sp,
          children: [
            AppSearchTextField(

              controller: controller.addNewSearchController,
              onChanged: (value) {
                controller.filterEmployeesToGiveAccess(value);
              },
            ),
            _buildDepartment(context)
          ],
        ),
      ],
    );
  }

  Widget _buildDepartment(BuildContext context) {
    final departmentItems = Get.find<MainCoreDepartmentController>()
        .departmentIds
        .map((String department) => department)
        .toList();

    final width = ContextExtension(context).isTablet ? 180.sp : 120.sp;

    return Customdemo_appDropdown<String>(
      width: width,
      height: 35.h,
      language: context.isArabic ? AppLanguage.arabic : AppLanguage.english,
      labelEn: '',
      labelAr: '',
      hintEn: 'Select Department',
      hintAr: S.of(context).department,
      items: departmentItems,
      itemLabelBuilder: (department) => FormatHelper.capitalize(
        context.isArabic
            ? Get.find<MainCoreDepartmentController>()
            .getArabicDepartmentNameFromDepartmentId(
            departmentId: department) ??
            ''
            : Get.find<MainCoreDepartmentController>()
            .getEnglishDepartmentNameFromDepartmentId(
            departmentId: department) ??
            '',
      ),
      value: controller.addNewAccessDepartmentId,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      borderRadius: 8.r,
      onChanged: (value) {
        if (controller.addNewAccessDepartmentId == value) {
          controller.addNewAccessDepartmentId = null;
        } else {
          controller.addNewAccessDepartmentId = value;
        }
        controller.filterEmployeesToGiveAccess(
            controller.addNewSearchController.text);
        setState(() {});
      },
      hoverBackgroundColor: AppColors.primary,
      fillColor: AppColors.card,
      borderColor: AppColors.background,
      focusedBorderColor: AppColors.primary,
      errorBorderColor: Colors.red[600],
      hoverTextColor: AppColors.textButton,
      defaultTextColor: AppColors.text,
      labelStyle: StyleText.fontSize16Weight500.copyWith(
        color: AppColors.text,
      ),
      hintStyle: StyleText.fontSize14Weight500.copyWith(
        color: AppColors.secondaryText.withOpacity(.7),
      ),
      itemStyle: StyleText.fontSize14Weight500.copyWith(
        color: AppColors.text,
      ),
      iconColor: AppColors.secondaryText,

      borderWidth: 1,
      isRequired: false,
    );
  }
}