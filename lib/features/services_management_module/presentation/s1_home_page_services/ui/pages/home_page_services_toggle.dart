/// ******************* FILE INFO *******************
/// File Name: home_page_services_toggle.dart
/// Description: toggle in All Platform of this screen
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Only if using context extensions
import 'package:get/get.dart';

import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services.dart';


class LayoutScreenServices extends StatelessWidget {
  const LayoutScreenServices({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final isLandscape = context.isLandscape;

    return Scaffold(
      body: Builder(
        builder: (context) {
          if (isTablet && isLandscape) {
            return ServicesScreenTablet(); // Or tablet Landscape
          } else if (isTablet && !isLandscape) {
            return const ServicesScreenTablet();
          } else if (!isTablet && isLandscape) {
            return ServicesScreenTablet();
          } else {
            return ServicesScreenTablet();
          }
        },
      ),
    );
  }
}



