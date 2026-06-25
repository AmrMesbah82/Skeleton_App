import 'package:get/get.dart';
import 'package:intl/intl.dart';

Map<String, String> monthsMap = {
  'Jan': 'يناير',
  'Feb': 'فبراير',
  'Mar': 'مارس',
  'Apr': 'أبريل',
  'May': 'مايو',
  'Jun': 'يونيو',
  'Jul': 'يوليو',
  'Aug': 'أغسطس',
  'Sep': 'سبتمبر',
  'Oct': 'أكتوبر',
  'Nov': 'نوفمبر',
  'Dec': 'ديسمبر',
};

DateFormat dateFormat = DateFormat("d MMM yyyy");
String convertToArabicDate(String date) {
  // Split the input string by comma and space
  List<String> dateParts = date.split(", ");

  // Split the date part by space to get month, day, and year
  List<String> dateComponents = dateParts[0].split(" ");

  // Define a map of English months to Arabic months

  // Convert the month to Arabic using the map
  String arabicMonth =
      monthsMap[dateComponents[0].capitalize] ?? dateComponents[0];

  // Convert the day and year to Arabic
  String arabicDay = convertNumberToArabic(dateComponents[1]);
  String arabicYear = convertNumberToArabic(dateParts[1]);

  // Return the Arabic date format
  return '$arabicMonth $arabicDay, $arabicYear';
}

// Function to convert numbers to Arabic
String convertNumberToArabic(String number) {
  String arabicNumber = '';
  for (int i = 0; i < number.length; i++) {
    switch (number[i]) {
      case '0':
        arabicNumber += '٠';
        break;
      case '1':
        arabicNumber += '١';
        break;
      case '2':
        arabicNumber += '٢';
        break;
      case '3':
        arabicNumber += '٣';
        break;
      case '4':
        arabicNumber += '٤';
        break;
      case '5':
        arabicNumber += '٥';
        break;
      case '6':
        arabicNumber += '٦';
        break;
      case '7':
        arabicNumber += '٧';
        break;
      case '8':
        arabicNumber += '٨';
        break;
      case '9':
        arabicNumber += '٩';
        break;
      default:
        arabicNumber += number[i];
    }
  }
  return arabicNumber;
}

List<DateTime> extractDates(String input) {
  String cleanString = input.replaceAll("From ", "").replaceAll(" To ", " ");
  List<String> dateParts = cleanString.split(" ");
  String startDateStr = dateParts.sublist(0, 3).join(" ");
  String endDateStr = dateParts.sublist(3).join(" ");

  try {
    DateTime startDate = dateFormat.parse(startDateStr);
    DateTime endDate = dateFormat.parse(endDateStr);
    return [startDate, endDate];
  } catch (e) {
    print("Error parsing date: $e");
    return [];
  }
}

String convertToArabic(String dateStr) {
  // Define the input format
  DateFormat inputFormat = DateFormat('d MMM yyyy', 'en');

  // Parse the input date string
  DateTime date = inputFormat.parse(dateStr);

  // Define the output format with Arabic locale
  DateFormat outputFormat = DateFormat('d MMMM yyyy', 'ar');

  // Format the date to Arabic
  String formattedDate = outputFormat.format(date);
  return formattedDate;
}

String convertTimeToArabic(String timeString) {
  // Convert input time to DateTime object
  DateTime dateTime = DateFormat.jm().parse(timeString);

  // Format DateTime object to desired format
  String formattedHour =
      convertNumberToArabic(DateFormat('h').format(dateTime));
  String formattedMinute =
      convertNumberToArabic(DateFormat('mm').format(dateTime));
  String formattedAMPM = DateFormat('a').format(dateTime);

  // Map AM/PM to Arabic equivalents
  String ampmInArabic = formattedAMPM == 'AM' ? 'صباحًا' : 'مساءً';

  // Final formatted string
  String formattedTimeString = '$formattedHour:$formattedMinute $ampmInArabic';

  return formattedTimeString;
}

String translateDateFormatToArabic(String formattedDate) {
  // Define a map of English days of the week to Arabic
  Map<String, String> arabicDaysOfWeek = {
    'Monday': 'الاثنين',
    'Tuesday': 'الثلاثاء',
    'Wednesday': 'الأربعاء',
    'Thursday': 'الخميس',
    'Friday': 'الجمعة',
    'Saturday': 'السبت',
    'Sunday': 'الأحد',
  };

  try {
    // Split the formatted date to extract the day of the week, day, month, and year
    List<String> dateParts = formattedDate.split(', ');
    String dayOfWeek = dateParts[0];
    String dateWithoutDayOfWeek = dateParts[1];

    // Parse the date without the day of the week
    DateTime parsedDate =
        DateFormat('dd MMMM yyyy').parse(dateWithoutDayOfWeek);

    // Get the Arabic translation of the day of the week
    String arabicDayOfWeek = arabicDaysOfWeek[dayOfWeek] ?? '';

    // Get the Arabic translation of the month
    String arabicMonth = monthsMap[DateFormat('MMMM').format(parsedDate)] ?? '';

    // Convert the day and year to Arabic
    String arabicDay =
        convertNumberToArabic(DateFormat('dd').format(parsedDate));
    String arabicYear =
        convertNumberToArabic(DateFormat('yyyy').format(parsedDate));

    // Return the translated Arabic date format
    return '$arabicDayOfWeek، $arabicDay $arabicMonth $arabicYear';
  } catch (e) {
    print("Error translating date format to Arabic: $e");
    return '';
  }
}

String convertToArabicDateSpaceVersion(String date) {
  // Split the input string by space
  List<String> dateComponents = date.split(" ");

  // Define a map of English months to Arabic months

  // Convert the month to Arabic using the map
  String arabicMonth = monthsMap[dateComponents[1]] ??
      dateComponents[1]; // Using full month name

  // Convert the day and year to Arabic
  String arabicDay = convertNumberToArabic(dateComponents[0]);
  String arabicYear = convertNumberToArabic(dateComponents[2]);

  // Return the Arabic date format
  return '$arabicDay $arabicMonth $arabicYear';
}

String translateMonthYearToArabic(String text) {
  // Check if the text already contains Arabic characters
  bool containsArabic = text.contains(RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\uFB50-\uFDFF\uFE70-\uFEFF\uFB50-\uFDFF]'));

  if (containsArabic) {
    // If text contains Arabic characters, assume it's already translated
    return text;
  }

  try {
    // Split the text to separate month and year
    List<String> textParts = text.split(" ");
    String month = textParts[0];
    String year = textParts[1];

    // Translate the month into Arabic
    String arabicMonth = monthsMap[month] ?? month;

    // Translate the year into Arabic numbers
    String arabicYear = convertNumberToArabic(year);

    // Return the translated date format
    return '$arabicMonth $arabicYear';
  } catch (e) {
    print("Error translating text to Arabic: $e");
    return '';
  }
}

String convertToArabicDateTime(String dateTimeString) {
  if (dateTimeString == '') {
    return '';
  }
  // Split the input string by comma and space
  List<String> dateParts = dateTimeString.split(", ");

  // Split the date part by space to get day, month, and year
  List<String> dateComponents = dateParts[0].split(" ");

  // Define a map of English months to Arabic months

  // Convert the month to Arabic using the map
  String arabicMonth = monthsMap[dateComponents[1]] ?? dateComponents[1];

  // Convert the day and year to Arabic
  String arabicDay = convertNumberToArabic(dateComponents[0]);
  String arabicYear = convertNumberToArabic(dateComponents[2]);

  // Split the time part by space to get hour, minute, and AM/PM
  List<String> timeComponents = dateParts[1].split(" ");
  String time = timeComponents[0];
  String amPm = timeComponents[1];

  // Convert AM/PM to Arabic equivalents
  String arabicAMPM = amPm == 'AM' ? 'صباحًا' : 'مساءً';

  // Return the Arabic date-time format
  return '$arabicDay $arabicMonth $arabicYear، $time $arabicAMPM';
}

String reduceNumber(int number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}${"M".tr}';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}${"K".tr}';
  } else {
    return '$number';
  }
}

String timeAgo(DateTime dateTime) {
  Duration diff = DateTime.now().difference(dateTime);

  String timeString;

  if (diff.inSeconds < 60) {
    timeString = Get.locale.toString().contains('en')
        ? '${diff.inSeconds} ${"Seconds Ago".tr}'
        : (diff.inDays == 1 ? "قبل ثانية".tr : "قبل ${diff.inDays} ثانية".tr);
  } else if (diff.inMinutes < 60) {
    timeString = Get.locale.toString().contains('en')
        ? '${diff.inMinutes} ${"Minutes Ago".tr}'
        : (diff.inDays == 1 ? "قبل دقيقة".tr : "قبل ${diff.inDays} دقيقة".tr);
  } else if (diff.inHours < 24) {
    timeString = Get.locale.toString().contains('en')
        ? '${diff.inHours} ${"Hours Ago".tr}'
        : (diff.inDays == 1 ? "قبل ساعة".tr : "قبل ${diff.inDays} ساعات".tr);
  } else if (diff.inDays < 7) {
    timeString = Get.locale.toString().contains('en')
        ? '${diff.inDays} ${"Days Ago".tr}'
        : (diff.inDays == 1 ? "امس".tr : "قبل ${diff.inDays} ايام".tr);
  } else if (diff.inDays < 30) {
    timeString = Get.locale.toString().contains('en')
        ? '${(diff.inDays / 7).floor()} ${"Weeks Ago".tr}'
        : (diff.inDays == 1 ? "قبل اسبوع".tr : "قبل ${diff.inDays} اسابيع".tr);
  } else if (diff.inDays < 365) {
    timeString = Get.locale.toString().contains('en')
        ? '${(diff.inDays / 30).floor()} ${"Months Ago".tr}'
        : (diff.inDays == 1 ? "قبل شهر".tr : "قبل ${diff.inDays} شهور".tr);
  } else {
    timeString = Get.locale.toString().contains('en')
        ? '${(diff.inDays / 365).floor()} ${"Years Ago".tr}'
        : (diff.inDays == 1 ? "قبل سنة".tr : "قبل ${diff.inDays} سنين".tr);
  }

  if (Get.locale.toString().contains('ar')) {
    timeString = convertNumberToArabic(timeString);
  }

  return timeString;
}

String localizeNumber(String value) {
  return Get.locale.toString().contains('ar')
      ? convertNumberToArabic(value)
      : value;
}

String translateDate(String original) {
  // Define month translations
  const Map<String, String> monthTranslations = {
    "Jan": "يناير",
    "Feb": "فبراير",
    "Mar": "مارس",
    "Apr": "أبريل",
    "May": "مايو",
    "Jun": "يونيو",
    "Jul": "يوليو",
    "Aug": "أغسطس",
    "Sep": "سبتمبر",
    "Oct": "أكتوبر",
    "Nov": "نوفمبر",
    "Dec": "ديسمبر"
  };

  // Define number translations
  const Map<String, String> numberTranslations = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩'
  };

  // Split the input string to separate day, month, and year
  List<String> parts = original.split(" ");

  // Debug print to check the split parts
  print("Parts: $parts");

  // Translate the day part
  String dayPart = parts[0];
  String translatedDayPart = dayPart
      .split('')
      .map((char) => numberTranslations[char] ?? char)
      .join('');

  // Translate the month part
  String monthPart = parts[1];
  String translatedMonthPart = monthTranslations[monthPart] ?? monthPart;

  // Translate the year part
  String yearPart = parts[2];
  String translatedYearPart = yearPart
      .split('')
      .map((char) => numberTranslations[char] ?? char)
      .join('');

  // Combine translated parts
  String translatedDate =
      "$translatedDayPart $translatedMonthPart $translatedYearPart";

  return translatedDate;
}

// Method to translate date to Arabic format
String translateDateTask(String date) {
  // Define Arabic numerals mapping
  final arabicNumerals = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  // Format the input date
  DateFormat inputFormat = DateFormat('dd/MM/yyyy');
  DateFormat outputFormat = DateFormat('dd MMMM yyyy', 'ar');
  DateTime dateTime = inputFormat.parse(date);
  String formattedDate = outputFormat.format(dateTime);

  // Translate to Arabic numerals
  String translatedDate = formattedDate.split('').map((char) {
    if (char.contains(RegExp(r'[0-9]'))) {
      return arabicNumerals[int.parse(char)];
    } else {
      return char;
    }
  }).join('');

  return translatedDate;
}

String translateTime(String original) {
  // Define AM and PM translations
  const Map<String, String> amPmTranslations = {"AM": "ص", "PM": "م"};

  // Define number translations
  const Map<String, String> numberTranslations = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩'
  };

  // Split the input string to separate time and period
  List<String> parts = original.split(" ");

  // Translate the time part
  String timePart = parts[0];
  String translatedTimePart = timePart
      .split('')
      .map((char) => numberTranslations[char] ?? char)
      .join('');

  // Translate AM/PM part
  String periodPart = parts[1];
  String translatedPeriodPart = amPmTranslations[periodPart] ?? periodPart;

  // Combine translated parts
  String translatedTime = "$translatedTimePart $translatedPeriodPart";

  return translatedTime;
}
