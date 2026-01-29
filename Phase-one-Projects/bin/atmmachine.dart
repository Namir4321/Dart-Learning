import 'dart:io';

void main() {
  double balance = 100;
  bool choice = true;
  while (choice) {
    stdout.write("Enter your choice:\n"
        "1. Check balance\n"
        "2. Deposit\n"
        "3. Withdraw\n"
        "4. Exit\n");
    stdout.write("Enter your choice ");
    int? num1 = int.tryParse(stdin.readLineSync()!);
    switch (num1) {
      case 1:
        print('your balance is $balance');
        break;
      case 2:
        stdout.write("enter the amount you want to deposit ");
        double? num2 = double.tryParse(stdin.readLineSync()!);
        if (num2 == null) {
          print("please enter the correct number");
        } else {
          balance = balance + num2;
          print('your balance is $balance');
        }
        break;
      case 3:
        stdout.write("enter the amount you want to withdraw ");
        double? num3 = double.tryParse(stdin.readLineSync()!);
        if (num3 == null) {
          print("enter the correct number");
        } else if (num3 > balance) {
          print("you dont have enough balance");
        } else {
          balance -= num3;
          print("your new balance is $balance");
        }
        break;
      case 4:
        choice = false;
        break;
      case null:
        print("please enter the correct choice");
        break;
      default:
        print("please enter the correct choice");

        break;
    }
  }
}











// Use ternary only to choose between two VALUES, not to perform program logic.
// if we use tryparse then it can return the null value as well