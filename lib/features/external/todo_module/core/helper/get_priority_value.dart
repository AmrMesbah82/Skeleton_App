///Date create :15/March/2025 By Mohamed Yaser
String getEnglishPriorityValue(String arabicValue) {
  switch (arabicValue) {
    case "منخفضة": // Arabic translation for "Low"
      return "Low";
    case "متوسطة": // Arabic translation for "Medium"
      return "Medium";
    case "عالية": // Arabic translation for "High"
      return "High";
    default:
      return "Medium"; // Default to "Low" if no match found
  }
}
