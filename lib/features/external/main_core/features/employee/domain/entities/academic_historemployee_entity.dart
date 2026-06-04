class AcademicHistoryEntity {
  final String? graduateFrom;
  final String? university;
  final String? yearOfGraduation;
  final String? gpa;
  final String? graduateFromStatus;
  final String? universityStatus;
  final String? yearOfGraduationStatus;
  final String? gpaStatus;

  AcademicHistoryEntity({
    this.graduateFrom,
    this.university,
    this.yearOfGraduation,
    this.gpa,
    this.graduateFromStatus,
    this.universityStatus,
    this.yearOfGraduationStatus,
    this.gpaStatus,
  });
  toJson() {}
}
