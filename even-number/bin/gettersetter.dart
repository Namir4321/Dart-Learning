class A {
  var name;
  void set Cusset(String name) {
    this.name = name;
  }

  String get Cusset {
    return name;
  }
}

void main() {
  A obj = A();
  obj.Cusset = "Rahul";
  print(obj.Cusset);
}
