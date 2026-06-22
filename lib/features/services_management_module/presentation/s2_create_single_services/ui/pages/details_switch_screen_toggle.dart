/// ******************* FILE INFO *******************
/// File Name: details_switch_screen_toggle.dart
/// Description: toggle in All Platform of this screen
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/pages/details_switch_screen.dart';

class DetailsToggleScreen extends StatelessWidget {
  final ServicesHistoryModel? editingModel;
  final String? docId;

  const DetailsToggleScreen({super.key, this.editingModel, this.docId});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isPhone;
    final isTablet = context.isTablet;
    final isLandscape = context.isLandscape;
    return Scaffold(
      body: Builder(
        builder: (context) {


          if (isTablet && isLandscape) { // desktop
            return DetailsSwitchScreenTablet(editingModel: editingModel, docId: docId);

          } else if (isTablet && !isLandscape) { // tablet
            return DetailsSwitchScreenTablet(editingModel: editingModel, docId: docId);


          } else if (!isTablet && isLandscape) {
            return DetailsSwitchScreenTablet(editingModel: editingModel, docId: docId);

          } else {
            return DetailsSwitchScreenTablet(editingModel: editingModel, docId: docId);

          }
        },
      ),
    );



  }
}

