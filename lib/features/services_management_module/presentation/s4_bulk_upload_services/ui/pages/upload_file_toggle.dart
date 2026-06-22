/// ******************* FILE INFO *******************
/// File Name: upload_file_toggle.dart
/// Description: toggle in All Platform of this screen
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'package:flutter/material.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/ui/pages/upload_file.dart';







class ToggleUploadFile extends StatelessWidget {
  const ToggleUploadFile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
          builder: (context, constrain){
            if (constrain.maxWidth >= 1200) {
              return UploadFileTablet(); // Desktop
            } else if (constrain.maxWidth >= 900) {
              return UploadFileTablet(); // Horizontal tablet
            } else if (constrain.maxWidth >= 600) {
              return UploadFileTablet(); // // tablet
            } else {
              return Center(child: Text("// mobile"),); // mobile
            }

          }),
    );
  }

}
