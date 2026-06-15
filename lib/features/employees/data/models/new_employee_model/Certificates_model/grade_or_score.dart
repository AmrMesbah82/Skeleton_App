import 'package:cloud_firestore/cloud_firestore.dart';


class GradeOrScore {
  final List<String>? gradeOrScore;
  final List<Timestamp>? timestamp;

  GradeOrScore({this.gradeOrScore, this.timestamp});

  factory GradeOrScore.fromJson(dynamic json) {
    return GradeOrScore(
      gradeOrScore: json['Grade_Or_Score'] != null ? List<String>.from(json['Grade_Or_Score']) : null,
      timestamp: json['Timestamp'] != null ? List<Timestamp>.from(json['Timestamp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Grade_Or_Score'] = gradeOrScore;
    map['Timestamp'] = timestamp;
    return map;
  }
}
