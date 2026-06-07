
class ConstantsMethods {
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
  static String capitalizeFirstCharAtCHoices(String input) {
  /*
  Input: "gff,fhff,"
  Output: "Gff,Fhff," 
  */
  
  // Split the input string by comma
  List<String> words = input.split(',');

  // Capitalize the first character of each word
  List<String> capitalizedWords = words.map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1);
    } else {
      return word;
    }
  }).toList();

  // Join the words back with commas, keeping the original commas
  return capitalizedWords.join(',');
}


static String lowercaseFirstCharAtChoice(String input) {
  /*
  Input: "Gff,Fhff,"
  Output: "gff,fhff," 
  */
  
  // Split the input string by comma
  List<String> words = input.split(',');

  // Lowercase the first character of each word
  List<String> lowercaseWords = words.map((word) {
    if (word.isNotEmpty) {
      return word[0].toLowerCase() + word.substring(1);
    } else {
      return word;
    }
  }).toList();

  // Join the words back with commas, keeping the original commas
  return lowercaseWords.join(',');
}

  static List<String?>? convertToLowercase(List<String?>? list) {
    /*
      Input: ["HELLO", "WORLD", null, "Dart"]
      Output: ["hello", "world", null, "dart"]
       */
    if (list != null) {
      return list.map((list) => list?.toLowerCase()).toList();
    }
    return null;
  }
}
