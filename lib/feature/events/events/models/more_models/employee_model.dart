import 'package:demo_app/feature/events/models/more_models/assigned_event_model.dart';

// class EmployeeModel {
//   final String? id;
//   final List<String> role;
//   final List<String> name;
//   final List<String> imageUrl;
//   final List<String> department;

//   EmployeeModel({
//     this.id,
//     required this.role,
//     required this.name,
//     required this.imageUrl,
//     required this.department,
//   });

//   factory EmployeeModel.fromMap(String docId, Map data) {
//     return EmployeeModel(
//       id: docId,
//       role: data['Job_Title'] != null
//           ? List<String>.from(
//               data['Job_Title'],
//             )
//           : [],
//       name: data['Employee_Name'] != null
//           ? List<String>.from(data['Employee_Name'])
//           : [],
//       imageUrl: data['Image_Path'] != null
//           ? List<String>.from(data['Image_Path'])
//           : [],
//       department: data['Department'] != null
//           ? List<String>.from(data['Department'])
//           : [],
//     );
//   }

//   Map<String, dynamic> toMap() => {
//         'Job_Title': role,
//         'Employee_Name': name,
//         'Image_Path': imageUrl,
//         'Department': department,
//       };
// }

class ApprovalAndInvitedListModel {
  final String? id;
  final List<AssignedEvent> invitedEvents;
  final List<AssignedEvent> approvalEvents;

  ApprovalAndInvitedListModel({
    this.id,
    required this.invitedEvents,
    required this.approvalEvents,
  });

  factory ApprovalAndInvitedListModel.fromMap(String docId, Map data) {
    return ApprovalAndInvitedListModel(
      id: docId,
      invitedEvents: (data['Invited_Events'] as List)
          .map((question) => AssignedEvent.fromMap(question))
          .toList(),
      approvalEvents: (data['Approval_Events'] as List)
          .map((question) => AssignedEvent.fromMap(question))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'Invited_Events': invitedEvents.map((event) => event.toMap()).toList(),
        'Approval_Events':
            approvalEvents.map((event) => event.toMap()).toList(),
      };
}
