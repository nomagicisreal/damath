
import 'dart:collection' as collection;


void main() async {
  final watch = Stopwatch();
  print('start');

  watch.start();
  print('way 1: ${way1()} in ${watch.elapsed}');
  watch.reset();

  watch.start();
  print('way 2: ${way2()} in ${watch.elapsed}');
  watch.reset();

  watch.start();
  print('way 3: ${way3()} in ${watch.elapsed}');
  watch.reset();

  print('end');
}

String way1() {
  for (var i = 1e4; i > 1; i--) {
  }
  throw UnimplementedError();
  // return list.length.toString();
}

String way2() {
  final inQ = collection.Queue.of(List.generate(1e6.toInt(), (index) => index));
  for (var i = 1e4; i > 1; i--) {
    inQ.removeFirst();
  }
  // throw UnimplementedError();
  return inQ.length.toString();
}


String way3() {
  final list = List.generate(1e6.toInt(), (index) => index);
  for (var i = 1e4; i > 1; i--) {
    list.removeLast();
  }
  // throw UnimplementedError();
  return list.length.toString();
}
