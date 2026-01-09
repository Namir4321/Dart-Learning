class Temparature {
  Temparature.celsius(this.celsius);
  Temparature.farenheit(double farenheit) : celsius = (farenheit - 32) / 1.8;
  double celsius;
  double get farenheit => celsius * 1.8 + 32;
  set farenheit(double farenheit) => celsius = (farenheit - 32) / 1.8;
}

void main() {
  final temp1 = Temparature.celsius(25);
  final temp2 = Temparature.farenheit(90);
  print(temp1.celsius);
  print(temp2.farenheit);
  temp1.celsius = 30;
  print(temp1.farenheit);
  temp1.farenheit = 86;
  final temp = 30;
}
