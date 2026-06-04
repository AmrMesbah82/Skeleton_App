import 'package:cloud_firestore/cloud_firestore.dart';

class Notify {
  Notify({
    this.notify,
    this.timestamp,
  });

  Notify.fromJson(dynamic json) {
    notify = json['Notify'] != null ? json['Notify'].cast<String>() : [];
    timestamp =
        json['Timestamp'] != null ? json['Timestamp'].cast<Timestamp>() : [];
  }
  List<String>? notify;
  List<Timestamp>? timestamp;
  Notify copyWith({
    List<String>? notify,
    List<Timestamp>? timestamp,
  }) =>
      Notify(
        notify: notify ?? this.notify,
        timestamp: timestamp ?? this.timestamp,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Notify'] = notify;
    map['Timestamp'] = timestamp;
    return map;
  }
}
