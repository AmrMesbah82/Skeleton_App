class FrequencyData {
  final String frequencyUnit; // "daily", "weekly", "monthly"
  final int frequencyCount;
  final Set<String>? selectedDays;

  FrequencyData({
    required this.frequencyUnit,
    required this.frequencyCount,
    this.selectedDays,
  });

  factory FrequencyData.fromMap(Map<String, dynamic> map) {
    return FrequencyData(
      frequencyUnit: map['frequencyUnit'] ?? map['Frequency_Unit'] ?? '',
      frequencyCount: map['frequencyCount'] ?? map['Frequency_Count'] ?? 0,
      selectedDays: (map['Selected_Days'] != null)
          ? Set<String>.from(map['Selected_Days'])
          : {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Frequency_Unit': frequencyUnit,
      'Frequency_Count': frequencyCount,
      if (selectedDays != null && selectedDays!.isNotEmpty)
        'Selected_Days': selectedDays!.toList(),
    };
  }
}
