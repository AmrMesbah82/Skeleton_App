class ParticipantModel {
  final String profilePhoto;
  final String email;
  final String name;
  final String nameArabic;
  final String jobTitle;
  final String department;
  final String departmentArabic;
  final String? status;
  final String? dateSentResponse;

  ParticipantModel(
      {required this.department,
      required this.email,
      required this.jobTitle,
      required this.name,
      required this.nameArabic,
      required this.departmentArabic,
      required this.profilePhoto,
      required this.status,
      this.dateSentResponse});
}
