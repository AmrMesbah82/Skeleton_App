import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingCreator {
  List<String>? meetingCreator;
  List<Timestamp>? timestamp;

  MeetingCreator({
    this.meetingCreator,
    this.timestamp,
  });

  MeetingCreator.fromJson(dynamic json) {
    meetingCreator = json['Meeting_Creator'] != null
        ? json['Meeting_Creator'].cast<String>()
        : [];
    timestamp =
        json['Timestamp'] != null ? json['Timestamp'].cast<Timestamp>() : [];
  }

  MeetingCreator copyWith({
    List<String>? meetingCreator,
    List<Timestamp>? timestamp,
  }) =>
      MeetingCreator(
        meetingCreator: meetingCreator ?? this.meetingCreator,
        timestamp: timestamp ?? this.timestamp,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Meeting_Creator'] = meetingCreator;
    map['Timestamp'] = timestamp;
    return map;
  }
}
