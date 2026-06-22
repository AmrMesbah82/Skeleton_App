

import 'package:flutter/material.dart';
import 'package:get/get.dart';



import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/pages/request_details.dart';

class RequestServicesDetailsToggle extends StatelessWidget {
  const RequestServicesDetailsToggle({required this.requestModel, super.key});
  final ServicesHistoryModel requestModel ;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final isLandscape = context.isLandscape;
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (isTablet && isLandscape) {
            return RequestServicesDetails(requestModel: requestModel,);
          } else if (isTablet && !isLandscape) {
            return RequestServicesDetails(requestModel: requestModel,);
          } else if (!isTablet && isLandscape) {
            return RequestServicesDetails(requestModel: requestModel);
          } else {
            return RequestServicesDetails(requestModel: requestModel);
          }
        },
      ),
    );

  }

}

/*
return Scaffold(
body: LayoutBuilder(
builder: (context, constrain){

if (constrain.maxWidth >= 1200) {
return RequestServicesDetailsFullScreen(requestModel:requestModel); // Desktop
} else if (constrain.maxWidth >= 900) {
return RequestServicesDetailsDesktop(requestModel:requestModel ,); // Horizontal tablet
} else if (constrain.maxWidth >= 600) {
return RequestServicesDetailsTablet(requestModel: requestModel,); // // tablet
} else {
return RequestServicesDetailsMobile(requestModel: requestModel); // mobile
}


}),
);

 */
