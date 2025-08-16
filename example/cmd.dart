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

  // final field = FieldAB.dayPerHour();
  // final field = FieldAB.dayPer10Minute();
  // final field = FieldAB.dayPer20Minute();
  // final field = FieldAB.dayPer30Minute();
  // final field = FieldRangingDates((2025, 1, 20), (2025, 8, 20));
  final field = Field3D(20, 3, 5);
  field
    ..[(2, 1, 15)] = true
    ..[(1, 1, 16)] = true
    ..[(2, 3, 9)] = true;

  final field2 = field.newFieldZero;
  field2
    ..[(2, 1, 1)] = true
    ..[(4, 1, 1)] = true
    ..[(1, 1, 16)] = true;

  // final field = Field2D(20, 5);
  // field
  //   ..[(3, 16)] = true
  //   ..[(3, 10)] = true
  //   ..[(2, 4)] = true;
  // final field2 = field.newFieldZero;
  // field2
  //   ..[(1, 1)] = true
  //   ..[(2, 2)] = true
  //   ..[(2, 4)] = true;

  print(field & field2);
  print(field.collapseOn(2));
  print(field.collapseOn(2).collapseOn(3));
}
