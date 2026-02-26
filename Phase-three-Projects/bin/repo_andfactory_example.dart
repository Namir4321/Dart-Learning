class MenuRepository {
  final Map<String, int> _menuItems = {
    'coffee': 5,
    'tea': 3,
  };

  int getPrice(String drinkName) {
    return _menuItems[drinkName.toLowerCase()] ?? 0;
  }
}

abstract class Drink {
  final String name;
  Drink(this.name);

  factory Drink.create(String name, int money) {
    final menuRepository = MenuRepository();
    int price = menuRepository.getPrice(name);

    if (price == null) {
      throw Exception("Error: $name is not on the menu.");
    }
    if (name.toLowerCase() == 'coffee') {
      return Coffee();
    } else {
      return Tea();
    }
  }
  void printDrink();
}

class Coffee extends Drink {
  Coffee() : super('Coffee');
  @override
  void printDrink() => print('You can have a Coffee');
}

class Tea extends Drink {
  Tea() : super('Tea');
  @override
  void printDrink() => print('You can have a Tea');
}

void main() {
  // MenuRepository menuRepository = MenuRepository();
  try {
    Drink d1 = Drink.create("coffee", 5);
    d1.printDrink();
    Drink d2 = Drink.create("tea", 3);
    d2.printDrink();
  } catch (e) {
    print(e);
  }
}
