import 'package:get/get.dart';
import 'package:demo_app/core/enums/enum.dart';

class Validator {


 static String? email(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return Get.locale.toString().contains("en")
          ? 'Invalid Email'.tr
          : 'حساب غير صحيح';
    } else {
      return null;
    }
  }

  static String? name(String? value, String invalid) {
    String pattern =
        r"^(?:[a-zA-Z\u0600-\u06FF]+(([',.-][a-zA-Z\u0600-\u06FF])?[a-zA-Z\u0600-\u06FF]*)*|(?!.*\d)[\p{L}\s'-]+)$";
    RegExp regex = RegExp(pattern, unicode: true);
    if (!regex.hasMatch(value!) || value.length <= 1) {
      return invalid;
    } else {
      return null;
    }
  }

 static String? isValidnumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Invalid Data Type';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Invalid Data Type';
    }
    return null; // Input is a valid number
  }

 static String? work(String? value, String invalid) {
    String pattern =
        r"^(?:[a-zA-Z\u0600-\u06FF]+(([',.-][a-zA-Z\u0600-\u06FF])?[a-zA-Z\u0600-\u06FF]*)*)|(?:[\p{L}\s'-]+)$";
    RegExp regex = RegExp(pattern, unicode: true);
    if (!regex.hasMatch(value!) || value.length <= 1) {
      return invalid;
    } else {
      return null;
    }
  }

  static String? date(String? value) {
    String pattern = r"(\d{4}-?\d\d-?\d\d)";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Invalid Date'.tr;
    } else {
      return null;
    }
  }

static  String? isDateValid(String dateString) {
    try {
      // Split the dateString by '/'
      List<String> parts = dateString.split('/');
      if (parts.length != 3) {
        return 'Invalid Date'.tr; // Date format should be "dd/MM/yyyy"
      }

      // Parse parts into integers
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      // Check if the parsed values represent a valid date
      if (day < 1 || day > 31 || month < 1 || month > 12) {
        return 'Invalid Date'.tr;
      }
      // Handle leap years
      bool isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      if (month == 2) {
        if (isLeapYear) {
          if (day > 29) return 'Invalid Date'.tr;
        } else {
          if (day > 28) return 'Invalid Date'.tr;
        }
      }

      // Check for months with 30 days
      if ([4, 6, 9, 11].contains(month)) {
        if (day > 30) return 'Invalid Date'.tr;
      }

      return null;
    } catch (e) {
      return 'Invalid Date'.tr;
    }
  }

  static String? number(String? value) {
    String pattern0 = r'^\D?(\d{3})\D?\D?(\d{5})\D?(\d{4})$';
    String pattern1 = r'^\D?(\d{3})\D?\D?(\d{5})\D?(\d{3})$';
    RegExp regex0 = RegExp(pattern0);
    RegExp regex1 = RegExp(pattern1);
    if (!regex0.hasMatch(value!) && !regex1.hasMatch(value)) {
      return 'Invalid Phone Number'.tr;
    } else {
      return null;
    }
  }

 static String? validateTaxNumber(String? value) {
    String pattern = r'^\d{9,14}$'; // Allowing numbers from 9 to 14 digits
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(value!)) {
      return 'Invalid Tax Number';
    } else {
      return null;
    }
  }

 static String? zip(String? value) {
    String pattern = r'^\d{4,14}$'; // Allowing numbers from 9 to 14 digits
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(value!)) {
      return 'Invalid Zip Code';
    } else {
      return null;
    }
  }

 static String? http(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else {
      if (!Uri.parse(value).isAbsolute) {
        return 'Invalid URL';
      }
      return null;
    }
  }

  ///validator link
 static String? isCorrectWebsiteLink(String websiteName, String link) {
    if (link == "") {
      return null;
    }
    bool isLink = isValidLink(link.trim());
    if (!isLink) {
      return "Invalid URL";
    }
    //String modelLink="https://www.$websiteName.com";
    bool correctWebsiteLink = link.contains(websiteName);
    String returnedMessage = "This link is not ${capitalize(websiteName)} link";
    if (!correctWebsiteLink) {
      return returnedMessage;
    }

    return null;
  }

 static bool isValidLink(String link) {
    bool isLink = true;
    final urlRegex = RegExp(
        r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$');
    isLink = urlRegex.hasMatch(link);
    return isLink;
  }

 static String? zipCode(String? value) {
    String pattern = r"^\d{5}$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Invalid Postal Code'.tr;
    } else {
      return null;
    }
  }

 static String? text(String? value, String invalid) {
    String pattern = r"^[a-zA-Z0-9\s.,#-]+$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!) || value.length <= 1) {
      return invalid;
    } else {
      return null;
    }
  }

static  String? insurancePolicyNumber(String? value, String invalidMessage) {
    String pattern = r"^[a-zA-Z0-9]+$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!) || value.length <= 1) {
      return invalidMessage;
    } else {
      return null;
    }
  }

 static String? gpa(String? value) {
    if (value == null || value.isEmpty) {
      return Get.locale.toString().contains('en')
          ? 'GPA Cannot Be Empty'
          : "لا يمكن أن يكون المعدل التراكمي فارغًا";
    }

    double gpaValue;
    try {
      gpaValue = double.parse(value);
    } catch (e) {
      return Get.locale.toString().contains('en')
          ? 'Invalid GPA Format'
          : "تنسيق المعدل التراكمي غير صالح";
    }

    if (gpaValue < 0.0 || gpaValue > 4.0) {
      return Get.locale.toString().contains('en')
          ? 'GPA Must Be Between 0.0 and 4.0'
          : "يجب أن يتراوح المعدل التراكمي بين 0.0 و4.0";
    }

    return null;
  }

 static String? nationalId(String? value) {
    String pattern = r'^\d{14}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return Get.locale.toString().contains('en')
          ? 'National ID Must Be Exactly 14 Numeric Digits'
          : "يجب أن يتكون الرقم القومي من 14 رقمًا بالضبط";
    } else {
      return null;
    }
  }

 static String? passportNumber(String? value) {
    String pattern = r'^[a-zA-Z0-9]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return Get.locale.toString().contains('en')
          ? 'Passport Number Can Contain Numbers and Characters'
          : "يمكن أن يحتوي رقم جواز السفر على أرقام وأحرف";
    } else {
      return null;
    }
  }

 static String? gender(String? value) {
    String pattern = r'^(male|female|other)$';
    RegExp regex = RegExp(pattern, caseSensitive: false);
    if (!regex.hasMatch(value!)) {
      return Get.locale.toString().contains('en')
          ? 'Invalid Gender'
          : "جنس غير صالح";
    } else {
      return null;
    }
  }

  static String? countryName(String? value) {
    String pattern = r'^[a-zA-Z\s]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return Get.locale.toString().contains('en')
          ? 'Invalid Name'
          : "اسم غير صالح";
    } else {
      return null;
    }
  }

  static String? postalCode(String? value) {
    String pattern = r'^\d{5}(?:[-\s]?\d{4})?$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return Get.locale.toString().contains('en')
          ? 'Invalid Postal Code'
          : "الرمز البريدي غير صالح";
    } else {
      return null;
    }
  }

  static String? maritalStatus(String? value) {
    String pattern = r'^(single|married|divorced|widowed)$';
    RegExp regex = RegExp(pattern, caseSensitive: false);
    if (!regex.hasMatch(value!)) {
      return Get.locale.toString().contains('en')
          ? 'Invalid Marital Status'
          : "حالة زواج غير صالحة";
    } else {
      return null;
    }
  }

  static String? relationship(String? value) {
    String pattern =
        r'^(brother|sister|father|mother|son|daughter|uncle|aunt|cousin|nephew|niece|grandfather|grandmother|grandson|granddaughter)$';
    RegExp regex = RegExp(pattern, caseSensitive: false);
    if (!regex.hasMatch(value!)) {
      return Get.locale.toString().contains('en')
          ? 'Invalid Relationship Name'
          : "اسم العلاقة غير صالح";
    } else {
      return null;
    }
  }

 static  String? validateSalary(String? value) {
    String pattern = r'^[0-9]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return Get.locale.toString().contains('en')
          ? 'Invalid Salary'
          : "الراتب غير صالح";
    } else {
      return null;
    }
  }

 static String? validateCurrencyCode(String? value) {
    String pattern = r'^[A-Z]{3}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return Get.locale.toString().contains('en')
          ? 'Invalid Currency Code'
          : "رمز العملة غير صالح";
    } else {
      return null;
    }
  }

  static String? validateWorkDays(String? value) {
    String pattern =
        r'^(saturday|sunday|monday|tuesday|wednesday|thursday|friday|SAT|SUN|MON|TUE|WED|THU|FRI)(,\s*(saturday|sunday|monday|tuesday|wednesday|thursday|friday|SAT|SUN|MON|TUE|WED|THU|FRI))*$';
    RegExp regex = RegExp(pattern, caseSensitive: false);
    if (!regex.hasMatch(value!)) {
      return Get.locale.toString().contains('en')
          ? 'Invalid Workdays'
          : "أيام العمل غير صالحة";
    } else {
      return null;
    }
  }

 static  String? validateTime(String? value) {
    String pattern = r'^(1[012]|[1-9]):[0-5][0-9]\s(AM|PM)$';
    RegExp regex = RegExp(pattern, caseSensitive: false);
    if (!regex.hasMatch(value!)) {
      return Get.locale.toString().contains('en')
          ? 'Invalid Time'
          : "وقت غير صالح";
    } else {
      return null;
    }
  }
}
