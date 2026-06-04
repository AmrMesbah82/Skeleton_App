import 'package:demo_app/feature/events/models/more_models/email_model.dart';
import 'package:demo_app/feature/events/models/more_models/remaining_time_model.dart';
import 'package:demo_app/feature/events/models/more_models/submission_status_model.dart';
import 'package:demo_app/feature/events/models/survey_models/survey_question_model.dart';

class EmployeeSubmissionModel {
  final Email email;
  final SubmissionStatus status;
  final TimeTakenModel timeTaken;
  final List<SurveyQuestion> questionModel;

  EmployeeSubmissionModel({
    required this.email,
    required this.questionModel,
    required this.status,
    required this.timeTaken,
  });

  factory EmployeeSubmissionModel.fromMap(Map<String, dynamic> map) {
    return EmployeeSubmissionModel(
      email: map['Email'] != null
          ? Email.fromMap(map['Email'])
          : Email(employeeEmail: [], timestamps: []),
      status: map['Status'] != null
          ? SubmissionStatus.fromMap(map['Status'])
          : SubmissionStatus(status: [], timestamps: []),
      questionModel: map['Qusetion_Model'] != null
          ? (map['Qusetion_Model'] as List)
              .map((question) => SurveyQuestion.fromMap(question))
              .toList()
          : [],
      timeTaken: map['Remaining_Time'] != null
          ? TimeTakenModel.fromMap(map['Remaining_Time'])
          : TimeTakenModel(remainingTime: [], timestamps: []),
    );
  }

  Map<String, dynamic> toMap() => {
        'Email': email.toMap(),
        'Status': status.toMap(),
        'Qusetion_Model': questionModel.map((q) => q.toMap()).toList(),
        'Remaining_Time': timeTaken.toMap()
      };

  @override
  String toString() {
    return 'EmployeeSubmissionModel(email: ${email.toString()})';
  }
}
