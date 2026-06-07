import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EventInviteGuestModel {
  List<String?>? guestEmail;
  List<String?>? status;
  List<Timestamp?>? timestamps;
  EventInviteGuestModel({
    this.guestEmail,
    this.status,
    this.timestamps,
  });

  EventInviteGuestModel copyWith({
    List<String?>? guestEmail,
    List<String?>? status,
    List<Timestamp?>? timestamps,
  }) {
    return EventInviteGuestModel(
      guestEmail: guestEmail ?? this.guestEmail,
      status: status ?? this.status,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Guest_Name': guestEmail,
      'Status': status,
      'Timestamp': timestamps,
    };
  }

  factory EventInviteGuestModel.fromMap(Map<String, dynamic> map) {
    return EventInviteGuestModel(
      guestEmail: map['Guest_Name'] != null
          ? List<String?>.from(
              (map['Guest_Name']),
            )
          : null,
      status:
          map['Status'] != null ? List<String?>.from((map['Status'])) : null,
      timestamps: map['Timestamp'] != null
          ? List<Timestamp?>.from(
              (map['Timestamp']),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventInviteGuestModel.fromJson(String source) =>
      EventInviteGuestModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'EventInviteGuestModel(Guest_Name: $guestEmail, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant EventInviteGuestModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.guestEmail, guestEmail) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => guestEmail.hashCode ^ timestamps.hashCode;
}
