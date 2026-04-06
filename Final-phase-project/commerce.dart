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

class UserAlreadyExistsException implements Exception {
  final String message;
  UserAlreadyExistsException(this.message);
  String toString() => message;
}

class InvalidCredentialsException implements Exception {
  final String message;
  InvalidCredentialsException(this.message);
  @override
  String toString() => message;
}

class AuthService {
  final List<User> _users = [];
  User? _currentuser;
  final Validator _valid = Validator();
  AuthService() {
    _loadUser();
  }
  void _loadUser() {
    File file = File('users.json');
    if (!file.existsSync()) return;
    String jsonString = File('users.json').readAsStringSync();
    List<dynamic> userMap = jsonDecode(jsonString);

    for (var v in userMap) {
      _users.add(User.fromJson(v as Map<String, dynamic>));
    }
  }

  void _saveUser() {
    List<Map<String, dynamic>> userMap = _users
        .map((user) => user.toJson())
        .toList();
    String jsonString = jsonEncode(userMap);
    File('users.json').writeAsStringSync(jsonString);
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
    _saveUser();
    return newUser;
  }
}
