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

  // final field = FieldADay.perHour();
  // final field = FieldADay.per10Minute();
  // final field = FieldADay.per20Minute();
  // final field = FieldADay.per30Minute();
  // final field = FieldRangingDates((2025, 1, 20), (2025, 8, 20));
  // final field = Field2D(17, 5, begin: 8);
  final field = Field3D(20, 3, 5);
  // field[(1, 1, 16)] = true;
  field[(2, 3, 9)] = true;
  // field[(3, 16)];
  // field[(3, 11)];
  print(field.toString());
  // print(20 & 31);
}
