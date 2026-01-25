class Addition {
  final int a = 1000;
  final int b = 2000;

  add(int a, int b) {
    print('${this.a}, ${this.b}');
  }
}

void main() {
  Addition obj = Addition();
  obj.add(5, 6);
}
// the this keyword is used fr the glabl refrence jus tlike
// in this example as i have passed the value f a and b as well but 
// the value are cming frm the glbal scpe nt frm the argument 
// which i have passed in vid main