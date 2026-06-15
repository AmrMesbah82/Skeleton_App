import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:demo_app/features/events/models/constants_methods.dart';

class SurveyTitle {
  List<String?>? title;
  List<Timestamp?>? timestamps;
  SurveyTitle({
    required this.title,
    required this.timestamps,
  });

  SurveyTitle copyWith({
    List<String?>? title,
    List<Timestamp?>? timestamps,
  }) {
    return SurveyTitle(
      title: title ?? this.title,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Title': ConstantsMethods.convertToLowercase(title),
      'Timestamp': timestamps,
    };
  }

  factory SurveyTitle.fromMap(Map<String, dynamic> map) {
    return SurveyTitle(
      title: map['Title'] != null
          ? List<String?>.from(map['Title']).map((creationDate) {
              if (creationDate != null && creationDate.isNotEmpty) {
                return ConstantsMethods.capitalizeFirstChar(creationDate);
              } else {
                return creationDate;
              }
            }).toList()
          : null,
      timestamps: map['Timestamp'] != null
          ? List<Timestamp?>.from(
              (map['Timestamp']),
            )
          : null,
    );
  }
static String capitalizeFirstChar(String input) {
    /*
    Input: "hello-world test-case"
    Output: "Hello-World Test-Case" */
    RegExp wordBoundary = RegExp(r'(\s|-)+');

    List<String> words = input.split(wordBoundary);

    Iterable<Match> delimiters = wordBoundary.allMatches(input);

    List<String> capitalizedWords = words.map((word) {
      if (word.isNotEmpty && RegExp(r'^[a-zA-Z0-9]').hasMatch(word)) {
        return word[0].toUpperCase() + word.substring(1);
      } else {
        return word;
      }
    }).toList();

    StringBuffer result = StringBuffer();
    for (int i = 0; i < capitalizedWords.length; i++) {
      result.write(capitalizedWords[i]);
      if (i < delimiters.length) {
        result.write(delimiters.elementAt(i).group(0));
      }
    }

    return result.toString();
  }

  String toJson() => json.encode(toMap());

  factory SurveyTitle.fromJson(String source) =>
      SurveyTitle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Title(Title: $title, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant SurveyTitle other) {
    if (identical(this, other)) return true;

    return listEquals(other.title, title) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => title.hashCode ^ timestamps.hashCode;
}
