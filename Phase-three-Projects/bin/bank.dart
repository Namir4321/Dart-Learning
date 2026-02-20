// import 'dart:io';

// class Account {
//   final String name;
//   final int id;
//   double _balance;
//   Account({required this.name, required this.id, double balance = 0.0})
//       : _balance = (balance >= 0) ? balance : 0.0 {
//     if (balance < 0) {
//       print(
//           "Warning: Initial balance cannot be negative. Setting balance to 0.0");
//     }
//   }

//   void deposit(double amount) {
//     if (amount > 0) {
//       _balance += amount;
//     }
//   }

//   void withdraw(double amount) {
//     if (amount > 0 && amount <= _balance) {
//       _balance -= amount;
//     } else {
//       print("Not Enough balance");
//     }
//   }

//   double get currentBalance => _balance;
// }

// class Bank {
//   List<Account> _bank = [];
//   void _openaccount(Account c) => _bank.add(c);

//   Account findById(int id) => _bank.firstWhere(
//         (a) => a.id == id,
//         orElse: () => throw Exception("Account with  $id not found"),
//       );
// }

// class BankApp {
//   final Bank banker;
//   BankApp(this.banker);
//   void start() {
//     while (true) {
//       print("1.Create Account: \n"
//           "2.Deposit: \n"
//           "3.Withdraw: \n"
//           "4.Checkbalance: \n"
//           "5.Exit: \n");
//       stdout.write("choice: ");
//       String choice = stdin.readLineSync()!;
//       switch (choice) {
//         case "1":
//           _openAccount();
//           break;
//         case "2":
//           _deposit();
//           break;
//         case "3":
//           _withdraw();
//           break;
//         case "4":
//           checkbalance();
//           break;
//         case "5":
//           print(exit);
//           break;
//         default:
//           print("you entered wrong choice");
//       }
//     }
//   }

//   void _openAccount() {
//     stdout.write("Enter your name: ");
//     String name = stdin.readLineSync()!;
//     stdout.write("enter the inital balance to deposit: ");
//     double? inital = double.tryParse(stdin.readLineSync() ?? "") ?? 0;
//     stdout.write("enter the account id: ");
//     int? id = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
//     banker._openaccount(Account(name: name, balance: inital, id: id));
//   }

//   void _deposit() {
//     stdout.write("enter the account id: ");
//     int? id = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
//     Account acc = banker.findById(id);
//     stdout.write("enter the balance to deposit: ");
//     double? amount = double.tryParse(stdin.readLineSync() ?? "") ?? 0;
//     acc.deposit(amount);
//   }

//   void _withdraw() {
//     stdout.write("enter the account id: ");
//     int? id = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
//     Account acc = banker.findById(id);
//     stdout.write("enter the balance to withdraw: ");
//     double? amount = double.tryParse(stdin.readLineSync() ?? "") ?? 0;
//     acc.withdraw(amount);
//   }

//   void checkbalance() {
//     stdout.write("enter the account id: ");
//     int? id = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
//     Account acc = banker.findById(id);
//     print(acc.currentBalance);
//   }
// }

// void main() {
//   final acc = Bank();
//   BankApp(acc).start();
// }



import 'dart:io';

// --- 1. THE DATA LAYER (Abstract & Open/Closed) ---
abstract class Account {
  final String name;
  final int id;
  double _balance;

  Account({required this.name, required this.id, double balance = 0.0})
      : _balance = (balance >= 0) ? balance : 0.0;

  double get currentBalance => _balance;

  // Abstract methods: Every account MUST have these, but logic varies
  void deposit(double amount);
  void withdraw(double amount);
  String get accountType;
}

// Concrete implementation: Savings
class SavingsAccount extends Account {
  SavingsAccount({required String name, required int id, double balance = 0.0})
      : super(name: name, id: id, balance: balance);

  @override
  String get accountType => "Savings";

  @override
  void deposit(double amount) {
    if (amount > 0) _balance += amount;
  }

  @override
  void withdraw(double amount) {
    // Savings Rule: Must keep at least 100 in the bank
    if (amount > 0 && (_balance - amount) >= 100) {
      _balance -= amount;
    } else {
      print("Error: Savings must maintain a 100 minimum balance.");
    }
  }
}

// Concrete implementation: Checking
class CheckingAccount extends Account {
  CheckingAccount({required String name, required int id, double balance = 0.0})
      : super(name: name, id: id, balance: balance);

  @override
  String get accountType => "Checking";

  @override
  void deposit(double amount) {
    if (amount > 0) _balance += amount;
  }

  @override
  void withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance -= amount;
    } else {
      print("Error: Insufficient funds in Checking.");
    }
  }
}

// --- 2. THE LOGIC LAYER (Single Responsibility) ---
class Bank {
  final List<Account> _accounts = [];

  void addAccount(Account acc) {
    _accounts.add(acc);
    print("${acc.accountType} Account created for ${acc.name}");
  }

  Account findById(int id) {
    return _accounts.firstWhere(
      (a) => a.id == id,
      orElse: () => throw Exception("Account ID $id not found."),
    );
  }
}

// --- 3. THE UI LAYER (Coordination) ---
class BankApp {
  final Bank banker;
  BankApp(this.banker);

  void start() {
    while (true) {
      print("\n=== BANK MENU ===\n1. Open Account\n2. Deposit\n3. Withdraw\n4. Balance\n5. Exit");
      stdout.write("Choice: ");
      String? choice = stdin.readLineSync();

      try {
        switch (choice) {
          case "1": _handleOpenAccount(); break;
          case "2": _handleTransaction("deposit"); break;
          case "3": _handleTransaction("withdraw"); break;
          case "4": _handleBalance(); break;
          case "5": exit(0);
          default: print("Invalid Choice.");
        }
      } catch (e) {
        print("System Error: ${e.toString()}");
      }
    }
  }

  void _handleOpenAccount() {
    stdout.write("Name: ");
    String name = stdin.readLineSync()!;
    stdout.write("Initial Balance: ");
    double bal = double.tryParse(stdin.readLineSync() ?? "") ?? 0.0;
    stdout.write("ID: ");
    int id = int.tryParse(stdin.readLineSync() ?? "") ?? 0;

    print("Type: (1) Savings  (2) Checking");
    String type = stdin.readLineSync()!;

    if (type == "1") {
      banker.addAccount(SavingsAccount(name: name, id: id, balance: bal));
    } else {
      banker.addAccount(CheckingAccount(name: name, id: id, balance: bal));
    }
  }

  void _handleTransaction(String type) {
    stdout.write("Account ID: ");
    int id = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
    Account acc = banker.findById(id);

    stdout.write("Amount: ");
    double amt = double.tryParse(stdin.readLineSync() ?? "") ?? 0;

    if (type == "deposit") {
      acc.deposit(amt);
    } else {
      acc.withdraw(amt);
    }
  }

  void _handleBalance() {
    stdout.write("Account ID: ");
    int id = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
    Account acc = banker.findById(id);
    print("Balance for ${acc.name} (${acc.accountType}): ${acc.currentBalance}");
  }
}

void main() {
  final myBank = Bank();
  final app = BankApp(myBank);
  app.start();
}