// the function library size matter. prevent import function by different library.

void main() async {
  final watch = Stopwatch();
  final process = [
    way1, way2,
    // way3
  ];

  print('start');
  for (var i = 0; i < process.length; i++) {
    watch.start();
    print('way ${i + 1}: ${process[i]()} in ${watch.elapsed}');
    watch.reset();
  }
  print('end');
}

// final List<double> list = List<double>.generate(
//   1000,
//   (i) => RandomExtension.intTo(i + 5).toDouble(),
// )..sort();
final int value = 100;

///
///
///
String way1() {
  dynamic result = 'finished';
  for (var i = 1; i < 1e10; i++) {
    // result = value.testing(value);
  }
  return result.toString();
}

String way2() {
  dynamic result = 'finished';
  for (var i = 1; i < 1e10; i++) {
    // result = IntExt.test(value, value);
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


