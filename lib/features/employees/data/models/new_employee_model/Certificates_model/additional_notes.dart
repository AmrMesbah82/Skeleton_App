import 'package:cloud_firestore/cloud_firestore.dart';

class Notes {
  final List<String>? notes;
  final List<Timestamp>? timestamp;

  Notes({this.notes, this.timestamp});

  factory Notes.fromJson(dynamic json) {
    return Notes(
      notes: json['Notes'] != null ? List<String>.from(json['Notes']) : null,
      timestamp: json['Timestamp'] != null ? List<Timestamp>.from(json['Timestamp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Notes'] = notes;
    map['Timestamp'] = timestamp;
    return map;
  }
}
