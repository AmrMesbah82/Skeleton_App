class QuestionModel {
  String question;
  String questionType;
  String answer;
  String choices;
  String status;
  String hintText;
  bool isMcq;
  bool hasPhoto;
  bool isRequired;

  QuestionModel(
      {required this.question,
      required this.hintText,
      required this.isMcq,
      required this.hasPhoto,
      required this.answer,
      required this.choices,
      required this.questionType,
      required this.isRequired,
      required this.status
      });
}
