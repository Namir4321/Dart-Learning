abstract class InterfacesA {
  void a();
}

abstract class InterfacesB {
  void b();
}

class AB implements InterfacesA, InterfacesB {
  @override
  void a() {}

  @override
  void b() {}
}

abstract class Base {
  void foo();
  void bar() => print('bar');
}

class Subclass implements Base {
  @override
  void foo() => print('foo');
}

// if we use the extends keyword, we can only extend one class, and we must override abstract methods, but we can choose to override concrete methods
// if we use the implements keyword, we can implement multiple classes, and we must override both abstract and concrete methods
// abstract methods are methods without a body
// concrete methods are methods with a body

// | keyword      | type     | abstract methods | concrete methods |
// |--------------|----------|------------------|------------------|
// | **extends**  | single   | must override    | can override     |
// |**implements**| multiple | must override    | must override    |
// |---------------------------------------------------------------|
// |           
//
//
//
//
//
//





//Object is the root of the Dart class hierarchy
// 
                // ┌──────────┐
                // │  Object  │
                // └────┬─────┘
        // ┌────────────┼────────────┬────────────┬────────────┐
        // │            │            │            │            │
   // ┌────▼────┐  ┌────▼─────┐  ┌────▼───┐  ┌────▼────┐  ┌────▼───-┐
   // │  Map    │  │ Iterable │  │  num   │  │ String  │  │  bool   │
  //  └─────────┘  └────┬─────┘  └────┬───┘  └─────────┘  └─────────┘
                    //  │             │
              //  ┌─────▼────┐   ┌────▼────┐
              //  │  List    │   │  int    │
              //  └──────────┘   └─────────┘
              //  ┌──────────┐   ┌─────────┐
              //  │  Set     │   │ double  │
              //  └──────────┘   └─────────┘
                                                    // |
