class Animal {
  const Animal({required this.age});
  final int age;
  void sleep() => print("sleeping");
}

class Dog extends Animal {
 Dog({required int age}):super(age:age);
  void bark() => print("bark");
}

// void cow()=>print("moo");
class Cow extends Animal {
  Cow({required int age}):super(age:age);
  void moo() => print("moo");
}
class CleverDog extends Dog {
  CleverDog({required int age}):super(age:age);
  void catchBall() => print('catch');
}

void main() {
  final animal = Animal(age:10);
  animal.sleep();
  final dog = Dog(age:5);
  dog.bark();
  dog.sleep();
  final cow = Cow(age:7);
  cow.moo();
  cow.sleep();
  final cleverDog =CleverDog(age:10);
  cleverDog.catchBall();
  cleverDog.bark();
  cleverDog.sleep();
}
