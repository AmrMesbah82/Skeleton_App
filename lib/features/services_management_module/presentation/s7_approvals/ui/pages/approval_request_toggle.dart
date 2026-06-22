/// ******************* FILE INFO *******************
/// File Name: approval_request_toggle.dart
/// Description: toggle in All Platform of this screen
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:demo_app/features/services_management_module/presentation/s7_approvals/ui/pages/approval_request.dart';

class ApprovalToggle extends StatelessWidget {
  const ApprovalToggle({super.key});

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
            return ApprovalServices(); // // tablet// // tablet
          } else if (isTablet && !isLandscape) {
            return ApprovalServices(); // // tablet // tablet
          } else if (!isTablet && isLandscape) {
            return ApprovalServices();
          } else {
            return ApprovalServices();
          }
        },
      ),
    );
  }
//CreatingNewServiceMobile()
//CreatingNewServiceScreen()
//CreatingNewServiceDesktop()
}

/*

return Scaffold(
body: LayoutBuilder(
builder: (context, constrain){
if (constrain.maxWidth >= 1200) {
return ApprovalMasterFullScreen(); // Desktop
} else if (constrain.maxWidth >= 900) {
return ApprovalMasterDesktop(); // Horizontal tablet
} else if (constrain.maxWidth >= 600) {
return ApprovalMasterTablet(); // // tablet
} else {
return MasterApprovalMobile(); // mobile
}

}),
);
 */
