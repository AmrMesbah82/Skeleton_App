/// ******************* FILE INFO *******************
/// File Name: create_new_services_toggle.dart
/// Description: toggle in All Platform of this screen
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
// ✅ UPDATED: Import the new refactored screen instead of the old one
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/ui/pages/create_new_services.dart'; // Remove this if no longer needed

class CreateNewServicesLayout extends StatelessWidget {
  final ServicesHistoryModel? editingModel;
  final String? docId;

  const CreateNewServicesLayout({
    super.key,
    this.editingModel,
    this.docId,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final isLandscape = context.isLandscape;

    return Scaffold(
      body: Builder(
        builder: (context) {
          final width = MediaQuery.of(context).size.width;
          final height = MediaQuery.of(context).size.height;

          // ✅ SIMPLIFIED: All conditions return the same new screen
          // You can simplify this since all branches are identical
          return CreateServiceScreen(
            editingModel: editingModel,
            docId: docId,
          );
        },
      ),
    );
  }
}
