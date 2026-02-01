import 'dart:io';

void main() {
  bool choice = true;

  double calculateTax(double price, double taxRate) {
    double tax = price * taxRate;
    final amount = price + tax;
    return amount;
  }

  String formattedName(String sendname) {
    String name = sendname.trim();
    if (name.isEmpty) return "Invalid name";
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  double applyDiscount(double priceone, double percent) {
    double rate = percent / 100;
    double discountcal = priceone * rate;
    return priceone - discountcal;
  }

  while (choice) {
    stdout.write("Enter your choice \n"
        "1. Calculat Tax\n"
        "2. Format Name\n"
        "3. Apply Discount \n"
        "4. Exit\n");
    int? select = int.tryParse(stdin.readLineSync()!);
    switch (select) {
      case 1:
        stdout.write("Enter the price ");
        double? price = double.tryParse(stdin.readLineSync()!);
        stdout.write("Enter the tax rate ");
        double? taxRate = double.tryParse(stdin.readLineSync()!);
        if (price != null && taxRate != null) {
          double calculatedtax = calculateTax(price, taxRate);
          print(calculatedtax);
        } else {
          print("Please enter the correct value");
        }
        break;
      case 2:
        stdout.write("Enter the Name ");
        String? sendname = stdin.readLineSync();
        if (sendname != null && sendname.isNotEmpty) {
          String FormattedNameDone = formattedName(sendname);
          print(FormattedNameDone);
        }
        break;
      case 3:
        stdout.write("Enter the price ");
        double? priceone = double.tryParse(stdin.readLineSync()!);
        stdout.write("Enter the discount rate ");
        double? percent = double.tryParse(stdin.readLineSync()!);
        if (priceone != null && percent != null) {
          double Discount = applyDiscount(priceone, percent);
          print(Discount);
        } else {
          print("enter the correct value");
        }
        break;
      case 4:
        choice = false;
        break;
    }
  }
}
