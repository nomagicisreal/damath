// ignore_for_file: unused_import, unused_local_variable, prefer_typing_uninitialized_variables
import 'dart:developer';

import 'package:damath/damath.dart';
import 'package:damath/src/typed_data/typed_data.dart';

void main(List<String> arguments) {
  // final list = List.generate(10, FKeep.applier);
  // final node =
  //     NodeBinaryAvl<int>.fromSorted(list)
  //       ..push(3113)
  //       ..push(313)
  //       ..push(99913)
  //       ..push(43113)
  //       // ..push(53113)
  // ;
  // print(node);
  final container = DatesContainer.fromIterable(
    Iterable.generate(
      10,
      (i) => DateTime.now().add(Duration(days: RandomExtension.intTo(50) - 1)),
    ),
  );
  print(container);
  print(container.contains(DateTime.now()));
  print(container.dates.join('\n'));
}
