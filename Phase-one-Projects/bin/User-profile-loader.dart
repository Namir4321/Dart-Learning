import 'dart:io';

void main() {
  List<Map<String, String?>> user = [
    {"name": "Ali", "email": null, "phone": "99999", "address": null},
    {
      "name": "Sara",
      "email": "sara@mail.com",
      "phone": null,
      "address": "Dubai"
    },
    {"name": null, "email": null, "phone": "12345", "address": null},
    {"name": null, "email": null, "phone": null, "address": null}
  ];
  bool choice = true;
  void validateProfile(Map<String, String?> user) {
    bool profileValid = true; 

    print("----- VALIDATION MODE -----");

    
    if (user['name'] == null) {
      print("❌ Name missing (REQUIRED)");
      profileValid = false;
    } else {
      print("✔ Name exists");
    }

    if (user['phone'] == null) {
      print("❌ Phone missing (REQUIRED)");
      profileValid = false;
    } else {
      print("✔ Phone exists");
    }

    // Optional fields
    if (user['email'] == null) {
      print("⚠ Email missing (optional)");
    } else {
      print("✔ Email exists");
    }

    if (user['address'] == null) {
      print("⚠ Address missing (optional)");
    } else {
      print("✔ Address exists");
    }

    // Final profile status
    if (profileValid) {
      print("\nProfile status: VALID");
      print("Action required: Accept profile");
    } else {
      print("\nProfile status: INVALID");
      print("Action required: Reject profile");
    }

    print("---------------------------\n");
  }

  while (choice) {
    stdout.write("Enter your choice\n"
        "1. Show Profile\n"
        "2. Validate profile\n"
        "3. Exit\n");
    int? select = int.tryParse(stdin.readLineSync()!);
    switch (select) {
      case 1:
        user.forEach((item) => print("name:${item['name'] ?? "Not provided"}\n"
            "email:${item['email'] ?? "Not Proided"}\n"
            "phone:${item['phone'] ?? "Not Proided"}\n"
            "address:${item['address'] ?? "Not Proided"}\n"));
        break;
      case 2:
        user.forEach(validateProfile);

        break;
      case 3:
        choice = false;
        break;
      default:
        "";
    }
    // break;
  }
}
