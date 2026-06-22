/// ******************* FILE INFO *******************
/// File Name: dashBoard_details_admin.dart
/// Description: toggle in All Platform of this screen
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/pages/dashboard_details_admin.dart';

class AdminDashBordDetailsLayout extends StatelessWidget {
  const AdminDashBordDetailsLayout({super.key, required this.selectedServiceName});

  final String selectedServiceName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          final isTablet = context.isTablet;
          final isLandscape = context.isLandscape;
          final width = MediaQuery.of(context).size.width;
          final height = MediaQuery.of(context).size.height;

          if (isTablet && isLandscape) {
            return AdminDashBoardDetailsTablet(selectedServiceName: selectedServiceName,); // tablet
          } else if (isTablet && !isLandscape) {
            return AdminDashBoardDetailsTablet(selectedServiceName: selectedServiceName,); // tablet
          } else if (!isTablet && isLandscape) {
            return AdminDashBoardDetailsTablet(selectedServiceName: selectedServiceName,); // mobile
          } else {
            return AdminDashBoardDetailsTablet(selectedServiceName: selectedServiceName,); // mobile
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
return AdminDashBoardDetailsTablet(selectedServiceName: selectedServiceName); // Desktop
} else if (constrain.maxWidth >= 900) {
return AdminDashBoardDetailsTablet(selectedServiceName: selectedServiceName);// Horizontal tablet
} else if (constrain.maxWidth >= 600) {
return AdminDashBoardDetailsTablet(selectedServiceName: selectedServiceName,); // tablet
} else {
return AdminDashBoardMasterDeatilsMobile(name: selectedServiceName,); // mobile
}
},
),
);
 */
