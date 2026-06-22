import 'package:flutter/material.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/build_services_card.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/table.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/features/services_management_module/presentation/s7_approvals/ui/pages/approval_request_details.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/controller/details_services_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/controller/details_services_state.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/helper_method.dart';

class RequestedServicesTabWidget extends StatelessWidget {
  final ServicesHistoryModel createServicesModel;

  const RequestedServicesTabWidget({
    required this.createServicesModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = DetailsServicesCubit.get(context);
    final isMobile = context.isPhone;

    return BlocBuilder<DetailsServicesCubit, DetailsServicesState>(
      builder: (context, state) {
        final displayedItems = cubit.displayedItems;

        if (isMobile) {
          // Mobile: Show empty message or cards
          if (displayedItems.isEmpty) {
            return Center(
              child: Text(S.of(context).noServicesFound),
            );
          }

          return Column(
            children: displayedItems
                .map(
                  (item) => GestureDetector(
                onTap: () {
                  final model = item['model'] as ServicesHistoryModel;
                  navigateTo(
                    context,
                    ApprovalDetailsScreen(
                      approvalModel: model,
                      index: displayedItems.indexOf(item),
                      fromTable: true,
                      createServicesModel: createServicesModel,
                    ),
                  );
                },
                child: buildServiceCardFromMap(item, context),
              ),
            )
                .toList(),
          );
        } else {
          // Tablet/Desktop: ALWAYS show table (with or without data)
          return tableDetailsServices(
            context,
            createServicesModel,
            displayedItems, // Pass empty list or data list - table handles both
          );
        }
      },
    );
  }
}
