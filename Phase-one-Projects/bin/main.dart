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
        break;
    }
    stdout.writeln(" the result is $result");
    stdout.write("want to cntinue ");
    choice = stdin.readLineSync()?.toLowerCase() == 'y';
  } while (choice);
}
