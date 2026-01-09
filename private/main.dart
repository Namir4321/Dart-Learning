import 'private-variable-and-methods.dart';

void main() {
  final bankAccount = Bank(0);
  bankAccount.deposit(100);
  print(bankAccount.balance);
}
