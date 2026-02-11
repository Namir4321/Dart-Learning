import 'dart:io';

class Book {
  final int id;
  final String title;
  final String author;
  int availableCopies;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.availableCopies,
  });

  bool get isAvaliable => availableCopies > 0;

  void display() {
    print(
        "ID: $id | Title: ${title} | Author: ${author} | Stock: $availableCopies");
  }
}

class Members {
  final int memberId;
  final String name;
  final List<Book> borrowedBooks = [];
  Members({required this.memberId, required this.name});

  void display() {
    String books = borrowedBooks.isEmpty
        ? "No book borrows"
        : borrowedBooks.map((b) => b.title).join(",");
    print("ID: $memberId | Name: ${name} | Borrowed: [$books]");
  }
}

class RegisterMember {
  final List<Members> _members = [];
  final List _history = [];

  void _registermember(Members p) => _members.add(p);
  void _registerhistory(String h) => _history.add(h);
  List<Members> get allMembers => List.unmodifiable(_members);
  List get allhistory => List.unmodifiable(_history);

  Members findById(int id) => _members.firstWhere(
        (m) => m.memberId == id,
        orElse: () => throw Exception("Member ID $id not found."),
      );
}

class InventoryManager {
  final List<Book> _books = [];

  void _addBook(Book b) => _books.add(b);
  List<Book> get allBooks => List.unmodifiable(_books);
  Book findById(int id) => _books.firstWhere(
        (b) => b.id == id,
        orElse: () => throw Exception("Book ID $id not found."),
      );
}

class Librarian {
  final InventoryManager inventory;
  final RegisterMember registry;

  Librarian({required this.inventory, required this.registry});

  void borrowedFlow(int mId, int bId) {
    final member = registry.findById(mId);

    if (member.borrowedBooks.length > 4) {
      throw Exception("Limit reached: ${member.name} already has 4 books.");
    }

    final book = inventory.findById(bId);

    if (!book.isAvaliable)
      throw Exception("No copies of '${book.title}' available.");
    book.availableCopies--;
    member.borrowedBooks.add(book);
    registry._registerhistory("${member.name} borrowed '${book.title}'");
    print("${member.name} borrowed '${book.title}'");
  }

  void returnFlow(int mId, bId) {
    final member = registry.findById(mId);
    final book = inventory.findById(bId);

    if (member.borrowedBooks.any((b) => b.id == bId)) {
      member.borrowedBooks.removeWhere((b) => b.id == bId);
      book.availableCopies++;
      registry._registerhistory("'${book.title}' returned by ${member.name}");
      print("'${book.title}' returned by ${member.name}");
    } else {
      throw Exception("${member.name} does not have this book!");
    }
  }
}

class LibraryApp {
  // Librarian _manager = Librarian();
  final Librarian librarian;
  LibraryApp(this.librarian);

  void start() {
    while (true) {
      try {
        print("1. Add book \n"
            "2. Register member \n"
            "3. Borrow book \n"
            "4. Return book \n"
            "5. View library \n"
            "6. View members \n"
            "7. View History \n"
            "8. Exit \n");
        stdout.write("choice :");
        String? choice = stdin.readLineSync()!;
        switch (choice) {
          case "1":
            _addBook();
            break;
          case "2":
            _addMember();
            break;
          case "3":
            _borrowBook();
            break;
          case "4":
            _uiReturn();
            break;
          case "5":
            _viewInventory();
            break;
          case "6":
            _viewMember();
            break;
          case "7":
            _libraryhistory();
            break;
          case "8":
            print(exit);
            break;
          default:
            print("you entered wrong choice");
        }
      } catch (err) {
        print(err);
      }
    }
  }

  void _addBook() {
    stdout.write("Enter the id of the book: ");
    int? id = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
    stdout.write("Enter the title of the book: ");
    String title = stdin.readLineSync()!;
    stdout.write("Enter the author of the book: ");
    String author = stdin.readLineSync()!;
    stdout.write("Enter the avaliableCopies of the book: ");
    int? availableCopies = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
    librarian.inventory._addBook(Book(
        id: id,
        title: title,
        author: author,
        availableCopies: availableCopies));
  }

  void SearchBookByAuthor() {
    stdout.write("Enter the author name to search book :");
    String search = stdin.readLineSync()!;
    var results = librarian.inventory.allBooks
        .where((b) => b.author.toLowerCase() == search.toLowerCase());

    if (results.isEmpty) {
    } else {
      for (var book in results) {
        book.display();
      }
    }
  }

  void _addMember() {
    stdout.write("Enter the id of the person :");
    int? memberId = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
    stdout.write("Enter your name :");
    String? name = stdin.readLineSync()!;
    librarian.registry._registermember(Members(memberId: memberId, name: name));
  }

  void _libraryhistory() {
    print("\n--- History ---");
    for (var h in librarian.registry.allhistory) {
      print(h);
    }
  }

  void _viewMember() {
    print("\n--- Members ---");
    for (var m in librarian.registry.allMembers) {
      m.display();
    }
    ;
  }

  void _viewInventory() {
    print("\n--- INVENTORY ---");
    for (var i in librarian.inventory.allBooks) {
      i.display();
    }
  }

  void _borrowBook() {
    stdout.write("Member ID: ");
    int mId = int.parse(stdin.readLineSync()!);
    stdout.write("Member ID: ");
    int bId = int.parse(stdin.readLineSync()!);
    librarian.borrowedFlow(mId, bId);
  }

  void _uiReturn() {
    stdout.write("Member ID: ");
    int mId = int.parse(stdin.readLineSync()!);
    stdout.write("Book ID: ");
    int bId = int.parse(stdin.readLineSync()!);
    librarian.returnFlow(mId, bId);
  }
}

void main() {
  final inv = InventoryManager();
  final reg = RegisterMember();
  final lib = Librarian(inventory: inv, registry: reg);
  LibraryApp(lib).start();
}
