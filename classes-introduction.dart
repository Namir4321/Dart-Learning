void main() {
  final bankAccount = Bank(accountHolder: "Namir", balance: 100);
  print(bankAccount.accountHolder);
  print(bankAccount.balance);
  // print('Initial balance: ${bankAccount.balance}');
  // bankAccount.deposit(100);
  // print('Initial balance: ${bankAccount.balance}');
  // bankAccount.deposit(100);
  // print('Initial balance: ${bankAccount.balance}');
  // final success1 = bankAccount.withdraw(100);
  // print(success1);
  // print('Initial balance: ${bankAccount.balance}');
  // final success2 = bankAccount.withdraw(150);
  // print(success2);
  // print('Initial balance: ${bankAccount.balance}');
}

class Bank {
  Bank({required this.accountHolder, this.balance = 0});
  double balance = 0;
  final String accountHolder;
  void deposit(double amount) {
    balance += amount;
  }

  String withdraw(double amount) {
    if (balance >= amount) {
      balance -= amount;
      return '$amount withdrawn successfully.';
    } else {
      return 'insufficient funds.';
    }
  }
}
