import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EventAgendaModel {
  List<String?>? agenda;
  List<Timestamp?>? timestamps;
  EventAgendaModel({
    this.agenda,
    this.timestamps,
  });

  EventAgendaModel copyWith({
    List<String?>? agenda,
    List<Timestamp?>? timestamps,
  }) {
    return EventAgendaModel(
      agenda: agenda ?? this.agenda,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Agenda': agenda,
      'Timestamp': timestamps,
    };
  }

  factory EventAgendaModel.fromMap(Map<String, dynamic> map) {
    return EventAgendaModel(
      agenda: map['Agenda'] != null
          ? List<String?>.from(
              (map['Agenda']),
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

  factory EventAgendaModel.fromJson(String source) =>
      EventAgendaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'EventAgenda_Model(Agenda: $agenda, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant EventAgendaModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.agenda, agenda) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => agenda.hashCode ^ timestamps.hashCode;
}
