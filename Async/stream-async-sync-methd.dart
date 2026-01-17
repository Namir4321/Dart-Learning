
// Future<int> sumStream2(Stream<int> stream) async {
//   var sum = 0;
//   await for (var value in stream) {
//     sum += value;
//   }
//   return sum;
// }


Future<int> sumStream2(Stream<int> stream) => stream.reduce((a, b) => a + b);
Stream<int> countStream(int n) async* {
  for (var i = 1; i <= n; i++) {
    yield i;
  }
}

Iterable<int> count(int n) sync* {
  for (var i = 1; i <= n; i++) {
    yield i;
  }
}

Future<void> main() async {
  final stream = Stream<int>.fromIterable([1, 2, 3, 4]);
  final stream2 =countStream(4);
  final sum = await sumStream2(stream);
  print('Sum: $sum');
}
// in stream we dnt required t write the await r async
