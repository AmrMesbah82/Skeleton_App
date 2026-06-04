import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

enum TodoFrequency { hour, day, week, month }

/// Developer Name : Ahmed Mahmoud
class FrequencyNumber {
  static const String fieldFrequencyNumber = 'frequencyNumber';
  static const String fieldTimestamp = 'Timestamp';

  List<String?>? frequencyNumber;
  List<Timestamp?> timestamps;

  FrequencyNumber({
    this.frequencyNumber,
    required this.timestamps,
  });

  FrequencyNumber copyWith({
    List<String?>? frequencyNumber,
    List<Timestamp?>? timestamps,
  }) {
    return FrequencyNumber(
      frequencyNumber: frequencyNumber ?? this.frequencyNumber,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldFrequencyNumber: convertToLowercase(frequencyNumber),
      fieldTimestamp: timestamps,
    };
  }

  factory FrequencyNumber.fromMap(Map<String, dynamic> map) {
    return FrequencyNumber(
      frequencyNumber: map[fieldFrequencyNumber] != null
          ? List<String?>.from(map[fieldFrequencyNumber])
          : null,
      timestamps: List<Timestamp?>.from(map[fieldTimestamp]),
    );
  }

  List<String?>? convertToLowercase(List<String?>? list) {
    if (list != null) {
      return list.map((item) => item?.toLowerCase()).toList();
    }
    return null;
  }
}

class FrequencyText {
  static const String fieldFrequencyText = 'frequencyText';
  static const String fieldTimestamp = 'Timestamp';

  List<TodoFrequency?>? frequencyText;
  List<Timestamp?>? timestamps;

  FrequencyText({
    this.frequencyText,
    this.timestamps,
  });

  FrequencyText copyWith({
    List<TodoFrequency?>? frequencyText,
    List<Timestamp?>? timestamps,
  }) {
    return FrequencyText(
      frequencyText: frequencyText ?? this.frequencyText,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldFrequencyText: frequencyText?.map((f) => f?.toString().split('.').last).toList(),
      fieldTimestamp: timestamps,
    };
  }

  factory FrequencyText.fromMap(Map<String, dynamic> map) {
    return FrequencyText(
      frequencyText: map[fieldFrequencyText] != null
          ? List<TodoFrequency?>.from(
              (map[fieldFrequencyText] as List).map(
                (e) => e != null ? frequencyFromString(e) : null,
              ),
            )
          : null,
      timestamps: map[fieldTimestamp] != null
          ? List<Timestamp?>.from(map[fieldTimestamp])
          : null,
    );
  }

  List<String?>? convertToLowercase(List<String?>? list) {
    if (list != null) {
      return list.map((item) => item?.toLowerCase()).toList();
    }
    return null;
  }

  // Helper function to convert string to TodoFrequency enum
  static TodoFrequency frequencyFromString(String frequency) {
    return TodoFrequency.values.firstWhere(
      (e) => e.toString().split('.').last == frequency,
      orElse: () => TodoFrequency.day, // Default value
    );
  }

  String getFrequencyText(TodoFrequency? frequency) {
    switch (frequency) {
      case TodoFrequency.day:
        return 'Frequency: Daily'.tr;
      case TodoFrequency.week:
        return 'Frequency: Weekly'.tr;
      case TodoFrequency.month:
        return 'Frequency: Monthly'.tr;
      case TodoFrequency.hour:
      default:
        return 'Frequency: Hourly'.tr;
    }
  }

  String getFrequencyDisplayText(TodoFrequency? frequency) {
    switch (frequency) {
      case TodoFrequency.hour:
        return "Hour".tr;
      case TodoFrequency.day:
        return "Day".tr;
      case TodoFrequency.week:
        return "Week".tr;
      case TodoFrequency.month:
        return "Month".tr;
      default:
        return "Hour".tr;
    }
  }

  TodoFrequency getFrequencyFromDisplayText(String displayText) {
    if (displayText == "Day".tr) return TodoFrequency.day;
    if (displayText == "Week".tr) return TodoFrequency.week;
    if (displayText == "Month".tr) return TodoFrequency.month;
    return TodoFrequency.hour; // default
  }

  // Helper to convert enum to display string (translated)
  static String frequencyToDisplayString(TodoFrequency frequency) {
    return frequency.toString().split('.').last.tr;
  }
}
