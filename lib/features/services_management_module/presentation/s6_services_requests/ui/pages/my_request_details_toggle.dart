/// ******************* FILE INFO *******************
/// File Name: my_request_details_toggle.dart
/// Description: toggle in All Platform of this screen
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/pages/my_request_details.dart';

class MyRequestDetailsServicesToggle extends StatelessWidget {
  const MyRequestDetailsServicesToggle({
    required this.myRequestDetailsModel,
    super.key,
  });

  final ServicesHistoryModel myRequestDetailsModel;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final isLandscape = context.isLandscape;

    return Scaffold(
      body: isTablet
          ? (isLandscape
      // Tablet • Landscape
          ? MyRequestDetails(myRequestDetailsModel: myRequestDetailsModel)
      // Tablet • Portrait
          : MyRequestDetails(myRequestDetailsModel: myRequestDetailsModel))
          : (isLandscape
      // Phone • Landscape
          ? MyRequestDetails(myRequestDetailsModel: myRequestDetailsModel)
      // Phone • Portrait
          : MyRequestDetails(myRequestDetailsModel: myRequestDetailsModel)),
    );
  }
}
