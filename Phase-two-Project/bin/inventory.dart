import 'dart:io';

class Product {
  final String id;
  final String name;
  final double price;
  int stock;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.stock});

  void addStock(int updateStock) => stock += updateStock;

  bool removeStock(int updateStock) {
    if (updateStock > stock || updateStock <= 0) return false;
    stock -= updateStock;
    return true;
  }
}

class InventoryManager {
  final List<Product> _product = [];
  void addProduct(Product p) => _product.add(p);
  List<Product> getAll() => List.unmodifiable(_product);

  Product findById(String id) {
    return _product.firstWhere(
      (p) => p.id.toLowerCase() == id.toLowerCase(),
      orElse: () => throw Exception("Product with ID $id not found"),
    );
  }
}

class InventroyApp {
  final InventoryManager _manager = InventoryManager();
  void start() {
    print("Welcome to the Inventory System");
    while (true) {
      print(
          "1. Add product | 2. View inventory | 3. Add stock | 4. Search product | 5. Exit");
      stdout.write("Choice: ");
      String choice = stdin.readLineSync() ?? "";

      try {
        switch (choice) {
          case "1":
            _addProduct();
            break;
          case "2":
            _viewProducts();
            break;
          case "3":
            _updateStock();
            break;
          case "4":
            _searchProduct();
            break;
          case "5":
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
    stdout.write("Product Id: ");
    String id = stdin.readLineSync()!;
    stdout.write("Product Name: ");
    String name = stdin.readLineSync()!;
    stdout.write("Price of the Product Per Piece: ");
    double price = double.tryParse(stdin.readLineSync() ?? "") ?? 0;
    stdout.write("Enter the Stock: ");
    int stock = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
    _manager
        .addProduct(Product(id: id, name: name, price: price, stock: stock));
    print("Product Created $id $name $price $stock");
  }

  void _viewProducts() {
    if (_manager.getAll().isEmpty) return print("Inventory is empty");
    for (var p in _manager.getAll()) {
      print("${p.id} | ${p.name} | \$${p.price} | Stock: ${p.stock}");
    }
  }

  void _updateStock() {
    stdout.write("Enter Product ID: ");
    var prod = _manager.findById(stdin.readLineSync() ?? "");
    stdout.write("Amount (negative to remove): ");
    int amount = int.tryParse(stdin.readLineSync() ?? "0") ?? 0;

    if (amount >= 0) {
      prod.addStock(amount);
    } else {
      if (!prod.removeStock(amount.abs())) print("Insufficient stock!");
    }
    print("Updated Stock: ${prod.stock}");
  }

  void _searchProduct() {
    stdout.write("Enter Product ID: ");
    var prod = _manager.findById(stdin.readLineSync() ?? "");
    print("${prod.id} | ${prod.name} | \$${prod.price} | Stock: ${prod.stock}");
  }
}

void main() => InventroyApp().start();
