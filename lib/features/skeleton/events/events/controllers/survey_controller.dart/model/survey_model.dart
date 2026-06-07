
import 'package:demo_app/features/skeleton/events/events/controllers/survey_controller.dart/model/participants_model.dart';
import 'package:demo_app/features/skeleton/events/events/controllers/survey_controller.dart/model/question_card_analytic_model.dart';
import 'package:demo_app/features/skeleton/events/events/controllers/survey_controller.dart/model/question_model.dart';

class SurveyModel {
  String surveyPhoto;
  String surveyTitle;
  String surveyTitleArabic;
  String summary;
  String summaryInArabic;
  String eventName;
  String eventNameArabic;
  String type;
  String departmentOwner;
  String date;
  String status;
  bool isSelected;
  List<QuestionModel> questions;
  List<QuestionCardAnalyticModel> questionAnalytics;
  String maxResponseTime;
  String averageTime;
  String minResponseTime;
  List<ParticipantModel> partitcipants;
  String id;
  String eventID;
  bool showResponse;

  SurveyModel(
      {required this.departmentOwner,
      required this.date,
      required this.eventName,
      required this.status,
      required this.surveyPhoto,
      required this.surveyTitle,
      required this.type,
      this.isSelected = false,
      required this.id,
      required this.questions,
      required this.questionAnalytics,
      required this.maxResponseTime,
      required this.averageTime,
      required this.minResponseTime,
      required this.partitcipants,
      required this.summary,
      required this.summaryInArabic,
      required this.surveyTitleArabic,
      required this.eventID,
      required this.eventNameArabic,
      required this.showResponse});
}
