import '../presentation/ui/pages/tablet/employees_screen.dart';

class EmployeesDummyData{
  Map<Employee, List<Employee>> employeesData = {
    Employee(
        name: "Scott Forstall",
        jobTitle: "Job Title",
        imageUrl: "assets/images/profile1.png"): [
      Employee(
          name: "Scott Forstall",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile1.png"),
      Employee(
          name: "Philip Schiller",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile3.png"),
      Employee(
          name: "Scott Forstall",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile1.png"),
      Employee(
          name: "Philip Schillerl",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile.png")
    ],
    Employee(
        name: "Philip Schiller",
        jobTitle: "Job Title",
        imageUrl: "assets/images/profile3.png"): [
      Employee(
          name: "Scott Forstall",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile.png"),
      Employee(
          name: "Philip Schiller",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile3.png"),
      Employee(
          name: "Scott Forstall",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile1.png"),
      Employee(
          name: "Philip Schillerl",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile3.png")
    ],
    Employee(
        name: "Philip Schiller",
        jobTitle: "Job Title",
        imageUrl: "assets/images/profile.png"): [
      Employee(
          name: "Scott Forstall",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile1.png"),
      Employee(
          name: "Philip Schiller",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile.png"),
      Employee(
          name: "Scott Forstall",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile1.png"),
      Employee(
          name: "Philip Schillerl",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile3.png")
    ],
    Employee(
        name: "Scott Forstall",
        jobTitle: "Job Title",
        imageUrl: "assets/images/profile3.png"): [
      Employee(
          name: "Scott Forstall",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile1.png"),
      Employee(
          name: "Philip Schiller",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile3.png"),
      Employee(
          name: "Scott Forstall",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile.png"),
      Employee(
          name: "Philip Schillerl",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile3.png")
    ],
    Employee(
        name: "Scott Forstall",
        jobTitle: "Job Title",
        imageUrl: "assets/images/profile.png"): [
      Employee(
          name: "Scott Forstall",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile1.png"),
      Employee(
          name: "Philip Schiller",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile3.png"),
      Employee(
          name: "Scott Forstall",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile1.png"),
      Employee(
          name: "Philip Schillerl",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile3.png")
    ],
    Employee(
        name: "Philip Schiller",
        jobTitle: "Job Title",
        imageUrl: "assets/images/profile1.png"): [
      Employee(
          name: "bastian romarinho",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile1.png"),
      Employee(
          name: "Philip Schiller",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile3.png"),
      Employee(
          name: "Scott Forstall",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile1.png"),
      Employee(
          name: "Philip Schillerl",
          jobTitle: "Job Title",
          imageUrl: "assets/images/profile3.png")
    ]
  };

}

class Employee {
  final String name;
  final String jobTitle;
  final String imageUrl;

  Employee({
    required this.name,
    required this.jobTitle,
    required this.imageUrl,
  });
}