import 'package:cloud_firestore/cloud_firestore.dart';

class Description {
  Description({
    this.description,
    this.timestamp,
  });

  Description.fromJson(dynamic json) {
    description =
        json['Description'] != null ? json['Description'].cast<String>() : [];
    timestamp =
        json['Timestamp'] != null ? json['Timestamp'].cast<Timestamp>() : [];
  }
  List<String>? description;
  List<Timestamp>? timestamp;
  Description copyWith({
    List<String>? description,
    List<Timestamp>? timestamp,
  }) =>
      Description(
        description: description ?? this.description,
        timestamp: timestamp ?? this.timestamp,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Description'] = description;
    map['Timestamp'] = timestamp;
    return map;
  }
}
