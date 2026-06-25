class ReminderData {
  String? durationUnit; // "minutes", "hours", "seconds"
  int durationCount;

  ReminderData({
    required this.durationUnit,
    required this.durationCount,
  });

  factory ReminderData.fromMap(Map<String, dynamic> map) {
    return ReminderData(
      durationUnit: map['Duration_Unit'] ?? 'hour',
      durationCount: map['Duration_Count'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Duration_Unit': durationUnit,
      'Duration_Count': durationCount,
    };
  }
}
