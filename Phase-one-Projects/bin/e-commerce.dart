import 'dart:io';

void main() {
  bool choice = true;
  final product = <String, Map<String, dynamic>>{};
  final cart = <String, int>{};
  while (choice) {
    stdout.write("Enter your choice:\n"
        "1. View Products\n"
        "2. Add Item to Inventory\n"
        "3. Add Item to Cart\n"
        "4. Update Item Quantity\n"
        "5. Remove Item from Cart\n"
        "6. View Cart\n"
        "7. Calculate Total\n"
        "8. Exit\n");
    stdout.write("Enter your choice ");
    int? num1 = int.tryParse(stdin.readLineSync()!);
    switch (num1) {
      case 1:
        if (product.isEmpty) {
          print("No products available.");
        }

        product.forEach((key, value) {
          print('$key,$value');
        });

        break;
      case 2:
        bool addtoinventory = true;
        while (addtoinventory) {
          stdout.write("Enter the product name");
          String add = (stdin.readLineSync() ?? "").trim().toLowerCase();
          stdout.write("Enter quantity: ");
          int quant = int.tryParse(stdin.readLineSync() ?? "") ?? 0;

          stdout.write("Enter price per unit: ");
          double price = double.tryParse(stdin.readLineSync() ?? "") ?? 0.0;

          product[add] = {
            'quantity': (product[add]?['quantity'] ?? 0) + quant,
            'price': price,
          };
          print("Added $quant units of $add at $price each.");
          stdout.write("Do you want to enter more product y/n");
          String? exit = stdin.readLineSync()!;
          if (exit == 'y') {
            addtoinventory = true;
          } else if (exit == 'n') {
            addtoinventory = false;
          } else {
            print("enter correct input");
          }
        }
        break;
      case 3:
        bool addtoinventory = true;
        while (addtoinventory) {
          stdout.write("Enter the product name you want to buy");
          String add = (stdin.readLineSync() ?? "").trim().toLowerCase();
          if (!product.containsKey(add)) {
            print("Product not found in inventory!");
            continue;
          }
          stdout.write("Enter the product quantity");
          int quant = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
          int currentStock = product[add]?['quantity'] ?? 0;
          if (quant > currentStock) {
            print("Insufficient quantity! We only have $currentStock left.");
          } else {
            cart[add] = (cart[add] ?? 0) + quant;
            product[add]?["quantity"] = currentStock - quant;
            print("Successfully bought $quant of $add.");
          }
          stdout.write("Do you want to buy more product y/n");
          String? exit = stdin.readLineSync()?.toLowerCase() ?? "n";
          if (exit == 'y') {
            addtoinventory = true;
          } else if (exit == 'n') {
            addtoinventory = false;
          } else {
            print("enter correct input");
          }
        }
        break;
      case 4:
        //  "4. Update Item Quantity\n"
        stdout.write(
            "enter the product name which you want to add more to the cart");
        String updatequant = (stdin.readLineSync() ?? "").trim().toLowerCase();
        if (!cart.containsKey(updatequant)) {
          print("there is no $updatequant in your cart");
        } else {
          stdout.write("enter the quantity you want more to add");
          int addquantcart = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
          int available = product[updatequant]?['quantity'] ?? 0;
          if (addquantcart > available) {
            print("Only $available left in stock.");
          } else {
            cart[updatequant] = (cart[updatequant] ?? 0) + addquantcart;
            product[updatequant]?['quantity'] = available - addquantcart;
          }
        }
        break;
      case 5:
        //      "5. Remove Item from Cart\n"
        stdout
            .write("enter the product name which you want to remove from cart");
        String updatcartequant =
            (stdin.readLineSync() ?? "").trim().toLowerCase();
        if (cart.containsKey(updatcartequant)) {
          int removedQty = cart[updatcartequant] ?? 0;
          product[updatcartequant]?['quantity'] =
              (product[updatcartequant]?['quantity'] ?? 0) + removedQty;
          cart.remove(updatcartequant);

          print("Successfully removed $updatcartequant from your cart.");
        } else {
          print("Could not find '$updatcartequant' in your cart.");
          print("Your current cart: ${cart.keys.join(', ')}");
        }
        break;
      case 6:
        if (cart.isEmpty) {
          print("Your cart is empty.");
        }

        cart.forEach((key, value) {
          print('$key,$value');
        });
        break;
      case 7:
        double total = 0.0;
        print("---final Bills Total---");
        cart.forEach((name, quant) {
          double price = product[name]?['price'] ?? 0.0;
          double finalprice = price * quant;
          total += finalprice;
        });
        print(total);
        cart.clear();
        break;
      case 8:
        choice = false;
        break;
    }
  }
}
