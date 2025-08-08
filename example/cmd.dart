// ignore_for_file: unused_import, unused_local_variable, prefer_typing_uninitialized_variables
import 'dart:math' as math;
import 'dart:collection';
import 'dart:developer';
import 'dart:typed_data';

import 'package:damath/damath.dart';

void main(List<String> arguments) {
  final buffer = StringBuffer();
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

  final flags = DateFlags.empty();
  flags.include((2025, 9, 11));
  flags.includeRange((2023, 3, 2), (2023, 4, 1));
  flags.includeRange((2025, 8, 2), (2025, 8, 6));
  flags.include((2023, 3, 2));
  print(flags);
  print(flags.firstDate);
  print(flags.lastDate);
  print(flags.yearsAvailable);
  print(flags.monthsAvailable(2025));
  print(flags.daysAvailable(2025, 8));

  // final map = SplayTreeMap();
  // map[100] = 'hello';
  // print(map);
  // print(map[100]);
}
