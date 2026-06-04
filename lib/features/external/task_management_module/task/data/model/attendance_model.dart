import 'dart:convert';

import 'package:get/get.dart';

import '../../../../main_core/features/employee/presentation/controller/main_core_employee_controller.dart';

// date:January/31/2024
// by:MohamedFouad
// lastUpdate:January/31/2024

class AttendanceModel {
  String? date;
  String? checkInTime;
  String? status;
  String? checkOutTime;
  String? totalTime;
  String? name;
  String? email;
  bool? takeBreak;

  AttendanceModel({
    this.date,
    this.checkInTime,
    this.status,
    this.checkOutTime,
    this.totalTime,
    this.takeBreak,
    this.name,
    this.email,
  });

  factory AttendanceModel.fromMap(Map data) {
    return AttendanceModel(
      date: data['Date'],
      checkInTime: data['Check_In_Time'],
      status: data['Status'],
      checkOutTime: data['Check_Out_Time'],
      totalTime: data['Total_Time'],
      takeBreak: data['Take_Break'],
      name: data['Name'],
      email: data['Email'],
    );
  }

  Map<String, dynamic> toMap() => {
        'Date': date,
        'Check_In_Time': checkInTime,
        'Status': status,
        'Check_Out_Time': checkOutTime,
        'Total_Time': totalTime,
        'Take_Break': takeBreak,
        'Name': Get.find<MainCoreEmployeeController>().getEmployeeName(
            Get.find<MainCoreEmployeeController>().employeeEntity!.email!),
        'Email': Get.find<MainCoreEmployeeController>().employeeEntity!.email!,
      };

  String toJson() => json.encode(toMap());
  Map<String, dynamic> fromJson(String jsonString) => json.decode(jsonString);
}
