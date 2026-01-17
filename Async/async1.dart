Future<String> fetchedUserOrder() => Future.delayed(
      Duration(seconds: 2),
      () => 'Cappuccino',
    );

Future<String> fetchedUserOrder2() => Future.value('Espresso');

Future<String> fetchedUserOrder3() => Future.error(UnimplementedError());
Future<void> main() async {
  print('Program started');
  try {
    final order = await fetchedUserOrder();
    print(order);
    final order2 = await fetchedUserOrder2();
    print(order2);
    final order3 = await fetchedUserOrder3();
    print(order3);
  } catch (e) {
    print(e);
  } finally {
    print('Done');
  }
}
