class FieldHistory<T> {
  final List<DateTime> timestamps;
  final List<T> values;

  FieldHistory({
    required this.timestamps,
    required this.values,
  });

  T? get current => values.isNotEmpty ? values.last : null;

  T? getValueAt(int index) => index < values.length ? values[index] : null;

  DateTime? getTimestampAt(int index) =>
      index < timestamps.length ? timestamps[index] : null;

  void add(T value, [DateTime? timestamp]) {
    timestamps.add(timestamp ?? DateTime.now());
    values.add(value);
  }

  // ✅ ADD THIS METHOD TO FIX THE DISPLAY
  @override
  String toString() => current?.toString() ?? '';

  Map<String, dynamic> toJson(dynamic Function(T) valueSerializer) {
    return {
      'timestamps': timestamps.map((e) => e.toIso8601String()).toList(),
      'values': values.map((v) => valueSerializer(v)).toList(),
    };
  }

  factory FieldHistory.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) valueDeserializer,
  ) {
    return FieldHistory(
      timestamps: (json['timestamps'] as List<dynamic>? ?? [])
          .map((e) => DateTime.tryParse(e.toString()) ?? DateTime.now())
          .toList(),
      values: (json['values'] as List<dynamic>? ?? [])
          .map((e) => valueDeserializer(e))
          .toList(),
    );
  }

  factory FieldHistory.initial(T value, [DateTime? timestamp]) {
    return FieldHistory(
      timestamps: [timestamp ?? DateTime.now()],
      values: [value],
    );
  }
}
