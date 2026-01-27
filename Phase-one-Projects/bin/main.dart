// import 'dart:io';

// void main() {
//   do {
//     stdout.write("want to contine y/n");
//     if (stdin.readLineSync() == 'n') {
//       break;
//     } else {
//       stdout.write("enter the first number");
//       double num1 = double.parse(stdin.readLineSync()!);
//       stdout.write("enter the second number");
//       double num2 = double.parse(stdin.readLineSync()!);
//       stdout.write("enter the operator");
//       String operator = stdin.readLineSync()!;

//       double result = 0;

//       switch (operator) {
//         case '+':
//           result = num1 + num2;
//           break;
//         case '-':
//           result = num1 - num2;
//           break;
//         case '*':
//           result = num1 * num2;
//           break;
//         case '/':
//           result = num1 / num2;
//           break;
//         case '%':
//           result = num1 % num2;
//           break;
//         default:
//           stdout.write("invalid operator");
//           // continue;
//           break;
//       }
//       stdout.write("the result is $result");
//     }
//   } while (true);
// }

import 'dart:io';

void main() {
  bool choice = true;

  do {
    double result = 0;
    stdout.write("enter the first number ");
    double num1 = double.parse(stdin.readLineSync()!);
    stdout.write("enter the second number ");
    double num2 = double.parse(stdin.readLineSync()!);
    stdout.write("enter the operator ");
    String operator = stdin.readLineSync()!;
    switch (operator) {
      case '+':
        result = num1 + num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case '*':
        result = num1 * num2;
        break;
      case '/':
        result = num1 / num2;
        break;
      case '%':
        result = num1 % num2;
        break;
      default:
        stdout.write("invalid operator");
        // continue;
        break;
    }
    stdout.writeln(" the result is $result");
    stdout.write("want to cntinue ");
    choice = stdin.readLineSync()?.toLowerCase() == 'y';
  } while (choice);
}
