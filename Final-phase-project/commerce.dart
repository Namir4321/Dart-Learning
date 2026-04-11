import 'dart:convert';
import 'dart:io';

class User {
  String email;
  String password;
  final Cart cart;
  final bool isAdmin;

  User({
    required this.email,
    required this.password,
    this.isAdmin = false,
    Cart? cart,
  }) : cart = cart ?? Cart();
  User.fromJson(Map<String, dynamic> json)
    : email = json['email'] as String,
      password = json['password'] as String,
      isAdmin = json['isAdmin'] as bool,
      cart = Cart.fromJson(json['cart'] as Map<String, dynamic>);
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "isAdmin": isAdmin,
      "cart": cart.toJson(),
    };
  }
}

class Product {
  String id;
  String name;
  double price;
  int stock;
  String description;

  Product({
    required this.description,
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
  });

  Product.fromJson(Map<String, dynamic> json)
    : description = json["description"] as String,
      id = json["id"] as String,
      name = json["name"] as String,
      stock = json["stock"] as int,
      price = (json["price"] as num).toDouble();

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "stock": stock,
      "description": description,
    };
  }

  void updateStock(int quantity) {
    if (quantity > stock) {
      throw InsufficientStockException("don't have enough stock");
    }
    stock = stock - quantity;
  }
}

class CartItem {
  final Product product;

  int quantity;
  CartItem({required this.product, required this.quantity});

  CartItem.fromJson(Map<String, dynamic> json)
    : product = Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity = json['quantity'] as int;

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
  };
}

class Cart {
  final List<CartItem> items;
  Cart({List<CartItem>? items}) : items = items ?? [];
  Cart.fromJson(Map<String, dynamic> json)
    : items = (json['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList();

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
  };
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
}

class InvalidInputException implements Exception {
  final String message;
  InvalidInputException(this.message);
  @override
  String toString() => message;
}

class InsufficientStockException implements Exception {
  final String message;
  InsufficientStockException(this.message);
  @override
  String toString() => message;
}

class UserAlreadyExistsException implements Exception {
  final String message;
  UserAlreadyExistsException(this.message);
  String toString() => message;
}

class ProductAlreadyExistsException implements Exception {
  final String message;
  ProductAlreadyExistsException(this.message);
  String toString() => message;
}

class InvalidProductException implements Exception {
  final String message;
  InvalidProductException(this.message);
  String toString() => message;
}

class InvalidCredentialsException implements Exception {
  final String message;
  InvalidCredentialsException(this.message);
  @override
  String toString() => message;
}

class PaymentFailedException implements Exception {
  final String message;
  PaymentFailedException(this.message);
  @override
  String toString() => message;
}

class AuthService {
  List<User> _users = [];
  // User _users = [];
  User? _currentuser;
  // final Validator _valid = Validator();
  final DatabaseService _databaseService;
  final Validator _valid;
  User? get currentUser => _currentuser;
  AuthService(this._databaseService, this._valid) {
    _users = _databaseService.loadData(
      "users.json",
      (json) => User.fromJson(json),
    );
  }
  User login(String email, String password) {
    User validUser = _users.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () =>
          throw InvalidCredentialsException("User not found or wrong password"),
    );
    _currentuser = validUser;
    return validUser;
  }

  User register(String email, String password) {
    _valid.validateEmail(email);
    _valid.validatePassword(password);
    bool emailExisting = _users.any((user) => user.email == email);
    if (emailExisting) {
      throw UserAlreadyExistsException("Email Already registered");
    }
    User newUser = User(email: email, password: password);
    _users.add(newUser);
    _databaseService.saveData("users.json", _users, (user) => user.toJson());
    return newUser;
  }

  void logout() {
    _currentuser = null;
  }
}

class ProductService {
  List<Product> _product = [];
  final DatabaseService _databaseService;
  ProductService(this._databaseService) {
    _product = _databaseService.loadData(
      "products.json",
      (json) => Product.fromJson(json),
    );
  }
  List<Product> listProducts() {
    return _product;
  }

  bool productExists(String name) {
    return _product.any((p) => p.name == name);
  }

  void addProduct(Product product) {
    _product.add(product);
    _databaseService.saveData("products.json", _product, (p) => p.toJson());
  }

  void removeProduct(String id) {
    _product.removeWhere((p) => p.id == id);
    _databaseService.saveData("products.json", _product, (p) => p.toJson());
  }

  void updateProduct(
    String id, {
    String? name,
    double? price,
    String? description,
    int? stock,
  }) {
    Product product = findById(id);

    if (name != null) product.name = name;
    if (price != null) product.price = price;
    if (description != null) product.description = description;
    if (stock != null) product.stock = stock;

    _databaseService.saveData("products.json", _product, (p) => p.toJson());
  }

  Product findById(String id) {
    return _product.firstWhere(
      (prod) => prod.id == id,
      orElse: () => throw InvalidProductException(
        "there is no product associated with this id",
      ),
    );
  }

  void updateStock(String id, int quantity) {
    Product product = findById(id);
    product.updateStock(quantity);
    _databaseService.saveData(
      "products.json",
      _product,
      (product) => product.toJson(),
    );
  }
}

class OrderItem {
  final Product product;
  final int quantity;
  final double price;
  OrderItem({
    required this.product,
    required this.price,
    required this.quantity,
  });

  OrderItem.fromJson(Map<String, dynamic> json)
    : product = Product.fromJson(json['product'] as Map<String, dynamic>),
      price = json['price'] as double,
      quantity = json['quantity'] as int;
  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
    'price': price,
  };
}

enum OrderStatus { pending, completed }

class Order {
  final String id;
  final List<OrderItem> items;
  final double totalAmount;
  final String paymentMethod;
  final OrderStatus status;
  final DateTime timestamp;

  Order({
    required this.id,
    required this.items,
    required this.paymentMethod,
    required this.status,
    required this.timestamp,
    required this.totalAmount,
  });
  Order.fromJson(Map<String, dynamic> json)
    : items = (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      id = json['id'] as String,
      paymentMethod = json['paymentMethod'] as String,
      status = OrderStatus.values.byName(json['status']),
      timestamp = DateTime.parse(json['timestamp']),
      totalAmount = (json['totalAmount'] as num).toDouble();

  Map<String, dynamic> toJson() => {
    'id': id,
    'items': items.map((e) => e.toJson()).toList(),
    'totalAmount': totalAmount,
    'paymentMethod': paymentMethod,
    'status': status.name,
    'timestamp': timestamp.toIso8601String(),
  };
}

abstract class Payment {
  final double amount;
  Payment(this.amount);

  Future<bool> pay();
}

class UpiPayment extends Payment {
  final String upiId;
  final String pin;
  UpiPayment(double amount, this.pin, this.upiId) : super(amount);
  @override
  Future<bool> pay() async {
    await Future.delayed(Duration(seconds: 5));
    return true;
  }
}

class CardPayment extends Payment {
  final String cardNumber;
  final String cvv;
  CardPayment(double amount, this.cardNumber, this.cvv) : super(amount);
  @override
  Future<bool> pay() async {
    await Future.delayed(Duration(seconds: 5));
    return true;
  }
}

class DatabaseService {
  List<T> loadData<T>(
    String fileName,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    List<T> items = [];
    File file = File(fileName);
    if (!file.existsSync()) return [];
    String jsonString = file.readAsStringSync();
    List<dynamic> userMap = jsonDecode(jsonString);
    for (var v in userMap) {
      // items.add(T.fromJson(v as Map<String, dynamic>));
      items.add(fromJson(v as Map<String, dynamic>));
    }
    return items;
  }

  void saveData<T>(
    String fileName,
    List<T> items,
    Map<String, dynamic> Function(T) toJson,
  ) {
    List<Map<String, dynamic>> userMap = items
        .map((item) => toJson(item))
        .toList();

    String jsonString = jsonEncode(userMap);
    File(fileName).writeAsStringSync(jsonString);
  }
}

class CartService {
  final User _user;
  final DatabaseService _databaseService;
  CartService(this._user, this._databaseService);

  void addItems(Product product, int quantity) {
    CartItem? existing = _user.cart.items
        .where((item) => item.product.id == product.id)
        .firstOrNull;
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      if (product.stock >= quantity) {
        _user.cart.items.add(CartItem(product: product, quantity: quantity));
      }else{
        throw InsufficientStockException("Stock ${product.stock} but your quantity is $quantity ")
      }
    }
  }

  void removeItem(String productId) {
    _user.cart.items.removeWhere((item) => item.product.id == productId);
  }

  void updateQuantity(String productId, int newQuantity) {
    CartItem? existing = _user.cart.items
        .where((item) => item.product.id == productId)
        .firstOrNull;
    if (existing != null) {
      existing.quantity += newQuantity;
      if (existing.quantity <= 0) {
        removeItem(productId);
      }
    }
  }

  List<CartItem> viewCart() {
    return _user.cart.items;
  }

  double calculateTotal() {
    return _user.cart.items.fold(
      0.0,
      (total, item) => total + (item.product.price * item.quantity),
    );
  }

  void clearCart() {
    _user.cart.items.clear();
  }
}

class OrderService {
  final CartService _cartService;
  final ProductService _productService;
  final DatabaseService _databaseService;
  List<Order> _orders = [];

  OrderService(this._cartService, this._productService, this._databaseService) {
    _orders = _databaseService.loadData(
      "orders.json",
      (json) => Order.fromJson(json),
    );
  }

  Future<Order> checkout(User user, Payment payment) async {
    List<CartItem> items = _cartService.viewCart();
    double total = _cartService.calculateTotal();

    bool success = await payment.pay();
    if (!success) {
      throw PaymentFailedException("Payment failed.");
    }
    for (CartItem item in items) {
      _productService.updateStock(item.product.id, (item.quantity));
    }

    Order order = Order(
      id: "ORDS${DateTime.now().millisecondsSinceEpoch}",
      items: items
          .map(
            (e) => OrderItem(
              product: e.product,
              price: e.product.price,
              quantity: e.quantity,
            ),
          )
          .toList(),
      totalAmount: total,
      paymentMethod: payment.runtimeType.toString(),
      status: OrderStatus.completed,
      timestamp: DateTime.now(),
    );
    _cartService.clearCart();
    _orders.add(order);
    _databaseService.saveData(
      "orders.json",
      _orders,
      (orders) => orders.toJson(),
    );
    return order;
  }

  List<Order> getOrders() {
    return _orders;
  }
}

class AdminService {
  final ProductService _productService;
  final DatabaseService _databaseService;

  AdminService(this._databaseService, this._productService);

  void addProduct(Product product) {
    if (_productService.productExists(product.name)) {
      throw ProductAlreadyExistsException("Product Already present");
    }
    _productService.addProduct(product);
  }

  void removeProduct(String id) {
    _productService.removeProduct(id);
  }

  void updateProduct(
    String id, {
    String? name,
    double? price,
    String? description,
    int? stock,
  }) {
    _productService.updateProduct(
      id,
      name: name,
      price: price,
      description: description,
      stock: stock,
    );
  }
}

class ConsoleUI {
  void start() async {
    final db = DatabaseService();
    final validator = Validator();
    final authService = AuthService(db, validator);
    final productService = ProductService(db);

    await showWelcomeMenu(authService, productService, db);
  }
}

Future<void> handleLogin(
  AuthService authService,
  ProductService productService,
  DatabaseService db,
) async {
  try {
    stdout.write("Email: ");
    String email = stdin.readLineSync()!;
    stdout.write("Password: ");
    String password = stdin.readLineSync()!;
    User user = authService.login(email, password);
    if (user.isAdmin) {
      print("Login successful! Welcome Admin! ");
      AdminService adminService = AdminService(db, productService);
      await showAdminDashboard(adminService, productService, authService);
    } else {
      print("Login successful! Welcome ${user.email} ");
      CartService cartService = CartService(user, db);
      OrderService orderService = OrderService(cartService, productService, db);
      await showDashboard(
        user,
        cartService,
        productService,
        orderService,
        authService,
        db,
      );
    }
  } catch (e) {
    print(e);
  }
}

void handleRegister(AuthService authService) {
  try {
    stdout.write("Email: ");
    String email = stdin.readLineSync()!;
    stdout.write("Password: ");
    String password = stdin.readLineSync()!;
    User user = authService.register(email, password);
    print("Registration successful! Welcome ${user.email} please login.");
  } catch (e) {
    print(e);
  }
}

Future<void> showWelcomeMenu(
  AuthService authService,
  ProductService productService,
  DatabaseService db,
) async {
  while (true) {
    print("\n=== Welcome to MiniShop ===");
    print("1. Login");
    print("2. Register");
    print("3. Exit");
    print("Enter choice: ");

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        await handleLogin(authService, productService, db);
        break;
      case '2':
        handleRegister(authService);
        break;
      case '3':
        print("Goodbye!");
        exit(0);
      default:
        print("Invalid choice!");
    }
  }
}

Future<void> showDashboard(
  User user,
  CartService cartService,
  ProductService productService,
  OrderService orderService,
  AuthService authService,
  DatabaseService db,
) async {
  while (true) {
    print("\n=== Dashboard ===");
    print("1. Browse Products");
    print("2. View Cart");
    print("3. Checkout");
    print("4. View Orders");
    print("5. Logout");
    print("Enter Choice:  ");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        List<Product> products = productService.listProducts();
        for (var p in products) {
          print("ID: ${p.id} | ${p.name} | ₹${p.price} | Stock: ${p.stock}");
        }
        stdout.write("Enter product ID to add (or 0 to go back): ");
        String? id = stdin.readLineSync();
        if (id != '0') {
          stdout.write("Quantity: ");
          int qty = int.parse(stdin.readLineSync()!);

          cartService.addItems(productService.findById(id!), qty);
          print("Added to cart!");
        }
        break;
      case '2':
        List<CartItem> items = cartService.viewCart();
        for (var item in items) {
          print(
            "${item.product.name} x${item.quantity} | ₹${item.product.price * item.quantity}",
          );
        }
        print("Total: ₹${cartService.calculateTotal()}");
        break;
      case '3':
        if (cartService.viewCart().isEmpty) {
          print("Cart is empty!");
          break;
        }
        double total = cartService.calculateTotal();
        print("Total: ₹$total");
        print("Choose payment (upi/card): ");
        String? method = stdin.readLineSync();

        Payment payment;
        if (method == 'upi') {
          stdout.write("UPI ID: ");
          String upiId = stdin.readLineSync()!;
          stdout.write("PIN: ");
          String pin = stdin.readLineSync()!;
          payment = UpiPayment(total, pin, upiId);
        } else {
          stdout.write("Card Number: ");
          String cardNumber = stdin.readLineSync()!;
          stdout.write("CVV: ");
          String cvv = stdin.readLineSync()!;
          payment = CardPayment(total, cardNumber, cvv);
        }

        try {
          print("Processing payment...");
          Order order = await orderService.checkout(user, payment);
          print("Order placed! ID: ${order.id}");
        } catch (e) {
          print(e);
        }
        break;
      case '4':
        List<Order> orders = orderService.getOrders();
        for (var o in orders) {
          print("ID: ${o.id} | ₹${o.totalAmount} | ${o.status.name}");
        }
        break;
      case '5':
        authService.logout();
        return;
      case '6':
        print("Goodbye!");
        exit(0);
      default:
        print("Invalid choice!");
    }
  }
}

Future<void> showAdminDashboard(
  AdminService adminService,
  ProductService productService,
  AuthService authService,
) async {
  while (true) {
    print("\n=== Admin Dashboard ===");
    print("1. View All Products");
    print("2.  Add Product");
    print("3. Remove Product");
    print("4. Update Product");
    print("5. Logout");
    print("Enter Choice:  ");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        List<Product> products = productService.listProducts();
        for (var p in products) {
          print("ID: ${p.id} | ${p.name} | ₹${p.price} | Stock: ${p.stock}");
        }
        break;
      case '2':
        stdout.write("ID: ");
        String id = stdin.readLineSync()!;
        stdout.write("Name: ");
        String name = stdin.readLineSync()!;
        stdout.write("Price: ");
        double price = double.parse(stdin.readLineSync()!);
        stdout.write("Stock: ");
        int stock = int.parse(stdin.readLineSync()!);
        stdout.write("Description: ");
        String desc = stdin.readLineSync()!;
        try {
          adminService.addProduct(
            Product(
              id: id,
              name: name,
              price: price,
              stock: stock,
              description: desc,
            ),
          );
          print("Product added!");
        } catch (e) {
          print(e);
        }
        break;
      case '3':
        stdout.write("ID: ");
        String id = stdin.readLineSync()!;
        try {
          adminService.removeProduct(id);
          print("Product removed!");
        } catch (e) {
          print(e);
        }
        break;
      case '4':
        stdout.write("Product ID: ");
        String id = stdin.readLineSync()!;
        print("What to update? (name/price/stock/description): ");
        String? field = stdin.readLineSync();
        switch (field) {
          case 'price':
            stdout.write("New price: ");
            double price = double.parse(stdin.readLineSync()!);
            adminService.updateProduct(id, price: price);
            print("Price updated!");
            break;
          case 'description':
            stdout.write("New description: ");
            String description = stdin.readLineSync()!;
            adminService.updateProduct(id, description: description);
            print("Description updated!");
            break;
          case 'name':
            stdout.write("New name: ");
            String name = stdin.readLineSync()!;
            adminService.updateProduct(id, name: name);
            print("Description updated!");
            break;
          case 'stock':
            stdout.write("New stock: ");
            int stock = int.parse(stdin.readLineSync()!);
            adminService.updateProduct(id, stock: stock);
            print("Description updated!");
            break;
        }
        break;
      case '5':
        authService.logout();
        return;
    }
  }
}

void main() => ConsoleUI().start();
