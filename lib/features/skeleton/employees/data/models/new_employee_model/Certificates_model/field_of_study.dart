import 'package:cloud_firestore/cloud_firestore.dart';
class FieldOfStudy {
  final List<String>? fieldOfStudy;
  final List<Timestamp>? timestamp;

  FieldOfStudy({this.fieldOfStudy, this.timestamp});

  factory FieldOfStudy.fromJson(dynamic json) {
    return FieldOfStudy(
      fieldOfStudy: json['Field_Of_Study'] != null ? List<String>.from(json['Field_Of_Study']) : null,
      timestamp: json['Timestamp'] != null ? List<Timestamp>.from(json['Timestamp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Field_Of_Study'] = fieldOfStudy;
    map['Timestamp'] = timestamp;
    return map;
  }
}

