

enum CompanySize {
  fiveToTen,
  tenToHundred,
  hundredToFiveHundred,
  fiveHundredToThousand,
  thousandToFiveThousand,
  fiveThousandToTenThousand,
  tenThousandPlus,
}



extension CompanySizeExtension on CompanySize {
  String get getName {
    switch (this) {
      case CompanySize.fiveToTen:
        return '5 To 10';
      case CompanySize.tenToHundred:
        return '10 To 100';
      case CompanySize.hundredToFiveHundred:
        return '100 To 500';
      case CompanySize.fiveHundredToThousand:
        return '500 To 1000';
      case CompanySize.thousandToFiveThousand:
        return '1000 To 5000';
      case CompanySize.fiveThousandToTenThousand:
        return '5000 To 10000';
      case CompanySize.tenThousandPlus:
        return '10000+';
      default:
        throw ArgumentError('Invalid company size:');
    }
  }
}


