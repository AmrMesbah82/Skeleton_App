List<String> initialData = [
    'Edit Message',
    'Delete Message' ,
    'Reactions' ,
    'Create message groups' ,
    "Export Chat as Excel" 
  ];
  List<String> initialData2 = [
    'Take Screenshot' ,
    'Know Who’s Online' ,
    'Know Last seen active' ,
    'Biometrics for login' ,
    "Lock the mobile / tablet out of geographical boundries" 
  ];
  List<String> initialData3 = [
    'Share Emails and Social Data (In Bio)' ,
    'Share Cellphones in social Data (In Bio)' ,
    'Share Social Information' ,
    'Bio' ,
    "Academic History" ,
    "Certificates" ,
    "Skills" ,
    "Hobbies" ,
    "Add Employees" ,
    "One By One" ,
    "Bulk Upload via Excel Sheet" ,
    "View and Search employee records" ,
  ];
   List<Function(bool)> messageControl(List<String> data) {
  return data.map((string) {
    switch (string) {
      case 'Edit Message':
        return (bool value) {
          print("Action for Edit Message with value: $value");
        };
      case 'Delete Message':
        return (bool value) {
          print("Action for Delete Message with value: $value");
        };
      case 'Reactions':
        return (bool value) {
          print("Action for Reactions with value: $value");
        };
      case 'Create message groups':
        return (bool value) {
          print("Action for Create message groups with value: $value");
        };
         case 'Export Chat as Excel':
        return (bool value) {
          print("Action for Export Chat as Excel with value: $value");
        };

      default:
        return (bool value) {
          print("");
        };
    }
  }).toList();
}
  
    List<Function(bool)> settingControl(List<String> data) {
  return data.map((string) {
    switch (string) {
      case 'Take Screenshot':
        return (bool value) {
          print("Action for Take Screenshot with value: $value");
        };
      case 'Know Who’s Online':
        return (bool value) {
          print("Action for Know Who’s Online with value: $value");
        };
      case 'Know Last seen active':
        return (bool value) {
          print("Action for Know Last seen active with value: $value");
        };
      case 'Biometrics for login':
        return (bool value) {
          print("Action for Biometrics for login with value: $value");
        };
         case 'Lock the mobile / tablet out of geographical boundries':
        return (bool value) {
          print("Action for Lock the mobile / tablet out of geographical boundries with value: $value");
        };

      default:
        return (bool value) {
          print("");
        };
    }
  }).toList();
}

List<Function(bool)> employeeControl(List<String> data) {
  return data.map((string) {
    switch (string) {
      case 'Share Emails and Social Data (In Bio)':
        return (bool value) {
          print("Action for Share Emails and Social Data (In Bio) with value: $value");
        };
      case 'Share Cellphones in social Data (In Bio)':
        return (bool value) {
          print("Action for Share Cellphones in social Data (In Bio) with value: $value");
        };
      case 'Share Social Information':
        return (bool value) {
          print("Action for Share Social Information with value: $value");
        };
      case 'Bio':
        return (bool value) {
          print("Action for Bio with value: $value");
        };
      case 'Academic History':
        return (bool value) {
          print("Action for Academic History with value: $value");
        };
      case 'Certificates':
        return (bool value) {
          print("Action for Certificates with value: $value");
        };
      case 'Skills':
        return (bool value) {
          print("Action for Skills with value: $value");
        };
      case 'Hobbies':
        return (bool value) {
          print("Action for Hobbies with value: $value");
        };
      case 'Add Employees':
        return (bool value) {
          print("Action for Add Employees with value: $value");
        };
      case 'One By One':
        return (bool value) {
          print("Action for One By One with value: $value");
        };
      case 'Bulk Upload via Excel Sheet':
        return (bool value) {
          print("Action for Bulk Upload via Excel Sheet with value: $value");
        };
      case 'View and Search employee records':
        return (bool value) {
          print("Action for View and Search employee records with value: $value");
        };
      default:
        return (bool value) {
          print("");
        };
    }
  }).toList();
}
