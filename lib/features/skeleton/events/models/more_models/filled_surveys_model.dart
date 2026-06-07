import 'package:demo_app/features/skeleton/events/models/more_models/employee_submission_model.dart';

class FilledSurveyModel {
  final String? surveyId;
  final List<EmployeeSubmissionModel> answers;

  FilledSurveyModel({required this.answers, this.surveyId});

  factory FilledSurveyModel.fromMap(String docId, Map<String, dynamic> map) {
    return FilledSurveyModel(
      surveyId: docId,
      answers: map['Responses'] != null
          ? (map['Responses'] as List)
              .map((answer) => EmployeeSubmissionModel.fromMap(answer))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() => {
        'Responses': answers.map((a) => a.toMap()).toList(),
      };

  @override
  String toString() {
    return 'FilledSurveyModel{id: $surveyId, Responses: ${answers.toString()}';
  }
}
