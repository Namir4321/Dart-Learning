class User {
  String email;
  String password;
  String _pin;
  User({required this.email, required this.password, required String pin})
    : _pin = pin;
  String get pin => _pin;
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

  void validatePin(String pin) {
    if (pin.length != 4 || !pin.contains(RegExp(r'^[0-9]+$'))) {
      throw InvalidInputException('Pin must be exactly 4 digits');
    }
  }
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

class InvalidInputException implements Exception {
  final String message;
  InvalidInputException(this.message);
  @override
  String toString() => message;
}

class AuthService {
  final List<User> _users = [];
  User? _currentUser;
  User? get currentUser => _currentUser;
  final Validator _valid = Validator();
  User register(String email, String password, String pin) {
    _valid.validateEmail(email);
    _valid.validatePassword(password);
    _valid.validatePin(pin);
    bool emailExists = _users.any((user) => user.email == email);
    if (emailExists) {
      throw UserAlreadyExistsException("Email Already registered");
    }
    User newUser = User(email: email, password: password, pin: pin);
    _users.add(newUser);
    return newUser;
  }

  User login(String email, String password) {
    User validUser = _users.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () =>
          throw InvalidCredentialsException("User not found or wrong password"),
    );
    _currentUser = validUser;
    return validUser;
  }

  void logout() {
    _currentUser = null;
  }
}
