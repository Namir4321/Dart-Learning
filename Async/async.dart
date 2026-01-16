Future<String> fetchedUserOrder() => Future.delayed(
      Duration(seconds: 2),
      () => 'Cappuccino',
    );
Future<void> main() async {
  print('Program started');
  try {
    final order = await fetchedUserOrder();
    print(order);
    final order2 = await fetchedUserOrder();
    print(order2);
  } catch (e) {
    print(e);
  } finally {
    print('Done');
  }
}

// use await to wait untill a future completes
// use multiple awaits t run Future in sequence
// await isonly allowed inside async function
// use try/catch t handle exceptions
// async/await + try/catch is a great way of working with futures in dart

