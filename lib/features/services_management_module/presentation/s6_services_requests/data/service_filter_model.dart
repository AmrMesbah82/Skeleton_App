class ServiceFilterModel {
  final String searchQuery;
  final String selectedDepartment;
  final String userEmail;
  final String userDepartment;

  ServiceFilterModel({
    required this.searchQuery,
    required this.selectedDepartment,
    required this.userEmail,
    required this.userDepartment,
  });

  factory ServiceFilterModel.initial() {
    return ServiceFilterModel(
      searchQuery: '',
      selectedDepartment: 'All',
      userEmail: '',
      userDepartment: '',
    );
  }

  ServiceFilterModel copyWith({
    String? searchQuery,
    String? selectedDepartment,
    String? userEmail,
    String? userDepartment,
  }) {
    return ServiceFilterModel(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      userEmail: userEmail ?? this.userEmail,
      userDepartment: userDepartment ?? this.userDepartment,
    );
  }
}