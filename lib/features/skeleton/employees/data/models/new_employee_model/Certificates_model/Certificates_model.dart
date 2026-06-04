import 'package:cloud_firestore/cloud_firestore.dart';
import '../../card_model/end_date.dart';
import '../../card_model/start_date.dart';
import 'additional_notes.dart';
import 'certificate_id.dart';
import 'created_at.dart';
import 'degree_certification.dart';
import 'document_url.dart';
import 'field_of_study.dart';
import 'grade_or_score.dart';
import 'institution_name.dart';
import 'issuing_authority.dart';
import 'updated_at.dart';

class CertificatesModel {
   String? employeeID;
   InstitutionName? institutionName;
   DegreeOrCertification? degreeOrCertification;
   FieldOfStudy? fieldOfStudy;
   StartDate? startDate;
   EndDate? endDate;
   GradeOrScore? gradeOrScore;
   CertificateID? certificateID;
   IssuingAuthority? issuingAuthority;
   DocumentURL? documentURL;
   Notes? notes;
   CreatedAt? createdAt;
   UpdatedAt? updatedAt;

  CertificatesModel({
    this.employeeID,
    this.institutionName,
    this.degreeOrCertification,
    this.fieldOfStudy,
    this.startDate,
    this.endDate,
    this.gradeOrScore,
    this.certificateID,
    this.issuingAuthority,
    this.documentURL,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory CertificatesModel.fromMap(Map<String, dynamic> map) {
    return CertificatesModel(
      employeeID: map['Employee_ID'],
      institutionName: map['Institution_Name'] != null ? InstitutionName.fromJson(map['Institution_Name']) : null,
      degreeOrCertification: map['Degree_Or_Certification'] != null ? DegreeOrCertification.fromJson(map['Degree_Or_Certification']) : null,
      fieldOfStudy: map['Field_Of_Study'] != null ? FieldOfStudy.fromJson(map['Field_Of_Study']) : null,
      startDate: map['Start_Date'] != null ? StartDate.fromJson(map['Start_Date']) : null,
      endDate: map['End_Date'] != null ? EndDate.fromJson(map['End_Date']) : null,
      gradeOrScore: map['Grade_Or_Score'] != null ? GradeOrScore.fromJson(map['Grade_Or_Score']) : null,
      certificateID: map['Certificate_ID'] != null ? CertificateID.fromJson(map['Certificate_ID']) : null,
      issuingAuthority: map['Issuing_Authority'] != null ? IssuingAuthority.fromJson(map['Issuing_Authority']) : null,
      documentURL: map['Document_URL'] != null ? DocumentURL.fromJson(map['Document_URL']) : null,
      notes: map['Notes'] != null ? Notes.fromJson(map['Notes']) : null,
      createdAt: map['Created_At'] != null ? CreatedAt.fromJson(map['Created_At']) : null,
      updatedAt: map['Updated_At'] != null ? UpdatedAt.fromJson(map['Updated_At']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Employee_ID': employeeID,
      'Institution_Name': institutionName?.toJson(),
      'Degree_Or_Certification': degreeOrCertification?.toJson(),
      'Field_Of_Study': fieldOfStudy?.toJson(),
      'Start_Date': startDate?.toJson(),
      'End_Date': endDate?.toJson(),
      'Grade_Or_Score': gradeOrScore?.toJson(),
      'Certificate_ID': certificateID?.toJson(),
      'Issuing_Authority': issuingAuthority?.toJson(),
      'Document_URL': documentURL?.toJson(),
      'Notes': notes?.toJson(),
      'Created_At': createdAt?.toJson(),
      'Updated_At': updatedAt?.toJson(),
    };
  }
}


