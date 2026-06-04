import 'package:cloud_firestore/cloud_firestore.dart';

class CreatedAt {
  final List<Timestamp>? createdAt;
  final List<Timestamp>? timestamp;

  CreatedAt({this.createdAt, this.timestamp});

  factory CreatedAt.fromJson(dynamic json) {
    return CreatedAt(
      createdAt: json['Created_At'] != null ? List<Timestamp>.from(json['Created_At']) : null,
      timestamp: json['Timestamp'] != null ? List<Timestamp>.from(json['Timestamp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Created_At'] = createdAt;
    map['Timestamp'] = timestamp;
    return map;
  }
}
