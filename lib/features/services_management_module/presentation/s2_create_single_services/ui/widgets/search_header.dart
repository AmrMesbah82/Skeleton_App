import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import 'package:demo_app/core/theme/app_colors.dart';

import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/controller/provider_selection_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/controller/provider_selection_state.dart';


class SearchHeader extends StatelessWidget {
  final TextEditingController controller;

  const SearchHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderSelectionCubit, ProviderSelectionState>(
      builder: (context, state) {
        return Row(
          children: [
            AppSearchTextField(
              fillColor: AppColors.background,
              controller: controller,
              onChanged: (value) {
                context.read<ProviderSelectionCubit>().updateSearch(value);
              },
            ),
          ],
        );
      },
    );
  }
}
