import 'package:cloud_firestore/cloud_firestore.dart';

// date:March/3/2024
// by:Fouad
// lastUpdate:March/3/2024
// description: A class that represents a todo item.
class TodoModel {
  final List<Timestamp> timestamp;
  final List<String> name;
  final List<String> priority;
  final List<String> description;
  final List<Timestamp> startDateTime;
  final List<Timestamp> endDateTime;
  final List<String> reminderNumber;
  final List<String> reminderUnit;
  final List<String> frequencyNumber;
  final List<String> frequencyUnit;
  final List<String> status;
  final String? id;

  TodoModel({
    required this.timestamp,
    required this.name,
    required this.priority,
    required this.description,
    required this.startDateTime,
    required this.endDateTime,
    required this.reminderNumber,
    required this.reminderUnit,
    required this.frequencyNumber,
    required this.frequencyUnit,
    required this.status,
    this.id,
  });

  static const String fieldTimestamp = 'Timestamp';
  static const String fieldName = 'Name';
  static const String fieldPriority = 'Priority';
  static const String fieldDescription = 'Description';
  static const String fieldStartDateTime = 'Start_DateTime';
  static const String fieldEndDateTime = 'End_DateTime';
  static const String fieldReminderNumber = 'Reminder_Number';
  static const String fieldReminderUnit = 'Reminder_Unit';
  static const String fieldFrequencyNumber = 'Frequency_Number';
  static const String fieldFrequencyUnit = 'Frequency_Unit';
  static const String fieldStatus = 'Status';

  factory TodoModel.fromMap(Map<String, dynamic> data, String? id) {
    return TodoModel(
      id: id,
      timestamp: List<Timestamp>.from(data[fieldTimestamp]),
      name: List<String>.from(data[fieldName]),
      priority: List<String>.from(data[fieldPriority]),
      description: List<String>.from(data[fieldDescription]),
      startDateTime: List<Timestamp>.from(data[fieldStartDateTime]),
      endDateTime: List<Timestamp>.from(data[fieldEndDateTime]),
      reminderNumber: List<String>.from(data[fieldReminderNumber]),
      reminderUnit: List<String>.from(data[fieldReminderUnit]),
      frequencyNumber: List<String>.from(data[fieldFrequencyNumber]),
      frequencyUnit: List<String>.from(data[fieldFrequencyUnit]),
      status: List<String>.from(data[fieldStatus]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      fieldTimestamp: timestamp,
      fieldName: name,
      fieldPriority: priority,
      fieldDescription: description,
      fieldStartDateTime: startDateTime,
      fieldEndDateTime: endDateTime,
      fieldReminderNumber: reminderNumber,
      fieldReminderUnit: reminderUnit,
      fieldFrequencyNumber: frequencyNumber,
      fieldFrequencyUnit: frequencyUnit,
      fieldStatus: status,
    };
  }
}
