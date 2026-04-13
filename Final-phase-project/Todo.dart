import 'dart:convert';
import 'dart:io';

import 'Bank.dart';

class User {
  final String email;
  final String password;
  final List<Board> boards;
  User({required this.email, required this.password, required this.boards});

  User.fromJson(Map<String, dynamic> json)
    : email = json["email"] as String,
      password = json["password"] as String,
      boards = (json['boards'] as List)
          .map((b) => Board.fromJson(b as Map<String, dynamic>))
          .toList();
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "boards": boards.map((b) => b.toJson()).toList(),
    };
  }
}

enum TaskStatus { TODO, IN_PROGRESS, DONE }

enum TaskPriority { LOW, MEDIUM, HIGH }

class Board {
  final String boardId;
  final String name;
  final List<Task> tasks;

  Board({required this.boardId, required this.name, required this.tasks});

  Board.fromJson(Map<String, dynamic> json)
    : boardId = json["boardId"] as String,
      name = json["name"] as String,
      tasks = (json['tasks'] as List)
          .map((t) => Task.fromJson(t as Map<String, dynamic>))
          .toList();

  Map<String, dynamic> toJson() {
    return {
      "boardId": boardId,
      "name": name,
      "tasks": tasks.map((t) => t.toJson()).toList(),
    };
  }
}

class Task {
  final String id;
  String title;
  String description;
  TaskStatus status;
  TaskPriority priority;
  DateTime due;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.due,
  });

  Task.fromJson(Map<String, dynamic> json)
    : id = json["id"] as String,
      title = json["title"] as String,
      description = json["description"] as String,
      status = TaskStatus.values.byName(json["status"]),
      priority = TaskPriority.values.byName(json["priority"]),
      due = DateTime.parse(json['due']);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "status": status.name,
      "priority": priority.name,
      "due": due.toIso8601String(),
    };
  }
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
  @override
  String toString() => message;
}

class InvalidCredentialsException implements Exception {
  final String message;
  InvalidCredentialsException(this.message);
  @override
  String toString() => message;
}

class InvalidBoardException implements Exception {
  final String message;
  InvalidBoardException(this.message);
  @override
  String toString() => message;
}

class CommonErrorException implements Exception {
  final String message;
  CommonErrorException(this.message);
  @override
  String toString() => message;
}

class InvalidTaskException implements Exception {
  final String message;
  InvalidTaskException(this.message);
  @override
  String toString() => message;
}

class AuthService {
  List<User> _users = [];
  User? _currentuser;
  final Validator _valid = Validator();

  User register(String email, String password) {
    _valid.validateEmail(email);
    _valid.validatePassword(password);
    bool existing = _users.any((user) => user.email == email);
    if (existing) {
      throw UserAlreadyExistsException("User already associated with us");
    }
    User user = User(email: email, password: password, boards: []);
    _users.add(user);
    return user;
  }

  User login(String email, String password) {
    User? existing = _users
        .where((user) => user.email == email && user.password == password)
        .firstOrNull;
    if (existing == null) {
      throw InvalidCredentialsException("Invalid email or password");
    }
    _currentuser = existing;
    return existing;
  }

  void logout() {
    if (_currentuser == null) throw Exception("No user is currently logged in");
    _currentuser = null;
  }
}

class BoardService {
  List<Board> _boards = [];
  Board createBoard(String name) {
    String boardId = (DateTime.now().microsecondsSinceEpoch % 1000000)
        .toString()
        .padLeft(6, '0');

    Board board = Board(boardId: boardId, name: name, tasks: []);
    _boards.add(board);
    return board;
  }

  Board updateBoard(String id, String name) {
    Board? existing = _boards.where((board) => board.boardId == id).firstOrNull;
    if (existing == null)
      throw InvalidBoardException("No board associated with this id");
    Board updated = Board(
      boardId: existing.boardId,
      name: name,
      tasks: existing.tasks,
    );
    int index = _boards.indexOf(existing);
    _boards[index] = updated;
    return updated;
  }

  void deleteBoard(String id) {
    Board? board = _boards.where((b) => b.boardId == id).firstOrNull;
    if (board == null) {
      throw InvalidBoardException("No board associated with this id");
    }
    _boards.remove(board);
  }

  List<Board> getBoards() {
    if (_boards.isEmpty) throw CommonErrorException("No boards found");
    return _boards;
  }

  Board getBoardById(String id) {
    Board? board = _boards.where((b) => b.boardId == id).firstOrNull;
    if (board == null)
      throw InvalidBoardException("No board associated with this id");
    return board;
  }
}

class TaskService {
  Task createTask(
    Board board,
    String title,
    String description,
    TaskStatus status,
    TaskPriority priority,
    DateTime due,
  ) {
    String taskId = (DateTime.now().microsecondsSinceEpoch % 1000000)
        .toString()
        .padLeft(6, '0');

    Task task = Task(
      id: taskId,
      title: title,
      description: description,
      status: status,
      priority: priority,
      due: due,
    );
    board.tasks.add(task);
    return task;
  }

  List<Task> getTasks(Board board) {
    if (board.tasks.isEmpty) throw CommonErrorException("No Task found");
    return board.tasks;
  }

  Task updateTask(
    Board board,
    String id, {
    String? title,
    String? description,
    DateTime? due,
  }) {
    Task? task = board.tasks.where((t) => t.id == id).firstOrNull;
    if (task == null)
      throw InvalidTaskException("Cannot find the task with this id");
    if (title != null) task.title = title;
    if (description != null) task.description = description;
    if (due != null) task.due = due;
    return task;
  }

  Task updateStatus(Board board, String id, TaskStatus status) {
    Task? task = board.tasks.where((t) => t.id == id).firstOrNull;
    if (task == null)
      throw InvalidTaskException("Cannot find the task with this id");
    task.status = status;
    return task;
  }

  Task updatePriority(Board board, String id, TaskPriority priority) {
    Task? task = board.tasks.where((t) => t.id == id).firstOrNull;
    if (task == null)
      throw InvalidTaskException("Cannot find the task with this id");
    task.priority = priority;
    return task;
  }

  void deleteTask(Board board, String id) {
    Task? task = board.tasks.where((t) => t.id == id).firstOrNull;
    if (task == null)
      throw InvalidTaskException("Cannot find the task with this id");
    board.tasks.remove(task);
  }

  List<Task> filterByStatus(Board board, TaskStatus status) {
    List<Task> task = board.tasks.where((t) => t.status == status).toList();
    if (task.isEmpty)
      throw InvalidTaskException("No tasks found with this status");
    return task;
  }

  List<Task> filterByPriority(Board board, TaskPriority priority) {
    List<Task> task = board.tasks.where((t) => t.priority == priority).toList();
    if (task.isEmpty)
      throw InvalidTaskException("No tasks found with this priority");
    return task;
  }

  List<Task> search(Board board, String keyword) {
    List<Task> task = board.tasks
        .where(
          (t) =>
              t.title.toLowerCase().contains(keyword.toLowerCase()) ||
              t.description.toLowerCase().contains(keyword.toLowerCase()),
        )
        .toList();
    if (task.isEmpty)
      throw InvalidTaskException("No tasks found with this keyword");
    return task;
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
