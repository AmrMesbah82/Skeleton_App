import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/core/generic_models/single_value_tracking_model.dart';
import 'package:demo_app/features/skeleton/employees/data/models/new_employee_model/emergency_contacts_model/emergency_contacts_model.dart';
import '../../../../../features/external/main_core/features/employee/data/models/emplyees_model/country_model.dart';
import '../../../../../features/external/main_core/features/employee/data/models/emplyees_model/province_model.dart';
import '../../data/models/card_model/end_date.dart';
import '../../data/models/card_model/start_date.dart';
import '../../data/models/health_insurance_model/health_insurance_model.dart';
import '../../data/models/new_employee_model/Certificates_model/Certificates_model.dart';
import '../../data/models/new_employee_model/Certificates_model/additional_notes.dart';
import '../../data/models/new_employee_model/Certificates_model/certificate_id.dart';
import '../../data/models/new_employee_model/Certificates_model/created_at.dart';
import '../../data/models/new_employee_model/Certificates_model/degree_certification.dart';
import '../../data/models/new_employee_model/Certificates_model/document_url.dart';
import '../../data/models/new_employee_model/Certificates_model/field_of_study.dart';
import '../../data/models/new_employee_model/Certificates_model/grade_or_score.dart';
import '../../data/models/new_employee_model/Certificates_model/institution_name.dart';
import '../../data/models/new_employee_model/Certificates_model/issuing_authority.dart';
import '../../data/models/new_employee_model/Certificates_model/updated_at.dart';
import '../../data/models/new_employee_model/emergency_contacts_model/relation_model.dart';
import '../../data/models/new_employee_model/emplyees_model/job_type_model.dart';
import '../../data/models/new_employee_model/emergency_contacts_model/phone_model.dart';
import '../../data/models/new_employee_model/emplyees_model/email_model.dart';
import '../../data/models/new_employee_model/emplyees_model/first_name_model.dart';
import '../../data/models/new_employee_model/emplyees_model/last_name_model.dart';
import '../../data/models/new_employee_model/emplyees_model/middle_name_model.dart';
import '../../data/models/new_employee_model/emplyees_model/mobile_phone_model.dart';
import '../../data/models/new_employee_model/salery_model/compensation_model.dart';
import '../../data/models/new_employee_model/salery_model/currency_model.dart';
import '../../data/models/new_employee_model/salery_model/end_time_model.dart';
import '../../data/models/new_employee_model/salery_model/salaries_model.dart';
import '../../data/models/new_employee_model/salery_model/salary_model.dart';
import '../../data/models/new_employee_model/salery_model/start_time_model.dart';
import '../../data/models/new_employee_model/salery_model/work_days_model.dart';

Future<void> uploadEmployeeEmptyCollections(String employeeId) async {
  await Future.wait([
    uploadEmergencyContactsModel(employeeId),
    addSalariesModel(employeeId),
    addEmptyInsuranceModel(employeeId),
    addCertificateModel(employeeId),
  ]);
}

Future<void> uploadEmergencyContactsModel(String employeeId) async {
  try {
    EmergencyContacts emptyEmergencyContact = EmergencyContacts(
      employeeId: employeeId,
      firstEmergencyContact: EmergencyContact(
        firstName: FirstName(firstNames: [], timestamps: []),
        middleName: MiddleName(middleName: [], timestamps: []),
        lastName: LastName(lastNames: [], timestamps: []),
        relationship: ContactRelation(contactRelation: [], timestamps: []),
        phoneNumber:
            Phone(phones: [], countryApp: [], countryCode: [], timestamps: []),
        email: Email(emails: [], timestamps: []),
        country: Country(country: [], timestamps: []),
        province: Province(province: [], timestamps: []),
      ),
      secondEmergencyContact: EmergencyContact(
        firstName: FirstName(firstNames: [], timestamps: []),
        middleName: MiddleName(middleName: [], timestamps: []),
        lastName: LastName(lastNames: [], timestamps: []),
        relationship: ContactRelation(contactRelation: [], timestamps: []),
        phoneNumber:
            Phone(phones: [], countryApp: [], countryCode: [], timestamps: []),
        email: Email(emails: [], timestamps: []),
        country: Country(country: [], timestamps: []),
        province: Province(province: [], timestamps: []),
      ),
    );

    await FirebaseFirestore.instance
        .collection('Emergency_Contacts')
        .doc(employeeId)
        .set(emptyEmergencyContact.toMap());
  } catch (e) {
    print("Failed to upload empty emergency contacts model: $e");
  }
}

Future<void> addCertificateModel(String employeeId) async {
  try {
    CertificatesModel emptyCertificate = CertificatesModel(
      employeeID: employeeId,
      institutionName: InstitutionName(institutionName: [], timestamp: []),
      degreeOrCertification:
          DegreeOrCertification(degreeOrCertification: [], timestamp: []),
      fieldOfStudy: FieldOfStudy(fieldOfStudy: [], timestamp: []),
      startDate: StartDate(startDate: [], timestamp: []),
      endDate: EndDate(endDate: [], timestamp: []),
      gradeOrScore: GradeOrScore(gradeOrScore: [], timestamp: []),
      certificateID: CertificateID(certificateID: [], timestamp: []),
      issuingAuthority: IssuingAuthority(issuingAuthority: [], timestamp: []),
      documentURL: DocumentURL(documentURL: [], timestamp: []),
      notes: Notes(notes: [], timestamp: []),
      createdAt: CreatedAt(createdAt: [], timestamp: []),
      updatedAt: UpdatedAt(updatedAt: [], timestamp: []),
    );

    // Uploading to Firebase
    await FirebaseFirestore.instance
        .collection('Certificates')
        .doc(employeeId)
        .set(emptyCertificate.toMap());
  } catch (e) {
    print("Failed to upload empty certificate model: $e");
  }
}

Future<void> addEmptyInsuranceModel(String employeeId) async {
  try {
    HealthInsuranceModel emptyInsurance = HealthInsuranceModel(
        employeeId: employeeId,
        insuranceProviderName: SingleValueTrackingModel(values: [], timestamps: []),
        insuranceProviderContact: MobilePhone(
            countryCode: [], countryApp: [], phones: [], timestamps: []),
        insurancePolicyNumber: SingleValueTrackingModel(values: [], timestamps: []),
        postalCode: SingleValueTrackingModel(values: [], timestamps: []));
    await FirebaseFirestore.instance
        .collection('Insurance')
        .doc(employeeId)
        .set(emptyInsurance.toMap());
  } catch (e) {
    print("Failed to upload empty insurance model: $e");
  }
}

Future<void> addSalariesModel(String employeeId) async {
  try {
    Salaries emptySalaries = Salaries(
      employeeId: employeeId,
      jobType: JobType(jobType: [], timestamps: []),
      compensation: Compensation(compensation: [], timestamps: []),
      currency: Currency(currency: [], timestamps: []),
      salary: Salary(salary: [], timestamps: []),
      workDays: WorkDays(workDays: [], timestamps: []),
      startTime: StartTime(startTimes: [], timestamps: []),
      endTime: EndTime(endTimes: [], timestamps: []),
    );

    // Uploading to Firebase using employeeId as document ID
    await FirebaseFirestore.instance
        .collection('Salaries')
        .doc(employeeId)
        .set(emptySalaries.toMap());

    print("Empty salaries model uploaded successfully.");
  } catch (e) {
    print("Failed to upload empty salaries model: $e");
  }
}
