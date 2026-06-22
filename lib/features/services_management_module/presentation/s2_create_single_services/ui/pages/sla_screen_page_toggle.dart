/// ******************* FILE INFO *******************
/// File Name: sla_screen_page_toggle.dart
/// Description: toggle in All Platform of this screen
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/pages/sla_screen_page.dart';

import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s12_sla_mobile/ui/pages/sla_screen_mobile.dart';







class ToggleSlaScreen extends StatelessWidget {
  final ServicesHistoryModel? editingModel;

  const ToggleSlaScreen({super.key, this.editingModel});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final isLandscape = context.isLandscape;
    return Scaffold(
      body: Builder(
        builder: (context) {

          if (isTablet && isLandscape) {
            return SlaScreenPageTablet(editingModel: editingModel); // tablet


          } else if (isTablet && !isLandscape) {
            return SlaScreenPageTablet(editingModel: editingModel); // tablet



          } else if (!isTablet && isLandscape) {
            return SlaScreenMobile(editingModel: editingModel); // mobile

          } else {
            return SlaScreenMobile(editingModel: editingModel); // mobile

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
return SlaScreenFullScreen(); // Desktop
} else if (constrain.maxWidth >= 900) {
return SlaScreenDesktop(); // Horizontal tablet
} else if (constrain.maxWidth >= 600) {
return SlaScreenPageTablet(editingModel: editingModel); // tablet
} else {
return SlaScreenMobile(editingModel: editingModel); // mobile
}
},
),
);
 */
