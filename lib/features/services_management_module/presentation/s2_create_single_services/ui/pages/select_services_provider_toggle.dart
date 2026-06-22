/// ******************* FILE INFO *******************
/// File Name: select_services_provider_toggle.dart
/// Description: toggle in All Platform of this screen
/// Created by: Amr Mesbah
/// Last Update: 6/2/2026

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/pages/select_services_provider.dart';

import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';

class ServicesProviderLayout extends StatelessWidget {
  final ServicesHistoryModel? editingModel;
  final String? docId;
  final ServicesHistoryModel? editProvider;

  const ServicesProviderLayout({
    super.key,
    this.editingModel,
    this.docId,
    this.editProvider,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final isLandscape = context.isLandscape;

    // Determine which widget to show based on device type
    final Widget child;

    if (isTablet && isLandscape) {
      // Tablet Landscape
      child = SelectServicesProviderPage(
        editingModel: editingModel,
        docId: docId,
        editProvider: editProvider,
      );
    } else if (isTablet && !isLandscape) {
      // Tablet Portrait
      child = SelectServicesProviderPage(
        editingModel: editingModel,
        docId: docId,
        editProvider: editProvider,
      );
    } else if (!isTablet && isLandscape) {
      // Phone Landscape
      child = SelectServicesProviderPage(
        editingModel: editingModel,
        docId: docId,
        editProvider: editProvider,
      );
    } else {
      // Phone Portrait
      child = SelectServicesProviderPage(
        editingModel: editingModel,
        docId: docId,
        editProvider: editProvider,
      );
    }

    return Scaffold(body: child);
  }
}
