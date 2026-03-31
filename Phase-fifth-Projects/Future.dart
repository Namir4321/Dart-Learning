import 'dart:io';

class PaymentProcessor {
  Future<void> process(Payment method) async {
    print("\n--- Processing Started ---");
    await method.pay();
    print("--- Processing Finished ---");
  }
}

class PaymentFailed implements Exception {
  final String message;
  PaymentFailed(this.message);
  @override
  String toString() => message;
}

abstract class Payment {
  //   final String source;
  final double amount;
  Payment(this.amount);
  Future<void> pay();

  factory Payment.method(int choice, double amount) {
    switch (choice) {
      case 1:
        return CreditCard(amount);
      case 2:
        return Upi(amount);
      default:
        throw PaymentFailed("Invalid Payment Method Selection");
    }
  }
}

class Upi implements Payment {
  final double amount;
  Upi(this.amount);

  @override
  Future<void> pay() async {
    print("Validating UPI ID...");
    await Future.delayed(Duration(seconds: 1));
    if (amount > 100000) {
      throw PaymentFailed("UPI limit exceeded! Please use Credit Card.");
    } else if (amount < 0) {
      throw PaymentFailed("Please enter a valid amount.");
    }
    print("Paying ₹$amount via UPI.");
  }
}

class CreditCard implements Payment {
  final double amount;
  CreditCard(this.amount);

  @override
  Future<void> pay() async {
    print("Connecting to Bank Server...");
    await Future.delayed(Duration(seconds: 1));
    print("Charged ₹$amount to Credit Card.");
  }
}

class PaymentUi {
  final PaymentProcessor processor;
  PaymentUi(this.processor);
  Future<void> start() async {
    print("\n=== WELCOME TO THE PAYMENT SYSTEM ===");

    while (true) {
      try {
        print("\n--- MENU ---");
        print("1. Credit Card | 2. UPI | 0. Exit");
        stdout.write("Enter choice: ");

        int choice = int.tryParse(stdin.readLineSync()!) ?? 0;
        if (choice == 0) {
          print("Exiting... Thank you!");
          break;
        }

        stdout.write("Enter amount: ");
        double amount = double.tryParse(stdin.readLineSync()!) ?? 0;

        // Factory creates it
        Payment result = Payment.method(choice, amount);

        // Processor runs it
        await processor.process(result);
      } on PaymentFailed catch (e) {
        print("⚠️ Transaction Failed: $e");
      } catch (e) {
        print("❌ System Error: $e");
      }
    }
  }
}

// 1. Add 'async' to main
void main() async {
  final processor = PaymentProcessor();
  final ui = PaymentUi(processor);

  await ui.start();
}
