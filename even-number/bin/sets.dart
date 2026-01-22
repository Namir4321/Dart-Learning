class Test {
  add() {
    Set items = {1, 2, 3, 4, 5};
    // items.add(6);
    // print(items.last);
    // print(items.first);
    // print(items.contains(6));
    // print(items.elementAt(2));
    // print(items.remove(3));
    Set items1 = {6, 7, 8, 9, 10};
    items.addAll(items1);
    print(items1);
  }
}

void main() {
  Test obj = Test();
  obj.add();
}
