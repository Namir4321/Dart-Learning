void main() {
  final Person1 = Person(name: 'Namir', age: 25, height: 5.11);
  Person1.PersonDetails();
}

class Person {
  Person({required this.name, required this.age, required this.height});
 final String name;
 final int age;  
 final double height;

  void PersonDetails() {
    print('Name:$name,Age:$age,Height:$height');
  }
} 
