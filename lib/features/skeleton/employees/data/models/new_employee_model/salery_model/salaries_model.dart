import 'package:cloud_firestore/cloud_firestore.dart';

import '../emplyees_model/job_type_model.dart';
import 'compensation_model.dart';
import 'currency_model.dart';
import 'end_time_model.dart';
import 'salary_model.dart';
import 'start_time_model.dart';
import 'work_days_model.dart';

class Salaries {
  final String employeeId;
  JobType? jobType;
  Compensation? compensation;
  Currency? currency;
  Salary? salary;
  WorkDays? workDays;
  StartTime? startTime;
  EndTime? endTime;

  Salaries({
    required this.employeeId,
    this.jobType,
    this.compensation,
    this.currency,
    this.salary,
    this.workDays,
    this.startTime,
    this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'Employee_Id': employeeId,
      'Job_Type': jobType?.toMap(),
      'Compensation': compensation?.toMap(),
      'Currency': currency?.toMap(),
      'Salary': salary?.toMap(),
      'Work_Days': workDays?.toMap(),
      'Start_Time': startTime?.toMap(),
      'End_Time': endTime?.toMap(),
    };
  }

  factory Salaries.fromMap(Map<String, dynamic> map) {
    return Salaries(
      employeeId: map['Employee_Id'],
      jobType: map['Job_Type'] != null
          ? JobType.fromMap(Map<String, dynamic>.from(map['Job_Type']))
          : null,
      compensation: map['Compensation'] != null
          ? Compensation.fromMap(Map<String, dynamic>.from(map['Compensation']))
          : null,
      currency: map['Currency'] != null
          ? Currency.fromMap(Map<String, dynamic>.from(map['Currency']))
          : null,
      salary: map['Salary'] != null
          ? Salary.fromMap(Map<String, dynamic>.from(map['Salary']))
          : null,
      workDays: map['Work_Days'] != null
          ? WorkDays.fromMap(Map<String, dynamic>.from(map['Work_Days']))
          : null,
      startTime: map['Start_Time'] != null
          ? StartTime.fromMap(Map<String, dynamic>.from(map['Start_Time']))
          : null,
      endTime: map['End_Time'] != null
          ? EndTime.fromMap(Map<String, dynamic>.from(map['End_Time']))
          : null,
    );
  }
}
