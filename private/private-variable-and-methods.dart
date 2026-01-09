class Bank {
  Bank(this._balance);
  double _balance;
  double get balance => _balance;
  void deposit(double amount) {
    _balance += amount;
  }

  void withdraw(double amount) {
    if (_balance >= amount) {
      _balance -= amount;
    }
  }
}
