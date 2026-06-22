import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/core/helper/cross_axis_count_helper.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/controller/provider_selection_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/controller/provider_selection_state.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/widgets/provider_card_widget.dart';

class ProviderGridWidget extends StatelessWidget {
  const ProviderGridWidget({super.key});

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
        final data = state.data;

        var availableEmployees = List.from(state.allEmployees);

        if (data.isEditMode && data.originalProviderEmail != null) {
          // CHANGED: Use public method normalizeEmail instead of _normalizeEmail
          final normalizedOriginal = cubit.normalizeEmail(data.originalProviderEmail);
          availableEmployees = availableEmployees
              .where((e) => cubit.normalizeEmail(e.email) != normalizedOriginal)
              .toList();
        }

        final list = state.filteredEmployees.isNotEmpty
            ? state.filteredEmployees
            : availableEmployees;

        if (list.isEmpty) {
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

        final double rowHeight = 73.sp;
        final double spacing = 16.sp;
        final int maxRows = 3;
        final double gridHeight = (rowHeight * maxRows) + (spacing * (maxRows - 1));

        return Padding(
          padding: EdgeInsets.only(bottom: 10.sp),
          child: SizedBox(
            height: gridHeight,
            child: GridView.builder(
              itemCount: list.length,
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: CrossAxisCountHelper.getCrossAxisCountForDefaultTablet2(context),
                mainAxisExtent: 75.sp,
                crossAxisSpacing: 15.sp,
                mainAxisSpacing: 15.sp,
              ),
              itemBuilder: (context, index) {
                final employee = list[index];
                return ProviderCardWidget(
                  employee: employee,
                  // CHANGED: Use public method normalizeEmail
                  isSelected: data.selectedEmployeeEmails.contains(
                    cubit.normalizeEmail(employee.email),
                  ),
                  onTap: () => cubit.toggleProviderSelection(employee.email ?? ''),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
