import 'package:demo_app/features/skeleton/events/models/survey_models/assigned_event_id_model.dart';
import 'package:demo_app/features/skeleton/events/models/survey_models/show_responses_model.dart';
import 'package:demo_app/features/skeleton/events/models/survey_models/survey_description_model.dart';
import 'package:demo_app/features/skeleton/events/models/survey_models/survey_question_model.dart';
import 'package:demo_app/features/skeleton/events/models/survey_models/survey_status_model.dart';
import 'package:demo_app/features/skeleton/events/models/survey_models/survey_title_model.dart';

class SurveyFirebaseModel {
  final String? id;
  final AssignedId assignedEventId;
  final SurveyTitle englishTitle;
  final SurveyTitle arabicTitle;
  final SurveyDescription englishDescription;
  final SurveyDescription arabicDescription;
  final List<SurveyQuestion> questions;
  final SurveyStatus status;
  final ShowResponses showResponse;

  SurveyFirebaseModel({
    this.id,
    required this.assignedEventId,
    required this.englishTitle,
    required this.arabicTitle,
    required this.englishDescription,
    required this.arabicDescription,
    required this.questions,
    required this.status,
    required this.showResponse,
  });

  factory SurveyFirebaseModel.fromMap(
      {required String docId, required Map data}) {
    return SurveyFirebaseModel(
      id: docId,
      assignedEventId: AssignedId.fromMap(data['Assigned_Event_Id']),
      englishTitle: SurveyTitle.fromMap(data['Title_English']),
      arabicTitle: SurveyTitle.fromMap(data['Title_Arabic']),
      englishDescription:
          SurveyDescription.fromMap(data['Description_English']),
      arabicDescription: SurveyDescription.fromMap(data['Description_Arabic']),
      questions: (data['Questions'] as List)
          .map((question) => SurveyQuestion.fromMap(question))
          .toList(),
      status: SurveyStatus.fromMap(data['Status']),
      showResponse: ShowResponses.fromMap(data['Show_Response']),
    );
  }

  Map<String, dynamic> toMap() => {
        'Title_English': englishTitle.toMap(),
        'Title_Arabic': arabicTitle.toMap(),
        'Description_English': englishDescription.toMap(),
        'Description_Arabic': arabicDescription.toMap(),
        'Questions': questions.map((question) => question.toMap()).toList(),
        'Status': status.toMap(),
        'Assigned_Event_Id': assignedEventId.toMap(),
        'Show_Response': showResponse.toMap(),
      };
}
