import 'reminder_model.dart';

class ScheduledData {
  final DateTime taskStartDate;
  final String taskStartTime;
  final DateTime? taskEndDate;
  final String? taskEndTime;
  final List<ReminderData> reminders;

  ScheduledData({
    required this.taskStartDate,
    required this.taskStartTime,
    this.taskEndDate,
    this.taskEndTime,
    required this.reminders,
  });

  factory ScheduledData.fromMap(Map<String, dynamic> map) {
    return ScheduledData(
      taskStartDate:
          _convertToDateTime(map['taskStartDate'] ?? map['Task_Start_Date']),
      taskStartTime: map['taskStartTime'] ?? map['Task_Start_Time'] ?? '',
      taskEndDate: (map['taskEndDate'] ?? map['Task_End_Date']) != null
          ? _convertToDateTime(map['taskEndDate'] ?? map['Task_End_Date'])
          : null,
      taskEndTime: map['taskEndTime'] ?? map['Task_End_Time'],
      reminders: _parseReminders(map['reminders'] ?? map['Reminders']),
    );
  }

  // Helper لتحويل Reminders
  static List<ReminderData> _parseReminders(dynamic remindersData) {
    if (remindersData == null) return [];

    try {
      if (remindersData is List) {
        return remindersData
            .map((e) => ReminderData.fromMap(e is Map<String, dynamic>
                ? e
                : Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    } catch (e) {
      print('Error parsing reminders: $e');
    }

    return [];
  }

  Map<String, dynamic> toMap() {
    return {
      'taskStartDate': taskStartDate.toIso8601String(),
      'taskStartTime': taskStartTime,
      'taskEndDate': taskEndDate?.toIso8601String(),
      'taskEndTime': taskEndTime,
      'reminders': reminders.map((r) => r.toMap()).toList(),
    };
  }

  static DateTime _convertToDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    if (value is Map && value.containsKey('_seconds')) {
      return DateTime.fromMillisecondsSinceEpoch(value['_seconds'] * 1000);
    }
    if (value.runtimeType.toString() == 'Timestamp') {
      return (value as dynamic).toDate();
    }
    throw Exception('Unsupported date format: $value');
  }
}
