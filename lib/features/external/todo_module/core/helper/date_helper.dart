import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/external/todo_module/core/constants/enum.dart';

abstract class DateHelper {
  static TimeOfDay? parseTimeOfDay(String timeString) {
    final timeParts = timeString.split(' ');
    if (timeParts.length != 2) {
      return null;
    }
    final time = timeParts[0].split(':');
    if (time.length != 2) {
      return null;
    }
    final hour = int.tryParse(time[0]);
    final minute = int.tryParse(time[1]);
    final period = timeParts[1].toLowerCase();

    if (hour == null || minute == null) {
      return null;
    }
    if (period == 'pm' && hour < 12) {
      return TimeOfDay(hour: hour + 12, minute: minute);
    } else if (period == 'am' && hour == 12) {
      return TimeOfDay(hour: 0, minute: minute);
    } else {
      return TimeOfDay(hour: hour, minute: minute);
    }
  }

  static String formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay != null) {
      final now = DateTime.now();
      final dt = DateTime(
          now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
      final format = DateFormat('hh:mm a');
      return format.format(dt);
    } else {
      return "";
    }
  }

  static bool checkIsEnded({required String date, required String time}) {
    if (date.toLowerCase() == "empty" || time.toLowerCase() == "empty") {
      return false;
    }
    final specificDateTime = DateTime.now();
    try {
      final providedDateTime = DateFormat('dd MMM yyyy hh:mm a')
          .parse('${formatDateString(date)} ${time.toUpperCase()}');
      return providedDateTime.isBefore(specificDateTime);
    } catch (e) {
      log("Error parsing date/time: $e");
      return false;
    }
  }
 static String formatDateString(String date) {
    List<String> parts = date.split(' ');
    if (parts.length >= 2) {
      parts[1] = capitalize(parts[1]);
    }
    return parts.join(' ');
  }
}
