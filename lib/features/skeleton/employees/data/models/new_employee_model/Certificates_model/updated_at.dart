import 'package:cloud_firestore/cloud_firestore.dart';

class UpdatedAt {
  final List<Timestamp>? updatedAt;
  final List<Timestamp>? timestamp;

  UpdatedAt({this.updatedAt, this.timestamp});

  factory UpdatedAt.fromJson(dynamic json) {
    return UpdatedAt(
      updatedAt: json['Updated_At'] != null ? List<Timestamp>.from(json['Updated_At']) : null,
      timestamp: json['Timestamp'] != null ? List<Timestamp>.from(json['Timestamp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Updated_At'] = updatedAt;
    map['Timestamp'] = timestamp;
    return map;
  }
}
