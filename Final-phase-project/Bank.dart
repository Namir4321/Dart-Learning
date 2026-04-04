import 'dart:io';
import 'dart:math';

class User {
  String email;
  String password;
  final Account account;
  User({required this.email, required this.password, required this.account});
}

class Account {
  double _balance = 100;
  final String _pin;
  final String id;

  Account({required this.id, required String pin}) : _pin = pin;

  String get pin => _pin;
  double get balance => _balance;
  void deposit(double amount) {
    _balance += amount;
  }

  void withdraw(double amount) {
    _balance -= amount;
  }
}

abstract class Payment {
  final double amount;
  Payment(this.amount);

  Future<void> pay();
}

class PaymentProcess {
  final Payment _payment;
  final BankService _service;
  PaymentProcess(this._payment, this._service);
  Future<void> processPayment(String pin, String recieverId) async {
    print("\n--- Processing Started ---");
    try {
      await _payment.pay();
      _service.transferAmount(pin, recieverId, _payment.amount);
      print("--- Processing Finished ---");
    } catch (e) {
      print(e);
    }
  }
}

class PaymentFactory {
  static Payment create(String type, double amount) {
    if (type == 'upi') return UpiPayment(amount);
    if (type == "card") return CardPayment(amount);
    throw PaymentFailedException("Invalid payment method");
  }
}

class UpiPayment extends Payment {
  UpiPayment(double amount) : super(amount);
  @override
  Future<void> pay() async {
    if (amount > 100000) {
      throw PaymentFailedException(
        "UPI limit exceeded. Maximum limit is ₹100000",
      );
    }
    await Future.delayed(Duration(seconds: 5));
    print("Payment of ₹$amount processed successfully");
  }
}

class CardPayment extends Payment {
  CardPayment(double amount) : super(amount);
  @override
  Future<void> pay() async {
    await Future.delayed(Duration(seconds: 5));
    print("Payment of ₹$amount processed successfully");
  }
}

class Validator {
  void validateEmail(String email) {
    String value = email.trim();
    if (!value.contains("@") || !value.contains(".")) {
      throw InvalidInputException('Invalid email format');
    }
  }

  void validatePassword(String password) {
    if (password.length < 6) {
      throw InvalidInputException('Password must be at least 6 characters');
    }
    if (!password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      throw InvalidInputException(
        'Password must have at least one special character',
      );
    }
  }

  void validatePin(String pin) {
    if (pin.length != 4 || !pin.contains(RegExp(r'^[0-9]+$'))) {
      throw InvalidInputException('Pin must be exactly 4 digits');
    }
  }
}

class UserAlreadyExistsException implements Exception {
  final String message;
  UserAlreadyExistsException(this.message);
  String toString() => message;
}

class InvalidCredentialsException implements Exception {
  final String message;
  InvalidCredentialsException(this.message);
  @override
  String toString() => message;
}

class InvalidInputException implements Exception {
  final String message;
  InvalidInputException(this.message);
  @override
  String toString() => message;
}

class InvalidAmountException implements Exception {
  final String message;
  InvalidAmountException(this.message);
  @override
  String toString() => message;
}

class InsufficientFundsException implements Exception {
  final String message;
  InsufficientFundsException(this.message);
  @override
  String toString() => message;
}

class PaymentFailedException implements Exception {
  final String message;
  PaymentFailedException(this.message);
  String toString() => message;
}

class AccountNotFoundException implements Exception {
  final String message;
  AccountNotFoundException(this.message);
  @override
  String toString() => message;
}

class AuthService {
  final List<User> _users = [];
  var random = Random();
  User? _currentUser;
  User? get currentUser => _currentUser;
  final Validator _valid = Validator();
  User register(String email, String password, String pin) {
    _valid.validateEmail(email);
    _valid.validatePassword(password);
    _valid.validatePin(pin);
    bool emailExists = _users.any((user) => user.email == email);
    if (emailExists) {
      throw UserAlreadyExistsException("Email Already registered");
    }
    String accountId =
        "${DateTime.now().millisecondsSinceEpoch}${random.nextInt(1000)}";
    Account newAccount = Account(id: accountId, pin: pin);
    User newUser = User(email: email, password: password, account: newAccount);
    _users.add(newUser);
    return newUser;
  }

  User login(String email, String password) {
    User validUser = _users.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () =>
          throw InvalidCredentialsException("User not found or wrong password"),
    );
    _currentUser = validUser;

    return validUser;
  }

  void logout() {
    _currentUser = null;
  }

  User findAccountById(String id) {
    return _users.firstWhere(
      (a) => a.account.id == id,
      orElse: () => throw AccountNotFoundException("Account $id not found"),
    );
  }
}

class BankService {
  final User _user;
  final AuthService _authService;
  BankService(this._user, this._authService);
  void deposit(double amount, String pin) {
    if (pin != _user.account.pin) {
      throw InvalidCredentialsException("Invalid pin");
    }
    if (amount <= 0) {
      throw InvalidAmountException("Enter a valid amount");
    }
    _user.account.deposit(amount);
  }

  void withdraw(double amount, String pin) {
    bool isvalid = _user.account.balance >= amount;
    if (pin != _user.account.pin) {
      throw InvalidCredentialsException("Invalid pin");
    }
    if (amount <= 0) {
      throw InvalidAmountException("Amount is not valid");
    } else if (!isvalid) {
      throw InsufficientFundsException("Insufficent Funds. Withdraw failed.");
    }
    _user.account.withdraw(amount);
  }

  double checkBalance(String pin) {
    if (pin != _user.account.pin) {
      throw InvalidCredentialsException("Invalid pin");
    }
    return _user.account.balance;
  }

  String getAccountNumber() {
    return _user.account.id;
  }

  void transferAmount(String pin, String id, double amount) {
    if (pin != _user.account.pin) {
      throw InvalidCredentialsException("Invalid pin");
    }
    if (amount <= 0) throw InvalidAmountException("Enter a valid amount");
    if (_user.account.balance < amount)
      throw InsufficientFundsException("Insufficient funds");
    User reciver = _authService.findAccountById(id);
    _user.account.withdraw(amount);
    reciver.account.deposit(amount);
  }
}

class BankUi {
  final AuthService _service = AuthService();
  BankService? _bankService;

  void start() async {
    while (true) {
      print("1. Login \n2. Register \n3. Exit");
      int choice = int.tryParse(stdin.readLineSync()!) ?? 0;
      try {
        switch (choice) {
          case 1:
           await _handleLogin();
            break;
          case 2:
            _handleRegister();
            break;
          case 3:
            exit(0);
          default:
            print("Invalid choice. Please try again.");
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _handleLogin() async {
    try {
      stdout.write("Email: ");
      String email = stdin.readLineSync()!;
      stdout.write("Password: ");
      String password = stdin.readLineSync()!;
      User user = _service.login(email, password);
      _bankService = BankService(user, _service);
      print(
        "Login successful! Welcome ${user.email} Acc no:${user.account.id}",
      );
      await _showDashboard();
    } catch (e) {
      print(e);
    }
  }

  void _handleRegister() {
    try {
      stdout.write("Email: ");
      String email = stdin.readLineSync()!;
      stdout.write("Password: ");
      String password = stdin.readLineSync()!;
      stdout.write("Pin: ");
      String pin = stdin.readLineSync()!;
      User user = _service.register(email, password, pin);
      print(
        "Registration successful! Welcome ${user.email} Acc no ${user.account.id}",
      );
    } catch (e) {
      print(e);
    }
  }

  void _handleDeposit() {
    stdout.write("Amount: ");
    double amount = double.tryParse(stdin.readLineSync()!) ?? 0;
    stdout.write("Pin: ");
    String pin = stdin.readLineSync()!;
    try {
      _bankService!.deposit(amount, pin);
      print(
        "Deposit successful! New balance: ${_bankService!.checkBalance(pin)}",
      );
    } catch (e) {
      print(e);
    }
  }

  void _handleWithdraw() {
    stdout.write("Amount: ");
    double amount = double.tryParse(stdin.readLineSync()!) ?? 0;
    stdout.write("Pin: ");
    String pin = stdin.readLineSync()!;
    try {
      _bankService!.withdraw(amount, pin);
      print(
        "Withdrawal successful! New balance: ${_bankService!.checkBalance(pin)}",
      );
    } catch (e) {
      print(e);
    }
  }

  void _handleCheckBalance() {
    stdout.write("Pin: ");
    String pin = stdin.readLineSync()!;
    try {
      print(
        "Balance: ${_bankService!.checkBalance(pin)} Acc no: ${_bankService!.getAccountNumber()}",
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _handleTransfer() async {
    try {
      stdout.write("Receiver Account Number: ");
      // .trim() removes accidental spaces at the start or end
      String id = stdin.readLineSync()!.trim();

      stdout.write("Method (upi/card): ");
      String method = stdin.readLineSync()!.trim().toLowerCase();

      stdout.write("Pin: ");
      String pin = stdin.readLineSync()!.trim();

      stdout.write("Amount: ");
      String amountInput = stdin.readLineSync()!.trim();
      double amount = double.tryParse(amountInput) ?? 0;

      if (id == _bankService!.getAccountNumber()) {
        print("Error: You cannot transfer money to your own account.");
        return;
      }

      Payment payment = PaymentFactory.create(method, amount);
      PaymentProcess process = PaymentProcess(payment, _bankService!);

      // Wait for the 5-second simulated delay in pay()
      await process.processPayment(pin, id);

      print("Transfer successful!");
    } catch (e) {
      // Printing 'e' specifically helps you see if it's an
      // AccountNotFoundException or a PaymentFailedException
      print("Error during transfer: $e");
    }
  }

  Future<void> _showDashboard() async {
    while (true) {
      print("1. Deposit \n2. Withdraw \n3. Balance \n4. Transfer \n5. Logout");
      String? input = stdin.readLineSync();
      int choice = int.tryParse(input ?? "") ?? 0;
      try {
        switch (choice) {
          case 1:
            _handleDeposit();
            break;
          case 2:
            _handleWithdraw();
            break;
          case 3:
            _handleCheckBalance();
            break;
          case 4:
            await _handleTransfer();
            break;
          case 5:
            _service.logout();
            _bankService = null;
            print("Logged out successfully");
            return;
          default:
            print("Invalid choice. Please try again.");
        }
      } catch (e) {
        print(e);
      }
    }
  }
}

void main()  => BankUi().start();
