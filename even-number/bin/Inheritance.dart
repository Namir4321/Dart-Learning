class Parent {
  parent() {
    print("Parent class");
  }
}

class Daughter extends Parent {
  daughter() {
    print("daughter class");
  }
}

class Son extends Parent {
  son() {
    print('Son is called');
  }
}

void main() {
  Son obj = Son();
  obj.son();
  obj.parent();

  Daughter obj1 = Daughter();
  obj1.daughter();
  obj1.parent();
}
