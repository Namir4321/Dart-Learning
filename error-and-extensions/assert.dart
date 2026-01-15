class PositiveInt {
  const PositiveInt(this.value) : assert(value >= 0, 'Value cannt be negative');
  final int value;
}

void signIn(String email, String password) {
  assert(email.isNotEmpty);
  assert(password.isNotEmpty);
}

void main() {
  const list = [1, 2, 3];
  print(list[4]);
  signIn("", "");
}
// Asseratin are enabled in debug mde
// assertins are disabled in realse mde
// assertins are nly a saftey net t catch runtime errr early
// exceptin are triggered in debug and relase mde
