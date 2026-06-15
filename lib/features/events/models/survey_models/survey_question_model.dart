import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:demo_app/features/events/models/constants_methods.dart';

class SurveyQuestion {
  List<String?>? questionTitle;
  List<String?>? questionType;
  List<bool?>? isRequired;
  List<String?>? answer;
  List<String?>? choices;
  List<String?>? correctAnswer;
  List<bool?>? isCorrectAnswer;
  List<String?>? status;
  List<Timestamp?>? timestamps;

  SurveyQuestion({
    required this.questionTitle,
    required this.questionType,
    required this.isRequired,
    required this.answer,
    required this.choices,
    required this.timestamps,
    required this.correctAnswer,
    required this.isCorrectAnswer,
    required this.status,
  });

  SurveyQuestion copyWith({
    List<String?>? questionTitle,
    List<String?>? questionType,
    List<bool?>? isRequired,
    List<String?>? answer,
    List<String?>? choices,
    List<Timestamp?>? timestamps,
    List<String?>? correctAnswer,
    List<bool?>? isCorrectAnswer,
    List<String?>? status,
  }) {
    return SurveyQuestion(
      questionTitle: questionTitle ?? this.questionTitle,
      questionType: questionType ?? this.questionType,
      isRequired: isRequired ?? this.isRequired,
      answer: answer ?? this.answer,
      choices: choices ?? this.choices,
      timestamps: timestamps ?? this.timestamps,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      isCorrectAnswer: isCorrectAnswer ?? this.isCorrectAnswer,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Question_Title': ConstantsMethods.convertToLowercase(questionTitle),
      'Question_Type': ConstantsMethods.convertToLowercase(questionType),
      'Is_Required': isRequired ?? [null],
      'Answer': answer ?? [null],
      'Choices': ConstantsMethods.convertToLowercase(choices),
      'Timestamp': timestamps ?? [null],
      'Correct_Answer': ConstantsMethods.convertToLowercase(correctAnswer),
      'Is_Correct_Answer': isCorrectAnswer ?? [null],
      'Status': status ?? [null],
    };
  }

  factory SurveyQuestion.fromMap(Map<String, dynamic> map) {
    return SurveyQuestion(
      questionTitle: map['Question_Title'] != null
          ? List<String?>.from(map['Question_Title']).map((questionTitle) {
              if (questionTitle != null && questionTitle.isNotEmpty) {
                return ConstantsMethods.capitalizeFirstChar(questionTitle);
              } else {
                return questionTitle;
              }
            }).toList()
          : null,
      questionType: map['Question_Type'] != null
          ? List<String?>.from(map['Question_Type']).map((questionType) {
              if (questionType != null && questionType.isNotEmpty) {
                return ConstantsMethods.capitalizeFirstChar(questionType);
              } else {
                return questionType;
              }
            }).toList()
          : null,
      isRequired: map['Is_Required'] != null
          ? List<bool?>.from(
              (map['Is_Required']),
            )
          : null,
      answer: map['Answer'] != null
          ? List<String?>.from(
              (map['Answer']),
            )
          : null,
      choices: map['Choices'] != null
          ? List<String?>.from(map['Choices']).map((correctAnswer) {
              if (correctAnswer != null && correctAnswer.isNotEmpty) {
                return ConstantsMethods.capitalizeFirstCharAtCHoices(
                    correctAnswer);
              } else {
                return correctAnswer;
              }
            }).toList()
          : null,
      timestamps: map['Timestamp'] != null
          ? List<Timestamp?>.from(
              (map['Timestamp']),
            )
          : null,
      correctAnswer: map['Correct_Answer'] != null
          ? List<String?>.from(map['Correct_Answer']).map((correctAnswer) {
              if (correctAnswer != null && correctAnswer.isNotEmpty) {
                return ConstantsMethods.capitalizeFirstChar(correctAnswer);
              } else {
                return correctAnswer;
              }
            }).toList()
          : null,
      isCorrectAnswer: map['Is_Correct_Answer'] != null
          ? List<bool?>.from(
              (map['Is_Correct_Answer']),
            )
          : null,
      status: map['Status'] != null
          ? List<String?>.from(
              (map['Status']),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SurveyQuestion.fromJson(String source) =>
      SurveyQuestion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Questions(Question_Title: $questionTitle, Question_Type: $questionType, Is_Required: $isRequired, Answer: $answer, Choices: $choices, Timestamp: $timestamps, Correct_Answer: $correctAnswer, Is_Correct_Answer: $isCorrectAnswer, Status: $status)';

  @override
  bool operator ==(covariant SurveyQuestion other) {
    if (identical(this, other)) return true;

    return listEquals(other.questionTitle, questionTitle) &&
        listEquals(other.questionType, questionType) &&
        listEquals(other.isRequired, isRequired) &&
        listEquals(other.answer, answer) &&
        listEquals(other.choices, choices) &&
        listEquals(other.timestamps, timestamps) &&
        listEquals(other.correctAnswer, correctAnswer) &&
        listEquals(other.isCorrectAnswer, isCorrectAnswer) &&
        listEquals(other.status, status);
  }

  @override
  int get hashCode =>
      questionTitle.hashCode ^
      questionType.hashCode ^
      isRequired.hashCode ^
      answer.hashCode ^
      choices.hashCode ^
      timestamps.hashCode ^
      correctAnswer.hashCode ^
      isCorrectAnswer.hashCode ^
      status.hashCode;
}
