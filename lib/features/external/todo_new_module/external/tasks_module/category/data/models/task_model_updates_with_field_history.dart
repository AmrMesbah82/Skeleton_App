import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/enums/task_priority_enum.dart';
import '../../../core/enums/task_status_enum.dart';
import 'frequency_model.dart';
import 'items_data.dart';
import 'schedule_data.dart';
import 'storage_location_model.dart';

class TaskModel {
  final FieldHistory<String> creatorEmail;
  // final FieldHistory<String> createdAt;
  final FieldHistory<String> taskId;
  final FieldHistory<String> name;
  final FieldHistory<String> description;
  final FieldHistory<String> items; // JSON String
  final FieldHistory<String> taskStatus; // to_do, done, scheduled, deleted
  final FieldHistory<String> priority; // low, medium, high
  final FieldHistory<String> scheduled; // JSON String
  final FieldHistory<String> frequency; // JSON String

  TaskModel({
    required this.creatorEmail,
    // required this.createdAt,
    required this.taskId,
    required this.name,
    required this.description,
    required this.items,
    required this.taskStatus,
    required this.priority,
    required this.scheduled,
    required this.frequency,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TaskModel(
      creatorEmail:
          _parseFieldHistory(data['creatorEmail'], (v) => v as String? ?? ''),
      taskId: _parseFieldHistory(data['taskId'], (v) => v as String? ?? doc.id),
      name: _parseFieldHistory(data['name'], (v) => v as String? ?? ''),
      description:
          _parseFieldHistory(data['description'], (v) => v as String? ?? ''),
      items: _parseFieldHistory(data['items'], (v) => _jsonArrayToString(v)),
      taskStatus: _parseFieldHistory(
          data['taskStatus'], (v) => v as String? ?? TaskStatus.toDo),
      priority: _parseFieldHistory(
          data['priority'], (v) => v as String? ?? TaskPriority.medium),
      scheduled:
          _parseFieldHistory(data['scheduled'], (v) => _jsonObjectToString(v)),
      frequency:
          _parseFieldHistory(data['frequency'], (v) => _jsonObjectToString(v)),
    );
  }

  static FieldHistory<T> _parseFieldHistory<T>(
    dynamic value,
    T Function(dynamic) deserializer,
  ) {
    if (value is Map<String, dynamic> &&
        value.containsKey('timestamps') &&
        value.containsKey('values')) {
      return FieldHistory.fromJson(value, deserializer);
    }
    return FieldHistory.initial(deserializer(value));
  }

  static String _jsonArrayToString(dynamic value) {
    if (value == null) return '[]';
    if (value is String) return value;
    if (value is List) return jsonEncode(value);
    return '[]';
  }

  static String _jsonObjectToString(dynamic value) {
    if (value == null) return '{}';
    if (value is String) return value;
    if (value is Map) return jsonEncode(value);
    return '{}';
  }

  Map<String, dynamic> toFirestore() {
    return {
      'creatorEmail': creatorEmail.toJson((v) => v),
      'taskId': taskId.toJson((v) => v),
      'name': name.toJson((v) => v),
      'description': description.toJson((v) => v),
      'items': items.toJson((v) => v),
      'taskStatus': taskStatus.toJson((v) => v),
      'priority': priority.toJson((v) => v),
      'scheduled': scheduled.toJson((v) => v),
      'frequency': frequency.toJson((v) => v),
    };
  }

  ScheduledData? get currentScheduled {
    try {
      final str = scheduled.current;
      if (str == null || str == '{}') return null;
      return ScheduledData.fromMap(jsonDecode(str));
    } catch (e) {
      print('Error parsing scheduled: $e');
      return null;
    }
  }

  FrequencyData? get currentFrequency {
    try {
      final str = frequency.current;
      if (str == null || str == '{}') return null;
      return FrequencyData.fromMap(jsonDecode(str));
    } catch (e) {
      print('Error parsing frequency: $e');
      return null;
    }
  }

  List<ItemData>? get currentItems {
    try {
      // print('🔥🔥🔥 === Getting currentItems ===');
      // print('items.values = ${items.values}');
      // print('items.values.length = ${items.values.length}');
      // print('items.timestamps = ${items.timestamps}');

      final current = items.current;
      // print('items.current = $current');
      // print('current == null? ${current == null}');
      // print('current.isEmpty? ${current?.isEmpty}');
      // print('current == "[]"? ${current == "[]"}');

      if (current == null || current.isEmpty || current == '[]') {
        // print('⚠️ Returning empty because current is null/empty');
        return [];
      }
      //
      // print('🔍 Trying to decode: $current');
      final List<dynamic> jsonList = jsonDecode(current);
    //  print('✅ Decoded successfully! List length: ${jsonList.length}');
    //  print('Decoded content: $jsonList');

      final result = jsonList
          .map((e) => ItemData.fromMap(Map<String, dynamic>.from(e)))
          .toList();

   //   print('✅ Final ItemData list length: ${result.length}');
      return result;
    } catch (e, stack) {
      print('❌ Error parsing currentItems: $e');
      print('Stack: $stack');
      return [];
    }
  }

  factory TaskModel.createNew({
    required String creatorEmail,
    required String taskId,
    required String name,
    required String description,
    List<ItemData>? items,
    String taskStatus = TaskStatus.toDo,
    String priority = TaskPriority.medium,
    ScheduledData? scheduled,
    FrequencyData? frequency,
  }) {
    return TaskModel(
      creatorEmail: FieldHistory.initial(creatorEmail),
      taskId: FieldHistory.initial(taskId),
      name: FieldHistory.initial(name),
      description: FieldHistory.initial(description),
      items: FieldHistory.initial(
        jsonEncode(items?.map((e) => e.toMap()).toList() ?? []),
      ),
      taskStatus: FieldHistory.initial(taskStatus),
      priority: FieldHistory.initial(priority),
      scheduled: FieldHistory.initial(
        scheduled != null ? jsonEncode(scheduled.toMap()) : '{}',
      ),
      frequency: FieldHistory.initial(
        frequency != null ? jsonEncode(frequency.toMap()) : '{}',
      ),
    );
  }

  void updateName(String newName) {
    name.add(newName);
  }

  void updateDescription(String newDescription) {
    description.add(newDescription);
  }

  void updateTaskStatus(String newStatus) {
    taskStatus.add(newStatus);
  }

  void updatePriority(String newPriority) {
    priority.add(newPriority);
  }

  void updateItems(List<ItemData> newItems) {
    items.add(jsonEncode(newItems.map((e) => e.toMap()).toList()));
  }

  void updateScheduled(ScheduledData? newScheduled) {
    scheduled.add(
      newScheduled != null ? jsonEncode(newScheduled.toMap()) : '{}',
    );
  }

  void updateFrequency(FrequencyData? newFrequency) {
    frequency.add(
      newFrequency != null ? jsonEncode(newFrequency.toMap()) : '{}',
    );
  }
}
