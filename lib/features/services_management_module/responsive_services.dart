import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services_toggle.dart';

import '../../core/custom/38-custom_responsive.dart';



class ServicesResponsivePage extends StatelessWidget {
  const ServicesResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper(
        mobileWidget: LayoutScreenServices(),
        tabletWidget: Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) {
                return LayoutScreenServices();
              },
            );
          },
        )
    );
  }

}
