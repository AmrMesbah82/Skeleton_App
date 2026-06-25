import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/features/employee/data/models/emplyees_model/mobile_phone_model.dart';
import 'dart:math';

import 'package:demo_app/features/employee/data/models/emplyees_model/new_employee_model.dart';

class EmployeeFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate random 8-digit employee ID
  String generateEmployeeId() {
    final random = Random();
    // Generate number between 10000000 and 99999999
    final id = 10000000 + random.nextInt(90000000);
    return id.toString();
  }

  // Check if employee ID already exists
  Future<bool> isEmployeeIdExists(String employeeId) async {
    try {
      final doc = await _firestore
          .collection('Demo')
          .doc('75440689')
          .collection('Employees_Info')
          .doc(employeeId)
          .get();
      return doc.exists;
    } catch (e) {
      print('Error checking employee ID: $e');
      return false;
    }
  }

  // Generate unique employee ID
  Future<String> generateUniqueEmployeeId() async {
    String employeeId;
    bool exists;

    do {
      employeeId = generateEmployeeId();
      exists = await isEmployeeIdExists(employeeId);
    } while (exists);

    return employeeId;
  }

  // Upload new employee data
// Update the createNewEmployee method in EmployeeFirebaseService

  Future<String?> createNewEmployee({
    required Map<String, dynamic> personalInfo,
    Map<String, dynamic>? contactInfo,
    Map<String, dynamic>? addressInfo,
    Map<String, dynamic>? identificationInfo,
    Map<String, dynamic>? positionInfo,
    Map<String, dynamic>? certificationInfo,
    Map<String, dynamic>? insuranceInfo,
    Map<String, dynamic>? emergencyInfo,
  }) async {
    try {
      // Generate unique employee ID
      final employeeId = await generateUniqueEmployeeId();
      final now = Timestamp.now();

      // Create NewEmployeeModelHistory object
      final newEmployee = NewEmployeeModelHistory(
        id: employeeId,
        timestamps: [DateTime.now().millisecondsSinceEpoch],

        // Personal Information
        firstName: [personalInfo['firstName'] ?? ''],
        middleName: [personalInfo['middleName'] ?? ''],
        lastName: [personalInfo['lastName'] ?? ''],
        gender: [personalInfo['gender'] ?? ''],
        birthDay: [personalInfo['birthday'] ?? ''],
        maritalStatus: [personalInfo['maritalStatus'] ?? ''],
        nationality: [personalInfo['nationality'] ?? ''],
        language: [personalInfo['language'] ?? ''],

        // Contact Details
        email: [contactInfo?['personalEmail'] ?? ''],
        mobilePhone: [
          MobilePhone(
            phones: [contactInfo?['mobilePhone'] ?? ''],
            countryCode: ['+20'], // Default country code
            countryApp: ['EG'], // Default country app
            timestamps: [now],
          )
        ],
        homePhone: [contactInfo?['homeNumber'] ?? ''],
        officePhone: [contactInfo?['officeNumber'] ?? ''],
        extension: [contactInfo?['extension'] ?? ''],

        // Address Details
        country: [addressInfo?['country'] ?? ''],
        province: [addressInfo?['province'] ?? ''],
        city: [addressInfo?['city'] ?? ''],
        street: [addressInfo?['street'] ?? ''],
        postalCode: [addressInfo?['postalCode'] ?? ''],

        // Identification Details
        nationalId: [identificationInfo?['nationalId'] ?? ''],
        nationalIdExpirationDate: [identificationInfo?['nationalIdExpiration'] ?? ''],
        passport: [identificationInfo?['passport'] ?? ''],
        passportExpirationDate: [identificationInfo?['passportExpiration'] ?? ''],
        drivingLicenseId: [identificationInfo?['drivingLicenseId'] ?? ''],
        carPlates: identificationInfo?['carPlate'] != null
            ? [[identificationInfo!['carPlate']]]
            : [[]],

        // Position Details
        title: [positionInfo?['jobTitle'] ?? ''],
        departmentId: [positionInfo?['department'] ?? ''],
        role: [positionInfo?['jobType'] ?? ''],
        workLocation: [positionInfo?['jobLocation'] ?? ''],

        // Certification Details
        academicHistory: certificationInfo != null ? [certificationInfo] : [{}],

        // Insurance Details
        insuranceName: [insuranceInfo?['insuranceName'] ?? ''],
        insurancePolicyNumber: [insuranceInfo?['insurancePolicyNumber'] ?? ''],

        // Emergency Contacts - First Contact
        firstContactFirstName: [emergencyInfo?['firstContact']?['firstName'] ?? ''],
        firstContactLastName: [
          '${emergencyInfo?['firstContact']?['middleName'] ?? ''} ${emergencyInfo?['firstContact']?['lastName'] ?? ''}'.trim()
        ],
        firstContactRelationship: [emergencyInfo?['firstContact']?['relationship'] ?? ''],
        firstContactEmail: [emergencyInfo?['firstContact']?['email'] ?? ''],
        firstContactPhone: [emergencyInfo?['firstContact']?['mobilePhone'] ?? ''],
        firstContactLanguage: [emergencyInfo?['firstContact']?['language'] ?? ''],
        firstContactCountry: [emergencyInfo?['firstContact']?['country'] ?? ''],
        firstContactProvince: [emergencyInfo?['firstContact']?['province'] ?? ''],

        // Emergency Contacts - Second Contact
        secondContactFirstName: [emergencyInfo?['secondContact']?['firstName'] ?? ''],
        secondContactLastName: [
          '${emergencyInfo?['secondContact']?['middleName'] ?? ''} ${emergencyInfo?['secondContact']?['lastName'] ?? ''}'.trim()
        ],
        secondContactRelationship: [emergencyInfo?['secondContact']?['relationship'] ?? ''],
        secondContactEmail: [emergencyInfo?['secondContact']?['email'] ?? ''],
        secondContactPhone: [emergencyInfo?['secondContact']?['mobilePhone'] ?? ''],
        secondContactLanguage: [emergencyInfo?['secondContact']?['language'] ?? ''],
        secondContactCountry: [emergencyInfo?['secondContact']?['country'] ?? ''],
        secondContactProvince: [emergencyInfo?['secondContact']?['province'] ?? ''],

        // Status
        status: ['active'],
      );

      // Upload to Firebase
      await _firestore
          .collection('Demo')
          .doc('75440689')
          .collection('Employees_Info')
          .doc(employeeId)
          .set(newEmployee.toMap());

      print('✅ Employee created successfully with ID: $employeeId');
      return employeeId;

    } catch (e, stackTrace) {
      print('❌ Error creating employee: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }
}