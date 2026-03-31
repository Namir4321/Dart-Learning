import 'dart:io';

class Character {
  String name;
  int health;
  Character(this.name, {this.health = 100});

  void showStatus() {
    print("$name -> Health :$health");
  }
}

mixin Attack on Character {
  void attack() {
    print("$name attack the enemy!");
  }
}
mixin Heal on Character {
  void heal() {
    health += 10;
    if (health > 100) {
      health = 100;
    }
    print("$name heals and restores health");
  }
}

mixin Defence on Character {
  void defend() {
    print("$name raise shield and perpare to defend");
  }
}

class Healer extends Character with Heal {
  Healer(String name) : super(name);
}

class Warrior extends Character with Attack,Defence {
  Warrior(String name) : super(name);
}

class Paladin extends Character with Attack, Heal,Defence {
  Paladin(String name) : super(name);
}

void main() {
  Warrior thor = Warrior("Thor");
  Healer luna = Healer("Luna");
  Paladin ares = Paladin("Ares");
 bool running = true;

  print("=== GAME CHARACTER SYSTEM ===");

  while (running) {
    print("\n------------------------------");
    print("1. Warrior Attack");
    print("2. Healer Heal");
    print("3. Paladin Attack");
    print("4. Paladin Heal");
    print("5. Paladin Defend");
    print("6. Show Status");
    print("7. Exit");
    print("------------------------------");

    stdout.write("Enter your choice: ");
    int? choice = int.tryParse(stdin.readLineSync() ?? "");

    switch (choice) {
      case 1:
        thor.attack();
        break;

      case 2:
        luna.heal();
        break;

      case 3:
        ares.attack();
        break;

      case 4:
        ares.heal();
        break;

      case 5:
        ares.defend();
        break;

      case 6:
        print("\n--- CHARACTER STATUS ---");
        thor.showStatus();
        luna.showStatus();
        ares.showStatus();
        print("------------------------");
        break;

      case 7:
        print("Exiting game...");
        running = false;
        break;

      default:
        print("Invalid choice. Try again.");
    }
  }
}
