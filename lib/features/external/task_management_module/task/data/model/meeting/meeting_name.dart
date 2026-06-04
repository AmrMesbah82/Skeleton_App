import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingName {
  MeetingName({
    this.meetingName,
    this.timestamp,
  });

  MeetingName.fromJson(dynamic json) {
    meetingName =
        json['Meeting_Name'] != null ? json['Meeting_Name'].cast<String>() : [];
    timestamp =
        json['Timestamp'] != null ? json['Timestamp'].cast<Timestamp>() : [];
  }

  List<String>? meetingName;
  List<Timestamp>? timestamp;

  MeetingName copyWith({
    List<String>? meetingName,
    List<Timestamp>? timestamp,
  }) =>
      MeetingName(
        meetingName: meetingName ?? this.meetingName,
        timestamp: timestamp ?? this.timestamp,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Meeting_Name'] = meetingName;
    map['Timestamp'] = timestamp;
    return map;
  }
}
