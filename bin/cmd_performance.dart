import 'package:collection/collection.dart';
import 'package:damath/src/collection/collection.dart';
import 'package:damath/src/typed_data/typed_data.dart';

void main() async {
  final watch = Stopwatch();
  // print(list);
  print('start');

  watch.start();
  print('way 1: ${way1()} in ${watch.elapsed}');
  watch.reset();

  watch.start();
  print('way 2: ${way2()} in ${watch.elapsed}');
  watch.reset();

  // watch.start();
  // print('way 3: ${way3()} in ${watch.elapsed}');
  // watch.reset();

  print('end');
}

// final list = RandomExtension.listDoubleInt(1e7.toInt());
final list = RandomExtension.sample(1e5.toInt());

String way1() {
  var result = <double>[];
  for (var i = 1e2; i > 1; i--) {
    result = list
      ..shuffle()
      ..sort();
  }
  // throw UnimplementedError();
  return 'finished';
  // return result.toString();
}

String way2() {
  var result = <double>[];
  for (var i = 1e2; i > 1; i--) {
    result = list
      ..shuffle()
      ..sortMerge();
  }
  return 'finished';
  // return result.toString();
}

String way3() {
  var result = <double>[];
  for (var i = 1e2; i > 1; i--) {
    mergeSort(list..shuffle());
    result = list;
  }
  // throw UnimplementedError();
  return 'finished';
  // return record.toString();
}
