import 'package:demo_app/core/helper/employees/data/models/health_insurance_model/health_insurance_model.dart';

/// **************************** FILE INFO **************************** ///
/// Purpose: entity that will hold new data that changed in insurance
/// Author: Mohamed Elrashidy
/// created At: 20/11/2024

class HealthInsuranceEntity {
  String employeeId;
  String? providerName;
  String? policyNumber;
  String? providerNumber;
  String? providerCountryCode;
  String? providerCountryApp;
  String? postalCode;

  HealthInsuranceEntity({
    required this.employeeId,
    this.providerName,
    this.policyNumber,
    this.providerNumber,
    this.providerCountryCode,
    this.providerCountryApp,
    this.postalCode,
  });

  // Add these getters to match what the controller expects
  String? get insuranceName => providerName;
  String? get policyNum => policyNumber;

  factory HealthInsuranceEntity.fromModel(
      HealthInsuranceModel healthInsuranceModel) {
    return HealthInsuranceEntity(
      employeeId: healthInsuranceModel.employeeId!,
      providerName:
      healthInsuranceModel.insuranceProviderName.values.lastOrNull,
      policyNumber:
      healthInsuranceModel.insurancePolicyNumber.values.lastOrNull,
      providerNumber:
      healthInsuranceModel.insuranceProviderContact.phones?.lastOrNull,
      providerCountryCode:
      healthInsuranceModel.insuranceProviderContact.countryCode?.lastOrNull,
      providerCountryApp:
      healthInsuranceModel.insuranceProviderContact.countryApp?.lastOrNull,
      postalCode: healthInsuranceModel.postalCode.values.lastOrNull,
    );
  }
}