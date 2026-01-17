Future<void> main() async {
  final stream = Stream.fromIterable([1, 2, 3]);
  // final value=await stream.first;
  // print(value);
  await stream.forEach((element) => print(element));
  final doubles =
      await stream.map((value) => value * 2).where((value) => value > 3);

  await doubles.forEach(print);
}
