String capitalizeMonth(String date) {
  List<String> parts = date.split(' ');
  if (parts.length == 3) {
    parts[1] = parts[1][0].toUpperCase() + parts[1].substring(1);
  }
  return parts.join(' ');
}

String capitalizeAmPm(String time) {
  if (time.toLowerCase().contains('am') || time.toLowerCase().contains('pm')) {
    time = time.replaceAll('am', 'AM').replaceAll('pm', 'PM');
  }
  return time;
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
