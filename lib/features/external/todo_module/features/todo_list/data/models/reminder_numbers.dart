import 'package:cloud_firestore/cloud_firestore.dart';

class FirstReminderNumber {
  static const String fieldFirstReminderNumber = 'firstReminderNumber';
  static const String fieldTimestamp = 'Timestamp';

  List<String?>? firstReminderNumber;
  List<Timestamp?> timestamps;
  FirstReminderNumber({
    this.firstReminderNumber,
    required this.timestamps,
  });

  FirstReminderNumber copyWith({
    List<String?>? firstReminderNumber,
    List<Timestamp?>? timestamps,
  }) {
    return FirstReminderNumber(
      firstReminderNumber: firstReminderNumber ?? this.firstReminderNumber,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldFirstReminderNumber: firstReminderNumber,
      fieldTimestamp: timestamps,
    };
  }

  factory FirstReminderNumber.fromMap(Map<String, dynamic> map) {
    return FirstReminderNumber(
      firstReminderNumber: map[fieldFirstReminderNumber] != null
          ? List<String?>.from(map[fieldFirstReminderNumber])
          : null,
      timestamps: List<Timestamp?>.from(map[fieldTimestamp]),
    );
  }
}

class SecondReminderNumber {
  static const String fieldSecondReminderNumber = 'secondReminderNumber';
  static const String fieldTimestamp = 'Timestamp';

  List<String?>? secondReminderNumber;
  List<Timestamp?>? timestamps;
  SecondReminderNumber({
    this.secondReminderNumber,
    this.timestamps,
  });

  SecondReminderNumber copyWith({
    List<String?>? secondReminderNumber,
    List<Timestamp?>? timestamps,
  }) {
    return SecondReminderNumber(
      secondReminderNumber: secondReminderNumber ?? this.secondReminderNumber,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldSecondReminderNumber: secondReminderNumber,
      fieldTimestamp: timestamps,
    };
  }

  factory SecondReminderNumber.fromMap(Map<String, dynamic> map) {
    return SecondReminderNumber(
      secondReminderNumber: map[fieldSecondReminderNumber] != null
          ? List<String?>.from(map[fieldSecondReminderNumber])
          : null,
      timestamps: map[fieldTimestamp] != null
          ? List<Timestamp?>.from(map[fieldTimestamp])
          : null,
    );
  }
}

class ThirdReminderNumber {
  static const String fieldThirdReminderNumber = 'thirdReminderNumber';
  static const String fieldTimestamp = 'Timestamp';

  List<String?>? thirdReminderNumber;
  List<Timestamp?>? timestamps;
  ThirdReminderNumber({
    this.thirdReminderNumber,
    this.timestamps,
  });

  ThirdReminderNumber copyWith({
    List<String?>? thirdReminderNumber,
    List<Timestamp?>? timestamps,
  }) {
    return ThirdReminderNumber(
      thirdReminderNumber: thirdReminderNumber ?? this.thirdReminderNumber,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldThirdReminderNumber: thirdReminderNumber,
      fieldTimestamp: timestamps,
    };
  }

  factory ThirdReminderNumber.fromMap(Map<String, dynamic> map) {
    return ThirdReminderNumber(
      thirdReminderNumber: map[fieldThirdReminderNumber] != null
          ? List<String?>.from(map[fieldThirdReminderNumber])
          : null,
      timestamps: map[fieldTimestamp] != null
          ? List<Timestamp?>.from(map[fieldTimestamp])
          : null,
    );
  }
}
