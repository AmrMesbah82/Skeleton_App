import 'package:cloud_firestore/cloud_firestore.dart';

class Repeat {
  Repeat({
    this.repeat,
    this.timestamp,
  });

  Repeat.fromJson(dynamic json) {
    repeat = json['Repeat'] != null ? json['Repeat'].cast<String>() : [];
    timestamp =
        json['Timestamp'] != null ? json['Timestamp'].cast<Timestamp>() : [];
  }
  List<String>? repeat;
  List<Timestamp>? timestamp;
  Repeat copyWith({
    List<String>? repeat,
    List<Timestamp>? timestamp,
  }) =>
      Repeat(
        repeat: repeat ?? this.repeat,
        timestamp: timestamp ?? this.timestamp,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Repeat'] = repeat;
    map['Timestamp'] = timestamp;
    return map;
  }
}
