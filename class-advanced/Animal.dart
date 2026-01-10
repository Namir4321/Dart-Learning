class Animal {
  void sleep() => print("sleeping");
}

class Dog extends Animal {
  void bark() => print("bark");
}

// void cow()=>print("moo");
class Cow extends Animal {
  void moo() => print("moo");
}

void main() {
  final animal = Animal();
  animal.sleep();
  final dog = Dog();
  dog.bark();
  dog.sleep();
  final cow = Cow();
  cow.moo();
  cow.sleep();
}
// subclass is als knw as extended class or derived class
// superclass is also known as base class or parent class
// inheritance is a mechanism where a new class acquires the properties and behaviors of an existing class.
// In Dart, inheritance is implemented using the 'extends' keyword.
// In the example above, Dog and Cow are subclasses that inherit from the Animal superclass.
