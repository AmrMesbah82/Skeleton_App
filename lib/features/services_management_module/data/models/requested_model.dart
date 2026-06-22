import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';

class RequestedServices {
  final String? id;

  final String? status;
  final String? serviceRequester;
  final List<EmployeeEntityModell>? serviceProvider;
  final String? serviceName;
  final String? duration;
  final String? selectedDurationUnit;
  final String? requestDate;
  final String? state;
  final List? department;

  final String? firstNameRequester;
  final String? lastNameRequester;
  final String? firstNameRequesterArabic;
  final String? lastNameRequesterArabic;
  final String? jobTitleRequester;
  final String? jobTitleRequesterArabic;
  final String? departmentRequester;
  final String? departmentRequesterArabic;

  RequestedServices({
    this.id,
    this.status,
    this.serviceRequester,
    this.serviceProvider,
    this.serviceName,
    this.state,
    this.duration,
    this.selectedDurationUnit,
    this.requestDate,
    this.department,
    this.firstNameRequester,
    this.lastNameRequester,
    this.firstNameRequesterArabic,
    this.lastNameRequesterArabic,
    this.jobTitleRequester,
    this.jobTitleRequesterArabic,
    this.departmentRequester,
    this.departmentRequesterArabic,
  });

  factory RequestedServices.fromJson(Map<String, dynamic> json) {
    return RequestedServices(
      id: json['id'],
      status: json['status'],
      serviceRequester: json['serviceRequester'],
      serviceProvider: (json['serviceProvider'] as List<dynamic>?)
          ?.map((item) => EmployeeEntityModell.fromJson(item as Map<String, dynamic>))
          .toList(),
      duration: json['duration'],
      selectedDurationUnit: json['selectedDurationUnit'],
      serviceName: json['serviceName'],
      state: json['state'],
      requestDate: json['requestDate'],
      department: json['department'],
      firstNameRequester: json['firstNameRequester'],
      lastNameRequester: json['lastNameRequester'],
      firstNameRequesterArabic: json['firstNameRequesterArabic'],
      lastNameRequesterArabic: json['lastNameRequesterArabic'],
      jobTitleRequester: json['jobTitleRequester'],
      jobTitleRequesterArabic: json['jobTitleRequesterArabic'],
      departmentRequester: json['departmentRequester'],
      departmentRequesterArabic: json['departmentRequesterArabic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'serviceRequester': serviceRequester,
      'serviceProvider': serviceProvider?.map((e) => e.toJson()).toList(),
      'duration': duration,
      'selectedDurationUnit': selectedDurationUnit,
      'serviceName': serviceName,
      'state': state,
      'requestDate': requestDate,
      'department': department,
      'firstNameRequester': firstNameRequester,
      'lastNameRequester': lastNameRequester,
      'firstNameRequesterArabic': firstNameRequesterArabic,
      'lastNameRequesterArabic': lastNameRequesterArabic,
      'jobTitleRequester': jobTitleRequester,
      'jobTitleRequesterArabic': jobTitleRequesterArabic,
      'departmentRequester': departmentRequester,
      'departmentRequesterArabic': departmentRequesterArabic,
    };
  }
}
