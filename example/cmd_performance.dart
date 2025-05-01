import 'package:damath/damath.dart' show RandomExtension;

// the function library size matter. prevent import.

void main() async {
  final watch = Stopwatch();
  final process = [way1, way2];

  print('start');
  for (var i = 0; i < process.length; i++) {
    watch.start();
    print('way ${i + 1}: ${process[i]()} in ${watch.elapsed}');
    watch.reset();
  }
  print('end');
}

// final list = List.generate(100, (i) => RandomExtension.intTo(i + 5))..sort();

///
///
///
String way1() {
  dynamic result = 'finished';
  for (var i = 1; i < 1e5; i++) {
    // result = indexSearch(list, 8);
  }
  return result.toString();
}

String way2() {
  dynamic result = 'finished';
  for (var i = 1; i < 1e5; i++) {
    // result = binarySearch(list, 8);
  }
  return result.toString();
}

String way3() {
  dynamic result = 'finished';
  for (var i = 1; i < 1e5; i++) {}
  return result.toString();
}
