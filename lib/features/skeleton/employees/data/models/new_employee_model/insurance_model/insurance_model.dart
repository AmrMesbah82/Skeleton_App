import 'package:cloud_firestore/cloud_firestore.dart';

class InsuranceProviderContact {
  List<String?>? insuranceProviderContact;
  List<String?>? countryCode;
  List<String?>? countryApp;

  List<Timestamp?>? timestamps;
  InsuranceProviderContact({
    this.insuranceProviderContact,
    this.countryCode,
    this.countryApp,
    this.timestamps,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Insurance_Provider_Contact': insuranceProviderContact,
      'Country_Code': countryCode,
      'Country_App': countryApp,
      'Timestamp': timestamps,
    };
  }

  factory InsuranceProviderContact.fromMap(Map<String, dynamic> map) {
    return InsuranceProviderContact(
      insuranceProviderContact: map['Insurance_Provider_Contact'] != null
          ? List<String?>.from(
              (map['Insurance_Provider_Contact']),
            )
          : null,
      countryCode: map['Country_Code'] != null
          ? List<String?>.from(
              (map['Country_Code']),
            )
          : null,
      countryApp: map['Country_App'] != null
          ? List<String?>.from(
              (map['Country_App']),
            )
          : null,
      timestamps: map['Timestamp'] != null
          ? List<Timestamp?>.from(
              (map['Timestamp']),
            )
          : null,
    );
  }
}

class InsuranceName {
  List<String?>? insuranceNames;
  List<Timestamp?>? timestamps;
  InsuranceName({
    this.insuranceNames,
    this.timestamps,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Insurance_Name': insuranceNames,
      'Timestamp': timestamps,
    };
  }

  factory InsuranceName.fromMap(Map<String, dynamic> map) {
    return InsuranceName(
      insuranceNames: map['Insurance_Name'] != null
          ? List<String?>.from(
              (map['Insurance_Name']),
            )
          : null,
      timestamps: map['Timestamp'] != null
          ? List<Timestamp?>.from(
              (map['Timestamp']),
            )
          : null,
    );
  }
}

class InsurancePoliceNumber {
  List<String?>? insurancePoliceNumber;
  List<Timestamp?>? timestamps;
  InsurancePoliceNumber({
    this.insurancePoliceNumber,
    this.timestamps,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Insurance_Police_Number': insurancePoliceNumber,
      'Timestamp': timestamps,
    };
  }

  factory InsurancePoliceNumber.fromMap(Map<String, dynamic> map) {
    return InsurancePoliceNumber(
      insurancePoliceNumber: map['Insurance_Police_Number'] != null
          ? List<String?>.from(
              (map['Insurance_Police_Number']),
            )
          : null,
      timestamps: map['Timestamp'] != null
          ? List<Timestamp?>.from(
              (map['Timestamp']),
            )
          : null,
    );
  }
}

class Insurance {
  final String employeeId;
  InsuranceName? insuranceName;
  InsurancePoliceNumber? insurancePoliceNumber;
  InsuranceProviderContact? insuranceProviderContact;

  Insurance({
    required this.employeeId,
    this.insuranceName,
    this.insurancePoliceNumber,
    this.insuranceProviderContact,
  });

  // Convert Insurance instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'Employee_Id': employeeId,
      'Insurance_Name': insuranceName?.toMap(),
      'Insurance_Police_Number': insurancePoliceNumber?.toMap(),
      'Insurance_Provider_Contact': insuranceProviderContact?.toMap(),
    };
  }

  // Convert Map to Insurance instance
  factory Insurance.fromMap(Map<String, dynamic> map) {
    return Insurance(
      employeeId: map['Employee_Id'],
      insuranceName: map['Insurance_Name'] != null
          ? InsuranceName.fromMap(
              Map<String, dynamic>.from(map['Insurance_Name']))
          : null,
      insurancePoliceNumber: map['Insurance_Police_Number'] != null
          ? InsurancePoliceNumber.fromMap(
              Map<String, dynamic>.from(map['Insurance_Police_Number']))
          : null,
      insuranceProviderContact: map['Insurance_Provider_Contact'] != null
          ? InsuranceProviderContact.fromMap(
              Map<String, dynamic>.from(map['Insurance_Provider_Contact']))
          : null,
    );
  }
}

