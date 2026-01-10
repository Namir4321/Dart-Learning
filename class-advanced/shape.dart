import 'dart:math';

abstract class Shape {
  double get area;
}

class Square extends Shape {
  Square(this.side);
  final double side;

  @override
  double get area => side * side;
}

class Circle extends Shape {
  Circle(this.radius);
  final double radius;

  @override
  double get area => pi * radius * radius;
}

void printArea(Shape shape) {
  print(shape.area);
}

void main() {
  // we can use Shape as a type even though we cannot instantiate it
  // we can use the subclasses that implement Shape
  final Shape square = Square(10);
  final Shape circle = Circle(5);
  printArea(square);
  printArea(circle);
}
