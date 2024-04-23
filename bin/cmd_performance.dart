// ignore_for_file: unused_local_variable
import 'package:damath/src/core/core.dart';

///
///
/// [way1]
/// [way2]
/// [way3]
/// [comparing]
///
///
final list = RandomExtension.sample(1e5.toInt());

void main() async {
  final watch = Stopwatch();
  comparing(
    watch,
    2,
    (i) => switch (i) {
      1 => way1(),
      2 => way2(),
      3 => way3(),
      _ => throw UnimplementedError(),
    },
  );
}

String way1() {
  dynamic result;
  for (var i = 1; i < 1e5; i++) {
    // result = list
    //   ..shuffle()
    //   ..sort();
  }
  // throw UnimplementedError();
  return 'finished';
  // return result.toString();
}

String way2() {
  dynamic result;
  for (var i = 1; i < 1e5; i++) {
    // result = list
    //   ..shuffle()
    //   ..sortMerge();
  }
  return 'finished';
  // return result.toString();
}

String way3() {
  dynamic result;
  for (var i = 1; i < 1e5; i++) {
    // mergeSort(list..shuffle());
    result = list;
  }
  // throw UnimplementedError();
  return 'finished';
  // return record.toString();
}



void comparing(Stopwatch watch, int count, Generator<String> process) {
  print('start');
  for (var i = 1; i <= count; i++) {
    watch.start();
    print('way $i: ${process(i)} in ${watch.elapsed}');
    watch.reset();
  }
  print('end');
}