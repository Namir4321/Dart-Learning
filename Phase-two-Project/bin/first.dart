import 'dart:io';

class Student {
  String name;
  double? age;
  double? marks;

  Student({required this.name, required this.age, required this.marks});
  void printvalue() {
    print('${this.name},${this.age},${this.marks}');
  }
}

String? gradeforStudent(List<Student> students, String searchName) {
  String grade;
  for (var s in students) {
    if (s.name.toLowerCase() == searchName.toLowerCase()) {
      if (s.marks! >= 90) return "A";
      if (s.marks! >= 75) return "B";
      if (s.marks! >= 60) return "C";
      if (s.marks! >= 40) return "D";
      return "F";
    }
  }
  return null;
}

Student promptForStudent() {
  stdout.write("Enter the name of the student ");
  String? name = stdin.readLineSync()!;
  stdout.write("Enter the age of the Student ");
  double? age = double.tryParse(stdin.readLineSync()!);
  stdout.write("Enter the marks of the Students ");
  double? marks = double.tryParse(stdin.readLineSync() ?? '') ?? 0.0;

  return Student(name: name, age: age, marks: marks);
}

void main() {
  bool choice = true;
  List<Student> student = [];
  while (choice) {
    stdout.write("Enter Your Choice \n"
        "1. Add student\n"
        "2. View all students\n"
        "3. Check result\n"
        "4. Exit \n ");
    int? selectchoice = int.tryParse(stdin.readLineSync() ?? "") ?? 2;
    switch (selectchoice) {
      case 1:
        Student newStudent = promptForStudent();
        student.add(newStudent);
        newStudent.printvalue();
        break;
      case 2:
        if (student.isEmpty) {
          print("\n[!] No students found in the list.");
        } else {
          student.forEach((s) => s.printvalue());
        }
        break;
      case 3:
        stdout.write("enter the student name to search for");
        String searchName = stdin.readLineSync() ?? "";

        var found = student
            .where((s) => s.name.toLowerCase() == searchName.toLowerCase());
        if (found.isEmpty) {
          print("\n[!] No students found.");
        } else {
          print("\n--- Result Status ---");
          for (var s in student) {
            String status = (s.marks! >= 40) ? "PASS" : "FAIL";
            print('${s.name}: $status (${s.marks})');
          }
          print("\n-----------");
        }
        break;
      case 4:
        stdout.write("enter the student name to search for its grade");
        String searchName = stdin.readLineSync() ?? "";
        String? grade = gradeforStudent(student, searchName);
        if (grade == null) {
          print("Student not found");
        } else {
          print("Grade: $grade");
        }
        break;
      case 5:
        choice = false;
        break;
    }
  }
}
