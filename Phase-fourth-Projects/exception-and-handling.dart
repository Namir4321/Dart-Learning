class InvalidAmountException implements Exception {
  final double amount;
  InvalidAmountException(this.amount);
  @override
  String toString() => "❌ ₹$amount is invalid! Amount must be greater than 0.";
}

class InsufficentFundsException implements Exception {
  final double balance;
  final double amount;
  InsufficentFundsException(this.balance, this.amount);
  @override
  String toString() =>
      "❌ Cannot withdraw ₹$amount! Available balance is only ₹$balance.";
}

class BankAccount {
  final String ownerName;
  double balance;
  BankAccount(this.ownerName, this.balance);

  void checkBalance() {
    print("💰 $ownerName's Balance: ₹$balance");
  }

  void deposit(double amount) {
    if (amount <= 0) throw InvalidAmountException(amount);
    balance += amount;
    print("✅ ₹$amount deposited! New balance: ₹$balance");
  }

  void withdraw(double amount) {
    if (amount <= 0) throw InvalidAmountException(amount);
    if (amount > balance) {
      throw InsufficentFundsException(balance, amount);
    } else {
      balance -= amount;
      print("💸 ₹$amount withdrawn! New balance: ₹$balance");
    }
  }
}

void main() {
  BankAccount account = BankAccount("Bank", 100.0);
  print("🏦 Welcome, ${account.ownerName}!\n");
  print("--- Test 1: Deposit ₹500 ---");
  try {
    account.deposit(500);
  } on InvalidAmountException catch (e) {
    print(e);
  } finally {
    print("Done!\n");
  }

   print("--- Test 2: Withdraw ₹200 ---");
  try {
    account.withdraw(200);
  } on InvalidAmountException catch (e) {
    print(e);
  } on InsufficentFundsException catch (e) {
    print(e);
  } finally {
    print("Done!\n");
  }

  // Test 3 — Insufficient Funds
  print("--- Test 3: Withdraw ₹99999 ---");
  try {
    account.withdraw(99999);
  } on InvalidAmountException catch (e) {
    print(e);
  } on InsufficentFundsException catch (e,s) {
    print(e);
    print(s);
  } finally {
    print("Done!\n");
  }

  // Test 4 — Invalid Amount
  print("--- Test 4: Deposit ₹-100 ---");
  try {
    account.deposit(-100);
  } on InvalidAmountException catch (e) {
    print(e);
  } finally {
    print("Done!\n");
  }

  // Final Balance
  account.checkBalance();

}
