import 'dart:math';

import 'package:damath/src/collection/collection.dart';
import 'package:damath/src/core/core.dart';

void main(List<String> arguments) async {
  final result = <bool>[];

  // var list = RandomExtension.sample(11);
  // print(list);
  // final result = List.of(list)..sortMerge();
  // print(result);
  // print(list.isVariationTo(result));
  // print(result.iterator.isSorted(true));

  // for (var i = 0; i < 10; i++) {
  //   var list = RandomExtension.sample(1e4.toInt());
  //   final sorted = List.of(list)..sortMerge();
  //   result.add(sorted.iterator.isSorted(true));
  //   result.add(list.isVariationTo(sorted));
  // }
  // print(result.iterator.isTautology);

  // print(IntExtension.partitionSet(5));

  // final m = 44;
  // final m = 60;
  // final m = 100;
  // final m = 100;
  // final n = 22;
  // final n = 29;
  // final n = 30;
  // final n = 50;
  // final n = 51;

  // print(CountingExtension.partitionSpace<int>(m, n, true).mapping(
  //       (value) => CountingExtension.partitionByIterative(value, m, n),
  // ));
  //
  // print(CountingExtension.partitionSpace<int>(m, n).mapping(
  //       (value) => CountingExtension.partitionByRecursive(value, m, n),
  // ));

  for (var m = 100; m < 700; m++) {
    final n = Random().nextInt(10) + m ~/ 3;
    result.add(
      CountingExtension.partitionSpace<int>(m, n, true).mapping(
            (value) => CountingExtension.partitionByIterative(value, m, n),
          ) ==
          CountingExtension.partitionSpace<int>(m, n).mapping(
            (value) => CountingExtension.partitionByRecursive(value, m, n),
          ),
    );
  }
  print(result.iterator.isTautology);
}
