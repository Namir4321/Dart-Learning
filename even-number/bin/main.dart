import 'dart:io';

void main() {
  stdout.write("enter the number t check the even d dd ");
  int num1 = int.parse(stdin.readLineSync()!);

  if (num1 % 2 == 0) {
    stdout.write("its an even number");
  } else {
    stdout.write("its an dd number");
  }
}
