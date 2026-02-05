// import 'dart:io';

// class Account {
//   String name;
//   double balance;
//   String number;
//   String _pin;
//   Account(
//       {required this.name,
//       required this.balance,
//       required this.number,
//       required String pin})
//       : _pin = pin,
//         assert(pin == 4);

//   bool validatePin(String inputPin) {
//     return _pin == inputPin;
//   }

//   bool authorize() {
//     stdout.write("Enter your PIN to withdraw: ");
//     String enteredPin = stdin.readLineSync()!.toLowerCase();
//     if (validatePin(enteredPin)) {
//       return true;
//     } else {
//       print("❌ Incorrect PIN. Access Denied.");
//       return false;
//     }
//   }

//   void printAccount() {
//     print('${this.name}, ${this.balance}');
//   }
// }

// Account bankOpening() {
//   stdout.write("Enter the person name whose account is being opened ");
//   String name = stdin.readLineSync()!.toLowerCase();
//   stdout.write("Enter the amount you want to initialize account with ");
//   double? initbalance = double.parse(stdin.readLineSync() ?? "") ?? 0;
//   stdout.write("Enter the number you want your account to be associated with ");
//   String number = stdin.readLineSync()!.toLowerCase();
//   stdout.write("Create a 4-digit PIN: ");
//   String pin = stdin.readLineSync()!.toLowerCase();
//   return Account(name: name, balance: initbalance, number: number, pin: pin);
// }

// Account findAccount(List<Account> account) {
//   stdout.write("Enter the person name or mobile number ");
//   String input = (stdin.readLineSync() ?? "").toLowerCase();
//   try {
//     return account.firstWhere(
//         (s) => s.name.toLowerCase() == input || s.number.toString() == input);
//   } catch (err) {
//     throw Exception("No Account found matching '$input' ");
//   }
// }

// void bankDeposit(Account account) {
//   try {
//     if (!account.authorize()) return;
//     stdout.write("Enter the amount you want to deposit ");
//     double? amount = double.parse(stdin.readLineSync() ?? "") ?? 0;
//     if (amount > 0) {
//       account.balance += amount;
//       print("New balance for ${account.name}: ${account.balance}");
//     } else {
//       print("Add amount to deposit");
//     }
//   } catch (err) {
//     print("Account not found");
//   }
// }

// void bankWithDraw(Account account) {
//   try {
//     if (!account.authorize()) return;
//     stdout.write("Enter the amount you want to withdraw ");
//     double? amount = double.parse(stdin.readLineSync() ?? "") ?? 0;
//     if (amount <= 0) {
//       print("Please enter a valid amount greater than 0.");
//       return;
//     }
//     if (account.balance >= amount) {
//       account.balance -= amount;
//       print("Withdrawal successful! New balance: ${account.balance}");
//     } else {
//       print("Error: Not enough balance. Current balance: ${account.balance}");
//     }
//   } catch (err) {
//     print("Server Error");
//   }
// }

// void TransferAmount(Account SenderAccount, Account RecieverAccount) {
//   stdout.write("How much amount you want to transfer");
//   double? amount = double.tryParse(stdin.readLineSync() ?? "") ?? 0;
//   if (!SenderAccount.authorize()) return;
//   if (SenderAccount.balance >= amount) {
//     SenderAccount.balance -= amount;
//     RecieverAccount.balance += amount;
//     print("Transfer successful! New balance: ${SenderAccount.balance}");
//   } else {
//     print("You don't have enough balance");
//   }
// }

// void AccountDetails(Account account) {
//   if (!account.authorize()) return;
//   print('Account Holder: ${account.name}');
//   print('Current Balance: ${account.balance}');
// }

// void main() {
//   bool choice = true;
//   List<Account> account = [];
//   while (choice) {
//     stdout.write("Enter Your Choice \n"
//         "1. Create account\n"
//         "2. Deposit\n"
//         "3. Withdraw\n"
//         "4. Show balance \n"
//         "5. Transfer Amount \n"
//         "6. Exit\n");
//     int? selectchoice = int.tryParse(stdin.readLineSync() ?? "") ?? 2;
//     switch (selectchoice) {
//       case 1:
//         Account newAccount = bankOpening();
//         account.add(newAccount);
//         newAccount.printAccount();
//         break;
//       case 2:
//         Account searchAccount = findAccount(account);
//         bankDeposit(searchAccount);
//         break;
//       case 3:
//         Account withAccount = findAccount(account);
//         bankWithDraw(withAccount);
//         break;
//       case 4:
//         Account ShowBalance = findAccount(account);
//         AccountDetails(ShowBalance);
//         break;
//       case 5:
//         Account SenderAccount = findAccount(account);
//         Account RecieverAccount = findAccount(account);
//         TransferAmount(SenderAccount, RecieverAccount);
//         break;
//       case 6:
//         choice = false;
//         break;
//     }
//   }
// }

import 'dart:io';

class Account {
  final String name;
  final String number;
  final String _pin;
  double balance;

  Account({
    required this.name,
    required this.balance,
    required this.number,
    required String pin,
  }) : _pin = pin;

  bool isPinValid(String input) => _pin == input;

  void deposit(double amount) => balance += amount;

  bool withdraw(double amount) {
    if (amount > balance || amount <= 0) return false;
    balance -= amount;
    return true;
  }
}

// -----transfer balance-------
class BankService {
  void transfer(Account sender, Account reciever, double amount) {
    if (sender.withdraw(amount)) {
      reciever.deposit(amount);
      print("Transfer successful");
    } else {
      print("Transfer failed:Insufficient funds.");
    }
  }
}

// ------------console--------------
class BankApp {
  final List<Account> _account = [];
  final BankService _service = BankService();

  void start() {
    while (true) {
      print("\n ---mini bank system------");
      print(
          "1. Create | 2. Deposit | 3. Withdraw | 4. Balance | 5. Transfer | 6. Exit");
      stdout.write("Choice: ");
      String choice = stdin.readLineSync() ?? "";

      try {
        switch (choice) {
          case '1':
            _handleCreate();
            break;
          case '2': _handleDeposit(); break;
          case '3': _handleWithdraw(); break;
          case '4': _handleBalance(); break;
          case '5': _handleTransfer(); break;
          case '6':
            exit(0);
          default:
            print("Invalid choice.");
        }
      } catch (e) {
        print("Error: ${e.toString()}");
      }
    }
  }

  Account _findAccountPrompt(String label) {
    stdout.write("Enter $label Name or Number: ");
    String input = (stdin.readLineSync() ?? "").toLowerCase();
    return _account.firstWhere(
        (a) => a.name.toLowerCase() == input || a.number == input,
        orElse: () => throw Exception("Account '$input'not found"));
  }

  bool _authenticate(Account acc) {
    stdout.write("Enter PIN for ${acc.name}: ");
    String pin = stdin.readLineSync() ?? "";
    if (acc.isPinValid(pin)) return true;
    print("❌ Incorrect PIN.");
    return false;
  }

  void _handleCreate() {
    stdout.write("Name: ");
    String name = stdin.readLineSync()!;
    stdout.write("Intial Deposit: ");
    double balance = double.tryParse(stdin.readLineSync()!) ?? 0;
    stdout.write("Mobile Number: ");
    String number = stdin.readLineSync()!;
    stdout.write("Set 4-Digit PIN: ");
    String pin = stdin.readLineSync()!;
    _account
        .add(Account(name: name, balance: balance, number: number, pin: pin));
    print("Account created for $name. ");
  }

  void _handleDeposit() {
    Account acc = _findAccountPrompt("target");
    stdout.write("Amount to deposit: ");
    double amt = double.tryParse(stdin.readLineSync()!) ?? 0;
    acc.deposit(amt);
    print("✅ Deposited. New balance: ${acc.balance}");
  }

  void _handleWithdraw() {
    Account acc = _findAccountPrompt("your");
    if (!_authenticate(acc)) return;
    stdout.write("Amount to withdraw: ");
    double amt = double.tryParse(stdin.readLineSync()!) ?? 0;
    if (acc.withdraw(amt)) {
      print("✅ Withdrawn. New balance: ${acc.balance}");
    } else {
      print("❌ Withdrawal failed.");
    }
  }

  void _handleBalance() {
    Account acc = _findAccountPrompt("your");
    if (_authenticate(acc)) {
      print("👤 Owner: ${acc.name} | 💰 Balance: ${acc.balance}");
    }
  }

  void _handleTransfer() {
    print("--- Sender ---");
    Account sender = _findAccountPrompt("Sender");
    if (!_authenticate(sender)) return;

    print("--- Receiver ---");
    Account receiver = _findAccountPrompt("Receiver");

    stdout.write("Amount to transfer: ");
    double amt = double.tryParse(stdin.readLineSync()!) ?? 0;
    _service.transfer(sender, receiver, amt);
  }
}

void main() => BankApp().start();
