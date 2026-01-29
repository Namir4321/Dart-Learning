import 'dart:io';

void main() {
  bool choice = true;
  final contact = <String, int>{};

  while (choice) {
    stdout.write("Enter your choice:\n"
        "1. Add Contact\n"
        "2. View All Contact\n"
        "3. Search Contact\n"
        "4. Delete Contact\n"
        "5. Exit\n");
    int? type = int.tryParse(stdin.readLineSync()!);
    switch (type) {
      case 1:
        stdout.write("Enter the contact name you want to add ");
        String? name = (stdin.readLineSync() ?? "").trim();
        stdout.write("enter the number of the person ");
        String? rawtext = (stdin.readLineSync() ?? "").trim();
        int? number1 = int.tryParse(rawtext);

        if (name.isEmpty || number1 == null) {
          print("add the correct info");
        } else if (contact.containsValue(number1)) {
          print("This number is already assigned to someone else");
        } else {
          contact[name] = number1;
          print('contact added');
        }
        break;
      case 2:
        if (contact.isEmpty) {
          print("there is no contact");
        }
        contact.forEach((key, value) {
          print('$key,$value');
        });
        break;
      case 3:
        stdout.write("Enter the number you want to search ");
        String? search = stdin.readLineSync()!;
        final searchresult = Map.fromEntries(contact.entries.where((entry) =>
            entry.key == search || entry.value == int.tryParse(search)));
        if (contact.isEmpty) {
          print("there is no contact");
        } else if (searchresult == "") {
          print(searchresult);
        } else {
          print(searchresult);
        }
        break;
      case 4:
        stdout.write("Enter the number you want to delete");
        String? delnum = stdin.readLineSync();
        print(delnum);
        bool waitingForValidInput = true;
        while (waitingForValidInput) {
          stdout.write("Really want t delete y/n");
          String? delcn = stdin.readLineSync();
          if (delcn == 'y') {
            contact.removeWhere((key, value) =>
                key == delnum || value == int.tryParse(delnum!));
            print('contact deleted');
            waitingForValidInput = false;
          } else if (delcn == 'n') {
            print("Deletion cancelled.");
            waitingForValidInput = false;
          } else {
            print("enter valid input y/n");
            waitingForValidInput = true;
          }
        }
        break;
      case 5:
        choice = false;
        break;
      default:
        print("enter the correct choice");
    }
  }
}
