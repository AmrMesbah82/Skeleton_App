/// ******************* FILE INFO *******************
/// File Name: approval_request_details_toggle.dart
/// Description: toggle in All Platform of this screen
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s7_approvals/ui/pages/approval_request_details.dart';

class ServicesApprovalDetailsToggle extends StatelessWidget {
  const ServicesApprovalDetailsToggle({
    Key? key,
    required this.approvalModel,
    required this.index,
    this.fromTable = false,
    this.createServicesModel, // ✅ Optional parameter
  }) : super(key: key);

  final ServicesHistoryModel approvalModel;
  final int index;
  final bool fromTable;
  final ServicesHistoryModel? createServicesModel;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final isLandscape = context.isLandscape;
    return Scaffold(
      body: Builder(
        builder: (context) {
          final width = MediaQuery.of(context).size.width;
          final height = MediaQuery.of(context).size.height;

          if (isTablet && isLandscape) {
            return ApprovalDetailsScreen(

              createServicesModel: createServicesModel,
              approvalModel: approvalModel,
              index: index,
              fromTable: fromTable,

            );
          } else if (isTablet && !isLandscape) {
            return ApprovalDetailsScreen(

              createServicesModel: createServicesModel,
              approvalModel: approvalModel,
              index: index,
              fromTable: fromTable,

            );
          } else if (!isTablet && isLandscape) {
            return ApprovalDetailsScreen(
              approvalModel: approvalModel,
              index: index,

            );
          } else {
            return ApprovalDetailsScreen(
              approvalModel: approvalModel,
              index: index,

            );
          }
        },
      ),
    );
  }
}

/*
return Scaffold(
body: LayoutBuilder(
builder: (context, constrain) {
if (constrain.maxWidth >= 1200) {
return ApprovalDetailsScreenFullScreen(
approvalModel: approvalModel,
index: index,

);
} else if (constrain.maxWidth >= 900) {
return ApprovalDetailsScreenDesktop(
approvalModel: approvalModel,
index: index,

);
} else if (constrain.maxWidth >= 600) {
return ApprovalDetailsScreenTablet(

createServicesModel: createServicesModel,
approvalModel: approvalModel,
index: index,
fromTable: fromTable,

);
} else {
return ApprovalDetailsScreenMobile(
approvalModel: approvalModel,
index: index,

);
}
},
),
);
 */
