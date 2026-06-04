import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AssignedEvent {
  List<String?>? eventId;
  List<String?>? status;
  List<String?>? rejectionReason;
  List<Timestamp?>? timestamps;
  AssignedEvent({
    required this.eventId,
    required this.status,
    required this.rejectionReason,
    required this.timestamps,
  });

  AssignedEvent copyWith({
    List<String?>? eventId,
    List<String?>? status,
    List<String?>? rejectionReason,
    List<Timestamp?>? timestamps,
  }) {
    return AssignedEvent(
      eventId: eventId ?? this.eventId,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Event_Id': eventId,
      'Status': status,
      'Rejection_Reason': rejectionReason,
      'Timestamp': timestamps,
    };
  }

  factory AssignedEvent.fromMap(Map<String, dynamic> map) {
    return AssignedEvent(
      eventId: map['Event_Id'] != null
          ? List<String?>.from(
              (map['Event_Id']),
            )
          : null,
      status: map['Status'] != null
          ? List<String?>.from(
              (map['Status']),
            )
          : null,
      rejectionReason: map['Rejection_Reason'] != null
          ? List<String?>.from(
              (map['Rejection_Reason']),
            )
          : null,
      timestamps: map['Timestamp'] != null
          ? List<Timestamp?>.from(
              (map['Timestamp']),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssignedEvent.fromJson(String source) =>
      AssignedEvent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Status(Event_Id: $eventId, Status: $status, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant AssignedEvent other) {
    if (identical(this, other)) return true;

    return listEquals(other.eventId, eventId) &&
        listEquals(other.status, status) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => eventId.hashCode ^ status.hashCode ^ timestamps.hashCode;
}
