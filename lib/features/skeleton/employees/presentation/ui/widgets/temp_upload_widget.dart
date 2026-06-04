import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/features/skeleton/employees/presentation/controller/health_insurance_controller.dart';

import '../../../../../../core/theme/font_manager.dart';
import '../../../../../../core/theme/my_theme.dart';
import '../../controller/emergency_contact_controller.dart';

class TempUploadWidget extends StatelessWidget {
  TempUploadWidget({super.key});
  FilePickerResult? result;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MainCustomIconButton(
            onPressed: () async {
              List<List<dynamic>> csvTable = await pickCSVFile();
              Get.find<EmergencyContactController>()
                  .addEmployeesEmergencyContactData(csvData: csvTable);
            },
            buttonText: "emergency".tr,
        
            widgetIcon: "assets/images/case.svg",
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: MyThemeData.signOut,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
            )),
        SizedBox(width: 20.h),
        MainCustomIconButton(
            onPressed: () async {
              List<List<dynamic>> csvTable = await pickCSVFile();
              Get.find<HealthInsuranceController>()
                  .addEmployeesInsuranceFromCsvData(csvData: csvTable);
            },
            buttonText: "insurance".tr,
      
            widgetIcon: "assets/images/case.svg",
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: MyThemeData.signOut,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
            )),
      ],
    );
  }

  pickCSVFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);

      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(file.readAsStringSync());
      print(csvTable);
      return csvTable;
    }
  }
}
