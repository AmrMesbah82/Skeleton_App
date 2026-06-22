import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/widgets/provider_card.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/widgets/services_management/custom_grid_view.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/controller/provider_selection_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/controller/provider_selection_state.dart';

import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';


class ProviderGrid extends StatelessWidget {
  const ProviderGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderSelectionCubit, ProviderSelectionState>(
      buildWhen: (previous, current) =>
      current is ProviderSelectionLoaded &&
          (previous is! ProviderSelectionLoaded ||
              previous.filteredEmployees != current.filteredEmployees ||
              previous.data.selectedEmployeeEmails != current.data.selectedEmployeeEmails),
      builder: (context, state) {
        if (state is! ProviderSelectionLoaded) return const SizedBox.shrink();

        final cubit = context.read<ProviderSelectionCubit>();
        final employees = state.filteredEmployees;

        if (employees.isEmpty) {
          return _buildEmptyState(context);
        }

        return SizedBox(
          height: 250.sp, // Adjust based on your needs
          child: GridView.builder(
            itemCount: employees.length,
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: CrossAxisCountHelperResponsive.getCrossAxisCountForDefaultTabletResponsive(context),
              mainAxisExtent: 75.sp,
              crossAxisSpacing: 15.sp,
              mainAxisSpacing: 15.sp,
            ),
            itemBuilder: (context, index) {
              final employee = employees[index];
              final isSelected = state.data.selectedEmployeeEmails.contains(
                cubit.normalizeEmail(employee.email),
              );
              return ProviderCard(
                employee: employee,
                isSelected: isSelected,
                onTap: () => cubit.toggleProviderSelection(employee.email ?? ''),
                isEditMode: state.data.isEditMode, // ✅ NEW
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Text(
          Localizations.localeOf(context).languageCode == 'ar'
              ? 'لا يوجد موظفون متاحون'
              : 'No employees available',
          style: AppTextStyles.font14BlackCairoRegular.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    // Your logic here
    return 3;
  }
}
