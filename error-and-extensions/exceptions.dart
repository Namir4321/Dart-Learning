class Fraction {
  Fraction(this.numerator, this.denominator) {
    if (denominator == 0) {
      throw UnsupportedError("");
    }
  }
  final numerator;
  final denominator;

  double get value => numerator / denominator;
}

void testFraction() {
  try {
    final f = Fraction(3, 0);
    print(f);
  } on UnsupportedError catch (e) {
    print(e);
  } on Exception catch (e) {
    print(e);
  } finally {
    print('testFractin done');
  }
}

void main() {
  testFraction();
  print('done');
}
