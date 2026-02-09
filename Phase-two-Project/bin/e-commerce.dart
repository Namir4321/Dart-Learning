import 'dart:io';

class Product {
  final String id;
  final String name;
  final double price;
  int stock;
  // final String _pin;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.stock});
  // : _pin = pin;

  void addStock(int updateStock) => stock += updateStock;
  // bool isPinValid(String pin) => _pin == pin;
  bool removeStock(int updateStock) {
    if (updateStock > stock || updateStock <= 0) return false;
    stock -= updateStock;
    return true;
  }
}

class Cart {
  final Product product;
  int quantity;

  Cart({required this.product, required this.quantity});
  double get subtotal => product.price * quantity;
}

class ShoppingCart {
  final List<Cart> _items = [];
  void addItems(Product product, int quantity) {
    for (var item in _items) {
      if (item.product.id == product.id) {
        item.quantity += quantity;
        return;
      }
    }
    _items.add(Cart(product: product, quantity: quantity));
  }

  int removeProductCompletely(String productId) {
    int quantitySaved = 0;

    for (var item in _items) {
      if (item.product.id == productId) {
        quantitySaved = item.quantity;
        break;
      }
    }
    _items.removeWhere((item) => item.product.id == productId);
    return quantitySaved;
  }

  double calculateTotal() {
    return _items.fold(0, (total, item) => total + item.subtotal);
  }

  void clear() => _items.clear();
}

class InventoryManager {
  final List<Product> _product = [];
  void addProduct(Product p) => _product.add(p);
  List<Product> getAll() => List.unmodifiable(_product);
  Product findById(String id) {
    return _product.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception("Product with Id $id not found"),
    );
  }
}

class Ecommerce {
  // final List<Product> _product = [];
  final InventoryManager _manager = InventoryManager();
  final ShoppingCart _salesman = ShoppingCart();
  void start() {
    print("Welcome to the Store");
    while (true) {
      print("1. Add item to inventory \n"
          "2. Remove item from inventory \n"
          "3. View Inventory \n"
          "4. Add item to cart \n"
          "5. Remove item from cart \n"
          "6. View Cart \n"
          "7. Checkout \n"
          "8. Exit \n");
      stdout.write("Choice: ");
      String choice = stdin.readLineSync() ?? "";

      try {
        switch (choice) {
          case "1":
            _addProduct();
            break;
          case "2":
            _updateStock();
            break;
          case "3":
            _viewInventory();
            break;
          case "4":
            _addToCart();
            break;
          case "5":
            _removeFromCart();
            break;
          case "6":
            _viewCart();
            break;
          case "7":
            _checkout();
            break;
          case "8":
            exit(0);
          default:
            print("Invalid choice");
        }
      } catch (err) {
        print("Error: ${err.toString()}");
      }
    }
  }

  void _addProduct() {
    stdout.write("Enter the product id ");
    String id = stdin.readLineSync() ?? "";
    stdout.write("Enter the product Name ");
    String name = stdin.readLineSync()!;
    stdout.write("Enter the product Stock ");
    int? stock = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
    stdout.write("Enter the product price ");
    double? price = double.tryParse(stdin.readLineSync() ?? "") ?? 0;
    _manager._product
        .add(Product(id: id, name: name, price: price, stock: stock));
  }

  void _updateStock() {
    stdout.write("Enter the Product ID: ");
    var prod = _manager.findById(stdin.readLineSync() ?? "");
    stdout.write("Amount (negative to remove): ");
    int amount = int.tryParse(stdin.readLineSync() ?? "0") ?? 0;
    if (amount > 0) {
      prod.addStock(amount);
    } else {
      prod.removeStock(amount);
    }
  }

  Product _searchProduct() {
    stdout.write("Enter the product id ");
    var prod = _manager.findById(stdin.readLineSync() ?? "");
    return prod;
  }

  void _viewInventory() {
    if (_manager.getAll().isEmpty) return print("Inventory is Empty");
    _manager._product.forEach((p) => print(
        " product id: ${p.id} | product name: ${p.name} | \$price: ${p.price} | Stock: ${p.stock}"));
  }

  void _addToCart() {
    try {
      // enter the product to buy
      Product prod = _searchProduct();
      stdout.write("Enter the Quantity of the Product ");
      int? quant = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
      // look if that items is in the inventory or not and its stocks as well
      if (prod.stock >= quant) {
        // if smaller than the stock add to cart
        // _salesman._items.add(Cart(product: prod, quantity: quant));
        _salesman.addItems(prod, quant);
        // decrease the stock form the inventory
        prod.removeStock(quant);
        print("Added $quant x ${prod.name} to cart.");
      } else {
        // if greater than stock then this
        print("Insufficient stock! Only ${prod.stock} available.");
      }
    } catch (err) {
      print("Error: Product not found.");
    }
  }

  void _removeFromCart() {
    try {
      // enter the product to buy
      Product prod = _searchProduct();
      print(prod);
      //  remove the product from shopping cart and add the quantity to the inventory back
      int removedQuantity = _salesman.removeProductCompletely(prod.id);
      if (removedQuantity > 0) {
        prod.addStock(removedQuantity);
        print(
            "Removed ${prod.name} from cart and returned $removedQuantity to stock.");
      } else {
        print("That product wasn't in your cart!");
      }
    } catch (err) {
      print("Error: Product not found.");
    }
  }

  void _viewCart() {
    if (_salesman._items.isEmpty) {
      print("Your cart is empty.");
      return;
    }
    print("--- Your Cart ---");
    for (var item in _salesman._items) {
      print(
          "${item.product.name} | Quantity: ${item.quantity} | Subtotal: \$${item.subtotal}");
    }
  }

  void _checkout() {
    final items = _salesman._items; // Accessing the private list

    if (items.isEmpty) {
      print("\n" + "!" * 30);
      print("CHECKOUT FAILED: Cart is empty.");
      print("!" * 30 + "\n");
      return;
    }

    print("\n" + "=" * 45);
    print("             OFFICIAL RECEIPT             ");
    print("=" * 45);

    // Header
    print(
        "${'Item'.padRight(20)} ${'Qty'.padRight(5)} ${'Price'.padRight(8)} ${'Total'}");
    print("-" * 45);

    // Item Rows
    for (var entry in items) {
      String name = entry.product.name;
      // Truncate name if it's too long for the receipt layout
      if (name.length > 18) name = name.substring(0, 15) + "...";

      print(name.padRight(20) +
          entry.quantity.toString().padRight(6) +
          "\$${entry.product.price.toStringAsFixed(2).padRight(7)} " +
          "\$${entry.subtotal.toStringAsFixed(2)}");
    }

    print("-" * 45);

    // Totals
    double total = _salesman.calculateTotal();
    print("${'GRAND TOTAL:'.padLeft(32)} \$${total.toStringAsFixed(2)}");

    print("=" * 45);
    print("      Thank you for shopping with us!      ");
    print("=" * 45 + "\n");

    // Optional: Clear the cart after checkout
    items.clear();
  }
}

void main() => Ecommerce().start();
