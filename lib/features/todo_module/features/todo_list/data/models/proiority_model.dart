import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

enum TodoPriority { low, medium, high }

class PriorityModel {
  static const String fieldPriority = 'Priority';
  static const String fieldTimestamp = 'Timestamp';

  List<TodoPriority?>? priority;
  List<Timestamp?> timestamps;

  PriorityModel({
    this.priority,
    required this.timestamps,
  });

  PriorityModel copyWith({
    List<TodoPriority?>? priority,
    List<Timestamp?>? timestamps,
  }) {
    return PriorityModel(
      priority: priority ?? this.priority,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldPriority: priority?.map((p) => p?.toString().split('.').last).toList(),
      fieldTimestamp: timestamps,
    };
  }

  factory PriorityModel.fromMap(Map<String, dynamic> map) {
    return PriorityModel(
      priority: map[fieldPriority] != null
          ? List<TodoPriority?>.from(
              (map[fieldPriority] as List).map(
                (e) => e != null ? priorityFromString(e) : null,
              ),
            )
          : null,
      timestamps: List<Timestamp?>.from((map[fieldTimestamp])),
    );
  }

  static String getEnumName(TodoPriority priority) {
    return priority.toString().split('.').last;
  }

  static String getDisplayText(TodoPriority priority) {
    return getEnumName(priority).tr;
  }

  static TodoPriority? fromStoredValue(String? value) {
    if (value == null) return null;
    try {
      return TodoPriority.values.firstWhere(
        (e) => getEnumName(e) == value.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  static TodoPriority priorityFromString(String priority) {
    return TodoPriority.values.firstWhere(
      (e) => e.toString().split('.').last == priority,
      orElse: () => TodoPriority.medium,
    );
  }
}
