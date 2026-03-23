import 'dart:io';

extension StringExtension on String {
  String capitalize() {
    String value = trim();
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }
}

extension EmailExtension on String {
  bool get Validate {
    String value = trim();
    if (!value.contains("@") || !value.contains(".")) return false;
    return true;
  }
}

extension NumberToPrice on String {
  String Formated() {
    String value = trim();
    if (value.isEmpty) return "₹0.00";
    String cleanNumber = value.replaceAll(RegExp(r'[^0-9.]'), '');
    String formatted = cleanNumber.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ",",
    );
    return "₹$formatted";
  }
}

void main() {
  bool isRunning = true;

  print("=== SMART UTILITY TOOLKIT ===");

  while (isRunning) {
    print("\n------------------------------");
    print("1. Capitalize Name");
    print("2. Validate Email");
    print("3. Format Currency");
    print("4. Exit");
    print("------------------------------");

    stdout.write("Enter choice: ");
    String? input = stdin.readLineSync();
    switch (input) {
      case '1':
        stdout.write("Enter name: ");
        String name = stdin.readLineSync() ?? "";
        print("Formatted Name: ${name.capitalize()}");
        break;

      case '2':
        stdout.write("Enter email: ");
        String email = stdin.readLineSync() ?? "";
        if (email.Validate) {
          print("Valid Email ✅");
        } else {
          print("Invalid Email ❌");
        }
        break;

      case '3':
        stdout.write("Enter amount: ");
        String amount = stdin.readLineSync() ?? "";
        print("Formatted: ${amount.Formated()}");
        break;

      case '4':
        print("Exiting toolkit...");
        isRunning = false;
        break;

      default:
        print("Invalid choice. Please try again.");
    }
  }
}
