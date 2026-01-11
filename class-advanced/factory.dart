import 'dart:math';

abstract class Shape {
  double get area;
  const Shape();
  factory Shape.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    switch (type) {
      case 'square':
        final side = json['side'];
        if (side is double) {
          return Square(side);
        }
        throw UnsupportedError('Invalid or missing side property');
      case 'circle':
        final radius = json['radius'];
        if (radius is double) {
          return Circle(radius);
        }
        throw UnsupportedError('invalid or missing radius property');
      default:
        throw UnimplementedError('Shape type $type is not supported');
    }
  }
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
  final shapeJson1 = {'type': 'square', 'side': 10.0};
  final shapeJson2 = {'type': 'circle', 'radius': 5.0};
  final shapeJson3 = {'type': 'triangle', 'radius': 5.0};


  final shape1 = Shape.fromJson(shapeJson1);
  final shape2 = Shape.fromJson(shapeJson2);
  final shape3 = Shape.fromJson(shapeJson3);


  printArea(shape1);
  printArea(shape2);
  printArea(shape3);

}


// IF A class desnt have a any cnstructrs, dart will genrate a default no-arg cnstructr for it.
// However, if you define any constructor, the default no-arg constructor is not generated automatically.
// In the case of abstract classes, since they cannot be instantiated directly, there is no need for a default constructor.
// Therefore, if you define a constructor in an abstract class, it is typically used by its subclasses when they call super() to invoke the constructor of the abstract class.
// In summary, abstract classes do not have default constructors because they are not meant to be instantiated directly. Any constructors defined in an abstract class are intended to be used by its subclasses.
  // Example of using the factory constructor to create Shape instances from JSON