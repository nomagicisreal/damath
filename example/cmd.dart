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

  // final flags = FlagsADay.perHour();
  // final flags = FlagsADay.per10Minute();
  // final flags = FlagsADay.per20Minute();
  // final flags = FlagsADay.per30Minute();
  // final flags = FlagsRangingDates((2025, 1, 20), (2025, 8, 20));
  final flags = Field2D(12, 20, 8);
  flags.includes((1, 16));
  flags.includes((3, 16));
  // flags.exclude((3, 16));
  // flags.include((3, 11));
  print(flags.toString());
}
