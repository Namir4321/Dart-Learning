import 'package:intl/intl.dart';

// This code demonstrates a simple user authentication model using the factory design pattern in Dart. It defines a UserList class to store user data, an abstract User class with a factory constructor for login, and two concrete classes (Admin and Student) that extend User. The main function tests the login functionality with valid and invalid credentials.
class UserList {
  // Repository of users with their email, password, and role
  List<Map<String, String>> _users = [
    {"email": "admin@mail.com", "pass": "123", "role": "admin"},
    {"email": "student@mail.com", "pass": "456", "role": "student"},
  ];

  Map<String, String>? searchUser(String email) {
    for (var user in _users) {
      if (user['email'] == '$email') {
        return user;
      }
    }
    return null;
  }
}

// abstract class user for solid foundation and which method can be override by admin and student class
abstract class User {
  final String email;
  final String password;
  User(this.email, this.password);

// factory constructor for login and which return admin or student class based on role
  factory User.login(String email, String password) {
    final userList = UserList();
    final userData = userList.searchUser(email);
    if (userData == null) {
      throw Exception("Error: User not found.");
    }

    // check password
    if (password != userData['pass']) {
      throw Exception("Error: Incorrect password.");
    }
    if (userData['role'] == "admin") {
      return Admin(email, password);
    } else {
      return Student(email, password);
    }
  }
  void printRole();
}

// admin class which extend user class and override printRole method
class Admin extends User {
  Admin(String email, String password) : super(email, password);
  String loginTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
  @override
  void printRole() =>
      print('Login successful!\n' 'Welcome Admin \n' 'Login Time:$loginTime');
}

// student class which extend user class and override printRole method
class Student extends User {
  Student(String email, String password) : super(email, password);
  String loginTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
  @override
  void printRole() => print(
      'Login successful!\n' 'Welcome Student \n' 'Login Time:$loginTime');
}

void main() {
  try {
    // login with valid credentials
    // login with invalid credentials
    // login with non-existing user
    // the ui layer or reprentation layer will call the login method and based on the role it will print the role of user
    User user1 = User.login("admin@mail.com", "123");
    user1.printRole();
    User user2 = User.login("student@mail.com", "456");
    user2.printRole();
    User user3 = User.login("stud@mail.com", "456");
    user3.printRole();
    User user4 = User.login("student@mail.com", "wrongpassword");
    user4.printRole();
  } catch (e) {
    print(e);
  }
}
