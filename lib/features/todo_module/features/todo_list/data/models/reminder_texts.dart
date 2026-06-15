import 'package:cloud_firestore/cloud_firestore.dart';

/// Developer Name : Ahmed Mahmoud
class FirstReminderText {
  static const String fieldFirstReminderText = 'firstReminderText';
  static const String fieldTimestamp = 'Timestamp';

  List<String?>? firstReminderText;
  List<Timestamp?> timestamps;
  FirstReminderText({
    this.firstReminderText,
    required this.timestamps,
  });

  FirstReminderText copyWith({
    List<String?>? firstReminderText,
    List<Timestamp?>? timestamps,
  }) {
    return FirstReminderText(
      firstReminderText: firstReminderText ?? this.firstReminderText,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldFirstReminderText: convertToLowercase(firstReminderText),
      fieldTimestamp: timestamps,
    };
  }

  factory FirstReminderText.fromMap(Map<String, dynamic> map) {
    return FirstReminderText(
      firstReminderText: map[fieldFirstReminderText] != null
          ? List<String?>.from(map[fieldFirstReminderText])
          : null,
      timestamps: List<Timestamp?>.from(map[fieldTimestamp]),
    );
  }

  List<String?>? convertToLowercase(List<String?>? list) {
    if (list != null) {
      return list.map((list) => list?.toLowerCase()).toList();
    }
    return null;
  }
}

class SecondReminderText {
  static const String fieldSecondReminderText = 'secondReminderText';
  static const String fieldTimestamp = 'Timestamp';

  List<String?>? secondReminderText;
  List<Timestamp?>? timestamps;
  SecondReminderText({
    this.secondReminderText,
    this.timestamps,
  });

  SecondReminderText copyWith({
    List<String?>? secondReminderText,
    List<Timestamp?>? timestamps,
  }) {
    return SecondReminderText(
      secondReminderText: secondReminderText ?? this.secondReminderText,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldSecondReminderText: convertToLowercase(secondReminderText),
      fieldTimestamp: timestamps,
    };
  }

  factory SecondReminderText.fromMap(Map<String, dynamic> map) {
    return SecondReminderText(
      secondReminderText: map[fieldSecondReminderText] != null
          ? List<String?>.from(map[fieldSecondReminderText])
          : null,
      timestamps: map[fieldTimestamp] != null
          ? List<Timestamp?>.from(map[fieldTimestamp])
          : null,
    );
  }

  List<String?>? convertToLowercase(List<String?>? list) {
    if (list != null) {
      return list.map((list) => list?.toLowerCase()).toList();
    }
    return null;
  }
}

class ThirdReminderText {
  static const String fieldThirdReminderText = 'thirdReminderText';
  static const String fieldTimestamp = 'Timestamp';

  List<String?>? thirdReminderText;
  List<Timestamp?>? timestamps;
  ThirdReminderText({
    this.thirdReminderText,
    this.timestamps,
  });

  ThirdReminderText copyWith({
    List<String?>? thirdReminderText,
    List<Timestamp?>? timestamps,
  }) {
    return ThirdReminderText(
      thirdReminderText: thirdReminderText ?? this.thirdReminderText,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldThirdReminderText: convertToLowercase(thirdReminderText),
      fieldTimestamp: timestamps,
    };
  }

  factory ThirdReminderText.fromMap(Map<String, dynamic> map) {
    return ThirdReminderText(
      thirdReminderText: map[fieldThirdReminderText] != null
          ? List<String?>.from(map[fieldThirdReminderText])
          : null,
      timestamps: map[fieldTimestamp] != null
          ? List<Timestamp?>.from(map[fieldTimestamp])
          : null,
    );
  }

  List<String?>? convertToLowercase(List<String?>? list) {
    if (list != null) {
      return list.map((list) => list?.toLowerCase()).toList();
    }
    return null;
  }
}
