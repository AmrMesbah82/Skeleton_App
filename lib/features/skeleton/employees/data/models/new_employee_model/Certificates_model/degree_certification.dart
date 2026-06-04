import 'package:cloud_firestore/cloud_firestore.dart';
class DegreeOrCertification {
  final List<String>? degreeOrCertification;
  final List<Timestamp>? timestamp;

  DegreeOrCertification({this.degreeOrCertification, this.timestamp});

  factory DegreeOrCertification.fromJson(dynamic json) {
    return DegreeOrCertification(
      degreeOrCertification: json['Degree_Or_Certification'] != null ? List<String>.from(json['Degree_Or_Certification']) : null,
      timestamp: json['Timestamp'] != null ? List<Timestamp>.from(json['Timestamp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Degree_Or_Certification'] = degreeOrCertification;
    map['Timestamp'] = timestamp;
    return map;
  }
}
