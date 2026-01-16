Future<String> fetchedUserOrder() => Future.delayed(
      Duration(seconds: 2),
      () => throw Exception('out of milk'),
    );
void main() {
  print('Program started');
  fetchedUserOrder()
      .then((order) => print("order is ready:$order"))
      .catchError((error) => print(error))
      .whenComplete(() => print('Done'));
}
