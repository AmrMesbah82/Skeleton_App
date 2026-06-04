import 'package:flutter/material.dart';

int expirationCalculation(String expirationTime) {
  DateTime expirationDate = _parseExpirationDate(expirationTime);
  DateTime currentDate = DateTime.now();

  Duration difference = expirationDate.difference(currentDate);
  int weeksLeft = (difference.inDays / 7).ceil();
  return weeksLeft;
}

DateTime _parseExpirationDate(String expirationTime) {
  List<String> parts = expirationTime.split('/');
  int day = int.parse(parts[0]);
  String month = parts[1];
  int year = int.parse(parts[2]);

  Map<String, int> months = {
    'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
    'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
  };

  int monthValue = months[month]!;
  return DateTime(year, monthValue, day);
}
