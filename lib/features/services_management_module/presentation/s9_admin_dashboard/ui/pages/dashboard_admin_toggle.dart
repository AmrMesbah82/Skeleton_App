
/// ******************* FILE INFO *******************
/// File Name: dashBoard_admin.dart
/// Description: toggle in All Platform of this screen
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/pages/dashboard_admin.dart';

class AdminDashBordLayout extends StatelessWidget {
  const AdminDashBordLayout({super.key});

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
            return AdminDashBoardMasterTablet(); // // tablet
          } else if (isTablet && !isLandscape) {
            return AdminDashBoardMasterTablet(); // // tablet
          } else if (!isTablet && isLandscape) {
            return AdminDashBoardMasterTablet(); // mobile
          } else {
            return AdminDashBoardMasterTablet(); // mobile
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
return AdminDashBoardMasterTablet(); // Desktop
} else if (constrain.maxWidth >= 900) {
return AdminDashBoardMasterTablet(); // Horizontal tablet
} else if (constrain.maxWidth >= 600) {
return AdminDashBoardMasterTablet(); // // tablet
} else {
return AdminDashBoardMasterMobile(); // mobile
}
},
),
);
 */
