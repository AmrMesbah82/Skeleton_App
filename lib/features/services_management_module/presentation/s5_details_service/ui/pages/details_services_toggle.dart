/// ******************* FILE INFO *******************
/// File Name: details_services_toggle.dart
/// Description: toggle in All Platform of this screen
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/pages/details_services.dart';

class ToggleDetailsServicesLayout extends StatelessWidget {
  const ToggleDetailsServicesLayout({
  required this.createServicesModel ,super.key,});

 final ServicesHistoryModel createServicesModel ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          final isTablet = context.isTablet;
          final isLandscape = context.isLandscape;


          if (isTablet && isLandscape) {
            return DetailsServicesPage(createServicesModel: createServicesModel,); // // tablet
          } else if (isTablet && !isLandscape) {
            return DetailsServicesPage(createServicesModel: createServicesModel,); // // tablet
          } else if (!isTablet && isLandscape) {
            return DetailsServicesPage(createServicesModel: createServicesModel,); // mobile
          } else {
            return DetailsServicesPage(createServicesModel: createServicesModel,); // mobile
          }
        },
      ),
    );
  }
  //DetailsServicesMobile()
//DetailsServicesTablet()
//DetailsServicesDeskTop()
}


