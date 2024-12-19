import 'dart:io';

//letter grade
String letterGrade(double value) {
  if (value >= 80 && value <= 100)
    return "A+";
  else if (value >= 75 && value <= 79)
    return "A";
  else if (value >= 70 && value <= 74)
    return "A-";
  else if (value >= 65 && value <= 69)
    return "B+";
  else if (value >= 60 && value <= 64)
    return "B";
  else if (value >= 55 && value <= 59)
    return "B-";
  else if (value >= 50 && value <= 54)
    return "C+";
  else if (value >= 45 && value <= 49)
    return "C";
  else if (value >= 40 && value <= 44)
    return "D";
  else
    return "F";
}

//grade point
double gradePoint(double value) {
  if (value >= 80 && value <= 100)
    return 4.00;
  else if (value >= 75 && value <= 79)
    return 3.75;
  else if (value >= 70 && value <= 74)
    return 3.50;
  else if (value >= 65 && value <= 69)
    return 3.25;
  else if (value >= 60 && value <= 64)
    return 3.00;
  else if (value >= 55 && value <= 59)
    return 2.75;
  else if (value >= 50 && value <= 54)
    return 2.50;
  else if (value >= 45 && value <= 49)
    return 2.25;
  else if (value >= 40 && value <= 44)
    return 2.00;
  else
    return 0.0;
}

void main() {
  // Map to store subjects and their credit hours
  var credit = {
    'AI': 3.0,
    'AIL': 1.5,
    'OS': 3.0,
    'OSL': 1.5,
    'STP': 3.0,
    'MAD': 1.5,
    'COA': 3.0,
    'ISD': 3.0
  };

  var total_credit = 19.50; // total credit hours
  double totalGradePoints = 0.0;

  // Map to store marks for each subject
  var marks = {};

  //tracker if failed in any subject
  bool failed = false;

  //input section
  print("Please enter your obtained marks for the following subjects:");
  for (var subject in credit.keys) {
    while (true) {
      print("Marks for $subject: ");
      String? input = stdin.readLineSync();

      if (input != null && input.isNotEmpty) {
        try {
          double value = double.parse(input);

          if (value > 100) {
            print("Marks cannot be greater than 100. Please try again.");
            continue;
          }
          marks[subject] = value;

          // Check if student failed in any subject
          if (value < 40) {
            failed = true;
          }
          totalGradePoints += gradePoint(value) * credit[subject]!;
          break;
        } 
        catch (e) {
          print("Invalid input! Please enter a valid number.");
        }
      } 
      else {
        print("Input cannot be empty.");
      }
    }
  }

  // Calculate GPA
  double obtainedGPA = failed ? 0.0 : totalGradePoints / total_credit;

  // Output Section
  print("\nSubject\t\tTotal Marks\tLetter Grade\tGrade Point");
  for (var subject in credit.keys) {
    double subjectMarks = marks[subject];
    print(
        '$subject\t\t${subjectMarks.toStringAsFixed(2)}\t\t${letterGrade(subjectMarks)}\t\t${gradePoint(subjectMarks).toStringAsFixed(2)}');
  }
  print("\nObtained GPA: ${obtainedGPA.toStringAsFixed(2)}");
}
