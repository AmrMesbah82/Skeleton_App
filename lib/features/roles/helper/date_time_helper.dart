import 'package:get/get.dart';
import 'package:intl/intl.dart';

///************************ FILE INFO ********************///
/// FILE NAME: date_time_helper.dart
/// PURPOSE: handle all formatting and parsing of date and time
/// Author: Mohamed Elrashidy
/// Created at: 29/1/2025
abstract class DateTimeHelper {
  /// Method Name: [formatDateTimeMMMDDYYYY]
  ///
  /// Description: format the date time to be in MMM dd, yyyy format
  ///
  /// Parameters:
  ///            [DateTime?][dateTime] : the date time to be formatted
  ///
  /// Returns:
  ///         [String] : the formatted date time
  static String formatDateTimeMMMDDYYYY(DateTime? dateTime) {
    if (dateTime == null) return "";
    if (Get.locale.toString().contains('en')) {
      DateFormat formatter = DateFormat('MMM dd, yyyy');
      return formatter.format(dateTime);
    }
    else {
      DateFormat formatter = DateFormat('MMM dd, yyyy', 'ar');
      return formatter.format(dateTime);
    }
  }

  /// Method Name: [formatDateTimeHHMM]
  ///
  /// Description: format the date time to be in hh:mm a format
  ///
  /// Parameters:
  ///           [DateTime?][dateTime] : the date time to be formatted
  ///
  /// Returns:
  ///        [String] : the formatted date time
  static String formatDateTimeHHMM(DateTime? dateTime) {
    if (dateTime == null) return "";
    if (Get.locale.toString().contains('en')) {
      DateFormat formatter = DateFormat('hh:mm a');
      return formatter.format(dateTime);
    }
    else {
      DateFormat formatter = DateFormat('hh:mm a', 'ar');
      return formatter.format(dateTime);
    }
  }

  /// Formats an integer to a locale-aware string (used for Arabic number display).
  static String formatInt(int number) {
    return NumberFormat('0', Get.locale.toString()).format(number);
  }
}
