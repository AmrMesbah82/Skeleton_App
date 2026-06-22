/// ******************* FILE INFO *******************
/// File Name: details_table_section.dart
/// Description: Table (tablet) or Cards (mobile) for Dashboard Details
/// Created by: Amr Mesbah
/// *************************************************

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/table.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/controller/request_statistics_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/controller/request_statistics_state.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/build_services_card.dart';

import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/table_widget.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/employee_card.dart';

class DetailsTableSection extends StatelessWidget {
  final DashboardDetailsState state;
  final DashboardDetailsCubit cubit;
  final String locale;

  const DetailsTableSection({
    super.key,
    required this.state,
    required this.cubit,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isPhone;

    if (state.showRequestedServices) {
      if (isMobile) {
        return ServiceRequestMobileCard(
          displayedItems: state.displayedItems,
          locale: locale,
          enToArDepartments: state.enToArDepartments,
          onTap: (item) {},
        );
      }
      return ServiceRequestTableWidget(
        filteredItems: state.displayedItems,
        locale: locale,
        enToArDepartments: state.enToArDepartments,
        onRowTap: (item) {},
      );
    }

    return EmployeeStatsCard(
      filteredItems: state.filteredItems,
      locale: locale,
      enToArDepartments: state.enToArDepartments,
      getUniqueProviderEmails: cubit.getUniqueProviderNames,
      calculateProviderStats: cubit.calculateProviderStats,
    );
  }
}
