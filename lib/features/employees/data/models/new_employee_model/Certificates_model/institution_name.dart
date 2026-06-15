import 'package:cloud_firestore/cloud_firestore.dart';
class InstitutionName {
  final List<String>? institutionName;
  final List<Timestamp>? timestamp;

  InstitutionName({this.institutionName, this.timestamp});

  factory InstitutionName.fromJson(dynamic json) {
    return InstitutionName(
      institutionName: json['Institution_Name'] != null ? List<String>.from(json['Institution_Name']) : null,
      timestamp: json['Timestamp'] != null ? List<Timestamp>.from(json['Timestamp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Institution_Name'] = institutionName;
    map['Timestamp'] = timestamp;
    return map;
  }
}
