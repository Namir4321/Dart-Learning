import 'dart:io';

import 'package:test/cart.dart';
import 'package:test/product.dart';






const allProduct = [
  Product(id: 1, name: 'apple', price: 1.60),
  Product(id: 2, name: 'bananas', price: 1.32),
  Product(id: 3, name: 'grapes', price: 1.86),
  Product(id: 4, name: 'mango', price: 2.60),
  Product(id: 5, name: 'coconut', price: 3.60),
  Product(id: 6, name: 'pineapple', price: 3.60),
  Product(id: 7, name: 'orange', price: 0.60),
];
void main() {
  final cart = Cart();
  while (true) {
    stdout.write(
        "\nWhat do you want to do? (v) View Items, (a) Add Item, (c) Checkout: ");
    final line = stdin.readLineSync();

    if (line == 'a') {
      final product = chooseProduct();
      if (product != null) {
        cart.addPrduct(product);
        print(cart);
      }
    } else if (line == 'v') {
      print(cart);
    } else if (line == 'c') {
      if (checkout(cart)) {
        break;
      }
    }
  }
}

Product? chooseProduct() {
  final productList =
      allProduct.map((product) => product.displayName).join('\n');

  stdout.write("Available products:\n$productList\nYour choice: ");
  final line = stdin.readLineSync();

  if (line == null) return null;

  for (final product in allProduct) {
    if (product.initial.toLowerCase() == line.toLowerCase()) {
      return product;
    }
  }

  print('Product not found');
  return null;
}

bool checkout(Cart cart) {
  if (cart.isEmpty) {
    print('cart is empty');
    return false;
  }
  final total = cart.total();
  print('Total :\$$total');
  stdout.write('Payment in cash');
  final line = stdin.readLineSync();
  if (line == null || line.isEmpty) {
    return false;
  }
  final paid = double.tryParse(line);
  if (paid == null) {
    return false;
  }
  if (paid >= total) {
    final change = paid - total;
    print('Change \$${change.toStringAsFixed(2)}');
    return true;
  } else {
    print('Not enough cash.');
    return false;
  }
}
