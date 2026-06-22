class DepartmentCountModel {
  final int total;
  final Map<String, int> departmentCounts;

  DepartmentCountModel({
    required this.total,
    required this.departmentCounts,
  });

  factory DepartmentCountModel.empty() {
    return DepartmentCountModel(
      total: 0,
      departmentCounts: {},
    );
  }

  DepartmentCountModel copyWith({
    int? total,
    Map<String, int>? departmentCounts,
  }) {
    return DepartmentCountModel(
      total: total ?? this.total,
      departmentCounts: departmentCounts ?? this.departmentCounts,
    );
  }
}