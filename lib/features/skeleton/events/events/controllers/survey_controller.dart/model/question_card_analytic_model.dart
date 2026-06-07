class QuestionCardAnalyticModel {
  String questionName;
  int questionType; // 1 for essay, 2 for mcq, 3 for true/false
  String? answer; // For essay type questions
  List<String>? values; // For mcq and true/false type questions

  QuestionCardAnalyticModel({
    required this.questionName,
    required this.questionType,
    this.answer,
    this.values,
  });
}
