
import 'package:demo_app/features/external/main_core/features/employee/data/models/emplyees_model/country_model.dart';
import 'package:demo_app/features/external/main_core/features/employee/data/models/emplyees_model/province_model.dart';
import '../emplyees_model/email_model.dart';
import '../emplyees_model/first_name_model.dart';
import '../emplyees_model/last_name_model.dart';
import '../emplyees_model/middle_name_model.dart';
import 'phone_model.dart';
import 'relation_model.dart';

class EmergencyContacts {
  String employeeId;
  EmergencyContact? firstEmergencyContact;
  EmergencyContact? secondEmergencyContact;

  EmergencyContacts({
    required this.employeeId,
    this.firstEmergencyContact,
    this.secondEmergencyContact,
  });

  Map<String, dynamic> toMap() {
    return {
      'Employee_Id': employeeId,
      'First_Emergency_Contact': firstEmergencyContact?.toMap(),
      'Second_Emergency_Contact': secondEmergencyContact?.toMap(),
    };
  }

  factory EmergencyContacts.fromMap(Map<String, dynamic> map) {
    return EmergencyContacts(
      employeeId: map['Employee_Id'],
      firstEmergencyContact: map['First_Emergency_Contact'] != null
          ? EmergencyContact.fromMap(
              Map<String, dynamic>.from(map['First_Emergency_Contact']))
          : null,
      secondEmergencyContact: map['Second_Emergency_Contact'] != null
          ? EmergencyContact.fromMap(
              Map<String, dynamic>.from(map['Second_Emergency_Contact']))
          : null,
    );
  }
}

class EmergencyContact {
  FirstName? firstName;
  MiddleName? middleName;
  LastName? lastName;
  ContactRelation? relationship;
  Phone? phoneNumber;
  Email? email;
  Country? country;
  Province? province;

  EmergencyContact({
    this.firstName,
    this.middleName,
    this.lastName,
    this.relationship,
    this.phoneNumber,
    this.email,
    this.country,
    this.province,
  });

  Map<String, dynamic> toMap() {
    return {
      'First_Name': firstName?.toMap(),
      'Middle_Name': middleName?.toMap(),
      'Last_Name': lastName?.toMap(),
      'Relationship': relationship?.toMap(),
      'Phone_Number': phoneNumber?.toMap(),
      'Email': email?.toMap(),
      'Country': country?.toMap(),
      'Province': province?.toMap(),
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      firstName: map['First_Name'] != null
          ? FirstName.fromMap(Map<String, dynamic>.from(map['First_Name']))
          : null,
      middleName: map['Middle_Name'] != null
          ? MiddleName.fromMap(Map<String, dynamic>.from(map['Middle_Name']))
          : null,
      lastName: map['Last_Name'] != null
          ? LastName.fromMap(Map<String, dynamic>.from(map['Last_Name']))
          : null,
      relationship: map['Relationship'] != null
          ? ContactRelation.fromMap(
              Map<String, dynamic>.from(map['Relationship']))
          : null,
      phoneNumber: map['Phone_Number'] != null
          ? Phone.fromMap(Map<String, dynamic>.from(map['Phone_Number']))
          : null,
      email: map['Email'] != null
          ? Email.fromMap(Map<String, dynamic>.from(map['Email']))
          : null,
      country: map['Country'] != null
          ? Country.fromMap(Map<String, dynamic>.from(map['Country']))
          : null,
      province: map['Province'] != null
          ? Province.fromMap(Map<String, dynamic>.from(map['Province']))
          : null,
    );
  }
}


