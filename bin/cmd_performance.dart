import 'package:damath/damath.dart';

void main() async {
  final watch = Stopwatch();
  final process = [
    way1,
    way2,
  ];

  print('start');
  for (var i = 0; i < process.length; i++) {
    watch.start();
    print('way $i: ${process[i]()} in ${watch.elapsed}');
    watch.reset();
  }
  print('end');
}

///
///
///
String way1() {
  dynamic result = 'finished';
  final listA = [1, 2, 3, 4];
  final listB = [100, 200, 300];
  for (var i = 1; i < 1e5; i++) {
    result = listA.sandwich(listB);
  }
  return result.toString();
}

String way2() {
  dynamic result = 'finished';
  final listA = [1, 2, 3, 4];
  final listB = [100, 200, 300];
  for (var i = 1; i < 1e5; i++) {
    result = listA.sandwich(listB);
  }
  return result.toString();
}

String way3() {
  dynamic result = 'finished';
  for (var i = 1; i < 1e5; i++) {}
  return result.toString();
}
