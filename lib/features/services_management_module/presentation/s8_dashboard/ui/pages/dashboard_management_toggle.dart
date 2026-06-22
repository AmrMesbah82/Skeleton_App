/// ******************* FILE INFO *******************
/// File Name: dashBoard_management_toggle.dart
/// Description: toggle in All Platform of this screen
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/ui/pages/dashBord_mobile.dart';

class DashBordLayout extends StatelessWidget {
  const DashBordLayout({super.key});

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
            return DashBoardMasterMobile(); // // tablet// // tablet
          } else if (isTablet && !isLandscape) {
            return DashBoardMasterMobile(); // // tablet // tablet
          } else if (!isTablet && isLandscape) {
            return DashBoardMasterMobile();
          } else {
            return DashBoardMasterMobile();
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
return DashBoardMasterFullScreen(); // Desktop
} else if (constrain.maxWidth >= 900) {
return DashBoardMasterDesktop(); // Horizontal tablet
} else if (constrain.maxWidth >= 600) {
return DashBoardMasterTablet(); // // tablet
} else {
return DashBoardMasterMobile(); // mobile
}
},
),
);
 */
