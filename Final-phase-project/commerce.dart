import 'dart:convert';
import 'dart:io';

class User {
  String email;
  String password;
  final Cart cart;
  User({required this.email, required this.password, Cart? cart})
    : cart = cart ?? Cart();
  User.fromJson(Map<String, dynamic> json)
    : email = json['email'] as String,
      password = json['password'] as String,
      cart = Cart.fromJson(json['cart'] as Map<String, dynamic>);
  Map<String, dynamic> toJson() {
    return {"email": email, "password": password, "cart": cart.toJson()};
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

class AuthService {
  List<User> _users = [];
  // User _users = [];
  User? _currentuser;
  // final Validator _valid = Validator();
  final DatabaseService _databaseService;
  final Validator _valid;
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
