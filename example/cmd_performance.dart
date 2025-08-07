// the function library size matter. prevent import function by different library.

import 'dart:collection';

void main() async {
  final watch = Stopwatch();
  final process = [
    way1, way2,
    // way3
  ];

  print('start');
  for (var i = 0; i < process.length; i++) {
    watch.start();
    print('way ${i + 1} returns ${process[i]()} in ${watch.elapsed}');
    watch.reset();
  }
  print('end');
}

// final int value = 100;
// final List<double> list = List<double>.generate(
//   1000,
//   (i) => RandomExtension.intTo(i + 5).toDouble(),
// )..sort();
final Map<String, int> map1 = Map.fromEntries(
  List.generate(1e6.toInt(), (i) => MapEntry(i.toString(), i))..shuffle(),
);
final SplayTreeMap<String, int> mapLogN = SplayTreeMap()..addAll(map1);

///
///
///
String way1() {
  dynamic result = 'finished';
  for (var i = 1; i < 1e1; i++) {
    result = map1[i.toString()];
  }
  return result.toString();
}

String way2() {
  dynamic result = 'finished';
  for (var i = 1; i < 1e1; i++) {
    result = mapLogN[i.toString()];
  }
  return result.toString();
}

String way3() {
  dynamic result = 'finished';
  for (var i = 1; i < 1e2; i++) {
    // result = binarySearch(list, 5);
  }
  return result.toString();
}
