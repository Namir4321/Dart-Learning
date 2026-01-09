const welcome = 'Welcome';
const signIn = 'Sign In';

class Strings {
  static const welcome = 'Welcome';
  static const signIn = 'Sign In';

  static String greet(String name) => 'Hi,$name';
  void foo() {
    print(welcome);
  }
}

void main() {
  print(Strings.welcome);
  print(Strings.signIn);
  print(Strings.greet('Namir'));
}
