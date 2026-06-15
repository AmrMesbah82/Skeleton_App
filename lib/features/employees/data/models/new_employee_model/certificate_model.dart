import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// date:January/7/2024
// by:MohamedFouad
// lastUpdate:January/7/2024
class Certificate {
  List<String?>? certificateFile;
  List<String?>? certificateName;
  List<String?>? certificateNameStatus;
  List<String?>? issuedBy;
  List<String?>? issuedByStatus;
  List<String?>? yearOfIssue;
  List<String?>? yearOfIssueStatus;
  List<Timestamp?>? timestamps;
  Certificate({
    this.certificateFile,
    this.certificateName,
    this.issuedBy,
    this.yearOfIssue,
    this.certificateNameStatus,
    this.issuedByStatus,
    this.yearOfIssueStatus,
    this.timestamps,
  });

  Certificate copyWith({
    List<String?>? certificateFile,
    List<String?>? certificateName,
    List<String?>? issuedBy,
    List<String?>? yearOfIssue,
    List<String?>? certificateNameStatus,
    List<String?>? issuedByStatus,
    List<String?>? yearOfIssueStatus,
    List<Timestamp?>? timestamps,
  }) {
    return Certificate(
      certificateFile: certificateFile ?? this.certificateFile,
      certificateName: certificateName ?? this.certificateName,
      yearOfIssue: yearOfIssue ?? this.yearOfIssue,
      issuedBy: issuedBy ?? this.issuedBy,
      certificateNameStatus:
          certificateNameStatus ?? this.certificateNameStatus,
      yearOfIssueStatus: yearOfIssueStatus ?? this.yearOfIssueStatus,
      issuedByStatus: issuedByStatus ?? this.issuedByStatus,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Certificate_File': certificateFile,
      'Certificate_Name': certificateName,
      'Issued_By': issuedBy,
      'Year_Of_Issue': yearOfIssue,
      'Certificate_Name_Status': certificateNameStatus,
      'Issued_By_Status': issuedByStatus,
      'Year_Of_Issue_Status': yearOfIssueStatus,
      'Timestamp': timestamps,
    };
  }

  factory Certificate.fromMap(Map<String, dynamic> map) {
    return Certificate(
      certificateFile: map['Certificate_File'] != null
          ? List<String?>.from(
              (map['Certificate_File']),
            )
          : null,
      certificateName: map['Certificate_Name'] != null
          ? List<String?>.from(
              (map['Certificate_Name']),
            )
          : null,
      issuedBy: map['Issued_By'] != null
          ? List<String?>.from(
              (map['Issued_By']),
            )
          : null,
      yearOfIssue: map['Year_Of_Issue'] != null
          ? List<String?>.from(
              (map['Year_Of_Issue']),
            )
          : null,
      certificateNameStatus: map['Certificate_Name_Status'] != null
          ? List<String?>.from(
              (map['Certificate_Name_Status']),
            )
          : null,
      issuedByStatus: map['Issued_By_Status'] != null
          ? List<String?>.from(
              (map['Issued_By_Status']),
            )
          : null,
      yearOfIssueStatus: map['Year_Of_Issue_Status'] != null
          ? List<String?>.from(
              (map['Year_Of_Issue_Status']),
            )
          : null,
      timestamps: map['Timestamp'] != null
          ? List<Timestamp?>.from(
              (map['Timestamp']),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Certificate.fromJson(String source) =>
      Certificate.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Certificate(Certificate_File: $certificateFile, Certificate_Name: $certificateName, Issued_By: $issuedBy, Year_Of_Issue: $yearOfIssue, Certificate_Name_Status: $certificateNameStatus, Issued_By_Status: $issuedByStatus, Year_Of_Issue_Status: $yearOfIssueStatus, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant Certificate other) {
    if (identical(this, other)) return true;

    return listEquals(other.certificateFile, certificateFile) &&
        listEquals(other.certificateName, certificateName) &&
        listEquals(other.issuedBy, issuedBy) &&
        listEquals(other.yearOfIssue, yearOfIssue) &&
        listEquals(other.certificateNameStatus, certificateNameStatus) &&
        listEquals(other.issuedByStatus, issuedByStatus) &&
        listEquals(other.yearOfIssueStatus, yearOfIssueStatus) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode =>
      certificateFile.hashCode ^
      certificateName.hashCode ^
      issuedBy.hashCode ^
      yearOfIssue.hashCode ^
      certificateNameStatus.hashCode ^
      issuedByStatus.hashCode ^
      yearOfIssueStatus.hashCode ^
      timestamps.hashCode;
}
