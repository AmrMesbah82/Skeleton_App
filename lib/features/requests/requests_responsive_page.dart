import 'package:demo_app/core/widgets/responsive_helper.dart';
import 'package:demo_app/features/employees/employees_views/requests/requests_screen_mobile.dart';
import 'package:flutter/material.dart';


class RequestsResponsivePage extends StatelessWidget {
  const RequestsResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper(
        mobileWidget: RequestsScreenMobile(), tabletWidget: Container()
    );
  }
}
