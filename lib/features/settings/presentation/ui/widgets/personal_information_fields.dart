/// *************************** FILE INFO ****************************
/// Purpose: All content of setting personal information in mobile and tablet
/// Author: Mohamed Elrashidy
/// Created At: 10/11/2024
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/shared_components/calender_package/src/models/calendar_date_picker2_config.dart';
import 'package:demo_app/core/shared_components/date_picker_class.dart';
import 'package:demo_app/core/theme/screen_size.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/knowledge_hub_module/core/responsive_side_frame.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/tablet/tablet_personal_info_screen.dart';
import '../../../../../generated/l10n.dart';
import '../../controller/settings_controller.dart';
import 'contact_information.dart';
import 'location_data.dart';
import 'personal_data.dart';

class PersonalInformationFields extends StatefulWidget {
  PersonalInformationFields({
    super.key,
  });

  @override
  State<PersonalInformationFields> createState() =>
      _PersonalInformationFieldsState();
}

class _PersonalInformationFieldsState extends State<PersonalInformationFields> {
  SettingsController settingsController = Get.find();
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

      //  SizedBox(height: 200),

        PersonalData(isReadOnly: true,),
    //    SizedBox(height: isTablet ? 0.sp : 0.00.h),
        ContactInformation(isReadOnly: false,),
     //   SizedBox(height: isTablet ? 0.sp : 0.00.h),
        LocationData()
      ],
    );
  }
}
